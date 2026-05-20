use apps_and_crunchbase;

-- retrieve the name of the app that has the highest number of ratings and the number of ratings it received 
select a.name, r.rating_count as rating_count
from apps a 
join app_reviews r on a.id = r.id
group by a.name
order by rating_count desc
limit 1;

-- retrieve the name and primary category for the apps that are game-center enabled and whose primary category is not "Games"
select a.name, a.category_primary
from apps a
where a.game_center = 1
and a.category_primary != 'Games'; 

-- in which prmary category, the apps have the highest mean average_rating 
select a.category_primary, AVG(r.average_rating) as average_rating
from apps a 
join app_reviews r on a.id = r.id
group by a.category_primary 
order by average_rating desc;

-- list the total number of ratings recieved for each primary category in descending order
select a.category_primary, count(rating_count) as review_count
from apps a 
join app_reviews r on a.id = r.id
group by a.category_primary
order by review_count desc;

-- list the primary category, number of ratings and average ratings for the app "Google Earth"
select a.category_primary, r.rating_count as rating_count, r.average_rating as average_rating 
from apps a 
join app_reviews r on a.id = r.id 
where a.name = 'Google Earth' 
group by a.category_primary; 

-- show the top list and list the total number of apps in each top list from the table top300. anything you can say about the findings? 
select t.list as top_list, count(a.id) as total_apps 
from top300 t 
join apps a on a.id = t.id
group by top_list
order by total_apps desc;

-- in the "top free" list, which two primary categories appear most often? 
select a.category_primary, count(a.category_primary) as category_count
from apps a 
join top300 t on a.id = t.id 
where t.list = "top free" 
group by a.category_primary 
order by category_count desc;

-- what is the shortest amount of time in number of days between an apps release date and the date an app makes to the top list? what do you think about this information?
select min((date(t.insert_time) - date(a.release_date))) as shortest_days
from apps a 
join top300 t on a.id = t.id; 

-- on aug 31, do we miss any data for any of the top lists? please provide evidence to support your answer
select distinct t.list as missing_data, tlt.id
from top300 t 
left join top300 tlt
on t.id = tlt.id and tlt.insert_time = '2024-08-31'
where tlt.id is null;

-- is the apps table complete? that is, do we have data on all apps that appear in the top 300 list? 

select distinct t.id as missing_data, a.id as apps_id
from top300 t 
left join apps a on t.id = a.id
where a.id is null; 


select count(*) as errors 
from apps a 
join app_categories as ac 
on a.id = ac.id 
where a.developer not like ac.developer;

select count(*) as total 
from apps a 
join app_categories as ac 
on a.id = ac.id 
where a.developer like ac.developer; 
