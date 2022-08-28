select * from PortfolioProject..CovidDeaths order by 3,4

--select * from PortfolioProject..CovidVaccinations order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2

--Looking at Total cases vs Total Deaths
--shows Likelihood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where location like '%stonia%'

order by 1,2

--Looking at Total cases vs Population
--Shows what percentage of population got covid

select location,date,total_cases,population,(total_cases/population)*100 as Percentagepopulationinfected
from PortfolioProject..CovidDeaths
where location like '%states%'
--where location like '%stonia%'
--where location like '%India%'

order by 1,2

--Looking at Countries with Highest infection Rate compared to Population

select location,population,max(total_cases)as HighestInfectioncount,Max(total_cases/population)*100 as Percentagepopulationinfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
--where location like '%stonia%'
--where location like '%India%'
Group by location,population
order by Percentagepopulationinfected desc

--Showing countries with Highest Death count per population
--if we make continent as not null we can get TotalDeathcount by country wise
select location,max(cast(total_deaths as int))as TotalDeathcount
from PortfolioProject..CovidDeaths
--where location like '%states%'
--where location like '%stonia%'
--where location like '%India%'
where continent is not null
Group by location

order by TotalDeathcount desc

--Lets break things down by continent

select location,max(cast(total_deaths as int))as TotalDeathcount
from PortfolioProject..CovidDeaths
--where location like '%states%'
--where location like '%stonia%'
--where location like '%India%'
where continent is  null
Group by location
order by TotalDeathcount desc

--Showing continents with highest death count per population

select continent,max(cast(total_deaths as int))as TotalDeathcount
from PortfolioProject..CovidDeaths
--where location like '%states%'
--where location like '%stonia%'
--where location like '%India%'
where continent is not  null
Group by continent
order by TotalDeathcount desc


--Global Numbers

select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int))as new_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
--where location like '%stonia%'
--where location like '%India%'
where continent is not null
group by date
order by 1,2

--To get total_cases,new_deaths,DeathPercentage

select sum(new_cases) as total_cases,sum(cast(new_deaths as int))as new_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
--where location like '%stonia%'
--where location like '%India%'
where continent is not null
--group by date
order by 1,2


--Looking at Total Population vs Vaccinations


 --USE CTE  FOR POPULATION VS VACCINATION

With PopvsVac(Continent,Location,Date,Population,New_vaccinations,RollingpeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccinated
--(RollingpeopleVaccinated/population)*100

from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
 on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
-- order by 2,3
 )
 select * ,(RollingpeopleVaccinated/population)*100 from PopvsVac



 --Temp Table

 DROP TABLE IF EXISTS #PercentPopulationVaccinated
 create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingpeopleVaccinated numeric
 )

 Insert into #PercentPopulationVaccinated
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccinated
--(RollingpeopleVaccinated/population)*100

from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
 on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
-- order by 2,3
 
 select * ,(RollingpeopleVaccinated/population)*100 from #PercentPopulationVaccinated



 ----CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS


 CREATE VIEW PercentPopulationVaccinated AS
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingpeopleVaccinated
--(RollingpeopleVaccinated/population)*100

from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
 on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
--order by 2,3


select* from PercentPopulationVaccinated