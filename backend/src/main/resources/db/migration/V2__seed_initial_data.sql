INSERT INTO membership_plans (id, name, monthly_price, features_json, active) VALUES
('00000000-0000-0000-0000-000000000101', 'Free', 0.00, '["Basic map profile","Up to 5 photos","Single category"]', TRUE),
('00000000-0000-0000-0000-000000000102', 'Pro', 149000.00, '["Highlighted profile","Direct booking CTA","Basic analytics","Up to 30 photos"]', TRUE),
('00000000-0000-0000-0000-000000000103', 'Premium', 349000.00, '["Appears in generated itineraries","Advanced analytics","Review management","Dedicated account manager"]', TRUE);

INSERT INTO users (id, full_name, email, password_hash, role, active, created_at, updated_at) VALUES
('00000000-0000-0000-0000-000000000001', 'Admin Turismo', 'admin@turismo.local', '$2a$10$up11yr5NGuhVIaCchmmkOOMSlDf1p9b4xz4A3faSGL1DKwvSpkHhe', 'ADMIN', TRUE, NOW(), NOW()),
('00000000-0000-0000-0000-000000000002', 'Cafe Provenza SAS', 'owner@provenza.local', '$2a$10$up11yr5NGuhVIaCchmmkOOMSlDf1p9b4xz4A3faSGL1DKwvSpkHhe', 'BUSINESS_OWNER', TRUE, NOW(), NOW()),
('00000000-0000-0000-0000-000000000003', 'Alejandra Torres', 'alejandra@example.com', '$2a$10$up11yr5NGuhVIaCchmmkOOMSlDf1p9b4xz4A3faSGL1DKwvSpkHhe', 'TOURIST', TRUE, NOW(), NOW());

INSERT INTO businesses (id, owner_id, business_name, business_type, description, phone, email, website, verified, active, created_at, updated_at) VALUES
('00000000-0000-0000-0000-000000000201', '00000000-0000-0000-0000-000000000002', 'Pergamino Provenza', 'CAFE', 'Specialty coffee shop in Provenza with local roasted coffee and brunch menu.', '+57 3001234567', 'hola@pergamino.local', 'https://pergamino.local', TRUE, TRUE, NOW(), NOW()),
('00000000-0000-0000-0000-000000000202', '00000000-0000-0000-0000-000000000002', 'Carmen Medellin', 'RESTAURANT', 'Contemporary Colombian cuisine in El Poblado.', '+57 3001234568', 'reservas@carmen.local', 'https://carmen.local', TRUE, TRUE, NOW(), NOW());

INSERT INTO places (id, business_id, name, slug, category, subcategory, description, city, department, address, latitude, longitude, average_price, estimated_price_level, rating, safe_zone, featured, active, opening_hours_json, created_at, updated_at) VALUES
('00000000-0000-0000-0000-000000000301', NULL, 'Plaza Botero', 'plaza-botero', 'TOURIST_PLACE', 'Art', 'Iconic public square with Botero sculptures and close access to Museo de Antioquia.', 'Medellin', 'Antioquia', 'Cl. 52 #52-43, La Candelaria', 6.2518400, -75.5635900, 0.00, 'LOW', 4.70, FALSE, TRUE, TRUE, '{"mon-sun":"08:00-18:00"}', NOW(), NOW()),
('00000000-0000-0000-0000-000000000302', NULL, 'Parque Arvi', 'parque-arvi', 'EXPERIENCE', 'Nature', 'Ecotourism reserve ideal for hiking, cable car rides and local markets.', 'Medellin', 'Antioquia', 'Santa Elena, Medellin', 6.2719000, -75.5038000, 22000.00, 'LOW', 4.80, TRUE, TRUE, TRUE, '{"tue-sun":"09:00-17:00"}', NOW(), NOW()),
('00000000-0000-0000-0000-000000000303', '00000000-0000-0000-0000-000000000202', 'Carmen Restaurant', 'carmen-restaurant', 'RESTAURANT', 'Fine dining', 'High-end restaurant focused on modern Colombian cuisine and curated cocktails.', 'Medellin', 'Antioquia', 'Cra. 36 #10A-27, El Poblado', 6.2094000, -75.5712000, 180000.00, 'HIGH', 4.80, TRUE, TRUE, TRUE, '{"tue-sun":"12:00-22:30"}', NOW(), NOW()),
('00000000-0000-0000-0000-000000000304', '00000000-0000-0000-0000-000000000201', 'Pergamino Cafe', 'pergamino-cafe', 'RESTAURANT', 'Cafe', 'Popular specialty coffee shop for brunch, pastries and local beans.', 'Medellin', 'Antioquia', 'Cra. 37 #8A-37, Provenza', 6.2085000, -75.5675000, 35000.00, 'LOW', 4.70, TRUE, TRUE, TRUE, '{"mon-sun":"07:00-20:00"}', NOW(), NOW()),
('00000000-0000-0000-0000-000000000305', NULL, 'Provenza Night District', 'provenza-night-district', 'NIGHTLIFE', 'Nightlife', 'Bars, rooftops and music venues concentrated in one of the top nightlife zones of Medellin.', 'Medellin', 'Antioquia', 'Provenza, El Poblado', 6.2090000, -75.5679000, 90000.00, 'MEDIUM', 4.60, TRUE, TRUE, TRUE, '{"thu-sat":"18:00-03:00"}', NOW(), NOW()),
('00000000-0000-0000-0000-000000000306', NULL, 'Guatape', 'guatape', 'TOWN', 'Day trip', 'Colorful town near Medellin, known for El Penol and boat tours.', 'Medellin', 'Antioquia', 'Guatape, Antioquia', 6.2311000, -75.1635000, 80000.00, 'MEDIUM', 4.90, TRUE, TRUE, TRUE, '{"mon-sun":"06:00-20:00"}', NOW(), NOW());

