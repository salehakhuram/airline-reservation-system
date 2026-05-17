-- Delete Tickets with TicketID 1 
DELETE FROM Ticket WHERE TicketID = 1;
SELECT * FROM Ticket;
DELETE FROM Payment
WHERE ReservationID = 1; 
DELETE FROM Reservation
WHERE FlightID = 1; -- Delete all reservations using this flight

DELETE FROM Flight
WHERE FlightID = 1; 

-- Step-by-step deletion of all related data before deleting reservation
DELETE FROM ReservationSeat WHERE ReservationID = 3;
DELETE FROM Baggage WHERE ReservationID = 3;
DELETE FROM BoardingPass WHERE ReservationID = 3;
DELETE FROM Ticket WHERE ReservationID = 3;
DELETE FROM Payment WHERE ReservationID = 3;
DELETE FROM Reservation WHERE ReservationID = 3;
SELECT * FROM Reservation ;
-- Apply ON DELETE CASCADE to Seat table for FlightID
ALTER TABLE Seat
DROP CONSTRAINT FK__Seat__FlightID__339FAB6E;

ALTER TABLE Seat
ADD CONSTRAINT FK__Seat__FlightID__339FAB6E
FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
ON DELETE CASCADE;

-- Test query: delete a flight and see cascading
DELETE FROM Flight WHERE FlightID = 3;

-- Check: this should return 0 rows
SELECT * FROM Seat WHERE FlightID = 3;
SELECT * FROM Flight;
SELECT * FROM Seat;
SELECT
    fk.name AS FK_Name,
    tp.name AS TableName,
    cp.name AS ColumnName,
    tr.name AS ReferencedTable,
    cr.name AS ReferencedColumn
FROM 
    sys.foreign_keys fk
JOIN
    sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
JOIN
    sys.tables tp ON fkc.parent_object_id = tp.object_id
JOIN
    sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
JOIN
    sys.tables tr ON fkc.referenced_object_id = tr.object_id
JOIN
    sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
WHERE
    tp.name = 'Flight';

ALTER TABLE Flight
DROP CONSTRAINT FK__Flight__Aircraft__282DF8C2;

ALTER TABLE Flight
ADD CONSTRAINT FK__Flight__Aircraft__282DF8C2
FOREIGN KEY (AircraftID) REFERENCES Aircraft(AircraftID)
ON DELETE CASCADE;
SELECT * FROM Flight;









