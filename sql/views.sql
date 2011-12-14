
-- compute size of table or materialized view in MB
-- pass names in CAPITALIZE LETTERS
select
segment_name table_name,
sum(bytes)/(1024*1024) table_size_meg
from user_extents
where segment_type='TABLE'
and segment_name = '&table_name'
group by segment_name;

select distinct segment_type from user_extents;

-- show tables and materialised views together a view there
select distinct segment_name from user_extents;



create materialized view view_s_m 
build immediate  
--refresh fast on commit
disable query rewrite -- disables oracle by rewriting the queries by itself using this view
as
select sum( s.price * (1-s.discount)  * s.quantity )  from sub_subscription s
join sub_date d on s.keyDate = d.keyDate
join sub_location l on s.keyLocation = l.keyLocation
group by d.month, l.state; 

-- drop materialised view m_test
drop materialized view m_test; 
-- show usr NOT materialized views
select * from user_views;
-- drop normal view
drop view test;
