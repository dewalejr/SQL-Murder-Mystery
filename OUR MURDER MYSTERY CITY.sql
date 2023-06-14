/*You vaguely remember that the crime was a murder that occurred sometimes
on January 15, 2018 and that it took place in SQL City*/

Select * from crime_scene_report
where date = 20180115 and city = 'SQL City' and crime_type = 'murder'


/*Security footage shows that there were 2 witnesses. 
The first witness lives at the last house on "Northwestern Dr". 
The second witness, named Annabel, lives somewhere on "Franklin Ave".*/

Select * from person

-- find witness one

select * from person
where address_street_name = 'Northwestern Dr'
order by address_number desc

/*our first witness is Morty Schapiro, id - 14887, license_id is 118009
address number is 4919, stays on Northwestern Dr and ssn is 111564949*/

-- find the second witness

select * from person
where name like 'Annabel%' and address_street_name = 'Franklin Ave'

/*our second witness is Annabel Miller, id - 16371, license_id is 490173
address number is 103, stays on Franklin Ave and ssn is 318771143*/

--find the report of the witnesses

select * from interview
where person_id in (16371, 14887)

/* Witness 1 which is Morty said 'I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
The membership number on the bag started with "48Z". Only gold members have those bags. 
The man got into a car with a plate that included "H42W".'*/

/* Witness 2 said I saw the murder happen, and I recognized the killer from my gym when I was working out
last week on January the 9th.*/

select * from get_fit_now_member
where id like '48Z%' and membership_status = 'gold'

/* We have two suspects which are:
1. Joe Germuska with Id - 48Z7A, person_id - 28819, membership_start_date - 20160305,
   membership_status - gold.
2. Jeremy Bowers with Id - 48Z55, person_id - 67318, membership_start_date - 20160101,
   membership_status - gold.
*/

-- Find more information on both suspects using the person_id

select * from person
where id in (28819, 67318)

/* Joe Germuska: license_id - 173289, address_number - 111, address_street_name - Fisk Rd, ssn - 138909730
   Jeremy Bowers: license_id - 423327, address_number - 530, address_street_name - Washington Pl, Apt 3A 
   ssn - 138909730
*/

/*Using the license_id, let us find the plate number of both suspects based on one of the witness' 
report of a car with a plate that included "H42W".'*/

select * from drivers_license
where id in (173289, 423327) AND plate_number LIKE '%H42W%'

select * from (select * 
from person
join drivers_license
on person.license_id = drivers_license.id) as new
where license_id in (173289, 423327) AND plate_number LIKE '%H42W%'


/* Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, 
try querying the interview transcript of the murderer to find the real villain behind this crime. 
If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries.
Use this same INSERT statement with your new suspect to check your answer. */

select * from interview
where person_id = 67318

/* I was hired by a woman with a lot of money. 
I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
She has red hair and she drives a Tesla Model S. 
I know that she attended the SQL Symphony Concert 3 times in December 2017. */

select * from drivers_license
where height between 65 and 67 and hair_color = 'red' and car_make = 'Tesla' and car_model = 'Model S'

/* there are three people who match the murderer's description
1. id - 202298	age - 68	height - 66	eyecolor - "green"	haircolor - "red"	gender - "female"	
platenumber - "500123"	carmake - "Tesla"	carmodel - "Model S"
2. id - 291182	age - 65	height - 66	eyecolor - "blue"	haircolor - "red"	gender - "female"	
platenumber - "08CM64"	carmake - "Tesla"	carmodel - "Model S"
3. 918773	48	65	"black"	"red"	"female"	"917UU3"	"Tesla"	"Model S"
*/

/* To find the names of the three people, we will search the person table
using the license_IDs from the drivers_license table */

create table Villains AS (select * from person
where license_id in (202298, 291182, 918773))

/* the names are Red Korb, Regina George & Miranda Priestly respectively */

/* Since the person attended the SQL Symphony Concert 3 times in December 2017, 
we will search the facebook event checkin table for this */

create table event as (select * from facebook_event_checkin
where person_id in (78881, 90700, 99716))

select * 
from villains as v
join event as ev
on v.id = ev.person_id