--This is MAven Environmental Challenge(Apple's Greenhouse Gas Emissions Analysis)

--Overview of GHG Emission Datasets

SELECT *
FROM  [dbo].[Maven_Env_GHG_emissions]
---------------------------------------------------------------------------------

--Overview of Carbon Footprint by product

SELECT *
FROM [dbo].[Maven_Env_carbon_footprint_by_prdt]
---------------------------------------------------------------------------------
--Overview of Normalisation Factor

SELECT *
FROM [dbo].[Maven_Env_NFactor]
---------------------------------------------------------------------------------
--Check for null values

SELECT *
FROM  [dbo].[Maven_Env_GHG_emissions]
WHERE [Fiscal Year] IS NULL

SELECT *
FROM  [dbo].[Maven_Env_GHG_emissions]
WHERE [Category] IS NULL

SELECT *
FROM  [dbo].[Maven_Env_GHG_emissions]
WHERE [Type] IS NULL

SELECT *
FROM  [dbo].[Maven_Env_GHG_emissions]
WHERE [Scope] IS NULL
---------------------------------------------------------------------------------
--Alter [dbo].[Maven_Env_GHG_emissions] 

UPDATE [dbo].[Maven_Env_GHG_emissions]
SET Scope = REPLACE(Scope, 'Scope 2 (market-based)', 'Scope 2')
FROM [dbo].[Maven_Env_GHG_emissions]

--Join GHG Emissions and Normalization Factors

SELECT
   GHGEmissions.[Fiscal Year], 
   GHGEmissions.[Category],
   GHGEmissions.[Type], 
   [Scope],
   [Description],
   NFactor.[Revenue],
   NFactor.[Market Capitalization],
   NFactor.[Employees]
FROM 
   [dbo].[Maven_Env_GHG_emissions] AS GHGEmissions 
   FULL JOIN [dbo].[Maven_Env_NFactor] AS NFactor
   ON GHGEmissions.[Fiscal Year] = Nfactor.[Fiscal Year]

--CROSS Join Between Normalizing factor and Footprint
SELECT *
FROM [dbo].[Maven_Env_NFactor]
CROSS JOIN [dbo].[Maven_Env_carbon_footprint_by_prdt]

--Join and Cross Join of GHG Emissions, Normalization Factors and Carbon Footprint
SELECT
   GHGEmissions.[Fiscal Year], 
   GHGEmissions.[Category],
   GHGEmissions.[Type],
   [Scope],
   [Description],
   NFactor.[Revenue],
   NFactor.[Market Capitalization],
   NFactor.[Employees],
   FT.[Release Year],
   FT.[Product],
   FT.[Baseline Storage],
   FT.[Carbon Footprint]
FROM ([dbo].[Maven_Env_GHG_emissions] AS GHGEmissions 
FULL JOIN [dbo].[Maven_Env_NFactor] AS NFactor
ON GHGEmissions.[Fiscal Year] = Nfactor.[Fiscal Year])
CROSS JOIN [dbo].[Maven_Env_carbon_footprint_by_prdt] AS FT

----------------------------------------------------------------------------------
SELECT *
FROM [dbo].[Maven_Env_GHG_emissions] AS Emissions 
LEFT JOIN ([dbo].[Maven_Env_NFactor] AS Nfactor
CROSS JOIN [dbo].[Maven_Env_carbon_footprint_by_prdt])
ON Emissions.[Fiscal Year] = Nfactor.[Fiscal Year]

-----------------------------------------------------------------------------------
--INNER JOIN the Tables of GHG Emissions and Normalization Factor Tables

SELECT
   GHGEmissions.[Fiscal Year], 
   GHGEmissions.[Category],
   AVG(GHGEmissions.[Emissions]) AS Emissions, 
   --[Scope],
   [Description],
  AVG(NFactor.[Revenue]),
  AVG(NFactor.[Market Capitalization]),
  AVG(NFactor.[Employees])
FROM 
   [dbo].[Maven_Env_GHG_emissions] AS GHGEmissions 
   JOIN [dbo].[Maven_Env_NFactor] AS NFactor
   ON GHGEmissions.[Fiscal Year] = Nfactor.[Fiscal Year]
GROUP BY 
   [Description]
ORDER BY 
   Emissions DESC