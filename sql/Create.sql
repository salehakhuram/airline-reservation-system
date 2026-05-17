-- Table to store aircraft information
CREATE TABLE Aircraft (
    AircraftID INT PRIMARY KEY, -- Unique ID for the aircraft
    Model VARCHAR(50) NOT NULL, -- Model name of the aircraft
    Manufacturer VARCHAR(50) NOT NULL, -- Manufacturer name
    Capacity INT NOT NULL, -- Seating capacity
    AircraftCode VARCHAR(20) NOT NULL, -- Unique aircraft code
    AirlineID INT NOT NULL -- Associated airline
);

-- Table to store airline information
CREATE TABLE Airline (
    AirlineID INT PRIMARY KEY, -- Unique ID for the airline
    AirlineName VARCHAR(100) NOT NULL, -- Name of the airline
    Country VARCHAR(50) NOT NULL, -- Country where the airline is based
    ContactNum VARCHAR(20) NOT NULL, -- Contact phone number
    Website VARCHAR(100) NOT NULL -- Official website
);

-- Table to store airport details
CREATE TABLE Airport (
    AirportID INT PRIMARY KEY, -- Unique airport ID
    AirportName VARCHAR(100) NOT NULL, -- Name of the airport
    City VARCHAR(50) NOT NULL, -- City where the airport is located
    Country VARCHAR(50) NOT NULL, -- Country where the airport is located
    IATA_Code CHAR(3) NOT NULL -- Standard 3-letter IATA airport code
);

-- Table to store baggage details for reservations
CREATE TABLE Baggage (
    BaggageID INT PRIMARY KEY, -- Unique ID for baggage
    ReservationID INT NOT NULL, -- Linked reservation
    Weight DECIMAL NOT NULL, -- Weight of baggage
    BaggageTag VARCHAR(20) NOT NULL, -- Tag identifier
    Status VARCHAR(20) NOT NULL -- e.g., Checked, Loaded, Lost
);

-- Table to store boarding pass information
CREATE TABLE BoardingPass (
    BoardingPassID INT PRIMARY KEY, -- Unique boarding pass ID
    ReservationID INT NOT NULL, -- Linked reservation
    IssueDate DATE NOT NULL, -- Date boarding pass was issued
    GateNum VARCHAR(10) NOT NULL, -- Assigned gate
    BoardingTime DATETIME NOT NULL -- Time for boarding
);

-- Table to store flight information
CREATE TABLE Flight (
    FlightID INT PRIMARY KEY, -- Unique flight ID
    FlightNumber VARCHAR(10) NOT NULL, -- Public flight number
    Duration TIME NOT NULL, -- Duration of the flight
    AircraftID INT NOT NULL, -- Assigned aircraft
    AirlineID INT NOT NULL, -- Operating airline
    RouteID INT NOT NULL -- Flight route
);

-- Table to assign staff members to flights
CREATE TABLE FlightStaff (
    FlightID INT NOT NULL, -- Linked flight
    StaffID INT NOT NULL, -- Linked staff member
    AssignmentRole VARCHAR(50) NOT NULL -- Role on the flight (e.g., Pilot, Attendant)
);

