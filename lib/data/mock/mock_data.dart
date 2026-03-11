import '../models/plan_model.dart';
import '../models/user_model.dart';

class MockPlans {
  static final List<TripPlanModel> all = [
    TripPlanModel(
      id: 'plan001',
      title: 'Medellín Clásico - 3 Días',
      days: 3,
      totalBudget: 600000,
      style: TravelStyle.cultural,
      travelerType: TravelerType.couple,
      estimatedTotal: '\$550.000 COP por persona',
      transportSummary: 'Metro + Metrocable + Taxi autorizado',
      generalNotes: [
        'Recomendamos descargar la app del Metro',
        'Usar solo taxis o apps verificadas (InDriver, Cabify)',
        'Llevar efectivo para mercados y vendedores locales',
        'Hidratarse bien – Medellín puede estar muy calurosa',
      ],
      createdAt: DateTime(2026, 3, 10),
      dayPlans: [
        const DayPlan(
          dayNumber: 1,
          theme: 'Centro Histórico y Arte',
          neighborhood: 'Centro de Medellín',
          dailyBudget: '\$180.000 COP',
          safetyNote: 'Ir a Plaza Botero en horas de mañana. No llevar artículos de valor.',
          morning: [
            ItineraryBlock(
              time: '09:00',
              title: 'Plaza Botero y Museo de Antioquia',
              description: 'Inicia el día con las esculturas icónicas de Botero. Visita el museo para conocer la colección completa del maestro.',
              placeId: 'tp001',
              placeName: 'Plaza Botero',
              estimatedCost: '\$18.000 COP entrada museo',
              transport: 'Metro – Estación Parque Berrío',
              duration: '2.5h',
            ),
          ],
          afternoon: [
            ItineraryBlock(
              time: '13:00',
              title: 'Almuerzo en el Centro',
              description: 'Bandeja Paisa auténtica en uno de los restaurantes del centro histórico.',
              placeId: 'r003',
              placeName: 'Mondongos',
              estimatedCost: '\$35.000 COP',
              transport: 'A pie',
              duration: '1h',
            ),
            ItineraryBlock(
              time: '15:00',
              title: 'El Poblado – Parque Bello Horizonte',
              description: 'Paseo por el corazón turístico de Medellín. Cafés, tiendas y ambiente internacional.',
              placeId: 'tp001',
              placeName: 'El Poblado',
              estimatedCost: '\$25.000 COP cafés',
              transport: 'Metro – Estación El Poblado',
              duration: '2h',
            ),
          ],
          night: [
            ItineraryBlock(
              time: '19:30',
              title: 'Cena en Carmen Restaurant',
              description: 'Cocina contemporánea colombiana con cócteles artesanales y vista nocturna de la ciudad.',
              placeId: 'r004',
              placeName: 'Carmen Restaurant',
              estimatedCost: '\$220.000 COP por dos',
              transport: 'Taxi – 10 min desde El Poblado',
              duration: '2h',
            ),
          ],
        ),
        const DayPlan(
          dayNumber: 2,
          theme: 'Ecoturismo y Naturaleza Urbana',
          neighborhood: 'Parque Arví + Jardín Botánico',
          dailyBudget: '\$160.000 COP',
          safetyNote: 'Parque Arví es totalmente seguro. Llevar repelente y protector solar.',
          morning: [
            ItineraryBlock(
              time: '08:30',
              title: 'Jardín Botánico de Medellín',
              description: 'Pasea entre miles de especies tropicales, el orquideorama y los jardines temáticos.',
              placeId: 'tp003',
              placeName: 'Jardín Botánico',
              estimatedCost: '\$15.000 COP',
              transport: 'Metro – Estación Universidad',
              duration: '2h',
            ),
          ],
          afternoon: [
            ItineraryBlock(
              time: '11:30',
              title: 'Metrocable a Parque Arví',
              description: 'Sube en metrocable hasta el Parque Arví. Senderismo, mercado campesino y aire de montaña.',
              placeId: 'tp002',
              placeName: 'Parque Arví',
              estimatedCost: '\$22.000 COP cable + entrada',
              transport: 'Metrocable Línea L (desde Acevedo)',
              duration: '4h',
            ),
          ],
          night: [
            ItineraryBlock(
              time: '19:00',
              title: 'La 70 – Bares y Gastronomía',
              description: 'Explora la animada Carrera 70 de Laureles para cenar y tomar cócteles en ambiente local.',
              placeId: 'n002',
              placeName: 'La 70 Gastro-Bar District',
              estimatedCost: '\$70.000 COP por dos',
              transport: 'Cabify – 15 min',
              duration: '2.5h',
            ),
          ],
        ),
        const DayPlan(
          dayNumber: 3,
          theme: 'Day Trip a Guatapé',
          neighborhood: 'Guatapé – El Peñol',
          dailyBudget: '\$200.000 COP',
          safetyNote: 'Ruta turística totalmente segura. Usar transportes oficiales desde Terminal del Norte.',
          morning: [
            ItineraryBlock(
              time: '07:00',
              title: 'Salida a Guatapé',
              description: 'Bus desde Terminal del Norte hasta Guatapé (2h). Llegada al pueblo más colorido de Colombia.',
              placeId: 't001',
              placeName: 'Guatapé',
              estimatedCost: '\$20.000 COP bus ida y vuelta',
              transport: 'Bus Inter-municipal Terminal Norte',
              duration: '2h viaje',
            ),
            ItineraryBlock(
              time: '10:00',
              title: 'Subida al Peñol (740 escalones)',
              description: 'Sube los 740 escalones en la roca más famosa de Colombia. Vista de 360° del embalse y los 7 espejos de agua.',
              placeId: 't001',
              placeName: 'El Peñol de Guatapé',
              estimatedCost: '\$25.000 COP entrada',
              transport: 'A pie / Mototaxi \$5.000',
              duration: '2h',
            ),
          ],
          afternoon: [
            ItineraryBlock(
              time: '13:00',
              title: 'Almuerzo en el Pueblo',
              description: 'Trucha del embalse y bandeja paisa típica en los restaurantes del pueblo.',
              placeId: 't001',
              placeName: 'Restaurante local Guatapé',
              estimatedCost: '\$35.000 COP',
              transport: 'A pie',
              duration: '1h',
            ),
            ItineraryBlock(
              time: '15:00',
              title: 'Paseo en lancha por el embalse',
              description: 'Recorre el embalse de Guatapé en lancha, visita isletas y disfruta del atardecer en el agua.',
              placeId: 't001',
              placeName: 'Embalse de Guatapé',
              estimatedCost: '\$50.000 COP lancha compartida',
              transport: 'A pie hasta el muelle',
              duration: '2h',
            ),
          ],
          night: [
            ItineraryBlock(
              time: '18:00',
              title: 'Regreso a Medellín',
              description: 'Bus de regreso a las 18:00 desde la terminal de Guatapé. Llegada a Medellín hacia las 20:00.',
              placeId: 't001',
              placeName: 'Terminal Guatapé',
              estimatedCost: 'Incluido',
              transport: 'Bus Inter-municipal',
              duration: '2h regreso',
            ),
          ],
        ),
      ],
    ),
  ];
}

