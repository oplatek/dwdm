/* 1. TODO DATA  country only Canada*/
SELECT DISTINCT l.Country, l.Continent FROM sub_Location l;
/* 2. TODO DATA only NOT holidays */
SELECT DISTINCT d.Thanksgiving, d.Christmas, d.Easter FROM sub_Date d;


/* Subscription queries */
  /* 1. [Ondra]Revenue from subscriptions by year. */

SELECT SUM(ss.price), sd.YEAR FROM 
      sub_Date sd INNER JOIN sub_Subscription ss ON (sd.keyDate = ss.keyDate)  
      GROUP BY sd.YEAR ORDER BY sd.YEAR;

  /*
 2. Most popular period by year.
 3. [Ondra]Most revenue and quantity from subscriptions by country. 
     todo - do not undestand
     todo - return only Canada
 */
 
SELECT SUM(ss.price), SUM(ss.Quantity), sl.Country FROM 
       sub_Location sl INNER JOIN sub_Subscription ss ON (sl.keyLocation = ss.keyLocation)  
      GROUP BY sl.Country;
    
  
  /*
 4. How much we would earn without applying discounts on subscription by period type by year.
 5. [Ondra]Number of sales on different holidays in 2010 by period in United States.
 */
 SELECT SUM(ss.Quantity) FROM sub_Date sd, sub_Location sl, sub_Subscription ss  
 WHERE sd.keyDate = ss.keyDate AND sl.keyLocation = ss.keyLocation
 /* TODO WE DO NOT HAVE ANY HOLIDAYS!!! AND sd.Thanksgiving = 'Y' OR sd.Halloween = 'Y' OR sd.Easter = 'Y' OR sd.Christmas = 'Y'*/  
 AND sd.Year = 2010 AND sl.Country='Canada'; /*todo change to United States*/
 
 /*
 6. The cities with biggest revenue by country.
 7. [Ondra]Revenue by month and by state in United States together with average revenue by states in United States in the same month
*/
SELECT SUM(ss.Price) AS "state revenue", AVG(groupedstates_revenu) AS "average revenue across states" 
FROM sub_Date, sub_Location, sub_Subscription
WHERE sd.keyDate = ss.keyDate AND sl.keyLocation = ss.keyLocation
AND sl.Country='USA' /* todo add usa */
GROUP BY GROUPING SETS((sl.State,sl.Country),sd.Month);


/*
Article queries
 1. Top 10 read articles and author for every week in year 2011.
 2. [Ondra]Hours of the day when most articles are read, grouped by
category in year
    2010 + average number of articles read for the hour in year 2010
 3. Most read of articles by the day of week group by week together with avg
    num of articles read on this day of week
 4. [Ondra]Most commented authors group by category
 5. Each author's most read articles with num of reads together with avg num of reads for this author' s department and each author in this avg query has to have at least 20 articles and all these articles must be at least 1 month old
 6. [Ondra]The articles with #comments/ #reads higher and average #comments/#reads
    by category having more reads than 20000 and which are older than month
    group by category
 7. Comparing number of reads/shares/comments tagged with positive and
    negative group by year with ratio. Also the same with short/medium/long
 8. [Ondra] Most popular tags: Top 100 tags which has the highest value of number of articles with tags divided with number with the tags.
*/

/*
Advertisement queries
 1. Revenue by year together with average revenue in all years together with
    revenue in year and together with next year
 2. [Ondra]CPM(Clicks divided by displays) for top 10 advertisers by
revenue together
    with avg CPM for advertisers category having the advertiser at least 5
    campaigns
 3. Revenue by advertiser category with revenue by limits 10k/20k/30/k
 4. [Ondra]The Campaigns which lasted more then 5 month with revenue
bigger than
    10000 per month
 5. Most popular campaigns by category and year together with avg CPM per
    month in this year for every month
    */
