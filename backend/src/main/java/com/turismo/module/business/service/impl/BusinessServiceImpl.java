package com.turismo.module.business.service.impl;

import com.turismo.exception.ForbiddenException;
import com.turismo.exception.ResourceNotFoundException;
import com.turismo.module.business.dto.BusinessResponse;
import com.turismo.module.business.dto.BusinessUpsertRequest;
import com.turismo.module.business.entity.Business;
import com.turismo.module.business.repository.BusinessRepository;
import com.turismo.module.business.service.BusinessService;
import com.turismo.module.user.entity.User;
import com.turismo.module.user.entity.UserRole;
import com.turismo.module.user.repository.UserRepository;
import com.turismo.security.SecurityUtils;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class BusinessServiceImpl implements BusinessService {

    private final BusinessRepository businessRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional(readOnly = true)
    public List<BusinessResponse> findAll() {
        return businessRepository.findAll().stream().map(this::toResponse).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public BusinessResponse findById(UUID id) {
        return toResponse(getBusiness(id));
    }

    @Override
    @Transactional(readOnly = true)
    @PreAuthorize("isAuthenticated()")
    public List<BusinessResponse> findMine() {
        return businessRepository.findByOwnerId(SecurityUtils.currentUserId()).stream().map(this::toResponse).toList();
    }

    @Override
    @Transactional
    @PreAuthorize("isAuthenticated()")
    public BusinessResponse create(BusinessUpsertRequest request) {
        User owner = userRepository.findById(SecurityUtils.currentUserId())
                .orElseThrow(() -> new ResourceNotFoundException("Owner not found"));

        if (owner.getRole() == UserRole.TOURIST) {
            owner.setRole(UserRole.BUSINESS_OWNER);
        }

        Business business = new Business();
        business.setOwner(owner);
        apply(business, request);
        business.setVerified(false);
        return toResponse(businessRepository.save(business));
    }

    @Override
    @Transactional
    @PreAuthorize("isAuthenticated()")
    public BusinessResponse update(UUID id, BusinessUpsertRequest request) {
        Business business = getBusiness(id);
        UUID currentUserId = SecurityUtils.currentUserId();
        if (!business.getOwner().getId().equals(currentUserId)) {
            throw new ForbiddenException("You are not allowed to update this business");
        }
        apply(business, request);
        return toResponse(businessRepository.save(business));
    }

    private Business getBusiness(UUID id) {
        return businessRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Business not found"));
    }

    private void apply(Business business, BusinessUpsertRequest request) {
        business.setBusinessName(request.businessName().trim());
        business.setBusinessType(request.businessType());
        business.setDescription(request.description());
        business.setPhone(request.phone());
        business.setEmail(request.email());
        business.setWebsite(request.website());
        if (request.active() != null) {
            business.setActive(request.active());
        }
    }

    private BusinessResponse toResponse(Business business) {
        return new BusinessResponse(
                business.getId(),
                business.getOwner().getId(),
                business.getOwner().getFullName(),
                business.getBusinessName(),
                business.getBusinessType(),
                business.getDescription(),
                business.getPhone(),
                business.getEmail(),
                business.getWebsite(),
                business.isVerified(),
                business.isActive(),
                business.getCreatedAt(),
                business.getUpdatedAt()
        );
    }
}