class MockUser {
  static const UserModel mockUser = UserModel(
    id: 'u001',
    name: 'Alejandra Torres',
    email: 'alejandra@example.com',
    preferredLanguage: 'Español',
    interests: ['Gastronomía', 'Arte', 'Naturaleza', 'Fotografía'],
    budgetStyle: 'Moderado',
    notificationsEnabled: true,
    savedPlaceIds: ['tp001', 'tp002', 'r001', 'e002'],
    savedPlanIds: ['plan001'],
  );
}

class MockSafetyTips {
  static const List<SafetyTipModel> all = [
    SafetyTipModel(
      id: 's001',
      title: 'Usa taxis o apps certificadas',
      description:
          'Nunca tomes taxis informales de la calle. Usa InDriver, Cabify, o Beat. Comparte tu ruta con alguien de confianza.',
      icon: '🚕',
      category: SafetyTipCategory.transport,
    ),
    SafetyTipModel(
      id: 's002',
      title: 'Cuidado con el "Paseo Millonario"',
      description:
          'No aceptes taxis amarillos en la calle de noche. Es una estafa común donde te llevan a cajeros automáticos.',
      icon: '⚠️',
      category: SafetyTipCategory.scam,
    ),
    SafetyTipModel(
      id: 's003',
      title: 'Zonas seguras para turistas',
      description:
          'El Poblado, Laureles, Estadio y El Centro (de día) son zonas relativamente seguras. Evita El Bronx y zonas periféricas de noche.',
      icon: '📍',
      category: SafetyTipCategory.zones,
    ),
    SafetyTipModel(
      id: 's004',
      title: 'Emergencias: Número 123',
      description:
          'En Colombia el número de emergencias unificado es el 123. Policía: 112. Guárdalos en tu teléfono.',
      icon: '🚨',
      category: SafetyTipCategory.emergency,
    ),
    SafetyTipModel(
      id: 's005',
      title: 'No exhibas objetos de valor',
      description:
          'Evita usar celulares costosos en la calle, especialmente en Plaza Botero y el Centro. Usa réplicas o teléfonos viejos.',
      icon: '📱',
      category: SafetyTipCategory.general,
    ),
    SafetyTipModel(
      id: 's006',
      title: 'Escopolamina – "Burundanga"',
      description:
          'No aceptes bebidas o cigarrillos de extraños. La burundanga es una droga que anulan la voluntad. Muy usada en estafas.',
      icon: '🍺',
      category: SafetyTipCategory.scam,
    ),
    SafetyTipModel(
      id: 's007',
      title: 'Agua y altitud',
      description:
          'Medellín está a 1.500 msnm. Si vienes de lugares bajos, puede haber mareo leve. Hidratarse bien. Parque Arví está a 2.400 msnm.',
      icon: '💧',
      category: SafetyTipCategory.health,
    ),
    SafetyTipModel(
      id: 's008',
      title: 'Metrocable – Precauciones',
      description:
          'Los metrocables son seguros pero van a comunas populares. Ve de día con guía certificado si es tu primera visita.',
      icon: '🚡',
      category: SafetyTipCategory.zones,
    ),
  ];
}

