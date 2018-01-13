/* Let  be the number of CITY entries in STATION, and let  be the number of distinct
 CITY names in STATION; query the value of  from STATION. In other words, find the 
 difference between the total number of CITY entries in the table and the number of 
 distinct CITY entries in the table.
*/

SELECT COUNT(CITY) - (SELECT TOP 1 ((ROW_NUMBER() OVER(ORDER BY CITY)) ) FROM STATION
GROUP BY CITY
ORDER BY CITY DESC)
FROM STATION

/* 
Query the two cities in STATION with the shortest and longest CITY names, as well as 
their respective lengths (i.e.: number of characters in the name). If there is more than 
one smallest or largest city, choose the one that comes first when ordered alphabetically.
*/

SELECT * FROM (
SELECT TOP 1 CITY, LEN(CITY) LENGTH
FROM STATION 
ORDER BY LEN(CITY),CITY) M
UNION ALL
SELECT * FROM (
SELECT TOP 1 CITY, LEN(CITY) LENGTH
FROM STATION
ORDER BY LEN(CITY) DESC, CITY) L

/*
Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. 
Your result cannot contain duplicates
*/

SELECT DISTINCT CITY FROM STATION 
WHERE CITY LIKE ('a%') OR
CITY LIKE ('e%') OR 
CITY LIKE ('i%') OR
CITY LIKE ('o%') OR
CITY LIKE ('u%')

/*
Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. 
Your result cannot contain duplicates.
*/

SELECT DISTINCT CITY FROM STATION 
WHERE SUBSTRING(CITY,1,1) IN ('A','E','I','O','U')
AND SUBSTRING(CITY,LEN(CITY)-0,1) IN ('A','E','I','O','U')

/*
Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. 
Your result cannot contain duplicates.

*/

SELECT DISTINCT CITY FROM STATION 
WHERE SUBSTRING(CITY,1,1) NOT IN ('A','E','I','O','U')
OR SUBSTRING(CITY,LEN(CITY)-0,1) NOT IN ('A','E','I','O','U')

/*
Query the Name of any student in STUDENTS who scored higher than  Marks. 
Order your output by the last three characters of each name. If two or more students both have names ending in the same 
last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
*/

SELECT NAME FROM STUDENTS
WHERE MARKS > 75
ORDER BY RIGHT(NAME,3), ID

/*
Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary
 greater than $2000 per month who have been employees for less than 10 months. Sort your result by ascending employee_id
 */

 SELECT NAME FROM EMPLOYEE
 WHERE SALARY > 2000 AND MONTHS < 10
 ORDER BY EMPLOYEE_ID

 /*
Ketty gives Eve a task to generate a report containing three columns: Name, Grade and Mark. Ketty doesn't want the NAMES of those students who 
received a grade lower than 8. The report must be in descending order by grade -- i.e. higher grades are entered first. If there is more than one 
student with the same grade (8-10) assigned to them, order those particular students by their name alphabetically. Finally, if the grade is lower than 8, 
use "NULL" as their name and list them by their grades in descending order. If there is more than one student with the same grade (1-7) assigned to them,
 order those particular students by their marks in ascending order.
*/
SELECT CASE WHEN G.GRADE < 8 THEN NULL ELSE S.NAME END AS NAME,G.GRADE,S.MARKS
FROM STUDENTS S, GRADES G
WHERE S.MARKS BETWEEN G.MIN_MARK AND MAX_MARK
ORDER BY G.GRADE DESC,S.NAME


/*
Julia just finished conducting a coding contest, and she needs your help assembling the leaderboard! Write a query to print the respective 
hacker_id and name of hackers who achieved full scores for more than one challenge. Order your output in descending order by the total number of 
challenges in which the hacker earned a full score. If more than one hacker received full scores in same number of challenges, then sort them by
 ascending hacker_id.
*/
SELECT H.HACKER_ID, H.NAME 
FROM HACKERS H JOIN SUBMISSIONS S 
ON H.HACKER_ID = S.HACKER_ID 
JOIN CHALLENGES C ON C.CHALLENGE_ID = S.CHALLENGE_ID
JOIN DIFFICULTY D ON D.DIFFICULTY_LEVEL = C.DIFFICULTY_LEVEL
WHERE S.SCORE = D.SCORE
GROUP BY H.HACKER_ID,H.NAME 
HAVING COUNT(S.SUBMISSION_ID) > 1
ORDER BY COUNT(S.SUBMISSION_ID) DESC, H.HACKER_ID


/*
Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand.

Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy each non-evil wand of high power and age.
 Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power. 
 If more than one wand has same power, sort the result in order of descending age.
*/

SELECT W.ID, WP.AGE, W.COINS_NEEDED, W.POWER 
FROM WANDS W JOIN WANDS_PROPERTY WP
ON W.CODE = WP.CODE WHERE WP.IS_EVIL = 0 
AND W.COINS_NEEDED = (SELECT MIN(COINS_NEEDED) FROM WANDS  W1
                      JOIN WANDS_PROPERTY WP1 
                      ON W1.CODE = WP1.CODE 
                      WHERE W1.POWER = W.POWER AND WP1.AGE = WP.AGE)