INSERT INTO place_images (id, place_id, image_url, cover, sort_order) VALUES
('00000000-0000-0000-0000-000000000401', '00000000-0000-0000-0000-000000000301', 'https://images.unsplash.com/photo-1551009175-15bda988e551?w=1200', TRUE, 0),
('00000000-0000-0000-0000-000000000402', '00000000-0000-0000-0000-000000000302', 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=1200', TRUE, 0),
('00000000-0000-0000-0000-000000000403', '00000000-0000-0000-0000-000000000303', 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=1200', TRUE, 0),
('00000000-0000-0000-0000-000000000404', '00000000-0000-0000-0000-000000000304', 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=1200', TRUE, 0),
('00000000-0000-0000-0000-000000000405', '00000000-0000-0000-0000-000000000305', 'https://images.unsplash.com/photo-1470337458703-46ad1756a187?w=1200', TRUE, 0),
('00000000-0000-0000-0000-000000000406', '00000000-0000-0000-0000-000000000306', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=1200', TRUE, 0);

INSERT INTO events (id, business_id, title, slug, description, category, city, department, address, latitude, longitude, start_date, end_date, average_price, featured, active, created_at, updated_at) VALUES
('00000000-0000-0000-0000-000000000501', NULL, 'Feria de las Flores Preview', 'feria-flores-preview', 'Sample cultural event inspired by Medellin''s iconic Feria de las Flores.', 'CULTURAL', 'Medellin', 'Antioquia', 'Plaza Mayor, Medellin', 6.2439000, -75.5759000, NOW() + INTERVAL '10 days', NOW() + INTERVAL '10 days 5 hours', 40000.00, TRUE, TRUE, NOW(), NOW()),
('00000000-0000-0000-0000-000000000502', NULL, 'Provenza Live Sessions', 'provenza-live-sessions', 'Night live music event in the Provenza district.', 'NIGHTLIFE', 'Medellin', 'Antioquia', 'Provenza, El Poblado', 6.2093000, -75.5682000, NOW() + INTERVAL '3 days', NOW() + INTERVAL '3 days 4 hours', 70000.00, TRUE, TRUE, NOW(), NOW());

INSERT INTO safety_tips (id, city, zone, title, description, risk_level, active, created_at) VALUES
('00000000-0000-0000-0000-000000000601', 'Medellin', 'Centro', 'Watch personal belongings in downtown', 'Avoid showing expensive phones and keep bags secured around Plaza Botero and La Candelaria.', 'MEDIUM', TRUE, NOW()),
('00000000-0000-0000-0000-000000000602', 'Medellin', 'El Poblado', 'Use registered transport at night', 'Prefer app-based rides or hotel-booked taxis when moving between nightlife venues.', 'LOW', TRUE, NOW()),
('00000000-0000-0000-0000-000000000603', 'Medellin', 'General', 'Emergency line 123', 'In Colombia, 123 is the main emergency number for police, medical and fire emergencies.', 'LOW', TRUE, NOW());

INSERT INTO favorites (id, user_id, item_type, reference_id, created_at) VALUES
('00000000-0000-0000-0000-000000000701', '00000000-0000-0000-0000-000000000003', 'PLACE', '00000000-0000-0000-0000-000000000301', NOW()),
('00000000-0000-0000-0000-000000000702', '00000000-0000-0000-0000-000000000003', 'PLACE', '00000000-0000-0000-0000-000000000303', NOW());
