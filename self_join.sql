-- 1 How many stops are in the database.

select count(name) from stops


-- 2 Find the id value for the stop 'Craiglockhart'

select id from stops where name = "Craiglockhart"


-- 3 Give the id and the name for the stops on the '4' 'LRT' service.

select id, name from stops join route on (stops.id = route.stop) where route.num = "4" and route.company = "LRT"


-- 4 The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). 
-- Run the query and notice the two services that link these stops have a count of 2. 
-- Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) > 1


-- 5 Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, 
-- without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = 149


-- 6 The query shown is similar to the previous one, 
-- however by joining two copies of the stops table we can refer to stops by name rather than by number. 
-- Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. 
-- If you are tired of these places try 'Fairmilehead' against 'Tollcross'

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = "London Road"


-- 7 Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

select distinct a.company, a.num from route a join route b on (a.num = b.num) where a.stop = 115 and b.stop = 137


-- 8 Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

select a.company, a.num from route a join route b on (a.num = b.num) 
join stops stopa on (stopa.id = a.stop)
join stops stopb on (stopb.id = b.stop)
where stopa.name = "Craiglockhart" and stopb.name = "Tollcross"


-- 9 Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, 
-- including 'Craiglockhart' itself, 
-- offered by the LRT company. Include the company and bus no. of the relevant services.

select stopb.name, a.company, a.num from route a join route b on (a.num = b.num and a.company = b.company)
join stops stopa on (stopa.id = a.stop)
join stops stopb on (stopb.id = b.stop)
where stopa.name = "Craiglockhart"


-- 10 Find the routes involving two buses that can go from Craiglockhart to Sighthill.
-- Show the bus no. and company for the first bus, the name of the stop for the transfer,
-- and the bus no. and company for the second bus.

select distinct a.num, a.company, trans1.name, c.num, c.company 
from route a join route b on (a.num = b.num and a.company = b.company)
join( route c join route d on (c.num = d.num and c.company = d.company))
join stops start on (start.id = a.stop)
join stops trans1 on (trans1.id = b.stop)
join stops trans2 on (trans2.id = c.stop)
join stops end on (end.id = d.stop)
where start.name = "Craiglockhart" and end.name = "Sighthill" and trans1.name = trans2.name 
order by length(a.num), a.num
