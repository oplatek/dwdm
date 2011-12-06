
CREATE TABLE sub_Date
(
   keyDate integer NOT NULL,
   Day smallint NOT NULL,
   Month smallint NOT NULL,
   Year smallint NOT NULL,
   Week smallint NOT NULL,
   Thanksgiving CHAR(1) CHECK (Thanksgiving IN ( 'Y', 'N' )),
   Halloween CHAR(1) CHECK (Halloween IN ( 'Y', 'N' )),
   Easter CHAR(1) CHECK (Easter IN ( 'Y', 'N' )),
   Christmas CHAR(1) CHECK (Christmas IN ( 'Y', 'N' )),
   PRIMARY KEY (keyDate)
);

CREATE TABLE sub_Location
(
   keyLocation integer NOT NULL,
   City VARCHAR(256) NOT NULL,
   State VARCHAR(256) NOT NULL,
   Country VARCHAR(256) NOT NULL,
   Zone VARCHAR(256) NOT NULL,
   Continent VARCHAR(256) NOT NULL,
   PRIMARY KEY (keyLocation)
);

CREATE TABLE sub_Period
(
  keyPeriod integer NOT NULL,
  Name VARCHAR(256) NOT NULL,
  PRIMARY KEY (keyPeriod)
);

CREATE TABLE sub_Subscription
(
   keyDate integer REFERENCES sub_Date(keyDate) NOT NULL,
   keyLocation integer REFERENCES sub_Location(keyLocation) NOT NULL,
   keyPeriod integer REFERENCES sub_Period(keyPeriod) NOT NULL,
   Quantity smallint NOT NULL,
   Price numeric(5,2) NOT NULL,
   Discount numeric(6,5) NOT NULL,
   PRIMARY KEY (keyDate, keyLocation, keyPeriod)
);

