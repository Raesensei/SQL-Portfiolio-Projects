SELECT *
FROM [Portfolio project]..CovidDeaths$
Where continent is not null
ORDER BY 3, 4;


--SELECT *
--FROM [portfolio project]..CovidVaccinations$
--Where continent is not null
--ORDER BY 3, 4;

-- Selecting data to be used for analysis

Select location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio project]..CovidDeaths$
Where continent is not null
ORDER BY 1,2;

--Select location, date, total_cases,total_deaths, 
--(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
--From [Portfolio project]..CovidDeaths$
--order by 1,2

-- observing Total cases vs Total deaths
-- displaying possibilities of dying if you contract corona virus in Nigeria

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage
From [Portfolio project]..CovidDeaths$
Where location like '%Nigeria%'
and continent is not null
ORDER BY 1,2;


-- Observing Total cases vs Population
-- Showimg the percentage of Populatin infected

Select location, date, population, total_cases, (total_cases/population)*100 as PopulationInfectedPercentage
From [Portfolio project]..CovidDeaths$
Where location like '%Nigeria%'
where continent is not null
ORDER BY 1,2;


-- looking a countries  with the highest Infection Rate Compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PopulationInfectedPercentage
From [Portfolio project]..CovidDeaths$
Where continent is not null
Group by Location, population
ORDER BY PopulationInfectedPercentage desc


-- Looking at countries with the highest death count per population

Select location, population, MAX(cast(total_deaths as int)) as TotaldeathCount, MAX(total_deaths/population)*100 as DeathratePercentage
From [Portfolio project]..CovidDeaths$
Where continent is not null
Group by Location, population
ORDER BY DeathratePercentage desc


-- Looking at countries with the highest death count per population

Select location, MAX(cast(total_deaths as int)) as Totaldeathcount
From [Portfolio project]..CovidDeaths$
Where continent is not null
Group by Location
ORDER BY Totaldeathcount desc


--Breaking things down by continent
-- showing continents with the highest death count

Select continent, MAX(cast(total_deaths as int)) as Totaldeathcount
From [Portfolio project]..CovidDeaths$
Where continent is not null
Group by continent 
ORDER BY Totaldeathcount desc 


-- Global Numbers
-- Daily
 Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_percentage
From [Portfolio project]..CovidDeaths$
--Where location like '%Nigeria%'
where continent is not null
Group by date
ORDER BY 1,2;

-- All together
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_percentage
From [Portfolio project]..CovidDeaths$
--Where location like '%Nigeria%'
where continent is not null
--Group by date
ORDER BY 1,2;


SELECT *
FROM [portfolio project]..CovidVaccinations$
Where continent is not null
ORDER BY 3, 4;

select *
From [portfolio project]..CovidDeaths$ dea
Join [portfolio project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date

-- looking at total population vs vaccinations

select dea.continent, dea.location,dea.Date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location order by dea.Location, dea.Date) as Rollingpeoplevaccinated
From [portfolio project]..CovidDeaths$ dea
Join [portfolio project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- USE CTE

With populationvsVaccination (Continent, Location, Date, population, New_vaccination, Rollingpeoplevaccinated)
as
(
select dea.continent, dea.location,dea.Date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.Date) as Rollingpeoplevaccinated
From [portfolio project]..CovidDeaths$ dea
Join [portfolio project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (Rollingpeoplevaccinated/population)*100
From populationvsVaccination


-- Temptable

Drop table if exists  #PercentPopulationvaccinated
Create Table #PercentPopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
)

Insert into #PercentPopulationvaccinated
select dea.continent, dea.location,dea.Date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.Date) as Rollingpeoplevaccinated
From [portfolio project]..CovidDeaths$ dea
Join [portfolio project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null

Select *, (Rollingpeoplevaccinated/population)*100
From #PercentPopulationvaccinated



-- Creating view to sore data for later visualiztions
Create view PercentPopulationvaccinated as
select dea.continent, dea.location,dea.Date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.Date) as Rollingpeoplevaccinated
From [portfolio project]..CovidDeaths$ dea
Join [portfolio project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *
From PercentPopulationvaccinated