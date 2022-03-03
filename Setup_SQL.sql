-- This is needed for the AWS Lambda integration to work, which in turn is needed for the API.
CREATE EXTENSION IF NOT EXISTS aws_lambda CASCADE;

DROP TABLE IF EXISTS "USER" CASCADE;
DROP TABLE IF EXISTS "APP" CASCADE;
DROP TABLE IF EXISTS "VULNERABILITY" CASCADE;
DROP TABLE IF EXISTS "APP_VULNERABILITIES" CASCADE;
DROP TABLE IF EXISTS "BUSINESS_UNIT" CASCADE;
DROP TABLE IF EXISTS "COMPUTER" CASCADE;
DROP TABLE IF EXISTS "RUNS" CASCADE;
DROP TABLE IF EXISTS "COMPUTER_VULNERABILITIES" CASCADE;
/*
  I believe all these conditional drop table commands should keep us from running into trouble in the future.
  You might be thinking to yourself, "Gee, does EVERY drop table if exists line need a CASCADE? It seems excessive."
  NO. NO EVERY TABLE DOES NOT NEED A CASCADE. BUT I AM SICK OF SEEING POSTGRESQL YELL AT ME AS I TRY TO DELETE THINGS.
*/

CREATE TABLE "USER"
(
  Username VARCHAR (64) NOT NULL,
  Role VARCHAR (64) NOT NULL,
  FirstName VARCHAR (32) NOT NULL,
  LastName VARCHAR (255) NOT NULL,
  UserID SERIAL NOT NULL,
  -- Note that I changed all the primary keys to "SERIAL." This should hopefully make them auto-increment
  PRIMARY KEY (UserID),
  UNIQUE (Username)
);

CREATE TABLE "APP"
(
  AppID SERIAL NOT NULL,
  Name VARCHAR (255) NOT NULL,
  Version VARCHAR (32) NOT NULL,
  PRIMARY KEY (AppID)
);

CREATE TABLE "VULNERABILITY"
(
  Severity FLOAT NOT NULL,
  VulnID SERIAL NOT NULL,
  cve VARCHAR(32) NOT NULL,
  PRIMARY KEY (VulnID)
);

CREATE TABLE "APP_VULNERABILITIES"
(
  AppID INT NOT NULL,
  VulnID INT NOT NULL,
  PRIMARY KEY (AppID, VulnID),
  -- Take a look at the abomination that follows this comment! Yeah, PostgreSQL and I are not friends when it comes to foreign keys...
  CONSTRAINT AppID_FK
	FOREIGN KEY (AppID)
	REFERENCES "APP"(AppID)
	ON DELETE CASCADE
	/*
	  This "ON DELETE CASCADE" is reeeeeeaaaaaally important. It says "If I delete the object referenced by this foreign key, delete this item as well."
	  The reason we care is that otherwise, PostgreSQL would throw an error and be all grumpy if we ever tried to, say, delete a computer.
	  By including this, we keep it from yelling at us too much and we make database maintanence simple.
	*/
);

CREATE TABLE "BUSINESS_UNIT"
(
  UnitID SERIAL NOT NULL,
  Name VARCHAR (255) NOT NULL,
  Administrator INT NOT NULL,
  Belongs_To INT,
  PRIMARY KEY (UnitID),
  CONSTRAINT Administrator_FK
	FOREIGN KEY (Administrator)
	REFERENCES "USER"(UserID)
	ON DELETE CASCADE,
  CONSTRAINT Belongs_To_FK
    FOREIGN KEY (Belongs_To)
	REFERENCES "BUSINESS_UNIT"(UnitID)
	ON DELETE CASCADE
);

CREATE TABLE "COMPUTER"
(
  Name VARCHAR (32) NOT NULL,
  OperatingSystem VARCHAR (255) NOT NULL,
  ComputerID SERIAL NOT NULL,
  OS_Version VARCHAR (64) NOT NULL,
  UnitID INT NOT NULL,
  PRIMARY KEY (ComputerID),
  CONSTRAINT UnitID_FK
    FOREIGN KEY (UnitID)
	REFERENCES "BUSINESS_UNIT"(UnitID)
	ON DELETE CASCADE,
  UNIQUE (Name)
);

CREATE TABLE "RUNS"
(
  ComputerID INT NOT NULL,
  AppID INT NOT NULL,
  PRIMARY KEY (ComputerID, AppID),
  CONSTRAINT ComputerID_FK
    FOREIGN KEY (ComputerID)
	REFERENCES "COMPUTER"(ComputerID)
	ON DELETE CASCADE,
  CONSTRAINT AppID_FK
	FOREIGN KEY (AppID)
	REFERENCES "APP"(AppID)
	ON DELETE CASCADE
);

CREATE TABLE "COMPUTER_VULNERABILITIES"
(
  VulnID INT NOT NULL,
  ComputerID INT NOT NULL,
  PRIMARY KEY (VulnID, ComputerID),
  CONSTRAINT VulnID_FK
	FOREIGN KEY (VulnID)
	REFERENCES "VULNERABILITY"(VulnID)
	ON DELETE CASCADE,
  CONSTRAINT ComputerID_FK
	FOREIGN KEY (ComputerID)
	REFERENCES "COMPUTER"(ComputerID)
	ON DELETE CASCADE
);
