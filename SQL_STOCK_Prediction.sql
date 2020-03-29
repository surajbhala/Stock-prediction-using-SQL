## Assignment for determining Buy/Sell/Hold signal for a stock
use assignment; ## The name of the schema is kept to be assignment

### The below two statements are used as it relaxes the checks for non-deterministic function (the UDF created at the end)
SET SQL_SAFE_UPDATES = 0;
SET GLOBAL log_bin_trust_function_creators = 1;

## All the tables have been importe using the UI import utility of the MySQL workbench 
## Only 2 columns viz : Date and Close price have been imported as these are the only two factors in determining the signals

## Converting date from string format to valid date-time format
update `bajaj auto`
set date = str_to_date(`Date`,'%d-%M-%Y');

## Verifying the table after doing date conversion
select * from `bajaj auto`;

update `eicher motors`
set date = str_to_date(`Date`,'%d-%M-%Y');

update `hero motocorp`
set date = str_to_date(`Date`,'%d-%M-%Y');

update `infosys`
set date = str_to_date(`Date`,'%d-%M-%Y');

update `tcs`
set date = str_to_date(`Date`,'%d-%M-%Y');

update `tvs motors`
set date = str_to_date(`Date`,'%d-%M-%Y');

## Creating table bajaj1 having values of 20day MA and 50 days MA
create table bajaj1 as 
(select * , 
avg(`Close Price`) over (order by Date asc rows 19 preceding) as `20 Day MA`,
avg(`Close Price`) over (order by Date asc rows 49 preceding) as `50 Day MA`
from `bajaj auto`);

## Now as the first n values (19 and 49 respectively) will not be of much use to us we will be setting them null

update bajaj1
set `20 Day MA` = null
LIMIT 19;

update bajaj1
set `50 Day MA` = null
LIMIT 49;

## We repeat the same process as that of bajaj for the remaining stocks

create table eicher1 as (select
  Date, `Close Price`,
  avg(`Close Price`) over (order by Date asc rows 19 preceding) as '20 Day MA',
  avg(`Close Price`) over (order by Date asc rows 49 preceding) as '50 Day MA'
from 
  `eicher motors`);
  
update eicher1
set `20 Day MA` = null
LIMIT 19;

update eicher1
set `50 Day MA` = null
LIMIT 49;

create table hero1 as (select
  Date, `Close Price`,
  avg(`Close Price`) over (order by Date asc rows 19 preceding) as '20 Day MA',
  avg(`Close Price`) over (order by Date asc rows 49 preceding) as '50 Day MA'
from 
  `hero motocorp`);
  
update hero1
set `20 Day MA` = null
LIMIT 19;

update hero1
set `50 Day MA` = null
LIMIT 49;


create table infosys1 as (select
  Date, `Close Price`,
  avg(`Close Price`) over (order by Date asc rows 19 preceding) as '20 Day MA',
  avg(`Close Price`) over (order by Date asc rows 49 preceding) as '50 Day MA'
from 
  `infosys`);
  
update infosys1
set `20 Day MA` = null
LIMIT 19;

update infosys1
set `50 Day MA` = null
LIMIT 49;


create table tcs1 as (select
  Date, `Close Price`,
  avg(`Close Price`) over (order by Date asc rows 19 preceding) as '20 Day MA',
  avg(`Close Price`) over (order by Date asc rows 49 preceding) as '50 Day MA'
from 
  `tcs`);
  
update tcs1
set `20 Day MA` = null
LIMIT 19;

update tcs1
set `50 Day MA` = null
LIMIT 49;

create table tvs1 as (select
  Date, `Close Price`,
  avg(`Close Price`) over (order by Date asc rows 19 preceding) as '20 Day MA',
  avg(`Close Price`) over (order by Date asc rows 49 preceding) as '50 Day MA'
from 
  `tvs motors`);
  
update tvs1
set `20 Day MA` = null
LIMIT 19;

update tvs1
set `50 Day MA` = null
LIMIT 49;


## Creating master table combining all the stock prices as asked in (2)
create table `master table` as (
select b.Date, b.`Close Price` as Bajaj, t.`Close Price` as TCS, tv.`Close Price` as TVS , i.`Close Price` as Infosys,e.`Close Price` as Eicher, h.`Close Price` as Hero
from `bajaj auto` b inner join tcs t on b.Date = t.Date inner join `tvs motors` tv on t.Date = tv.Date inner join infosys i on tv.Date = i.Date inner join `eicher motors` e on i.Date = e.Date inner join `hero motocorp` h on e.Date = h.Date
);
select * from `master table`;


### Creating buy and sell signal for all the stocks 
## Here we have used LAG function as it is a analytic function in SQL which allows us to query more than one row
## of a table without the need of joining the table

create table bajaj2 as (select
Date, `Close Price`,
case
	when(`20 Day MA` < `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()>
		lag(`50 Day MA`, 1) over ())
    then 'Sell'
    when(`20 Day MA` > `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()<=
		lag(`50 Day MA`, 1) over ())
    then 'Buy'
    else 'Hold'
end as 'Signal'
from bajaj1);

## Verifying the generated table
select * from bajaj2;

## Repeat the same task for creating tables eicher2, hero2, tvs2, tcs2, infosys2

create table eicher2 as (select
Date, `Close Price`,
case
	when(`20 Day MA` < `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()>
		lag(`50 Day MA`, 1) over ())
    then 'Sell'
    when(`20 Day MA` > `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()<=
		lag(`50 Day MA`, 1) over ())
    then 'Buy'
    else 'Hold'
end as 'Signal'
from eicher1);

create table hero2 as (select
Date, `Close Price`,
case
	when(`20 Day MA` < `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()>
		lag(`50 Day MA`, 1) over ())
    then 'Sell'
    when(`20 Day MA` > `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()<=
		lag(`50 Day MA`, 1) over ())
    then 'Buy'
    else 'Hold'
end as 'Signal'
from hero1);

create table infosys2 as (select
Date, `Close Price`,
case
	when(`20 Day MA` < `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()>
		lag(`50 Day MA`, 1) over ())
    then 'Sell'
    when(`20 Day MA` > `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()<=
		lag(`50 Day MA`, 1) over ())
    then 'Buy'
    else 'Hold'
end as 'Signal'
from infosys1);

create table tcs2 as (select
Date, `Close Price`,
case
	when(`20 Day MA` < `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()>
		lag(`50 Day MA`, 1) over ())
    then 'Sell'
    when(`20 Day MA` > `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()<=
		lag(`50 Day MA`, 1) over ())
    then 'Buy'
    else 'Hold'
end as 'Signal'
from tcs1);

create table tvs2 as (select
Date, `Close Price`,
case
	when(`20 Day MA` < `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()>
		lag(`50 Day MA`, 1) over ())
    then 'Sell'
    when(`20 Day MA` > `50 Day MA` and 
		lag(`20 Day MA`, 1) over ()<=
		lag(`50 Day MA`, 1) over ())
    then 'Buy'
    else 'Hold'
end as 'Signal'
from tvs1);


## Creating a User Defined Function(UDF) which can take the date as input and return the signal for a particular date (as BUY / SELL / HOLD)

create function bajaj_signal(dat Date)
returns varchar(4)
return (select bajaj2.`Signal` from bajaj2
		where dat=bajaj2.Date);
        
## To verify the UDF(created above) couple of select queries are demonstrated

select bajaj_signal('2018-01-02') as result;

select bajaj_signal('2018-01-04') as result2;