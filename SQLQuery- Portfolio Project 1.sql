select *
from CovidDeaths

select *
from CovidDeaths
where continent is not null
order by 3, 4

---select *
---from CovidVaccinations
---order by 3, 4

---Select data we will be using

Select Location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1, 2


---Looking at total cases versus total deaths
---Shows the likelihood of dying if the disease is contracted in individual countries

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
from CovidDeaths
Where location = 'United states'
order by 1, 2

---Looking at the total cases versus the population
---Shows what percentage of the population have contracted the disease per day
Select Location, date, Population, total_cases, (total_cases/population)*100 As CasePercentage
from CovidDeaths
Where location = 'Nigeria'
order by 1,2

--Looking at countries with highest infection rate compared to population
Select Location, Population, MAX(total_cases) as HighestInfection, Max((total_cases/population))*100 As PercentPopulationInfected
from CovidDeaths
Group by Location, Population
order by PercentPopulationInfected DESC

---Showing countries with the highest death count as a percentage of the population

Select Location, Continent, Population, MAX(total_deaths) as HighestDeaths, Max((total_deaths/population))*100 As PercentPopulationDead
from CovidDeaths
where continent is not null
Group by Continent, Location, Population
order by 1 

--Showing countries with the highest death count 

Select Location, MAX(total_deaths) as HighestDeaths
from CovidDeaths
where continent is not null
Group by Location
order by HighestDeaths DESC


--Showing the continents with the highest Death count per population

Select continent, MAX(total_deaths) as HighestDeaths
from CovidDeaths
where continent is not null
Group by continent
order by HighestDeaths DESC

--GLOBAL NUMBERS

--shows the global number per day

Select Date, Sum(cast(new_cases as float)) as TotalCases, sum(cast(new_deaths as float)) as TotalDeaths, sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100 as DeathPercentage --total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
from CovidDeaths
where continent is not null
Group by Date
order by 1, 2

--shows the total global number (how many cases, how many deaths, and the percentage of the deaths to the cases)

Select Sum(cast(new_cases as float)) as TotalCases, sum(cast(new_deaths as float)) as TotalDeaths, sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100 as DeathPercentage --total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
from CovidDeaths
where continent is not null
--Group by Date
order by 1, 2

--Joining Tables CovidDeaths and CovidVaccinations
Select *
from CovidDeaths Dea
join covidVaccinations Vac
on Dea.Location=Vac.Location and Dea.Date=Vac.Date

--Looking at Total Population versus vaccinations

Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, MAX(Vac.New_Vaccinations/Dea.Population)*100 As PercentDailyVaccinated
from CovidDeaths Dea
join covidVaccinations Vac
on Dea.Location=Vac.Location and Dea.Date=Vac.Date
where Dea.continent is not null
Group by Dea.Continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations
Order by 2, 3

--Looking at 1) Daily Vaccinations. 2)Adding Daily Vaccinations to the previous day's number

Select Dea.Location, Dea.Date, Dea.Population, New_Vaccinations,
sum(cast(New_Vaccinations as int)) over (partition by Dea.Location order by Dea.Location, Dea.Date) as RollingPeopleVac
from CovidDeaths Dea
join covidVaccinations Vac
on Dea.Location=Vac.Location and Dea.Date=Vac.Date
where Dea.continent is not null and Dea.location='Albania'


--To find the percent of the population that have been vaccinated- based on (UpdateofTotalPeopleVaccinatedPerDay)/population)*100. 
--However, we cannot use a newly created column to create another column or make a new calculation.
--So, we need to use a CTE or a temp table 

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, UpdateofTotalPeopleVaccinatedPerDay)
As 
(Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, New_Vaccinations, 
sum(cast(new_vaccinations as int)) over (partition by Dea.Location order by Dea.Location, Dea.Date) as UpdateofTotalPeopleVaccinatedPerDay
from CovidDeaths Dea
join covidVaccinations Vac
on Dea.Location=Vac.Location and Dea.Date=Vac.Date
where Dea.continent is not null
)

Select *, (UpdateofTotalPeopleVaccinatedPerDay/population)*100
from PopvsVac
order by 2


--As part of CTE Showing the highest number of new vaccinations in every location and what percent of the population that number is

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, UpdateofTotalPeopleVaccinatedPerDay)
As 
(Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, New_Vaccinations, 
sum(cast(new_vaccinations as int)) over (partition by Dea.Location order by Dea.Location, Dea.Date) as UpdateofTotalPeopleVaccinatedPerDay
from CovidDeaths Dea
join covidVaccinations Vac
on Dea.Location=Vac.Location and Dea.Date=Vac.Date
where Dea.continent is not null
)

Select Location, Population, Max(UpdateofTotalPeopleVaccinatedPerDay) MaxTotalVac,  Max(UpdateofTotalPeopleVaccinatedPerDay/population)*100 PercentofPopVac
from PopvsVac
Group by location, Population
order by location

--As part of CTE Showing the highest number of Total Vaccinations in every location and what percent of the population that number is. 
--From the data, the highest number of new vaccinations and the total vaccinations do not match

With PopVsTotalvac (Location, Population, MaxTotalVac)
As 
(Select Vac.Location, Population, Max(cast(Total_Vaccinations as int)) MaxTotalVac
from CovidVaccinations Vac
Join CovidDeaths Dea
on Vac.Date=Dea.Date and Vac.Location=Dea.Location
Group by Vac.Location, Population
)

select *, (MaxTotalVac/population)*100
from PopVsTotalvac
order by 1


--USING A TEMP TABLE


Drop Table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric,
New_Vaccinations numeric,
UpdateofTotalPeopleVaccinatedPerDay NUMERIC
)

Insert into #PercentPopulationVaccinated

Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, New_Vaccinations, 
sum(cast(new_vaccinations as int)) over (partition by Dea.Location order by Dea.Location, Dea.Date) as UpdateofTotalPeopleVaccinatedPerDay
from CovidDeaths Dea
join covidVaccinations Vac
on Dea.Location=Vac.Location and Dea.Date=Vac.Date
where Dea.continent is not null


Select *, (UpdateofTotalPeopleVaccinatedPerDay/population)*100
from #PercentPopulationVaccinated


--- Creating View to Store Data for Later Visualisations

Create View PercentPopulationVaccinated AS

Select Dea.Continent, Dea.Location, Dea.Date, Dea.Population, New_Vaccinations, 
sum(cast(new_vaccinations as int)) over (partition by Dea.Location order by Dea.Location, Dea.Date) as UpdateofTotalPeopleVaccinatedPerDay
from CovidDeaths Dea
join covidVaccinations Vac
on Dea.Location=Vac.Location and Dea.Date=Vac.Date
where Dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated
order by 2