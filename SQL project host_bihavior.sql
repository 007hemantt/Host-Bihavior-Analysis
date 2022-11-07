use host_bihavior_analysis;

---1. collects all data sets from China country.

--(a) collects all data sets from Beijing City.

select* from [dbo].[df_beijing_availability];
select*from [dbo].[host_beijing_df];
select*from [dbo].[listing_beijing_df];
select*from [dbo].[review_beijing_df];

--(a) collects all data sets from Shanghai City.

select* from [dbo].[df_shanghai_availability];
select*from [dbo].[host_shanghai_df];
select*from [dbo].[review_shanghai_df];
select*from [dbo].[listing_shanghai_df];
--2. join all Beijing table
select * from [dbo].[df_beijing_availability] as A FULL OUTER JOIN [dbo].[listing_beijing_df] as B on A.id = B.host_id
FULL OUTER JOIN  [dbo].[review_beijing_df] as C on A.id=C.id FULL OUTER JOIN [dbo].[host_beijing_df] as D on A.id=D.host_id;

--2. join all Shanghai City  table

select * from [dbo].[df_shanghai_availability] as X FULL OUTER JOIN [dbo].[listing_shanghai_df] as Y on X.id = Y.host_id
FULL OUTER JOIN  [dbo].[review_shanghai_df] as Z on X.id=Z.id FULL OUTER JOIN [dbo].[host_shanghai_df] as S on X.id=S.host_id;

--- union all Beijing and Shanghai 

select * from [dbo].[df_beijing_availability] as A FULL OUTER JOIN [dbo].[listing_beijing_df] as B on A.id = B.host_id
FULL OUTER JOIN  [dbo].[review_beijing_df] as C on A.id=C.id FULL OUTER JOIN [dbo].[host_beijing_df] as D on A.id=D.host_id
union all
select * from [dbo].[df_shanghai_availability] as X FULL OUTER JOIN [dbo].[listing_shanghai_df] as Y on X.id = Y.host_id
FULL OUTER JOIN  [dbo].[review_shanghai_df] as Z on X.id=Z.id FULL OUTER JOIN [dbo].[host_shanghai_df] as S on X.id=S.host_id;


--a. Analyze different metrics to draw the distinction between Super Host and Other Hosts:

select * from 
(
(select * from [dbo].[df_beijing_availability] as A 
FULL OUTER JOIN [dbo].[listing_beijing_df] as B on A.id = B.host_id
FULL OUTER JOIN  [dbo].[review_beijing_df] as C on A.id=C.id 
FULL OUTER JOIN [dbo].[host_beijing_df] as D on A.id=D.host_id
)
union
(
select * from [dbo].[df_shanghai_availability] as X 
FULL OUTER JOIN [dbo].[listing_shanghai_df] as Y on X.id = Y.host_id
FULL OUTER JOIN  [dbo].[review_shanghai_df] as Z on X.id=Z.id 
FULL OUTER JOIN [dbo].[host_shanghai_df] as S on X.id=S.host_id)) as c ;

group by host_is_superhost ;




select*from [dbo].[host_shanghai_df];
select host_name, host_is_superhost from [dbo].[host_shanghai_df];

select*from [dbo].[host_shanghai_df] group by host_is_superhost having count(host_is_superhost)= 'True' ;

select*from [dbo].[host_shanghai_df] where host_is_superhost='False';

--no of count host and super host.

select sum(case when host_is_superhost = 'false' then 1 else 0 end) AS false_ct, 
sum(case when host_is_superhost = 'true' then 1 else 0 end) AS true_ct from host_beijing_df

select sum(case when host_is_superhost = 'false' then 1 else 0 end) AS false_ct, 
sum(case when host_is_superhost = 'true' then 1 else 0 end) AS true_ct from host_shanghai_df




-----finding superhost review ratings

select h.host_id, avg(l.review_scores_rating) from host_beijing_df as h full outer join 
listing_beijing_df as l on h.host_id = l.host_id where h.host_is_superhost='true'
group by h.host_id;

select avg(l.review_scores_rating) from host_beijing_df as h full outer join
listing_beijing_df as l on h.host_id = l.host_id where h.host_is_superhost='true'
;