class MockMembershipPlans {
  static const List<MembershipPlanModel> all = [
    MembershipPlanModel(
      id: 'm001',
      name: 'Gratis',
      price: '\$0',
      billingPeriod: 'Siempre',
      features: [
        'Perfil básico en el mapa',
        'Hasta 5 fotos',
        '1 categoría',
        'Contacto básico',
      ],
      isPopular: false,
      badgeColor: '6B7280',
    ),
    MembershipPlanModel(
      id: 'm002',
      name: 'Pro',
      price: '\$149.000 COP',
      billingPeriod: 'por mes',
      features: [
        'Perfil destacado en resultados',
        'Galería de hasta 30 fotos',
        'Múltiples categorías',
        'Badge "Recomendado"',
        'Estadísticas básicas de visitas',
        'Botón de reserva directa',
        'Soporte prioritario',
      ],
      isPopular: true,
      badgeColor: '1A5F7A',
    ),
    MembershipPlanModel(
      id: 'm003',
      name: 'Premium',
      price: '\$349.000 COP',
      billingPeriod: 'por mes',
      features: [
        'Todo lo de Pro',
        'Aparición en itinerarios generados',
        'Publicidad en Home Screen',
        'Badge "Premium"',
        'Analíticas avanzadas',
        'Gestión de reseñas',
        'Integración con whatsapp & redes',
        'Gestor de cuenta dedicado',
      ],
      isPopular: false,
      badgeColor: 'F39C12',
    ),
  ];
}

class MockCategories {
  static const List<CategoryModel> all = [
    CategoryModel(id: 'c001', name: 'Hoteles', icon: '🏨', routeKey: 'hotel', colorHex: '1A5F7A'),
    CategoryModel(id: 'c002', name: 'Restaurantes', icon: '🍽️', routeKey: 'restaurant', colorHex: '2ECC71'),
    CategoryModel(id: 'c003', name: 'Turismo', icon: '🗺️', routeKey: 'tourist', colorHex: 'F39C12'),
    CategoryModel(id: 'c004', name: 'Eventos', icon: '🎭', routeKey: 'events', colorHex: '9B59B6'),
    CategoryModel(id: 'c005', name: 'Vida Nocturna', icon: '🌃', routeKey: 'nightlife', colorHex: '1A1D2E'),
    CategoryModel(id: 'c006', name: 'Pueblos', icon: '🏡', routeKey: 'towns', colorHex: 'E67E22'),
  ];
}
