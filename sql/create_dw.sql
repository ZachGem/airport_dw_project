CREATE TABLE IF NOT EXISTS dim_airline (
	airline_sk SERIAL PRIMARY KEY,
	airline_id INT,
	airline_code VARCHAR(10),
	airline_name VARCHAR(100),
	airline_country VARCHAR(50),
	airline_alliance VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS dim_aircraft (
	aircraft_sk SERIAL PRIMARY KEY,
	aircraft_id INT,
	aircraft_registration_number VARCHAR(20),
	aircraft_type VARCHAR(50),
	aircraft_manufacturer VARCHAR(100),
	aircraft_seat_capacity INT
);

CREATE TABLE IF NOT EXISTS dim_airport (
	airport_sk SERIAL PRIMARY KEY,
	airport_id INT,
	airport_code VARCHAR(10),
	airport_name VARCHAR(100),
	city VARCHAR(100),
	country VARCHAR(50),
	timezone VARCHAR(50),
	latitude DECIMAL(9, 6),
	longitude DECIMAL(9, 6)
);

CREATE TABLE IF NOT EXISTS dim_terminal (
	terminal_sk SERIAL PRIMARY KEY,
	terminal_id INT,
	terminal_code VARCHAR(10),
	terminal_capacity INT,
	terminal_type VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_gate (
	gate_sk SERIAL PRIMARY KEY,
	gate_id INT,
	gate_code VARCHAR(10),
	gate_type VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_flight (
	flight_sk SERIAL PRIMARY KEY,
	flight_id INT,
	flight_number VARCHAR(20),
	flight_status VARCHAR(50),
	flight_delay_code VARCHAR(50),
	flight_cancellation_reason VARCHAR(50),
);

CREATE TABLE IF NOT EXISTS fact_flights (
	airport_sk_origin INT REFERENCES dim_airport(airport_sk),
	airport_sk_destination INT REFERENCES dim_airport(airport_sk),
	time_sk INT REFERENCES dim_time(time_sk),
	flight_sk INT REFERENCES dim_flight(flight_sk),
	airline_sk INT REFERENCES dim_airline(airline_sk),
	aircraft_sk INT REFERENCES dim_aircraft(aircraft_sk),
	gate_sk INT REFERENCES dim_gate(gate_sk),
	terminal_sk INT REFERENCES dim_terminal(terminal_sk),

	delay_departure_minutes INT,
	delay_arrival_minutes INT,
	avg_delay_departure DECIMAL(9, 6),
	avg_delay_arrival DECIMAL(9, 6),
	passengers_capacity INT,
	passengers_onboard INT,
	flight_duration_minutes INT,
	occupency_rate DECIMAL(9, 6)
);

CREATE TABLE IF NOT EXISTS dim_checkin (
	checkin_sk SERIAL PRIMARY KEY,
	checkin_id INT,
	checkin_desk_number VARCHAR(10),
	checkin_seat_number VARCHAR(10),
	checkin_boarding_pass_number VARCHAR(20),
	checkin_status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_passenger (
	passenger_sk SERIAL PRIMARY KEY,
	passenger_id INT,
	passenger_nationality VARCHAR(50),
	passenger_gender VARCHAR(50),
	passenger_birth_date VARCHAR(50),
	passenger_email VARCHAR(100),
	passenger_phone VARCHAR(50),
	passenger_type VARCHAR(50),
	passenger_passport_number VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS fact_checkins (
	passenger_sk INT REFERENCES dim_passenger(passenger_sk),
	time_sk INT REFERENCES dim_time(time_sk),
	checkin_sk INT REFERENCES dim_checkin(checkin_sk),
	terminal_id INT REFERENCES dim_terminal(terminal_sk),

	passenger_count INT,
	baggage_count INT,
	baggage_weight DECIMAL(9, 6),
	checkins_completed INT,
	checkins_cancelled INT
);

CREATE TABLE IF NOT EXISTS dim_shop (
	shop_sk SERIAL PRIMARY KEY,
	shop_id INT,
	shop_name VARCHAR(100),
	shop_category VARCHAR(100),
	shop_location VARCHAR(100),
	shop_floor INT,
	shop_opening_hour TIME,
	shop_closing_hour TIME,
	shop_monthly_rent DECIMAL(9, 6)
);

CREATE TABLE IF NOT EXISTS dim_sale (
	sale_sk SERIAL PRIMARY KEY,
	sale_id INT,
	sale_number VARCHAR(50),
	sale_datetime TIMESTAMP,
	sale_payment_method VARCHAR(50),
	sale_customer_type VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS fact_shop_sales (
	shop_sk INT REFERENCES dim_shop(shop_sk),
	time_sk INT REFERENCES dim_time(time_sk),
	sale_sk INT REFERENCES dim_sale(sale_sk),
	terminal_sk INT REFERENCES dim_terminal(terminal_sk),

	sales_price_total DECIMAL(9, 6),
	sales_quantity INT,
	tax_amount DECIMAL(9, 6),
	discount_amount DECIMAL(9, 6),
	net_sales DECIMAL(9, 6),
	average_sale_value DECIMAL(9, 6)
);