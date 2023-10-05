------------------SAILORS DATABASE-----------------------------
/*Boats: BID | BNAME | COLOR
Sailors: SID | SNAME | RATING | AGE
Reserves: SID | BID | DAY

Table_1                                 Table2                              Table_3          
SID SNAME   RATING         AGE          BID     BNAME       COLOR           SID BID     DAY
22	Dustin	7           45          101	Interlake   blue            22	101	10-OCT-98
29	Brutus	1           33          102	interlake   red             22	102	10-OCT-98
31	Lubber	8	    55.5        103	Clipper	    green           22	103	08-OCT-98
32	Andy	8	    25.5        104	Marine	    red             22	104	07-OCT-98
58	Rusty	10	    35          105	SeaBird	    blue            31	102	10-NOV-98
64	Horatio	9	    40                                              31	103	06-NOV-98
71	Zorba	10	    16                                              31	104	12-NOV-98
74	Horatio	9	    40                                              64	101	05-SEP-98
85	Art     3	    25.5                                            64	102	08-SEP-98
95	Bob     3	    63.5                                            74	103	08-SEP-98
                                                                            22	105	09-NOV-98
*/
--Create a table Boats

create table Boats(BID number(5), BNAME varchar2(10), COLOR varchar2(10));

alter table Boats 
modify (BID number(5) primary key);

--Inserted the Data into Boats table

insert into Boats(BID, BNAME, COLOR) values (&BID,'&BNAME', '&COLOR');

--Create a table Sailors

create table Sailors(SID number(5) primary key , SNAME varchar2(10), RATING number(2) check(RATING between 0 and 10), AGE number(3,1) );

--Inserted the Data into Sailors table    

insert into Sailors(SID, SNAME, RATING, AGE) values (&SID, '&SNAME', '&RATING', '&AGE');

--Create a table Reserves

create table Reserves(SID number(5) references Sailors, BID number(5) references Boats, DAY date);

--Inserted the Data into Reserves table 

insert into Reserves(SID,BID, Day) values(&SID,'&BID','&day');

select * from Boats;
select * from Sailors;
select * from Reserves;

Desc boats
Desc Sailors
Desc Reserves

--SQL Queries
--1. Find details of sailors whose name contains ‘s’ as a 3rd character.

select * from sailors 
where sname like '__s%';

--With out using wildcards

select * from sailors where substr(sname,3,1)='s';

--2. Find names of sailors who have reserved all the red boats.

select s.sid, s.sname, b.color, r.bid
from sailors s, boats b, reserves r 
where s.sid=r.sid and r.bid=b.bid and b.color='red';

--3. Display color of boats sailed by sailor 64.

select DISTINCT(s.sid), s.sname, b.color, r.bid
from sailors s, boats b, reserves r 
where s.sid=r.sid and r.bid=b.bid and S.SID='64';

--4. Find details of sailors whose name contains the letter ‘o’ only once (do not use wildcards).

SELECT * FROM sailors WHERE INSTR(UPPER(TRIM(SNAME)),'O')!=0 AND
INSTR(UPPER(TRIM(SNAME)),'O',1,3)=0;

--5. Find the Sailors who have sailed two different boats on the same day.

SELECT  S.sid, S.sname,R1.day
FROM Sailors S, Reserves R1, Reserves R2
WHERE S.sid = R1.sid AND S.sid = R2.sid
AND R1.day = R2.day AND R1.bid <> R2.bid;
 --or  

SELECT  DISTINCT S.sid, S.sname,R1.day
FROM Sailors S, Reserves R1, Reserves R2
WHERE S.sid = R1.sid AND S.sid = R2.sid
AND R1.day = R2.day AND R1.bid <> R2.bid;

--6. Display information of reservation made by any sailor named "Horatio".

SELECT s.sname, r.*
FROM sailors s
JOIN reserves r ON s.sid = r.sid
WHERE s.sname LIKE '%Horatio%';
--or

SELECT *
FROM reserves
WHERE sid IN (
    SELECT sid
    FROM sailors
    WHERE sname = 'Horatio'
);

--7. Display the details of top 3 sailors. 

SELECT *
FROM (
    SELECT *
    FROM sailors
    ORDER BY rating DESC
)
WHERE ROWNUM <= 3;

--8. Find the names of Sailors who are older than the oldest sailor with a rating of 10