-- Table to store passenger information
CREATE TABLE Passenger (
    PassengerID INT NOT NULL, -- Unique passenger ID
    FullName VARCHAR(100) NOT NULL, -- Full name
    Gender CHAR(1) NOT NULL, -- Gender (M/F)
    DateOfBirth DATE NOT NULL, -- Date of birth
    Email VARCHAR(100) NOT NULL, -- Email address
    PhoneNum VARCHAR(20) NOT NULL, -- Contact number
    Nationality VARCHAR(50) NOT NULL, -- Country of nationality
    PassportNum VARCHAR(20) NOT NULL, -- Passport number
    UserID NVARCHAR(10), -- Foreign key to Users table
    PRIMARY KEY (PassengerID),
    CONSTRAINT FK_Passenger_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table to store payment details
CREATE TABLE Payment (
    PayID INT NOT NULL, -- Unique payment ID
    ReservationID INT NOT NULL, -- Linked reservation
    PayDate DATE NOT NULL, -- Date of payment
    Amount DECIMAL NOT NULL, -- Amount paid
    PayMethod VARCHAR(50) NOT NULL, -- Payment method (e.g., Card, Cash)
    PayStatus VARCHAR(20) NOT NULL -- Status (e.g., Pending, Completed)
);

-- Table to store reservation records
CREATE TABLE Reservation (
    ReservationID INT NOT NULL, -- Unique reservation ID
    PassengerID INT NOT NULL, -- Passenger who made the reservation
    FlightID INT NOT NULL, -- Reserved flight
    BookingDate DATE NOT NULL, -- Date of booking
    ResStatus VARCHAR(20) NOT NULL, -- Status (e.g., Confirmed, Cancelled)
    Class VARCHAR(20) NOT NULL, -- Travel class (e.g., Economy)
    TotalFare DECIMAL NOT NULL, -- Total fare for the reservation
    SeatID INT NOT NULL -- Assigned seat
);

-- Table to store airline staff details
CREATE TABLE Staff (
    StaffID INT NOT NULL, -- Unique staff ID
    FullName VARCHAR(100) NOT NULL, -- Name of the staff member
    Role VARCHAR(50) NOT NULL, -- Job title or role
    ContactInfo VARCHAR(100) NOT NULL, -- Contact details
    UserID NVARCHAR(10), -- Foreign key to Users table
    PRIMARY KEY (StaffID),
    CONSTRAINT FK_Staff_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
);


-- Table to store ticket details linked to reservations
CREATE TABLE Ticket (
    TicketID INT NOT NULL, -- Unique ticket ID
    ReservationID INT NOT NULL, -- Associated reservation
    IssueDate DATE NOT NULL, -- Date ticket was issued
    TicketNumber VARCHAR(30) NOT NULL, -- Ticket reference number
    TicketType VARCHAR(20) NOT NULL, -- Type (e.g., One-way, Round-trip)
    PRIMARY KEY (TicketID),
    FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID)
);

-- Table for system users (admin, staff, etc.)
CREATE TABLE Users (
    UserID NVARCHAR(10) NOT NULL, -- User login ID
    FullName NVARCHAR(100) NOT NULL, -- Full name
    Username NVARCHAR(50) NOT NULL, -- Login username
    Password NVARCHAR(255) NOT NULL, -- Password
    Role NVARCHAR(10) NOT NULL, -- Role (e.g., Admin, Clerk)
    PRIMARY KEY (UserID)
);

-- Table to store seat information for flights
CREATE TABLE Seat (
    SeatID INT NOT NULL PRIMARY KEY, -- Unique seat ID
    FlightID INT NOT NULL, -- Associated flight
    SeatNumber VARCHAR(10) NOT NULL, -- e.g., 12A
    Class VARCHAR(20) NOT NULL, -- Seat class (Economy, Business)
    AvailabilityStatus VARCHAR(20) NOT NULL, -- e.g., Available, Booked
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
);

-- Table to store flight routes
CREATE TABLE Route (
    RouteID INT NOT NULL, -- Unique route ID
    OriginAirportID INT NOT NULL, -- Starting airport
    DestinationAirportID INT NOT NULL, -- Destination airport
    Distance DECIMAL NULL, -- Distance in km/miles
    PRIMARY KEY (RouteID),
    FOREIGN KEY (OriginAirportID) REFERENCES Airport(AirportID),
    FOREIGN KEY (DestinationAirportID) REFERENCES Airport(AirportID)
);

-- Linking table for many-to-many relationship between Reservation and Seat
CREATE TABLE ReservationSeat (
    ReservationID INT NOT NULL, -- Linked reservation
    SeatID INT NOT NULL, -- Linked seat
    PRIMARY KEY (ReservationID, SeatID),
    FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID),
    FOREIGN KEY (SeatID) REFERENCES Seat(SeatID)
);

-- Linking table for Flights and Schedules
CREATE TABLE FlightSchedule (
    ScheduleID INT NOT NULL PRIMARY KEY, -- Unique schedule ID
    FlightID INT NOT NULL, -- Linked flight
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
);
