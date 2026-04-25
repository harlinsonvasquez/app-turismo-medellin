package com.turismo.module.event.service.impl;

import com.turismo.exception.ForbiddenException;
import com.turismo.exception.ResourceNotFoundException;
import com.turismo.module.business.entity.Business;
import com.turismo.module.business.repository.BusinessRepository;
import com.turismo.module.event.dto.EventFilter;
import com.turismo.module.event.dto.EventResponse;
import com.turismo.module.event.dto.EventUpsertRequest;
import com.turismo.module.event.entity.Event;
import com.turismo.module.event.repository.EventRepository;
import com.turismo.module.event.service.EventService;
import com.turismo.module.event.service.EventSpecifications;
import com.turismo.security.SecurityUtils;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class EventServiceImpl implements EventService {

    private final EventRepository eventRepository;
    private final BusinessRepository businessRepository;

    @Override
    @Transactional(readOnly = true)
    public List<EventResponse> findAll(EventFilter filter) {
        return eventRepository.findAll(EventSpecifications.withFilter(filter)).stream().map(this::toResponse).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public EventResponse findById(UUID id) {
        return toResponse(getEvent(id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasAnyRole('ADMIN','BUSINESS_OWNER')")
    public EventResponse create(EventUpsertRequest request) {
        Event event = new Event();
        apply(event, request);
        return toResponse(eventRepository.save(event));
    }

    @Override
    @Transactional
    @PreAuthorize("hasAnyRole('ADMIN','BUSINESS_OWNER')")
    public EventResponse update(UUID id, EventUpsertRequest request) {
        Event event = getEvent(id);
        authorizeBusinessOwnership(event.getBusiness());
        apply(event, request);
        return toResponse(eventRepository.save(event));
    }

    @Override
    @Transactional
    @PreAuthorize("hasAnyRole('ADMIN','BUSINESS_OWNER')")
    public void delete(UUID id) {
        Event event = getEvent(id);
        authorizeBusinessOwnership(event.getBusiness());
        event.setActive(false);
        eventRepository.save(event);
    }

    private void apply(Event event, EventUpsertRequest request) {
        event.setBusiness(resolveBusiness(request.businessId()));
        event.setTitle(request.title().trim());
        event.setSlug(request.slug().trim().toLowerCase());
        event.setDescription(request.description().trim());
        event.setCategory(request.category());
        event.setCity(request.city().trim());
        event.setDepartment(request.department().trim());
        event.setAddress(request.address().trim());
        event.setLatitude(request.latitude());
        event.setLongitude(request.longitude());
        event.setStartDate(request.startDate());
        event.setEndDate(request.endDate());
        event.setAveragePrice(request.averagePrice());
        event.setFeatured(request.featured());
        if (request.active() != null) {
            event.setActive(request.active());
        }
    }

    private Business resolveBusiness(UUID businessId) {
        if (businessId == null) {
            if (!"ADMIN".equals(SecurityUtils.getCurrentUser().getRole())) {
                throw new ForbiddenException("Only admins can create orphan events without a linked business");
            }
            return null;
        }
        Business business = businessRepository.findById(businessId)
                .orElseThrow(() -> new ResourceNotFoundException("Business not found"));
        authorizeBusinessOwnership(business);
        return business;
    }

    private void authorizeBusinessOwnership(Business business) {
        if (business == null) {
            if (!"ADMIN".equals(SecurityUtils.getCurrentUser().getRole())) {
                throw new ForbiddenException("Only admins can manage events without a linked business");
            }
            return;
        }
        if (!business.getOwner().getId().equals(SecurityUtils.currentUserId()) && !"ADMIN".equals(SecurityUtils.getCurrentUser().getRole())) {
            throw new ForbiddenException("You are not allowed to manage this business resource");
        }
    }

    private Event getEvent(UUID id) {
        return eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found"));
    }

    private EventResponse toResponse(Event event) {
        return new EventResponse(
                event.getId(),
                event.getBusiness() != null ? event.getBusiness().getId() : null,
                event.getBusiness() != null ? event.getBusiness().getBusinessName() : null,
                event.getTitle(),
                event.getSlug(),
                event.getDescription(),
                event.getCategory(),
                event.getCity(),
                event.getDepartment(),
                event.getAddress(),
                event.getLatitude(),
                event.getLongitude(),
                event.getStartDate(),
                event.getEndDate(),
                event.getAveragePrice(),
                event.isFeatured(),
                event.isActive(),
                event.getCreatedAt(),
                event.getUpdatedAt()
        );
    }
}