SELECT s.sname, s.age
FROM sailors s
WHERE s.age > (
    SELECT MAX(age)
    FROM sailors
    WHERE rating = 10
);

--9. Display names of sailors that sailed boat on 10-OCT-1998.

select s.sname, b.bid, r.day
from sailors s, boats b, reserves r 
where S.sid=r.sid and r.bid=b.bid and r.day='10-OCT-1998';

--10. Find details of the reservations made by sailor 22 in the month of October.

SELECT r.*
FROM sailors s
JOIN reserves r ON s.sid = r.sid
WHERE s.sid = 22 AND r.day LIKE '%OCT%';


--11. Display total number of sailors with rating above 7 and age above 25.

select * from sailors 
where rating > 7 and age > 25;

--12. Display the bid and the number of reservations for each boat in the boats table.

SELECT b.bid, COUNT(r.bid) AS number_of_reservations
FROM boats b
LEFT JOIN reserves r ON b.bid = r.bid
GROUP BY b.bid;

--13. Find sailor details whose name contains ‘E’ as a 2nd character from end of the string.

SELECT * FROM sailors
where sname like'%e_';
--or

SELECT *
FROM sailors
WHERE UPPER(SUBSTR(TRIM(sname), -2, 1)) = 'E';

--14. Display sailor and boat details for those reservations where a sailor reserved  either a red boat or a boat named ‘Interlake’

SELECT distinct s.*, b.*
FROM sailors s
JOIN reserves r ON s.sid = r.sid
JOIN boats b ON r.bid = b.bid
WHERE b.color = 'red' OR b.bname = 'Interlake';

--15. Retrieve even rows from the Sailors table.

SELECT *
FROM (
    SELECT sailors.*, ROWNUM AS rn
    FROM sailors
)
WHERE MOD(rn, 2) = 0;

--16. Find the age of the youngest sailor for each rating level. 

SELECT rating, MIN(age) AS youngest_age
FROM sailors
GROUP BY rating;

--17. Count the number of different Sailor names.

SELECT COUNT(DISTINCT sname) AS number_of_different_names
FROM sailors;

--18 Find the names and ages of Sailors whose name begins and ends with ‘B’ and has at least 3 characters (use wildcards, ignore the case).
SELECT sname, age
FROM sailors
WHERE UPPER(sname) LIKE 'B%B' AND LENGTH(sname) >= 3;


--19. Display color of boats sailed by sailor with highest age.

select distinct b.color, s.sname, s.age
from sailors s, boats b
where s.age=(select max(age) from sailors);

--20. Retrieve nth row from Reserves table where n is entered at runtime.

select *
from (
select rownum as rn, r.*
from reserves r
order by r.sid
)
where rn=&n;

--21. Display details of sailors who reserved the boat ‘Clipper’.

select s.*, b.bname from
sailors s, reserves r, boats b
where s.sid=r.sid and b.bid=r.bid and b.bname like '%Clipper%';

--22. Display reservation sorted by month.

select * from 
reserves 
order by day;

--23. Display id of sailors that reserved all boats


SELECT s.sid
FROM sailors s
WHERE NOT EXISTS (
    SELECT b.bid
    FROM boats b
    WHERE NOT EXISTS (
        SELECT r.sid
        FROM reserves r
        WHERE r.bid = b.bid
        AND r.sid = s.sid
    )
);

--24. Find the age of the youngest sailor who is eligible to vote, for each rating level with at least two such sailors.

select rating , MIN(age) as youngest_eligible_age
from sailors 
where age>=18
group by rating 
having count(*)>=2;

--25. For each reservation made display sailor name and boat name

select DISTINCT(b.bname),r.sid, s.sname
from sailors s, boats b, reserves r 
where S.sid=r.sid and r.bid=b.bid;
--or
SELECT sname, bname
FROM reserves r
JOIN sailors s ON r.sid = s.sid
JOIN boats b ON r.bid = b.bid;

--26. Display ids of sailors that reserved at least two different color boats.

SELECT r.sid
FROM reserves r
JOIN boats b ON r.bid = b.bid
GROUP BY r.sid
HAVING COUNT(DISTINCT b.color) >= 2;


--27. Find the name and age of the oldest sailor.

SELECT sname, age
FROM sailors
WHERE age = (SELECT MAX(age) FROM sailors);


--28. Display id, name of sailors having third highest rating.

