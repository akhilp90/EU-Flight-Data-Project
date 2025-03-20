CREATE DATABASE Flightsassignment;
USE Flightsassignment;

CREATE TABLE Airports (
    airport_id SERIAL PRIMARY KEY,
    airport_name VARCHAR(255) NOT NULL,
    iata_code VARCHAR(3) NOT NULL,
    icao_code VARCHAR(4),
    country VARCHAR(100),
    city VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);

CREATE TABLE Airlines (
    airline_id SERIAL PRIMARY KEY,
    airline_name VARCHAR(255) NOT NULL
);

CREATE TABLE Flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number VARCHAR(10) NOT NULL,
    departure_airport_id INT REFERENCES Airports(airport_id),
    arrival_airport_id INT REFERENCES Airports(airport_id),
    airline_id INT REFERENCES Airlines(airline_id),
    departure_time TIMESTAMP,
    arrival_time TIMESTAMP,
    status VARCHAR(50)
);

CREATE TABLE FlightStatus (
    status_id SERIAL PRIMARY KEY,
    flight_id INT REFERENCES Flights(flight_id),
    status_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delay_minutes INT,
    status_description VARCHAR(255)
);

INSERT INTO Airports (airport_name, iata_code, icao_code, country, city, latitude, longitude)
VALUES
('Frankfurt Airport', 'FRA', 'EDDF', 'Germany', 'Frankfurt', 50.0379, 8.5622),
('Munich Airport', 'MUC', 'EDDM', 'Germany', 'Munich', 48.3538, 11.7861),
('Berlin Brandenburg Airport', 'BER', 'EDDB', 'Germany', 'Berlin', 52.3667, 13.5033),
('Hamburg Airport', 'HAM', 'EDDH', 'Germany', 'Hamburg', 53.6304, 9.9882),
('Düsseldorf Airport', 'DUS', 'EDDL', 'Germany', 'Düsseldorf', 51.2895, 6.7668);

INSERT INTO Airlines (airline_name) VALUES ('Lufthansa'), ('Eurowings');

INSERT INTO Flights (flight_number, departure_airport_id, arrival_airport_id, airline_id, departure_time, arrival_time, status)
VALUES
('LH123', 1, 2, 1, '2025-04-01 08:00:00', '2025-04-01 10:00:00', 'On Time'),
('EW456', 2, 3, 2, '2025-04-01 09:00:00', '2025-04-01 11:30:00', 'Delayed'),
('LH789', 3, 4, 1, '2025-04-01 10:00:00', '2025-04-01 12:00:00', 'On Time'),
('LH101', 4, 5, 1, '2025-04-01 11:00:00', '2025-04-01 13:30:00', 'Delayed'),
('EW202', 5, 1, 2, '2025-04-01 12:00:00', '2025-04-01 14:00:00', 'On Time'),
('LH303', 1, 3, 1, '2025-04-01 13:00:00', '2025-04-01 15:30:00', 'Delayed'),
('EW404', 2, 4, 2, '2025-04-01 14:00:00', '2025-04-01 16:00:00', 'On Time'),
('LH505', 3, 5, 1, '2025-04-01 15:00:00', '2025-04-01 17:30:00', 'Delayed'),
('EW606', 4, 1, 2, '2025-04-01 16:00:00', '2025-04-01 18:00:00', 'On Time'),
('LH707', 5, 2, 1, '2025-04-01 17:00:00', '2025-04-01 19:30:00', 'Delayed');

INSERT INTO FlightStatus (flight_id, delay_minutes, status_description)
VALUES 
(1, 150, 'Delayed due to weather'),
(2, 90, 'Minor delay - technical issue'),
(3, 200, 'Major delay - air traffic control'),
(4, 130, 'Delayed due to late arrival of aircraft');

INSERT INTO Airlines (airline_id, airline_name)
VALUES (1, 'Lufthansa');


-- Queries--
-- 1. Retrieve all flights from a specific airport
SELECT f.flight_number, f.departure_time, f.arrival_time, f.status
FROM Flights f
JOIN Airports a ON f.departure_airport_id = a.airport_id
WHERE a.iata_code = 'FRA';

-- 2. Identify flights delayed by more than 2 hours
SELECT f.flight_number, fs.delay_minutes, fs.status_description
FROM Flights f
JOIN FlightStatus fs ON f.flight_id = fs.flight_id
WHERE fs.delay_minutes > 120;

-- 3. Fetch flight details using the flight number
SELECT f.flight_number, f.departure_time, f.arrival_time, f.status,
       a1.airport_name AS departure_airport, a2.airport_name AS arrival_airport, al.airline_name
FROM Flights f
JOIN Airports a1 ON f.departure_airport_id = a1.airport_id
JOIN Airports a2 ON f.arrival_airport_id = a2.airport_id
JOIN Airlines al ON f.airline_id = al.airline_id
WHERE f.flight_number = 'LH123';

-- 4. Count total number of flights per airport
SELECT a.airport_name, COUNT(f.flight_id) AS total_flights
FROM Flights f
JOIN Airports a ON f.departure_airport_id = a.airport_id
GROUP BY a.airport_name;


















