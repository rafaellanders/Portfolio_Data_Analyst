-- Exploring datasets
select *  from covidmortescsv 




select location,date,total_cases ,new_cases ,total_deaths population  from covidmortescsv  
order by 1,2;


-- Looking for the percentage of deaths by country of desire


select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercentage from covidmortescsv   
where location like "%brazil%"
order by 1,2;

-- Looking for more important aspects of the dataset
-- (same as before but with population)


select location,date,population ,total_deaths, (total_deaths/population)*100 as deathpercentage from covidmortescsv   
where location like "%brazil%"
order by 1,2;


-- And now the case we desire to know the percentage of infected people

select location,date,population ,total_cases , (total_cases/population)*100 as PopulationCases from covidmortescsv   
where location like "%brazil%"
order by 1,2;

-- People with highest infection rate compared to population in every country

select location, population, max(total_cases) as HigehstInfectionCount, max((total_cases/population))*100 
as PopulationCases 
from covidmortescsv   
-- where location like "%brazil%"
group by location,population 
order by PopulationCases desc ;

 -- Countries with highest  death count per location

select location, max(total_deaths) as TotalDeathCount
from covidmortescsv   
where nullif(continent,'') is not null 
group by location 
order by TotalDeathCount desc  ;


-- and now continents


select location  , max(total_deaths) as TotalDeathCount
from covidmortescsv   
where nullif(continent,'') is null 
group by location  
order by TotalDeathCount desc  ;



-- Unbiased Values


select sum(new_cases) as TotalCases,sum(new_deaths) as  NewDeaths, (sum(new_deaths)/sum(new_cases))*100 as Percentile
from covidmortescsv 
where nullif(continent,'') is not null 
-- group by date
order by 1,2;

-- if you look for the problem (covid) you might w for a solution to (vaccine) 
-- looking for the percentage of population who got vaccinated

select	d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location,d.date) as VaccinatedPeople,
(sum(v.new_vaccinations) over (partition by d.location order by d.location,d.date)/population) * 100 as PercentileVaccinatedPeople
from covidmortescsv d
join covidvacinascsv v
	on d.location = v.location 
	and d.date = v.date
where nullif(d.continent,'') is not null 
order by 2,3


create view PercentileVaccinatedPeople as 
select	d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(v.new_vaccinations) over (partition by d.location order by d.location,d.date) as VaccinatedPeople,
(sum(v.new_vaccinations) over (partition by d.location order by d.location,d.date)/population) * 100 as PercentileVaccinatedPeople
from covidmortescsv d
join covidvacinascsv v
	on d.location = v.location 
	and d.date = v.date
where nullif(d.continent,'') is not null 	
-- order by 2,3



select * from percentilevaccinatedpeople p 
