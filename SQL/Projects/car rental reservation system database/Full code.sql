CREATE TABLE Car (
  CarId        INT           PRIMARY KEY,
  Make         VARCHAR(50)   NOT NULL,
  Model        VARCHAR(50)   NOT NULL,
  Year         INT           NOT NULL
);

CREATE TABLE AvailabilityCalendar (
  CarId        INT           NOT NULL,
  CalendarDate DATE          NOT NULL,
  IsAvailable  BIT           NOT NULL
    CONSTRAINT DF_AvCal_IsAvailable DEFAULT 1,
  PRIMARY KEY (CarId, CalendarDate),
  FOREIGN KEY (CarId) REFERENCES Car(CarId)
);

CREATE TABLE ReservationDetails (
  ReservationId INT          IDENTITY PRIMARY KEY,
  CarId         INT          NOT NULL,
  StartDate     DATE         NOT NULL,
  EndDate       DATE         NOT NULL,
  CustomerId    INT          NULL,
  CreatedAt     DATETIME     NOT NULL
    CONSTRAINT DF_Res_CreatedAt DEFAULT GETDATE(),
  CONSTRAINT FK_Res_Car FOREIGN KEY (CarId) REFERENCES Car(CarId),
  CONSTRAINT CK_Res_Dates CHECK (StartDate <= EndDate)
);


select * 
from AvailabilityCalendar;

INSERT INTO AvailabilityCalendar (CarId, CalendarDate)
SELECT c.CarId,
       DATEADD(DAY, v.number, '2025-08-01') AS CalendarDate
FROM Car AS c
CROSS APPLY (
  -- numbers 0 through 30
  SELECT TOP (31) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS number
  FROM master..spt_values
) AS v
WHERE DATEADD(DAY, v.number, '2025-08-01') <= '2025-08-31';


INSERT INTO Car 
Values (01, 'Honda', 'CRV', 2024), 
(02, 'BMW', 'M3', 2025),
(03,'Toyota', 'Camry', 2026);

select * 
from Car

select *
from ReservationDetails

CREATE OR ALTER PROCEDURE dbo.sp_ReserveCar
  @CarId     INT,
  @StartDate DATE,
  @EndDate   DATE
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRANSACTION;

  -- 1. Lock and check availability
  IF EXISTS (
    SELECT 1
    FROM AvailabilityCalendar WITH (UPDLOCK, HOLDLOCK)
    WHERE CarId = @CarId
      AND CalendarDate BETWEEN @StartDate AND @EndDate
      AND IsAvailable = 0
  )
  BEGIN
    ROLLBACK;
    RAISERROR('Car is not available for the requested dates.', 16, 1);
    RETURN;
  END

  -- 2. Insert the reservation
  INSERT INTO ReservationDetails (CarId, StartDate, EndDate)
  VALUES (@CarId, @StartDate, @EndDate);

  -- 3. Mark those dates as unavailable
  UPDATE AvailabilityCalendar
  SET IsAvailable = 0
  WHERE CarId = @CarId
    AND CalendarDate BETWEEN @StartDate AND @EndDate;

  COMMIT;
END;
z
select * 
from AvailabilityCalendar

EXEC dbo.sp_ReserveCar
    @CarId     = 1,
    @StartDate = '2025-08-05',
    @EndDate   = '2025-08-07';

EXEC dbo.sp_ReserveCar
    @CarId     = 2,
    @StartDate = '2025-08-09',
    @EndDate   = '2025-08-11';

EXEC dbo.sp_ReserveCar
    @CarId     = 2,
    @StartDate = '2025-08-10',
    @EndDate   = '2025-08-12';

EXEC dbo.sp_ReserveCar
    @CarId     = 3,
    @StartDate = '2025-08-11',
    @EndDate   = '2025-08-12';

EXEC dbo.sp_ReserveCar
    @CarId     = 3,
    @StartDate = '2025-08-15',
    @EndDate   = '2025-08-16';

EXEC dbo.sp_ReserveCar
    @CarId     = 1,
    @StartDate = '2025-08-15',
    @EndDate   = '2025-08-16';

select * 
from ReservationDetails

/*
5. Write SQL queries to retrieve the following information:
   a. List of all cars available for reservation on a specific date.
   b. List of all reservations made for a specific car.
   c. List of all cars reserved in the month of August 2025.
*/

--  a. List of all cars available for reservation on a specific date.
select CarId
from AvailabilityCalendar
where CalendarDate = '2025-08-10'
and IsAvailable = 1

-- b. List of all reservations made for a specific car.
select
ReservationId
,StartDate
,EndDate
from ReservationDetails
where CarId = 3

-- c. List of all cars reserved in the month of August 2025.
select 
CalendarDate
,max(case when CarId = 1 then 1 else 0 end) as Car_1
,max(case when CarId = 2 then 1 else 0 end) as Car_2
,max(case when CarId = 3 then 1 else 0 end) as Car_3
from AvailabilityCalendar
where IsAvailable = 0
group by CalendarDate
order by CalendarDate asc
