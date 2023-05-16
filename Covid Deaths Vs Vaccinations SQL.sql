-- Looking at total cases vs total deaths, and calculating the number of deaths as a percentage of the total number of cases at the time
SELECT location, date, CAST(total_cases AS numeric) as total_cases, CAST(total_deaths AS numeric) as total_deaths, (CAST(total_deaths AS numeric) / CAST(total_cases AS numeric)) * 100 as 'Deaths as a Percentage of Total Cases'
FROM CovidProject.. ['COVID DEATHS$']
ORDER BY 1, 2

-- Looking at total cases vs population, and calculating the population infected as a percentage of the entire population
SELECT location, date, CAST(total_cases AS numeric) as total_cases, CAST(population AS numeric) as population, (CAST(total_cases AS numeric) / CAST(population AS numeric)) * 100 as 'Infected as a Percentage of Population'
FROM CovidProject.. ['COVID DEATHS$']
ORDER BY 1, 2

-- Looking at total deaths vs population, and calculating the number deaths as a percentage of the entire population
SELECT location, date, CAST(total_deaths AS numeric) as total_deaths, CAST(population AS numeric) as population, (CAST(total_deaths AS numeric) / CAST(population AS numeric)) * 100 as 'Deaths as a Percentage of Population'
FROM CovidProject.. ['COVID DEATHS$']
ORDER BY 1, 2

-- Looking at countries with Highest population infected
SELECT location, MAX(CAST(total_cases AS numeric)) as 'Highest Number of Cases', MAX((CAST(total_cases AS numeric) / CAST(population AS numeric)) * 100) as 'Highest Number Infected as a Percentage of Population'
FROM CovidProject.. ['COVID DEATHS$']
GROUP BY location
ORDER BY 'Highest Number Infected as a Percentage of Population' DESC

-- Looking at countries with Highest population dead due after being infected with Covid
SELECT location, MAX(CAST(total_deaths AS numeric)) as 'Highest Number of Deaths', MAX((CAST(total_deaths AS numeric) / CAST(population AS numeric)) * 100) as 'Highest Number Dead as a Percentage of Population'
FROM CovidProject.. ['COVID DEATHS$']
GROUP BY location
ORDER BY 'Highest Number Dead as a Percentage of Population' DESC

-- Looking at percentage of deaths across the world
SELECT SUM(CAST(new_cases as numeric)) as total_cases, SUM(CAST(new_deaths AS numeric)) as total_deaths, (SUM(CAST(new_deaths AS numeric)) / SUM(CAST(new_cases AS numeric)) * 100) as 'Total Deaths as a Perecentage of Total Cases'
FROM CovidProject.. ['COVID DEATHS$']

-- Looking at total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(numeric, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as Total_population_vaccinated
From CovidProject.. ['COVID DEATHS$'] dea
JOIN CovidProject.. ['COVID VACCINATIONS$'] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
where dea.continent IS NOT NULL
order by 2,3


-- Creating a temp table to store the query above as a variable
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Total_population_vaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(numeric, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as Total_population_vaccinated
From CovidProject.. ['COVID DEATHS$'] dea
JOIN CovidProject.. ['COVID VACCINATIONS$'] vac
	ON dea.location = vac.location
	AND dea.date = vac.date

-- Calculating population vaccinated in each location as a percentage of the location's entire population
SELECT *, (Total_population_vaccinated/Population)*100
FROM #PercentPopulationVaccinated

-- Creating a view for visualisation
USE CovidProject
GO
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(numeric, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as Total_population_vaccinated
From CovidProject.. ['COVID DEATHS$'] dea
JOIN CovidProject.. ['COVID VACCINATIONS$'] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
wHERE dea.continent IS NOT NULL

DROP VIEW IF EXISTS PercentPopulationVaccinated