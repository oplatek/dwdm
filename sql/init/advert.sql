/* do not use schema -> we do not have user priviliges */
/* create separate drop tables sql script */
/* serial can not be used we have to create  
    http://www.techonthenet.com/oracle/sequences.php */
/* change text -> VARCHAR(CONSTANT) */

CREATE TABLE advert_Date
(
   keyDate integer NOT NULL,
   Day smallint NOT NULL,
   Month smallint NOT NULL,
   Quarter smallint NOT NULL,
   Year smallint NOT NULL,
   PRIMARY KEY (keyDate)
);

CREATE TABLE advert_Campaign
(
   keyCampaign integer NOT NULL,
   Name VARCHAR(255) NOT NULL,
   AdvertiserName VARCHAR(255) NOT NULL,
   AdvertiserCategory VARCHAR(255) NOT NULL,
   PRIMARY KEY (keyCampaign)
);

CREATE TABLE advert_Advertisement
(
   keyDate integer REFERENCES advert_Date(keyDate) NOT NULL,
   keyCampaign integer REFERENCES advert_Campaign(keyCampaign) NOT NULL,
   Revenue numeric(20,6) NOT NULL,
   Displays integer NOT NULL,
   Clicks integer NOT NULL,
   PRIMARY KEY (keyDate, keyCampaign)
);