--finding host review ratings
select h.host_id, avg(l.review_scores_rating) from host_beijing_df as h full outer join
listing_shanghai_df as l on h.host_id = l.host_id where h.host_is_superhost='false'
group by h.host_id;

select avg(l.review_scores_rating) from host_beijing_df as h full outer join
listing_shanghai_df as l on h.host_id = l.host_id where h.host_is_superhost='false'




--a. Analyze different metrics to draw the distinction between Super Host and Other Hosts:
--To achieve this, you can use the following metrics and explore a few yourself as well.
--Acceptance rate, response rate, instant booking, profile picture, identity verified, 
--review scores, average no of bookings per month, etc.

--Acceptance rate

select*from [dbo].[host_shanghai_df];

select avg(host_acceptance_rate) as host_acceptance_rate,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type from [dbo].[host_shanghai_df]
where host_is_superhost='False' group by host_is_superhost ;

select  avg(host_acceptance_rate) as host_acceptance_rate ,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type from [dbo].[host_shanghai_df]
where host_is_superhost='True' group by host_is_superhost ;
--avg Acceptance rate
select top 2  avg(host_acceptance_rate) as host_acceptance_rate ,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type from [dbo].[host_shanghai_df] group by host_is_superhost ;



--response rate

select host_response_rate,host_is_superhost from [dbo].[host_shanghai_df] where host_is_superhost='False';
select host_response_rate,host_is_superhost from [dbo].[host_shanghai_df] where host_is_superhost='True';


--avg response rate

select top 2  avg(host_response_rate) as host_response_rate ,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type from [dbo].[host_shanghai_df] group by host_is_superhost ;
--instant booking

