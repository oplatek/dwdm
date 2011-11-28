-- DROP SCHEMA IF EXISTS advert CASCADE; 
-- oracle cannot drop schema without drop user priviliges -> schema is associeted with user according https://forums.oracle.com/forums/thread.jspa?threadID=505126
CREATE SCHEMA advert;

CREATE TABLE advert.Date
(
   keyDate serial NOT NULL,
   Day smallint NOT NULL,
   Month smallint NOT NULL,
   Quarter smallint NOT NULL,
   Year smallint NOT NULL,
   PRIMARY KEY (keyDate)
);

CREATE TABLE advert.Campaign
(
   keyCampaign serial NOT NULL,
   Name text NOT NULL,
   AdvertiserName text NOT NULL,
   AdvertiserCategory text NOT NULL,
   PRIMARY KEY (keyCampaign)
);

CREATE TABLE advert.Advertisement
(
   keyDate integer REFERENCES advert.Date(keyDate) NOT NULL,
   keyCampaign integer REFERENCES advert.Campaign(keyCampaign) NOT NULL,
   Revenue numeric(20,6) NOT NULL,
   Displays integer NOT NULL,
   Clicks integer NOT NULL,
   PRIMARY KEY (keyDate, keyCampaign)
);
