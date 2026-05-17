-- Update Airlines: change contact number forAirlineID 1
UPDATE Airline SET ContactNum = '+92-300-1234567' WHERE AirlineID = 1;
SELECT * FROM Airline;


-- Update Airport city for AirportId is 1
UPDATE Airport SET City = 'Lahore' WHERE AirportID = 1;
SELECT * FROM Airport;

-- Update Staff roles
UPDATE Staff SET Role = 'Cabin Crew' WHERE StaffID IN (1,2);
SELECT * FROM Staff;
-- Update Reservation status
UPDATE Reservation SET ResStatus = 'Cancelled' WHERE ReservationID = 3;
SELECT * FROM Reservation;
-- Update Payment status
UPDATE Payment SET PayStatus = 'Pending' WHERE PayID = 2;
SELECT * FROM Payment;
-- Update BoardingPass GateNum
UPDATE BoardingPass SET GateNum = 'B12' WHERE BoardingPassID BETWEEN 1 AND 3;
SELECT * FROM BoardingPass;



