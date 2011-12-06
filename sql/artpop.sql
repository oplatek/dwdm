
CREATE TABLE artpop_Date 
(
   keyDate integer NOT NULL,
   Hour smallint NOT NULL,
   Day smallint NOT NULL,
   Month smallint NOT NULL,
   Year smallint NOT NULL,
   PRIMARY KEY (keyDate)
);

CREATE TABLE artpop_Article 
(
   keyArticle integer NOT NULL,
   Title VARCHAR(256) NOT NULL,
   Subcategory VARCHAR(256) NOT NULL,
   Category VARCHAR(256) NOT NULL,
   Author VARCHAR(256) NOT NULL,
   AuthorExperience VARCHAR(256) NOT NULL,
   AuthorDepartment VARCHAR(256) NOT NULL,
   PublicationdDay smallint NOT NULL,
   PublicationMonth smallint NOT NULL,
   PublicationYear smallint NOT NULL,
   PRIMARY KEY (keyArticle)
);

CREATE TABLE artpop_Tag
(
   keyTag integer NOT NULL,
   Tag VARCHAR(256) NOT NULL,
   PRIMARY KEY (keyTag)
);

CREATE TABLE artpop_ArticleTags
(
   keyTag integer REFERENCES artpop_Tag(keyTag) NOT NULL,
   keyArticle integer REFERENCES artpop_Article(keyArticle) NOT NULL,
   PRIMARY KEY (keyTag, keyArticle)
);

CREATE TABLE artpop_ArticlePopularity
(
   keyDate integer REFERENCES artpop_date(keyDate) NOT NULL,
   keyArticle integer REFERENCES artpop_article(keyArticle) NOT NULL,
   Reads integer NOT NULL,
   Shares integer NOT NULL,
   Comments integer NOT NULL,
   PRIMARY KEY (keyDate, keyArticle)
);