ORDER BY W.POWER DESC, WP.AGE DESC


/*
Julia asked her students to create some coding challenges. Write a query to print the hacker_id, name, 
and the total number of challenges created by each student. Sort your results by the total number of challenges in 
descending order. If more than one student created the same number of challenges, then sort the result by hacker_id. 
If more than one student created the same number of challenges and the count is less than the maximum number of challenges 
created, then exclude those students from the result.
*/

SELECT SUB1.HACKER_ID,H.NAME,SUB1.CNT
FROM HACKERS H,
(SELECT HACKER_ID,COUNT(CHALLENGE_ID) CNT 
FROM CHALLENGES 
GROUP BY HACKER_ID
HAVING COUNT(CHALLENGE_ID) = (SELECT MAX(TOTAL) FROM
                              (SELECT COUNT(CHALLENGE_ID) TOTAL
                              FROM CHALLENGES
                              GROUP BY HACKER_ID) CNT) 
                            
UNION ALL 

SELECT HACKER_ID, COUNT(CHALLENGE_ID) CNT
FROM CHALLENGES
GROUP BY HACKER_ID
HAVING COUNT(CHALLENGE_ID) IN (SELECT CNT FROM (SELECT CNT,COUNT(CNT) PT FROM(
                               SELECT HACKER_ID,COUNT(CHALLENGE_ID) CNT, ROW_NUMBER() OVER(PARTITION BY COUNT(CHALLENGE_ID) ORDER BY                                  HACKER_ID) RN
                               FROM CHALLENGES 
                               GROUP BY HACKER_ID 
                               HAVING COUNT(CHALLENGE_ID) < (SELECT MAX(TOTAL) FROM
                                                            (SELECT COUNT(CHALLENGE_ID) TOTAL
                                                             FROM CHALLENGES
                                                             GROUP BY HACKER_ID) CNT) 
                               ) RN1
GROUP BY CNT ) SUB
WHERE PT = 1)) SUB1
WHERE H.HACKER_ID = SUB1.HACKER_ID
ORDER BY SUB1.CNT DESC


/*
You did such a great job helping Julia with her last coding contest challenge that she wants you to work on this one, too!

The total score of a hacker is the sum of their maximum scores for all of the challenges.
Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score. 
If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. Exclude all hackers
with a total score of  from your result.
*/

SELECT SUB2.HACKER_ID, H.NAME, SUB2.SSCORE1 FROM
(SELECT HACKER_ID, SUM(SSCORE) SSCORE1
FROM (SELECT DISTINCT HACKER_ID, CHALLENGE_ID,
     MAX(SCORE) OVER(PARTITION BY CHALLENGE_ID,HACKER_ID ORDER BY HACKER_ID,CHALLENGE_ID) SSCORE
     FROM SUBMISSIONS) SUB1
GROUP BY HACKER_ID
HAVING SUM(SSCORE)>0) SUB2
INNER JOIN HACKERS H
ON H.HACKER_ID = SUB2.HACKER_ID
ORDER BY SUB2.SSCORE1 DESC, SUB2.HACKER_ID  



/*
P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

* * * * * 
* * * * 
* * * 
* * 
*
Write a query to print the pattern P(20).*/


CREATE TABLE #STAR
(C_STAR VARCHAR(50))

DECLARE @C INT;
SET @C = 20;

WHILE @C <> 0
BEGIN
INSERT INTO #STAR 
SELECT REPLICATE('* ',@C)
SET @C = @C - 1
END

SELECT * FROM #STAR

/*
Write a query to print all prime numbers less than or equal to 1000. Print your result on a single line, and use the ampersand (&) 
character as your separator (instead of a space).
*/

--Write a query to print all prime numbers less than or equal to 1000. Print your result on a single line, and use the ampersand (&) 
--character as your separator (instead of a space).



DECLARE @P INT
SET @P = 3
DECLARE @PRIME VARCHAR(MAX)
SET @PRIME = '2&'
DECLARE @I INT
SET @I = 2
DECLARE @S INT
SET @S = 2

WHILE @P <= 1000
BEGIN
	WHILE @I <= @S AND @P <= 1000
	BEGIN
		IF @P % @I = 0
			BEGIN
			SET @P = @P + 1
			SET @I = 2
			SET @S = ROUND(SQRT(@P),0)
			END
		ELSE
			BEGIN
			SET @I = @I + 1
			IF @I > @S
				BEGIN
				SET @I = 2
				SET @PRIME = CONCAT(@PRIME,CONCAT(@P,'&'))
				SET @P = @P +1
				SET @S = ROUND(SQRT(@P),0)
				END
			END
	END
END

PRINT LEFT(@PRIME,LEN(@PRIME)-1)



	





