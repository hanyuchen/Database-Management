DROP VIEW IF EXISTS q0, q1i, q1ii, q1iii, q1iv, q2i, q2ii, q2iii, q3i, q3ii, q3iii, q4i, q4ii, q4iii, q4iv;

-- Question 0
CREATE VIEW q0(era) 
AS
  SELECT MAX(era) 
  FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear 
  FROM master 
  WHERE weight > 300 
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear 
  FROM master 
  WHERE namefirst like '% %'
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  SELECT birthyear, avg(height) as avgheight, count(*) as count  
  FROM master 
  GROUP BY birthyear 
  ORDER BY birthyear asc
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  SELECT birthyear, avg(height) as avgheight, count(*) as count  
  FROM master 
  GROUP BY birthyear 
  HAVING avg(height) > 70
  ORDER BY birthyear asc
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  SELECT m.namefirst, m.namelast, m.playerid, h.yearid
  FROM master as m, halloffame as h
  WHERE m.playerid = h.playerid 
  AND h.inducted = 'Y'
  ORDER BY yearid desc
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS

SELECT m.namefirst, m.namelast, m.playerid, ca.schoolid, h.yearid
FROM
	(SELECT c.playerid, s.schoolid, s.schoolstate
  	FROM schools s left outer join collegeplaying c 
  	ON s.schoolid = c.schoolid
  	WHERE s.schoolstate = 'CA') ca, halloffame as h, master as m
WHERE ca.playerid = h.playerid 
AND m.playerid = h.playerid
AND h.inducted = 'Y'

ORDER BY h.yearid desc,  m.playerid asc, ca.schoolid asc

;

-- Question 2iii

CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS 
   SELECT mh.playerid, mh.namefirst, mh.namelast, c.schoolid
   FROM 
   	 (SELECT  m.playerid, m.namefirst, m.namelast
 	  FROM master as m, halloffame as h
 	  WHERE m.playerid = h.playerid 
 	    	and h.inducted = 'Y'
 	  ) mh 
	  left outer join collegeplaying c 
 	  on mh.playerid = c.playerid
	  ORDER BY mh.playerid desc, schoolid asc
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  SELECT DISTINCT(m.playerid), m.namefirst, m.namelast, b.yearid, (CAST(( (b.h-b.h2b-b.h3b-b.hr) + 2*b.h2b + 3*b.h3b + 4*hr) as float)/ ab) as slg
  FROM Master as m , Batting as b 
  Where m.playerid = b.playerid 
  and b.ab > 50
  order by slg desc, m.playerid asc
  limit 10
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  SELECT m.playerid, m.namefirst, m.namelast,
 (CAST (sum(b.h-b.h2b-b.h3b-b.hr) + 2*sum(b.h2b) + 3*sum(b.h3b) + 4*sum(b.hr) as float)/sum(ab) ) as lslg
  FROM Master as m , Batting as b 
  Where m.playerid = b.playerid
  group by m.playerid
  having sum(ab) > 50
  order by lslg desc, m.playerid asc
  limit 10;


-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS

SELECT a.namefirst, a.namelast, a.lslg
FROM
 (SELECT m.playerid, m.namefirst, m.namelast,
 (CAST (sum(b.h-b.h2b-b.h3b-b.hr) + 2*sum(b.h2b) + 3*sum(b.h3b) + 4*sum(b.hr) as float)/sum(ab) ) as lslg
  FROM Master as m , Batting as b 
  Where m.playerid = b.playerid
  group by m.playerid
  having sum(ab) > 50) as  a,

 (SELECT m.namefirst, m.namelast,
 (CAST (sum(b.h-b.h2b-b.h3b-b.hr) + 2*sum(b.h2b) + 3*sum(b.h3b) + 4*sum(b.hr) as float)/sum(ab) ) as lslg
  FROM Master as m , Batting as b 

  Where m.playerid = b.playerid
  group by m.playerid
  having m.playerid = 'mayswi01') as wm
where a.lslg > wm.lslg
order by a.namefirst asc
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg, stddev)
AS
  SELECT yearid, min(salary), max(salary), avg(salary), stddev(salary)
  FROM salaries s
  GROUP BY yearid
  ORDER BY yearid asc
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS
  