SELECT sid, sname
FROM (
  SELECT sid, sname, rating,
         DENSE_RANK() OVER (ORDER BY rating DESC) AS rank
  FROM sailors
) ranked_sailors
WHERE rank = 3;

--29. Display ids of sailors who have reserved both red and blue boats.

--30. Find the names of sailors who reserved a red boat but not green boat.

SELECT b.bname, r.sid, s.sname, b.color
FROM sailors s
JOIN reserves r ON s.sid = r.sid
JOIN boats b ON r.bid = b.bid
WHERE (b.color = 'red' and not b.color = 'green');

--31. Display id of sailors that made minimum number of reservations.
SELECT sid
FROM reserves
GROUP BY sid
HAVING COUNT(*) = (
    SELECT MIN(reservation_count)
    FROM (
        SELECT COUNT(*) AS reservation_count
        FROM reserves
        GROUP BY sid
    )
);

--32. Write a query to display duplicate rows in Sailors table.

SELECT sname, age, COUNT(*) AS duplicate_count
FROM sailors
GROUP BY sname, age
HAVING COUNT(*) > 1;

--33. Write a query to display today's date in the given format:  Wednesday 18th November 2015 

select TO_CHAR(sysdate, 'DAY DDth MONTH YYYY')
from dual;

--34. Find the names and ratings of sailor whose rating is better than some Sailor called Horatio

SELECT sname, rating
FROM sailors
WHERE rating > (
    SELECT MAX(rating)
    FROM sailors
    WHERE sname = 'Horatio'
);
--35. For each red boat, find the number of reservations for the boat.

SELECT b.bid, b.bname,b.color, COUNT(r.bid) AS reservation_count
FROM boats b
LEFT JOIN reserves r ON b.bid = r.bid
WHERE b.color = 'red'
GROUP BY b.bid, b.bname, b.color;

--36. Display the names and rating of all the sailors in the format: sailor X  has the rating Y

SELECT 'Sailor ' || s.sid || ' has the rating ' || s.rating AS sailor_info
FROM sailors s;

--37. Find the names of the sailors who have not reserved a red boat.

SELECT DISTINCT s.sid,s.sname
FROM sailors s
WHERE s.sid NOT IN (
    SELECT r.sid
    FROM reserves r
    JOIN boats b ON r.bid = b.bid
    WHERE b.color = 'red'
);

--38. Find the names and colors of the boats reserved by the sailor named Lubber

select s.sid,s.sname, bname, b.color
from sailors S
join reserves r on s.sid=r.sid
join boats b on r.bid=b.bid
where s.sname like 'Lubber'
order by b.color,b.bname;


--40. Write a query to display :  Today the date is: 18.11.2015

select 'Today date is: '||TO_CHAR(sysdate,' dd.MM.YYYY') as fdate from dual;

--41. Find the id, name and the age of the youngest sailor

select Sid, sname, age
from sailors 
where age =(select min(age) from sailors );


--42. Find the average age of sailors for each rating level that has at least two sailors.

SELECT rating, AVG(age) AS average_age, count (*)
FROM sailors
GROUP BY rating
HAVING COUNT(*) >= 2;

--43. Write a query to display the sid, rating and rating level of all the sailors, the rating levels are as follows:
	8-10 	High
	5- 7 	Medium
	1-4 	Low

SELECT sid, rating,
    CASE
        WHEN rating BETWEEN 8 AND 10 THEN 'High'
        WHEN rating BETWEEN 5 AND 7 THEN 'Medium'
        WHEN rating BETWEEN 1 AND 4 THEN 'Low'
        ELSE 'Unknown'
    END AS rating_level
FROM sailors;

--44. Find Sailors whose rating is better than every Sailor called Horatio.

SELECT s.sid, s.sname, s.rating
FROM sailors s
WHERE s.rating > ALL (
    SELECT s.rating
    FROM sailors s
    WHERE s.sname = 'Horatio'
);

--45. Compute Increments for the ratings of sailors who have sailed two different boats on the same day.

SELECT r1.sid,
       r1.day,
       r1.bid AS boat1,
       r2.bid AS boat2,
       s.rating AS initial_rating,
       (s.rating - s2.rating) AS rating_increment
FROM reserves r1
JOIN reserves r2 ON r1.sid = r2.sid
              AND r1.day = r2.day
              AND r1.bid != r2.bid
JOIN sailors s ON r1.sid = s.sid
JOIN sailors s2 ON r1.sid = s2.sid;

