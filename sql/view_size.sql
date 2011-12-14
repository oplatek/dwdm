-- QUERY 3
select l.country, sum(price * (1-discount) * quantity) revenue, 
  sum(quantity) subscriptions 
from oplatek.sub_subscription s 
join oplatek.sub_location l on s.keylocation = l.keylocation 
join oplatek.sub_date d on s.keydate=d.keydate and d.year=2010
group by l.country 
order by revenue desc;

--QUERY 4
select * from (select country, city, 
  sum(price * (1-discount) * quantity) revenue, 
  rank() over(partition by country 
    order by sum(price * (1-discount) * quantity) desc) rank 
from oplatek.sub_subscription s 
join oplatek.sub_date d 
  on s.keydate = d.keydate and d.year = 2010
join oplatek.sub_location l 
  on s.keylocation = l.keylocation
group by l.country, l.city
order by revenue desc)
where rank <= 10;

--QUERY 7
select l.state, d.month, 
  sum(price * (1-discount) * quantity) revenue,
  /* avg_revenue_in_this_month_across_all_states */
  avg(sum(price * (1-discount) * quantity)) 
    over (partition by month) avg_rev 
from oplatek.sub_subscription s 
join oplatek.sub_location l 
    on s.keylocation = l.keylocation and l.country = 'Canada' 
join oplatek.sub_date d 
    on s.keydate = d.keydate and d.year = 2010
where length(l.state) = 2
group by l.state, d.month
order by state asc, month asc;



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



create materialized view view_co 
build immediate  
--refresh fast on commit
disable query rewrite -- disables oracle by rewriting the queries by itself using this view
as
select sum( s.price * (1-s.discount)  * s.quantity )  from sub_subscription s
join sub_date d on s.keyDate = d.keyDate
join sub_location l on s.keyLocation = l.keyLocation
--group by d.month, l.state; -- view_s_m 
--group by l.state; -- view_s
--group by d.month; -- view_m
group by l.country; -- view_co


-- drop materialised view NAME
drop materialized view view_d; 
-- show usr NOT materialized views
select * from user_views;
-- drop normal view
drop view test;