with bin as
(
select (max(salary) - min(salary))/10 as bin,
     max(salary) as t0,
     max(salary) - (max(salary) - min(salary))/10 as t1,
     max(salary) - ((max(salary) - min(salary))/10)*2 as t2,
     max(salary) - ((max(salary) - min(salary))/10)*3 as t3,
     max(salary) - ((max(salary) - min(salary))/10)*4 as t4,
     max(salary) - ((max(salary) - min(salary))/10)*5 as t5,
     max(salary) - ((max(salary) - min(salary))/10)*6 as t6,
     max(salary) - ((max(salary) - min(salary))/10)*7 as t7,
     max(salary) - ((max(salary) - min(salary))/10)*8 as t8,
     max(salary) - ((max(salary) - min(salary))/10)*9 as t9,
     max(salary) - ((max(salary) - min(salary))/10)*10 as t10
from salaries
where yearid = '2016'
)

select 9 as binid, bin.t1 as low, bin.t0 as high, count(*) from salaries s, bin 
where s.salary > bin.t1 
and s.yearid = '2016'
group by bin.t1, bin.t0

union(select 8 as binidm,  bin.t2 as low, bin.t1 as high, count(*) from salaries s, bin 
where s.salary > bin.t2 and s.salary < bin.t1
and s.yearid = '2016'
group by bin.t2, bin.t1)

union(select 7 as binidm,  bin.t3 as low, bin.t2 as high, count(*) from salaries s, bin 
where s.salary > bin.t3 and s.salary < bin.t2
and s.yearid = '2016'
group by bin.t3, bin.t2)

union(select 6 as binidm,  bin.t4 as low, bin.t3 as high, count(*) from salaries s, bin 
where s.salary > bin.t4 and s.salary < bin.t3
and s.yearid = '2016'
group by bin.t4, bin.t3)

union(select 5 as binidm,  bin.t5 as low, bin.t4 as high, count(*) from salaries s, bin 
where s.salary > bin.t5 and s.salary < bin.t4
and s.yearid = '2016'
group by bin.t5, bin.t4)

union(select 4 as binidm,  bin.t6 as low, bin.t5 as high, count(*) from salaries s, bin 
where s.salary > bin.t6 and s.salary < bin.t5
and s.yearid = '2016'
group by bin.t6, bin.t5)

union(select 3 as binidm,  bin.t7 as low, bin.t6 as high, count(*) from salaries s, bin 
where s.salary > bin.t7 and s.salary < bin.t6
and s.yearid = '2016'
group by bin.t7, bin.t6)

union(select 2 as binidm,  bin.t8 as low, bin.t7 as high, count(*) from salaries s, bin 
where s.salary > bin.t8 and s.salary < bin.t7
and s.yearid = '2016'
group by bin.t8, bin.t7)

union(select 1 as binidm,  bin.t9 as low, bin.t8 as high, count(*) from salaries s, bin 
where s.salary > bin.t9 and s.salary < bin.t8
and s.yearid = '2016'
group by bin.t9, bin.t8)

union(select 0 as binidm,  bin.t10 as low, bin.t9 as high, count(*) from salaries s, bin 
where s.salary < bin.t9
and s.yearid = '2016'
group by bin.t10, bin.t9)

order by binid asc
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS


select t2.yearid, t2.min - t1.min, t2.max - t1.max, t2.avg - t1.avg
FROM
	(select yearid, min(salary) as min, max(salary) as max , avg(salary) as avg 
	from salaries 
	group by yearid 
	order by yearid asc 
	limit 31) t1,

	(select yearid, min(salary) as min, max(salary) as max , avg(salary) as avg 
	from salaries 
	group by yearid 
	order by yearid desc 
	limit 31) t2
where t1.yearid = t2.yearid - 1 
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS

select m.playerid, m.namefirst, m.namelast, s.salary, s.yearid
from
	master as m,
	(select *
	from salaries 
	where yearid = 2000 and salary >= all
      	      (select salary
      	      from salaries where yearid = 2000 )
  union (select *
	from salaries
	where yearid = 2001 and salary >= all
      	      (select salary
      	      from salaries where yearid = 2001 ))
	 ) as s

where m.playerid = s.playerid

;
