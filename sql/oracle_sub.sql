DROP SCHEMA IF EXISTS sub CASCADE;
CREATE SCHEMA sub;

CREATE TABLE sub.Date
(
   keyDate serial NOT NULL,
   Day smallint NOT NULL,
   Month smallint NOT NULL,
   Year smallint NOT NULL,
   Week smallint NOT NULL,
   Thanksgiving boolean NOT NULL,
   Halloween boolean NOT NULL,
   Easter boolean NOT NULL,
   Christmas boolean NOT NULL,
   PRIMARY KEY (keyDate)
);

CREATE TABLE sub.Location
(
   keyLocation serial NOT NULL,
   City text NOT NULL,
   State text NOT NULL,
   Country text NOT NULL,
   Zone text NOT NULL,
   Continent text NOT NULL,
   PRIMARY KEY (keyLocation)
);

CREATE TABLE sub.Period
(
  keyPeriod serial NOT NULL,
  Name text NOT NULL,
  PRIMARY KEY (keyPeriod)
);

CREATE TABLE sub.Subscription
(
   keyDate integer REFERENCES sub.Date(keyDate) NOT NULL,
   keyLocation integer REFERENCES sub.Location(keyLocation) NOT NULL,
   keyPeriod integer REFERENCES sub.Period(keyPeriod) NOT NULL,
   Quantity smallint NOT NULL,
   Price numeric(5,2) NOT NULL,
   Discount numeric(6,5) NOT NULL,
   PRIMARY KEY (keyDate, keyLocation, keyPeriod)
);

