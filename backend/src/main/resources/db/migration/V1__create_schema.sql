CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(160) NOT NULL,
    email VARCHAR(180) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_users_email ON users(email);

CREATE TABLE businesses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES users(id),
    business_name VARCHAR(180) NOT NULL,
    business_type VARCHAR(40) NOT NULL,
    description TEXT,
    phone VARCHAR(40),
    email VARCHAR(180),
    website VARCHAR(255),
    verified BOOLEAN NOT NULL DEFAULT FALSE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_businesses_owner_id ON businesses(owner_id);

CREATE TABLE membership_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(120) NOT NULL,
    monthly_price NUMERIC(12,2) NOT NULL,
    features_json TEXT NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE places (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id UUID REFERENCES businesses(id),
    name VARCHAR(180) NOT NULL,
    slug VARCHAR(180) NOT NULL UNIQUE,
    category VARCHAR(40) NOT NULL,
    subcategory VARCHAR(120),
    description TEXT NOT NULL,
    city VARCHAR(120) NOT NULL,
    department VARCHAR(120) NOT NULL,
    address VARCHAR(255) NOT NULL,
    latitude NUMERIC(10,7) NOT NULL,
    longitude NUMERIC(10,7) NOT NULL,
    average_price NUMERIC(12,2),
    estimated_price_level VARCHAR(20) NOT NULL,
    rating NUMERIC(3,2) NOT NULL DEFAULT 0,
    safe_zone BOOLEAN NOT NULL DEFAULT FALSE,
    featured BOOLEAN NOT NULL DEFAULT FALSE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    opening_hours_json TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_places_city ON places(city);
CREATE INDEX idx_places_category ON places(category);
CREATE INDEX idx_places_featured ON places(featured);
CREATE INDEX idx_places_active ON places(active);

CREATE TABLE place_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    image_url VARCHAR(500) NOT NULL,
    cover BOOLEAN NOT NULL DEFAULT FALSE,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    business_id UUID REFERENCES businesses(id),
    title VARCHAR(180) NOT NULL,
    slug VARCHAR(180) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    category VARCHAR(40) NOT NULL,
    city VARCHAR(120) NOT NULL,
    department VARCHAR(120) NOT NULL,
    address VARCHAR(255) NOT NULL,
    latitude NUMERIC(10,7) NOT NULL,
    longitude NUMERIC(10,7) NOT NULL,
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ,
    average_price NUMERIC(12,2),
    featured BOOLEAN NOT NULL DEFAULT FALSE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_events_city ON events(city);
CREATE INDEX idx_events_category ON events(category);

CREATE TABLE safety_tips (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city VARCHAR(120) NOT NULL,
    zone VARCHAR(120),
    title VARCHAR(180) NOT NULL,
    description TEXT NOT NULL,
    risk_level VARCHAR(20) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_safety_tips_city ON safety_tips(city);

CREATE TABLE itineraries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    title VARCHAR(180) NOT NULL,
    city_base VARCHAR(120) NOT NULL,
    total_days INTEGER NOT NULL,
    total_budget NUMERIC(12,2) NOT NULL,
    travel_style VARCHAR(30) NOT NULL,
    companion_type VARCHAR(30) NOT NULL,
    interests_json TEXT NOT NULL,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_itineraries_user_id ON itineraries(user_id);

CREATE TABLE itinerary_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    itinerary_id UUID NOT NULL REFERENCES itineraries(id) ON DELETE CASCADE,
    day_number INTEGER NOT NULL,
    period VARCHAR(20) NOT NULL,
    item_type VARCHAR(30) NOT NULL,
    reference_id UUID,
    title VARCHAR(180) NOT NULL,
    estimated_cost NUMERIC(12,2),
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_type VARCHAR(20) NOT NULL,
    reference_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_favorites_user_item UNIQUE (user_id, item_type, reference_id)
);
CREATE INDEX idx_favorites_user_id ON favorites(user_id);
