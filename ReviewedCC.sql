--chemicals in cosmetics table
select*
from DonGeorge.dbo.ReviewedCC

update DonGeorge.dbo.ReviewedCC
set ChemicalDateRemoved = replace (chemicalDateRemoved, '2103', '2013')

update DonGeorge.dbo.ReviewedCC
set ChemicalDateRemoved = replace (chemicalDateRemoved, '2104', '2014')

--1. most used chemicals
select ChemicalName, count(ChemicalName) as TotalMostChemicalsUsed
from DonGeorge.dbo.ReviewedCC
group by ChemicalName
order by count(chemicalName) desc

--2. Which companies used the most reported chemicals in their products

select distinct CompanyName, count( MostRecentDateReported) as FrequencyOfReport
from DonGeorge.dbo.ReviewedCC
where MostRecentDateReported is not null
group by CompanyName
order by count( MostRecentDateReported) desc

--3.Brands that had chemicals removed and discontinued.Identiy the chemicals

select BrandName, ChemicalName
from DonGeorge.dbo.ReviewedCC
where DiscontinuedDate is not null and ChemicalDateRemoved is not null
group by BrandName, ChemicalName
order by BrandName


--4.brands that had chemicals reported in 2018
select BrandName, count( MostRecentDateReported) as FrequencyOf2018Reports
from DonGeorge.dbo.ReviewedCC
where MostRecentDateReported between '2018-01-01' and '2018-12-31'
group by BrandName
order by count( MostRecentDateReported) desc

--5. brands that had chemicals removed and discontinued

select BrandName
from DonGeorge.dbo.ReviewedCC
where DiscontinuedDate is not null and ChemicalDateRemoved is not null
group by BrandName
order by BrandName

--6. period between the creation of removed chemicals and the date the chemicals were removed.

select ChemicalName, ChemicalCreatedAt, ChemicalDateRemoved, datediff( dd,ChemicalCreatedAt,ChemicalDateRemoved) as DaysBeforeChemicalRemoved 
from DonGeorge.dbo.ReviewedCC
where ChemicalCreatedAt is not null and ChemicalDateRemoved is not null
group by ChemicalName, ChemicalCreatedAt, ChemicalDateRemoved
order by datediff( dd,ChemicalCreatedAt,ChemicalDateRemoved) desc

-- 7.Tell if discontinued chemicals in bath products were removed
--still yet to figure it out. Check 

select PrimaryCategory, DiscontinuedDate, ChemicalDateRemoved,
case
	when ChemicalDateRemoved is not null then 'Removed'
	else 'Not Removed'
end
as 'Removed/Not Removed'
from DonGeorge.dbo.ReviewedCC
where PrimaryCategory = 'Bath Products'and DiscontinuedDate is not null 
group by PrimaryCategory, DiscontinuedDate , ChemicalDateRemoved
order by PrimaryCategory

--8. How long were removed chemicals in baby product used. use creation date as starting point

select PrimaryCategory, ChemicalCreatedAt, ChemicalDateRemoved, Datediff(dd,ChemicalCreatedAt,ChemicalDateRemoved) as DateDiffereence
from DonGeorge.dbo.ReviewedCC
where Primarycategory = 'Baby products' and ChemicalDateRemoved is not null
group by PrimaryCategory, ChemicalCreatedAt, ChemicalDateRemoved
order by Datediff(dd,ChemicalCreatedAt,ChemicalDateRemoved)desc

--9. identifying relationship between most recently reported chemicals and discontinued chemicals. 
--EG Did the most recently reported chemical equal to the discontinued chemicals?

select MostRecentDateReported, DiscontinuedDate, count (MostRecentDateReported) as NoOfMostRecentDadteReported, count(DiscontinuedDate) as NoOfDiscontinuedDate
from DonGeorge.dbo.ReviewedCC
where MostRecentDateReported is not null
group by MostRecentDateReported, DiscontinuedDate
order by  count(DiscontinuedDate) desc

--10. relationship between csf and chemicals used in the most manufactured subcategories.
-- tip:which chemicals gave a certain type of csf in subcategories


select distinct a.ChemicalName, b.CSF, b.SubCategory
from (DonGeorge.dbo.ReviewedCC a
inner join DonGeorge.dbo.ReviewedCC b on a.ChemicalName = b.ChemicalName)
where b.CSF is not null
group by a.ChemicalName, b.CSF, b.SubCategory

-- 11.Identify chemicals that are used in colognes

select distinct ChemicalName
from DonGeorge.dbo.ReviewedCC
where not SubCategory != 'Cologne'
group by ChemicalName
order by ChemicalName



