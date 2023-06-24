
Select location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as Perc 
from CovidDeaths$
where location like '%states%'


select location, date, population, total_cases, (total_cases / population)*100 as Perc
from CovidDeaths$
where location like '%pakistan%'
order by 1,2 

select count(distinct(location)) 
from CovidDeaths$

-- looking at countries with Highest infection rate compared to Population

select location, population, max(total_cases) as HighestInfectionCount, max((total_cases / population))*100 as Perc
from CovidDeaths$
group by location, population
order by Perc desc


-- Showing countries with the Highest Death Count Per Population 

Select location, max(cast(total_deaths as int)) as HighestDeathsCount, max(total_deaths / Population)*100 as Perc
from CovidDeaths$
where continent is not null 
Group by Location 
Order by HighestDeathsCount desc




-- Let's Break things down by Continent 




-- Showing Continents with the highest death count per population 


Select location , max(cast(total_deaths as int)) as TotalDeaths 
from CovidDeaths$
Where continent is null 
Group by location  
Order by TotalDeaths desc 


-- Global Numbers

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/ sum(new_cases))*100 as Perc
From CovidDeaths$
where continent is not null 
order by 1,2 


-- looking at total Population vs Vaccinations 


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as rollingvaccinations 
from CovidDeaths$ dea 
Join CovidVaccinations$ Vac 
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not null
order by 2,3

-- USING CTE

With PopVsVac (Continent, Location, Date, Population,new_vaccinations, rollingvaccinations)
as 
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as rollingvaccinations 
from CovidDeaths$ dea 
Join CovidVaccinations$ Vac 
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not null
)

Select * , (Rollingvaccinations / Population)*100 as Perc
From PopVsVac
Order by Perc ASC



-- TEMP Table 

Drop Table If Exists #PercentPopulationVaccinated 
Create Table #PercentPopulationVaccinated 
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric, 
New_Vaccinations numeric,
rollingvaccinations numeric
)

Insert into #PercentPopulationVaccinated 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as rollingvaccinations 
from CovidDeaths$ dea 
Join CovidVaccinations$ Vac 
on dea.location = vac.location 
and dea.date = vac.date 
--where dea.continent is not null

Select * , (Rollingvaccinations / Population)*100 as Perc
From #PercentPopulationVaccinated


Create View Total_Cases as 
Select location, max(total_cases) as total_cases , max(convert(int,Total_deaths)) as total_deaths, max(population) as population
From CovidDeaths$ 
Where Continent is null and location not like '%international%'
group by location 