select host_name, (case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type,instant_bookable from(
select host_id,instant_bookable from [dbo].[listing_shanghai_df]) as A inner join 
(select host_name, host_id,host_is_superhost from [dbo].[host_shanghai_df] where host_is_superhost='True') as B on A.host_id=B.host_id;


select host_name, (case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type,instant_bookable from(
select host_id,instant_bookable from [dbo].[listing_shanghai_df]) as A inner join 
(select host_name, host_id,host_is_superhost from [dbo].[host_shanghai_df] where host_is_superhost='False') as B on A.host_id=B.host_id;



---profile picture


select host_has_profile_pic,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type from [dbo].[host_shanghai_df] where host_is_superhost='False';

select host_has_profile_pic,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type from [dbo].[host_shanghai_df] where host_is_superhost='True';


---identity verified


select host_identity_verified,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type from [dbo].[host_shanghai_df] where host_is_superhost='False';

select host_identity_verified,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type from [dbo].[host_shanghai_df] where host_is_superhost='True';

--review scores

select*from [dbo].[listing_shanghai_df] as A inner join [dbo].[review_shanghai_df] as B on A.id=B.listing_id
inner join [dbo].[host_shanghai_df] as C on C.host_id=A.host_id
select*from [dbo].[listing_shanghai_df] as A inner join [dbo].[host_shanghai_df] as B on A.host_id=B.host_id;



---review scores other host
select host_name,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type,review_scores_accuracy,review_scores_checkin,review_scores_cleanliness,review_scores_communication
,review_scores_location,review_scores_rating,review_scores_value  from(
select host_id,review_scores_accuracy,review_scores_checkin,review_scores_cleanliness,review_scores_communication
,review_scores_location,review_scores_rating,review_scores_value from [dbo].[listing_shanghai_df]) as A inner join 
(select host_name, host_id,host_is_superhost from [dbo].[host_shanghai_df] where host_is_superhost='False') as B on A.host_id=B.host_id;

---review scores super host

select host_name,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type,review_scores_accuracy,review_scores_checkin,review_scores_cleanliness,review_scores_communication
,review_scores_location,review_scores_rating,review_scores_value  from(
select host_id,review_scores_accuracy,review_scores_checkin,review_scores_cleanliness,review_scores_communication
,review_scores_location,review_scores_rating,review_scores_value from [dbo].[listing_shanghai_df]) as A inner join 
(select host_name, host_id,host_is_superhost from [dbo].[host_shanghai_df] where host_is_superhost='True') as B on A.host_id=B.host_id;

---average no of bookings per month**

select avg(booking_per_month) as avg_booking_per_month,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type from(
select count(listing_id) as booking_per_month,B.host_is_superhost,month(date) as month from [dbo].[review_shanghai_df] as A inner join [dbo].[host_shanghai_df] as B
on A.reviewer_name = B.host_name
group by month(date),host_is_superhost)c group by host_is_superhost ;

---b. Using the above analysis, identify the top 3 crucial metrics one needs to maintain to become a Super Host and also, find their average values.

--all super host avg review
select (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) as host_type, 
avg(review_scores_accuracy) avg_review_scores_accuracy,avg(review_scores_checkin) avg_review_scores_checkin
,avg(review_scores_cleanliness) avg_review_scores_cleanliness,
avg(review_scores_communication) avg_review_scores_communication
,avg(review_scores_location) avg_review_scores_location,avg(review_scores_rating) avg_review_scores_rating,
avg(review_scores_value) avg_review_scores_value  from(
select host_id,review_scores_accuracy,review_scores_checkin,review_scores_cleanliness,review_scores_communication
,review_scores_location,review_scores_rating,review_scores_value from [dbo].[listing_shanghai_df]) as A inner join 
(select host_id,host_is_superhost from [dbo].[host_shanghai_df] where host_is_superhost='True') 
as B on A.host_id=B.host_id group by (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end);

--all other host avg review

select (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end)
as host_type, avg(review_scores_accuracy) avg_review_scores_accuracy,
avg(review_scores_checkin) avg_review_scores_checkin,avg(review_scores_cleanliness) avg_review_scores_cleanliness,
avg(review_scores_communication) avg_review_scores_communication,avg(review_scores_location) avg_review_scores_location,
avg(review_scores_rating) avg_review_scores_rating,avg(review_scores_value) avg_review_scores_value 
from(select host_id,review_scores_accuracy,review_scores_checkin,review_scores_cleanliness,review_scores_communication
,review_scores_location,review_scores_rating,review_scores_value from [dbo].[listing_shanghai_df]) as A inner join 
(select host_id,host_is_superhost from [dbo].[host_shanghai_df] where host_is_superhost='False')
as B on A.host_id=B.host_id group by (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end);


--avg  values of host responce rate

-- other host



select avg(host_response_rate) avg_host_response_rate ,(case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end)
as host_type from [dbo].[host_shanghai_df] where host_is_superhost='False' 
group by (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end);
--super host 
select avg(host_response_rate) avg_host_response_rate ,(case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end)
as host_type from [dbo].[host_shanghai_df] where host_is_superhost='True' 
group by (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end);

--avg response rate

select top 2  avg(host_response_rate) as host_response_rate ,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type from [dbo].[host_shanghai_df] group by host_is_superhost ;

--avg Acceptance rate
select top 2  avg(host_acceptance_rate) as host_acceptance_rate ,(case when host_is_superhost = 'True' 
then 'Super_host' else 'Other_host' end) as host_type from [dbo].[host_shanghai_df] group by host_is_superhost ;

---avg latitude for other host and super host.

select Distinct (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) as host_type, avg(l.latitude) as avg_latitude
from [dbo].[host_shanghai_df] as h full outer join [dbo].[listing_shanghai_df] as l on h.host_id = l.host_id 
group by (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) 
order by (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) DESC;

---avg longitude for other host and super host.

select Distinct (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) as host_type, avg(l.longitude) as avg_logitude  
from [dbo].[host_shanghai_df] as h full outer join [dbo].[listing_shanghai_df] as l on h.host_id = l.host_id 
group by (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end)
order by (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) DESC;

---badroom ,bed and prise 

select h.host_location,(case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) as host_type, l.bedrooms,l.beds,l.price
from [dbo].[host_shanghai_df] as h full outer join [dbo].[listing_shanghai_df] as l on h.host_id = l.host_id 
 order by l.price DESC;

 --avg price with location
 --top 4 highest price
 select top 5 (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) as host_type,avg(l.price) as Price
from [dbo].[host_shanghai_df] as h full outer join [dbo].[listing_shanghai_df] as l on h.host_id = l.host_id 
group by (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end)
order by avg(l.price) DESC;

 --top 4 lowest price

 select top 5 (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) as host_type,avg(l.price) as Price
from [dbo].[host_shanghai_df] as h full outer join [dbo].[listing_shanghai_df] as l on h.host_id = l.host_id 
group by (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end)
order by avg(l.price);


select top 2 (case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) as host_type, sum(l.bedrooms) as total_bedroom,sum(l.beds) 
as total_beds,sum(l.price) as total_price from [dbo].[host_shanghai_df] as h full outer join [dbo].[listing_shanghai_df]
as l on h.host_id = l.host_id  group by h.host_is_superhost;

---c. Analyze how the comments of reviewers vary for listings of Super Hosts vs Other Hosts(Extract words from the comments provided by the reviewers)


select*from [dbo].[host_shanghai_df];
select*from [dbo].[review_shanghai_df];

--analyze comments of reviewers  other host 

--find the reletion beetween host_name ,host_response_rate,host_is_superhost ,listing_id,reviewer_id,reviewer_name,comments.
select*from(
select host_name ,host_response_rate,(case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) as host_type
from [dbo].[host_shanghai_df] 
where host_is_superhost='False')as A inner join [dbo].[review_shanghai_df] as B
on A.host_name=B.reviewer_name;

--analyze comments of reviewers  super  host 

select*from(
select host_name ,host_response_rate,host_is_superhost from [dbo].[host_shanghai_df] 
where host_is_superhost='true')as A inner join [dbo].[review_shanghai_df] as B
on A.host_name=B.reviewer_name;

---Total response rate in month for other host
select month(date) as month,count(host_response_rate) as total_response from(
select*from(
select host_name ,host_response_rate,host_is_superhost from [dbo].[host_shanghai_df] 
where host_is_superhost='False')as A inner join [dbo].[review_shanghai_df] as B
on A.host_name=B.reviewer_name)c group by month(date) order by month(date);

---comments  with  other host 

select host_name,(case when host_is_superhost = 'True' then 'Super_host' else 'Other_host' end) as host_type,comments  from(
select*from(
select host_name ,host_response_rate,host_is_superhost from [dbo].[host_shanghai_df] 
where host_is_superhost='False')as A inner join [dbo].[review_shanghai_df] as B
on A.host_name=B.reviewer_name)c;

--number of other host
select count(host_id) as no_of_other_host from(
select*from(
select host_id,host_name ,host_response_rate,host_is_superhost from [dbo].[host_shanghai_df] 
where host_is_superhost='False')as A inner join [dbo].[review_shanghai_df] as B
on A.host_name=B.reviewer_name)c;

--analyze comments of reviewers  super  host 

select*from(
select host_name ,host_response_rate,host_is_superhost from [dbo].[host_shanghai_df] 
where host_is_superhost='true')as A inner join [dbo].[review_shanghai_df] as B
on A.host_name=B.reviewer_name;


---Total response rate in month for super host

select month(date) as month,count(host_response_rate) as total_response from(
select*from(
select host_name ,host_response_rate,host_is_superhost from [dbo].[host_shanghai_df] 
where host_is_superhost='True')as A inner join [dbo].[review_shanghai_df] as B
on A.host_name=B.reviewer_name)c group by month(date) order by month(date);


---comments  with  other host 

select host_name,host_is_superhost,comments  from(
select*from(
select host_name ,host_response_rate,host_is_superhost from [dbo].[host_shanghai_df] 
where host_is_superhost='True')as A inner join [dbo].[review_shanghai_df] as B
on A.host_name=B.reviewer_name)c;

--number of super host
select host_name as no_of_other_host from(
select*from(
select host_name ,host_response_rate,host_is_superhost from [dbo].[host_shanghai_df] 
where host_is_superhost='True')as A inner join [dbo].[review_shanghai_df] as B
on A.host_name=B.reviewer_name)c group by host_name;



--d. Analyze do Super Hosts tend to have large property types as compared to Other Hosts


select Distinct l.property_type,h.host_is_superhost from [dbo].[host_shanghai_df] as h full outer join 
[dbo].[listing_shanghai_df] as l on h.host_id = l.host_id order by h.host_is_superhost DESC;



select Distinct h.host_is_superhost, avg(l.latitude) as avg_latitude,avg(l.longitude) as avg_logitude 
from [dbo].[host_shanghai_df] as h full outer join [dbo].[listing_shanghai_df] as l on h.host_id = l.host_id 
group by h.host_is_superhost order by h.host_is_superhost DESC;