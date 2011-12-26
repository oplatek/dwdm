
create table android_changes (
	id integer,
	project varchar2(500),
	commit_hash varchar2(500),
	tree_hash varchar2(500),
	parent_hashes varchar2(500),
	author_name varchar2(500),
	author_e_mail varchar2(500),
	author_date date,
	commiter_name varchar2(500),
	commiter_email varchar2(500),
	committer_date date,
	subject varchar2(2000),
	message varchar2(2000),
	target varchar2(2000),
	PRIMARY KEY (id)
);


create table android_platform_bugs (
	bugid integer NOT NULL,
	title varchar2(500),
	status varchar2(500),
	owner varchar2(500),
	closedOn date,
	type varchar2(500),
	priority varchar2(500),
	component varchar2(500),
	stars integer,
	reportedBy varchar2(500),
	openedDate date,
	description varchar2(2000),
	PRIMARY KEY (bugid)
);


create table android_platform_bugs_comments (
	id integer NOT NULL,
	bugid integer NOT NULL,
	author varchar2(500),
	when date,
	what varchar2(2000),
	PRIMARY KEY (id),
	FOREIGN KEY (bugid) REFERENCES android_platform_bugs(bugid)
);


