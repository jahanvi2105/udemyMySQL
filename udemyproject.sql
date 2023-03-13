use udemy;
select* from udemy_graphic;

-- Arrange the shows in the decreasing order of the ratings
select course_id, course_title, (Rating*10) Ratings from udemy_graphic order by Ratings desc;

-- Find the total number of subscribers from enrolled in Graphic Design
select sum(num_subscribers) Total_Subscribers from udemy_graphic;

-- Find the total number of subscribers for the courses where the price is 0 and where the price is not 0
select sum(num_subscribers) Total_Subscribers from udemy_graphic where price >0;
select sum(num_subscribers)Total_Subscribers from udemy_graphic where price =0;

-- Find the total number of reviews 
select sum(num_reviews) Total_Reviews from udemy_graphic;

-- Find what percentage of subscribers are the reviews in each course
select course_title, round(num_reviews*100/num_subscribers,1) Review_Percentage from udemy_graphic order by Review_Percentage desc;

-- Arrange the courses according to their prices
select course_title, price from udemy_graphic order by price desc;

-- Find the number of people who subscribed the udemy courses each year
select extract(Year from published_timestamp) Year,sum(num_subscribers) Yearly_Subscribers from udemy_graphic group by Year order by Yearly_Subscribers desc;

drop table if exists all_courses;
create table all_courses
(course_id int, 
course_title text,
price int, 
num_subscribers int ,
num_reviews int,
num_lectures int, 
level text,
Rating double,
content_duration double, 
published_timestamp text, 
subject text );
insert into all_courses
( select * from udemy_graphic
union
select * from udemy_web
union
select * from udemymusic
);
select * from all_courses;

-- Find the total number of subscribers in all_courses
select sum(num_subscribers) from all_courses;

-- Find the top 30 courses according to the number of subscribers
select course_title, num_subscribers, subject from all_courses order by num_subscribers desc limit 30;

-- Find out the number of people enrolled in each course
select subject,count(*) Course_Count from all_courses group by subject order by Course_Count  desc;

-- Find the average rating of all the three courses
select subject, round(avg(Rating*10),2) Avg_Rating from all_courses group by Subject order by Avg_Rating desc;

-- Find the amount recieved as the fee for each course
select subject, sum(num_subscribers*price) Fee_Recieved from all_courses group by subject order by Fee_Recieved desc;

-- Find the total fee recieved from all the courses
select sum(a.Fee_Received) Total_Fee_collected from 
(
select subject, sum(num_subscribers*price) Fee_Received from all_courses) a ;

-- Find the 10 th highest course according to number of subscribers from the all the courses
select  course_title, num_subscribers from all_courses order by num_subscribers desc limit 9,1;

-- Display the duplicate rows from the table;
select * from(
select *, count(course_id) Count from all_courses group by course_id) a where a.count>1;

-- Find the even course_id and odd course_id
select course_id, course_title from all_courses where mod(course_id,2)=0;
select course_id,course_title from all_courses where mod(course_id,2)=1;

-- Find the top 4 and bottom 4 records of this table after arranging the table in increasing order of course_id
drop table if exists top4; 
create table top4
( course_title text,
course_id int);
insert into top4
(select max(course_id), course_title from all_courses  group by course_id order by course_id limit 4);
select* from top4;

-- Add a new column to the table showing the total fee of each course
alter table all_courses
add column total_fee int;
update all_courses set total_fee= price*num_subscribers order by course_id;

-- Group the courses by their levels
alter table all_courses 
add column level_range int;
update all_courses set level_range=1 where level="beginner level";
update all_courses set level_range= 2 where level="intermediate level";
update all_courses set level_range=3 where level="All levels";
update all_courses set level_range=4 where level="Expert Level";

-- Arrange the courses according to their levels
select course_title, level from all_courses order by level_range desc;

-- Count the courses in each level
select level,count(level)Course_Level from all_courses group by level_range;








