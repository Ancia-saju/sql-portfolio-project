SELECT *
FROM [portfolio project]..CovidDeaths
ORDER BY 3,4



SELECT *
FROM [portfolio project]..CovidVaccinations
ORDER BY 3,4

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM [portfolio project]..CovidDeaths
ORDER BY 1,3

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
FROM [portfolio project]..CovidDeaths
ORDER BY 1,2

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
FROM [portfolio project]..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

SELECT location,date,population,total_cases,(total_cases/population)*100 as Affectedpercentage
FROM [portfolio project]..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

SELECT location,date,population,total_cases,(total_cases/population)*100 as Affectedpercentage
FROM [portfolio project]..CovidDeaths
--WHERE location like '%states%'
ORDER BY 1,2

SELECT location,population,max(total_cases) as Highestinfectionrate,max((total_cases/population))*100 as Affectedpercentage
FROM [portfolio project]..CovidDeaths
GROUP BY location,population
ORDER BY Affectedpercentage DESC


SELECT location,MAX(CAST(total_deaths as INT))  as Totaldeathcount
FROM [portfolio project]..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY Totaldeathcount DESC


SELECT date,SUM(new_cases) as Totalnewcases,SUM(CAST(new_deaths as INT)) as Totalnewdeaths,SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as percentagetotal
FROM [portfolio project]..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

SELECT SUM(new_cases) as Totalnewcases,SUM(CAST(new_deaths as INT)) as Totalnewdeaths,SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as percentagetotal
FROM [portfolio project]..CovidDeaths
WHERE continent is not null
ORDER BY 1,2


SELECT * FROM [portfolio project]..CovidVaccinations

SELECT * FROM [portfolio project]..CovidDeaths dea
JOIN [portfolio project]..CovidVaccinations vac
ON dea.location=vac.location
AND dea.date=vac.date


SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
FROM [portfolio project]..CovidDeaths dea
JOIN [portfolio project]..CovidVaccinations vac
ON dea.location=vac.location
AND dea.date=vac.date
WHERE dea.continent is not null
ORDER BY 2,3


SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(INT,vac.new_vaccinations))
OVER(partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
FROM [portfolio project]..CovidDeaths dea
JOIN [portfolio project]..CovidVaccinations vac
ON dea.location=vac.location
AND dea.date=vac.date
WHERE dea.continent is not null
ORDER BY 2,3




WITH popvsvac(continent,location,date,population,new_vaccinations,Rollingpeoplevaccinated)
AS
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(INT,vac.new_vaccinations))
OVER(partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
FROM [portfolio project]..CovidDeaths dea
JOIN [portfolio project]..CovidVaccinations vac
ON dea.location=vac.location
AND dea.date=vac.date
WHERE dea.continent is not null
)

SELECT *,(Rollingpeoplevaccinated/population)*100
FROM popvsvac





CREATE Table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinated numeric,
Rollingpeoplevaccinated numeric
)
INSERT INTO #percentpopulationvaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(INT,vac.new_vaccinations))
OVER(partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
FROM [portfolio project]..CovidDeaths dea
JOIN [portfolio project]..CovidVaccinations vac
ON dea.location=vac.location
AND dea.date=vac.date
SELECT *,(Rollingpeoplevaccinated/population)*100
FROM #percentpopulationvaccinated




CREATE VIEW percentpopulatonvaccinated as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CONVERT(INT,vac.new_vaccinations))
OVER(partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
FROM [portfolio project]..CovidDeaths dea
JOIN [portfolio project]..CovidVaccinations vac
ON dea.location=vac.location
AND dea.date=vac.date
WHERE dea.continent is not null


SELECT * FROM percentpopulatonvaccinated