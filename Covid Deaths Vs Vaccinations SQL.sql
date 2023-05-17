-- Finding the total number of cases, total number of deaths, and the total number of deaths as a percentage of the total number of cases
-- This query is carried out where continents are not null

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject.. ['COVID DEATHS$']
where continent is not null

-- Finding the total number of deaths in each location
-- This query does not include locations like European union as this is a part of the already included location 'Europe' and would result in duplicate copies. Same with World and International as they will include the deaths from all the available locations combined

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidProject.. ['COVID DEATHS$']
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- Finding the total number of cases in each location, the population in each location, and the total number of cases in each location as a percentage of the location's population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject.. ['COVID DEATHS$']
Group by Location, Population
order by PercentPopulationInfected desc

-- Finding the total number of cases in each location per date, the population in each location per date, and the total number of cases in each location as a percentage of the location's population per date

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject.. ['COVID DEATHS$']
Group by Location, Population, date
order by PercentPopulationInfected desc