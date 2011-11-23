DROP SCHEMA IF EXISTS artpop CASCADE;
CREATE SCHEMA artpop;

CREATE TABLE artpop.Date (
   keyDate serial NOT NULL,
   Hour smallint NOT NULL,
   Day smallint NOT NULL,
   Month smallint NOT NULL,
   Year smallint NOT NULL,
   PRIMARY KEY (keyDate)
);

CREATE TABLE artpop.Article (
   keyArticle serial NOT NULL,
   Title text NOT NULL,
   Subcategory text NOT NULL,
   Category text NOT NULL,
   Author text NOT NULL,
   AuthorExperience text NOT NULL,
   AuthorDepartment text NOT NULL,
   PublicationdDay smallint NOT NULL,
   PublicationMonth smallint NOT NULL,
   PublicationYear smallint NOT NULL,
   PRIMARY KEY (keyArticle)
);

CREATE TABLE artpop.Tag
(
   keyTag serial NOT NULL,
   Tag text NOT NULL,
   PRIMARY KEY (keyTag)
);

CREATE TABLE artpop.ArticleTags
(
   keyTag integer REFERENCES artpop.Tag(keyTag) NOT NULL,
   keyArticle integer REFERENCES artpop.Article(keyArticle) NOT NULL,
   PRIMARY KEY (keyTag, keyArticle)
);

CREATE TABLE artpop.ArticlePopularity
(
   keyDate integer REFERENCES artpop.date(keyDate) NOT NULL,
   keyArticle integer REFERENCES artpop.article(keyArticle) NOT NULL,
   Reads integer NOT NULL,
   Shares integer NOT NULL,
   Comments integer NOT NULL,
   PRIMARY KEY (keyDate, keyArticle)
);
