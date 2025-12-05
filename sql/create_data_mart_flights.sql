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