/*Project : SQL
FINDING MURDER MYSTERY
A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. You vaguely remember that the crime was a murder that occurred sometime on Jan.15, 2018 and that it took place in SQL City. Start by retrieving the corresponding crime scene report from the police department’s database.
Follow these steps to solve this challenge:
- Download the `sql-murder-mystery.db` file 
- visit www.sqliteonline.com
- click on file, then open db and load in the database file you downloaded above
- write your SQL queries to see the different tables and the content
- use the schema diagram to navigate the different tables
- figure out who committed the crime with the details you remembered above
- create a word or txt document that contains your thought process, narrative and SQL codes written to   arrive at the solution to the murder mystery
- submit a link to the word or txt document.  
*/
-- SOLUTION
-- 1.1 Based on the crime scene report, the documentation was on a murder case in SQL 
-- city on Jan 15, 2018, querying the crime scene report table, I discovered that the 
-- security footage shows that there were 2 witnesses.

select date, description
from crime_scene_report
where date = "20180115"and city = "SQL City"and type = "murder";

-- 1.	The first witness lives at the last house on "Northwestern Dr,". 
-- 2.	The second witness, Annabel, lives on Franklin Ave". 

-- 1.2	For more information on the two witnesses, I query the table called PERSON;

select *
from person
where address_street_name = "Northwestern Dr" 
order by address_number DESC
limit 1;

select *
from person
where address_street_name =  "Franklin Ave"and name LIke "Anna%";

-- 3.	the first witness's name is Morty Schapiro with license_id 118009 with id 14887. address 4979, ssn 111564949
-- 4.	second witness's name is Annabel Miller with license_id 490173 with id 16371 address 103, ssn 318771143

-- 1.3	I went to the interview table to get information on their witness with id no;

select facebook_event_checkin.person_id, facebook_event_checkin.event_name, person.id, person.name, person.license_id
from facebook_event_checkin 
join person
on facebook_event_checkin.person_id=person.id
where person.id IN (14887, 16371);

-- The transcript from Morty (14887) is;
-- I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
-- The membership number on the bag started with "48Z". Only gold members have those bags. 
-- The man got into a car with a plate that included "H42W".

-- The transcript from Annabel (16371) is;
-- I saw the murder happen, and I recognized the killer from my gym when 
-- I was working out last week on January 9th.



select *
from drivers_license
where id in (118009,490173);

select *
from interview
where person_id IN (14887,16371,67318);

-- 1.4	Further enquiry on the information gotten from Morty, I used the get_fit_now_member table;
select *
from get_fit_now_member
where id like "48Z%" and membership_status = "gold";
-- There are two members with membership no starting with 48Z and they are gold member
-- Joe Germuska with person_id 28819 mem start date 20160305 id 48Z7A
-- Jeremy Bowers with person_id 67318 mem start date 20160101 id 48Z55


select *
from get_fit_now_check_in
where membership_id IN ("48Z7A", "48Z55");

select *
from get_fit_now_check_in
where check_in_date = 20180109 and membership_id in ("48Z7A","48Z55");

-- 1.5	Looking at the information Annabel gave, I joined two tables; 
-- get_fit_now_check_in and  get_fit_now_member. 
-- This also confirmed that they were both at the gym on the 9th Jan.

select *
from get_fit_now_check_in
join get_fit_now_member
on get_fit_now_check_in.membership_id = get_fit_now_member.id
where get_fit_now_check_in.membership_id IN ("48Z7A", "48Z55");

select *
from drivers_license
where plate_number like "%H42W%";

-- 1.6	Running the plate number (drivers_license table) 
-- with the personal information (Person table) for the part plate no given;
select *
from person
full join drivers_license
ON person.license_id=drivers_license.id
where drivers_license.plate_number LIKE "%H42W%";

-- This shows that Jeremy Bowers is the one with plate no 0H42W2. 
-- This investigation shows that Jeremy Bowers is the Murderer.

select *
from person
where 14887,16371,67318

-- 1.7	On checking where Jeremy was on the 15th Jan 2018, 
-- the Facebook event shows that he was for the event called “The Funky Groove Tour”.

select *
from facebook_event_checkin
where person_id = 67318;

-- 1.8	I also check all the people in that event with a date too, 
-- I discovered that Morty Schapiro, Annabel Miller and Jeremy Bowers were at the event.
select *
from facebook_event_checkin
where event_name like "The Funky%" and date = 20180115;


select facebook_event_checkin.person_id, facebook_event_checkin.event_name,facebook_event_checkin.date, person.id, person.name, person.license_id
from facebook_event_checkin 
join person
on facebook_event_checkin.person_id=person.id
where person.id IN (14887, 16371, 67318);
-- This shows that the three of them were at the event called “The Funky Groove Tour”

-- 1.9	This led to more investigation and I had to check the interview table.
select *
from interview
where person_id = 67318;

-- The transcript of the interview: I was hired by a woman with a lot of money. 
-- I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
-- She has red hair and she drives a Tesla Model S. 
-- I know that she attended the SQL Symphony Concert 3 times in December 2017.

select *
from facebook_event_checkin
where event_name like "SQL Sym%"
group by person_id;

-- 2.0	I checked the information given by the driver_license table for name(s);

 select *
 from drivers_license
-- where gender is "female"and hair_color is "red" and car_make is "Tesla" and car_model is "Model S";

-- I got three id:	 202298, 291192, 918773

-- 2.1	I ran the Id with personal information

select *
from person
where license_id IN (202298,291182,918773);

-- Red Korb with  id 78881 and license_id 918773
-- Regina George  with id 90700 and license_id 291182
-- Miranda Priestly with id 99716 and  license_id 202298

-- 2.2	I ran the event table with person table and
-- I discovered the person that hired Jeremy Bowers

select *
from facebook_event_checkin
full join person
on facebook_event_checkin.person_id=person.id
where person.id IN (78881,90700,99716);

-- Based on the reporting table, Miranda Priestly hired Jeremy Bowers 




