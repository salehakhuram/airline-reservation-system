--Queries
-- Shows flights along with aircraft model and airline info
SELECT
    F.FlightNumber,  
    A.Model AS AircraftModel,  
    L.AirlineName  
FROM Flight F
JOIN Aircraft A ON F.AircraftID = A.AircraftID 
JOIN Airline L ON F.AirlineID = L.AirlineID;  
-- Helpful for admins to view booking summaries.
SELECT
    R.ReservationID,  -- Unique ID of the reservation.
    P.FullName,  -- Passenger's full name.
    F.FlightNumber,  -- Flight number of the booked flight.
    R.ResStatus  -- Current reservation status (Confirmed, Pending, Cancelled).
FROM Reservation R
JOIN Passenger P ON R.PassengerID = P.PassengerID  -- Linking reservations with passenger details.
JOIN Flight F ON R.FlightID = F.FlightID;  -- Linking reservations with flight details.
-- View who is seated where, on which flight
SELECT
    F.FlightNumber,  -- Flight number from the Flight table
    S.SeatNumber,  -- Seat number from the Seat table
    P.FullName  -- Passenger's full name from the Passenger table
FROM ReservationSeat RS
JOIN Seat S ON RS.SeatID = S.SeatID  -- Linking reservation seats with seat details
JOIN Reservation R ON RS.ReservationID = R.ReservationID  -- Linking reservation seats with reservations
JOIN Passenger P ON R.PassengerID = P.PassengerID  -- Linking reservations with passenger details
JOIN Flight F ON S.FlightID = F.FlightID;  -- Linking seats with flights
-- Flight crew assignment viewer.
SELECT
    F.FlightNumber,  -- Flight number from the Flight table
    S.FullName,  -- Full name of the flight staff from the Staff table
    FS.AssignmentRole  -- Role of the flight crew from the FlightStaff table
FROM FlightStaff FS
JOIN Flight F ON FS.FlightID = F.FlightID  -- Linking flight staff with flight details
JOIN Staff S ON FS.StaffID = S.StaffID;  -- Linking flight staff with personal details
-- Baggage tracking and ownership.
SELECT 
    P.FullName,
    B.BaggageTag,
    B.Weight,
    B.Status
FROM Baggage B
JOIN Reservation R ON B.ReservationID = R.ReservationID
JOIN Passenger P ON R.PassengerID = P.PassengerID;

--Show where each flight goes and from where
SELECT 
    F.FlightNumber,
    A1.AirportName AS Origin,
    A2.AirportName AS Destination,
    R.Distance
FROM Flight F
JOIN Route R ON F.RouteID = R.RouteID
JOIN Airport A1 ON R.OriginAirportID = A1.AirportID
JOIN Airport A2 ON R.DestinationAirportID = A2.AirportID;
--Get all confirmed reservations with passenger and flight info
SELECT 
    P.FullName,
    F.FlightNumber,
    R.ResStatus
FROM Reservation R
INNER JOIN Passenger P ON R.PassengerID = P.PassengerID
INNER JOIN Flight F ON R.FlightID = F.FlightID
WHERE R.ResStatus = 'Confirmed';
--List all flights even if no aircraft is assigned yet
SELECT
    F.FlightNumber, A.Model
AS AircraftModel
FROM Flight F
LEFT JOIN Aircraft A ON F.AircraftID = A.AircraftID;
--List all aircraft and show if they're used in any flight
SELECT
    A.Model,
    F.FlightNumber
FROM Flight F
RIGHT JOIN Aircraft A ON F.AircraftID = A.AircraftID;
-- Select the airline name and flight number from both Airline and Flight tables
SELECT
    A.AirlineName,
    F.FlightNumber
FROM Airline A
FULL OUTER JOIN Flight F ON A.AirlineID = F.AirlineID;

--Total number of reservations per flight
SELECT
    F.FlightNumber,
    COUNT(R.ReservationID) AS TotalReservations
FROM Flight F
LEFT JOIN Reservation R ON F.FlightID = R.FlightID
GROUP BY F.FlightNumber;

-- SubQueries 

SELECT FullName -- Get the full names of passengers
FROM Passenger
WHERE PassengerID IN (
SELECT PassengerID FROM Reservation
WHERE FlightID IN (
SELECT FlightID FROM Flight
WHERE FlightNumber = 'PK101')); -- Find the FlightID of flight 'PK101'

--Show flights with the highest number of reservations
SELECT * FROM Flight
WHERE FlightID = ( SELECT TOP 1 FlightID
FROM Reservation
GROUP BY FlightID
ORDER BY COUNT(*) DESC );
SELECT FlightNumber
FROM Flight
WHERE AircraftID IN (
SELECT AircraftID FROM Aircraft WHERE Capacity > 150);
--Flights with less than 2 reservations
SELECT FlightNumber, DepartureTime, ArrivalTime
FROM Flight
WHERE FlightID IN (
SELECT FlightID FROM Reservation
GROUP BY FlightID
HAVING COUNT(ReservationID) < 2);
--Aircraft models used by 'Airblue'
SELECT Model
FROM Aircraft
WHERE AircraftID IN (
SELECT AircraftID FROM Flight WHERE AirlineID = (
SELECT AirlineID FROM Airline
WHERE AirlineName = 'Airblue'));
--Flights with aircraft having capacity greater than 150
SELECT FlightNumber
FROM Flight
WHERE AircraftID IN (
SELECT AircraftID FROM Aircraft WHERE Capacity > 150);
--Unreserved seats for Flight ID 1
SELECT SeatNumber
FROM Seat
WHERE FlightID = 1
AND SeatId NOT IN (
SELECT SeatID FROM ReservationSeat WHERE ReservationID IN (
SELECT ReservationID FROM Reservation WHERE FlightID = 1));
--Tickets issued in the last 30 days
SELECT TicketID
FROM Ticket
WHERE IssueDate >= DATEADD(day, -30, GETDATE());
 --Lost baggage booked after Jan 1, 2025
SELECT BaggageTag
FROM Baggage
WHERE Status = 'Lost' AND ReservationID IN (
SELECT ReservationID FROM Reservation WHERE BookingDate >= '2025-01-01');
--Find flights that have any reservations
SELECT FlightID, FlightNumber
FROM Flight
WHERE FlightID IN (
SELECT DISTINCT FlightID
FROM Reservation);