Select 
	*
From
	PortifolioProject..CovidDeaths
Where
	continent is not null
Order by
	3,4


--Select Data that we are going to be using

Select
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
From
	PortifolioProject..CovidDeaths
Where
	continent is not null
Order by
	1,2

-- Looking at Total Cases Vs Total Deaths
--Shows the likelyhood of dying if you contract Covid-19 in Ethiopia

Select 
	location, 
	date, 
	total_cases, 
	total_deaths, 
	(cast(total_deaths as float)/cast(total_cases as float ))*100 as DeathPercentage

From PortifolioProject..CovidDeaths

Where location like 'Ethiopia' And continent is not null

order by 1, 2
	
--Looking at the Total Cases vs The Population
--Shows what percent of the population of Ethiopia got covid

Select 
	location, 
	date, 
	population, 
	total_cases, 
	(total_cases/population)*100 as Infected_Pop_Percentage

From PortifolioProject..CovidDeaths

Where location like 'Ethiopia' And continent is not null

order by 1, 2

-- Looking at the countries with the highest InfectionRate compared to the popultion

Select 
	location, 
	population, MAX(total_cases) as HighInfectionCount, 
	MAX((total_cases/population))*100 as Infected_Pop_Percentage

From PortifolioProject..CovidDeaths

--Where location like 'Ethiopia'
Where continent is not null

Group by location, population

Order by Infected_Pop_Percentage DESC	

-- Showing Countries with Highest Death Count Per Population

Select 
	location, 
	MAX(cast(total_deaths as int)) as TotalDeathCount

From PortifolioProject..CovidDeaths

--Where location like 'Ethiopia'
Where continent is not null

Group by location

Order by TotalDeathCount DESC

-- BREAKING THINGS DOWN BY CONTINENT
-- Showing continents with the highest death count per population


Select 
	continent, 
	MAX(cast(total_deaths as int)) as TotalDeathCount

From PortifolioProject..CovidDeaths

--Where location like 'Ethiopia'
Where continent is not null
Group by continent
Order by TotalDeathCount DESC

-- Global Numbers

Select 
	date, 
	SUM(new_cases) as total_cases, 
	SUM(CAST(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage

From PortifolioProject..CovidDeaths

--Where location like 'Ethiopia' 
Where continent is not null
Group by date
order by 1,2


-- Looking at total population Vs total vaccination

Select Distinct
	dea.continent,
	dea.location, 
	dea.date, 
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated

From PortifolioProject..CovidDeaths dea

JOIN
    PortifolioProject..CovidVaccinations vac 

ON 
	dea.location = vac.location AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
ORDER BY
    2,3

-- Using CTE
With PopvsVac (Continet, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)

AS
(
Select Distinct
	dea.continent,
	dea.location, 
	dea.date, 
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) AS RollingPeopleVaccinated

From PortifolioProject..CovidDeaths dea

JOIN
    PortifolioProject..CovidVaccinations vac 

ON 
	dea.location = vac.location AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
)
Select 
	*
From 
	PopvsVac