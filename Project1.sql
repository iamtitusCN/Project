select *
from portfolio..CovidDeath
where continent is not null
order by 3,4


--select *
--from portfolio..CovidVaccin
--order by 3,4

--select location, date, total_cases, new_cases, total_deaths, population
--from portfolio..CovidDeath
--order by 1,2


--select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--from portfolio..CovidDeath
--order by 1,2

--select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--from portfolio..CovidDeath
--where location like '%africa%'
--order by 1,2

--select location, date, population,total_cases,  (total_cases/population)*100 as DeathPercentage
--from portfolio..CovidDeath
----where location like '%states%'
--order by 1,2

--select location, population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
--from portfolio..CovidDeath
--group by location, population
----where location like '%states%'
--order by PercentagePopulationInfected desc

--select location,MAX(cast(total_deaths as int)) as TotalDeathCount
--from portfolio..CovidDeath
--where continent is not null
--group by location
----where location like '%states%'
--order by TotalDeathCount desc

select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from portfolio..CovidDeath
where continent is not null
group by continent
--where location like '%states%'
order by TotalDeathCount desc

--select location,MAX(cast(total_deaths as int)) as TotalDeathCount
--from portfolio..CovidDeath
--where continent is null
--group by location
----where location like '%states%'
--order by TotalDeathCount desc

--select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
--from portfolio..CovidDeath
--where continent is not null
--group by continent
----where location like '%states%'
--order by TotalDeathCount desc

--select location, date, population,total_cases,  (total_cases/population)*100 as DeathPercentage
--from portfolio..CovidDeath
----where location like '%states%'
--and continent is not null
--order by 1,2

--select  date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(New_cases)*100 as DeathPercentage
--from portfolio..CovidDeath
----where location like '%states%'
--where continent is not null
--group by date
--order by 1,2

--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--,SUM(CAST(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingpeopleVaccinated
--from Portfolio..CovidDeath dea
--Join Portfolio..CovidVaccin vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

--CTE
with PopvsVac (continent, location,Date, population, new_vaccinations, RollingpeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingpeopleVaccinated
from Portfolio..CovidDeath dea
Join Portfolio..CovidVaccin vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingpeopleVaccinated/population)*100 as Total
from PopvsVac

--Temp Table
--Drop Table if exists #PercentPopulationVaccinated
--create Table #PercentPopulationVaccinated
--(
--continet nvarchar(255),
--location nvarchar(255),
--Date datetime,
--population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--insert into #PercentPopulationVaccinated
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--,SUM(CAST(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingpeopleVaccinated
--from Portfolio..CovidDeath dea
--Join Portfolio..CovidVaccin vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


--select *,(RollingpeopleVaccinated/population)*100 as Total
--from #PercentPopulationVaccinated

--Creating Views to store data

Create View PercentPopulationVaccinated 
as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.Date) as RollingpeopleVaccinated
from Portfolio..CovidDeath dea
Join Portfolio..CovidVaccin vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3