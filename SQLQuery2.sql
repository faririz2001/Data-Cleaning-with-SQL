 
--cleaning data in sql queries

select *
from PortfolioProject1..NashvilleHousings$
	
--standadise the date format 

select SaleDate, convert (Date,SaleDate)
from PortfolioProject1..NashvilleHousings$

update NashvilleHousings$
set SaleDate = convert (Date,SaleDate)

-- populate property address 

select *
from PortfolioProject1..NashvilleHousings$
Where PropertyAddress is null 
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject1..NashvilleHousings$ a
join PortfolioProject1..NashvilleHousings$ b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null 

 update a 
 set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProject1..NashvilleHousings$ a
join PortfolioProject1..NashvilleHousings$ b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null 

 --breaking out addresses into individual columns (address,city,state)

 select PropertyAddress
from PortfolioProject1..NashvilleHousings$
Where PropertyAddress is null 
order by ParcelID

select
substring( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address 
,substring( PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress ))
from PortfolioProject1..NashvilleHousings$

alter table PortfolioProject1..NashvilleHousings$
add PropertySplitAddress nvarchar(255)

update PortfolioProject1..NashvilleHousings$
set PropertySplitAddress = substring( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table PortfolioProject1..NashvilleHousings$
add PropertySplitCity nvarchar(255)

update PortfolioProject1..NashvilleHousings$
set PropertySplitCity = substring( PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress ))

select *
from PortfolioProject1..NashvilleHousings$

select OwnerAddress
from PortfolioProject1..NashvilleHousings$


select 
PARSENAME(replace(OwnerAddress, ',' , '.' ), 1)
,PARSENAME(replace(OwnerAddress, ',' , '.' ), 2)
,PARSENAME(replace(OwnerAddress, ',' , '.' ), 3)
from PortfolioProject1..NashvilleHousings$

alter table PortfolioProject1..NashvilleHousings$
add OwnerSplitAddress nvarchar(255)

update PortfolioProject1..NashvilleHousings$
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',' , '.' ), 3)

alter table PortfolioProject1..NashvilleHousings$
add OwnerSplitCity nvarchar(255)

update PortfolioProject1..NashvilleHousings$
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',' , '.' ), 2)

alter table PortfolioProject1..NashvilleHousings$
add OwnerSplitState nvarchar(255)

update PortfolioProject1..NashvilleHousings$
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',' , '.' ), 1)

select *
from PortfolioProject1..NashvilleHousings$

--change y and n to yes and no in "Sold as vacant" field

select distinct(soldasvacant), count(soldasvacant) 
from PortfolioProject1..NashvilleHousings$
group by soldasvacant
order by 2

select soldasvacant
, case when soldasvacant = 'Y' then 'YES'
       when soldasvacant = 'N' then 'NO'
	   else soldasvacant
	   end
 from PortfolioProject1..NashvilleHousings$

 update PortfolioProject1..NashvilleHousings$
set soldasvacant = case when soldasvacant = 'Y' then 'YES'
       when soldasvacant = 'N' then 'NO'
	   else soldasvacant
	   end

--remove duplicates


with RowNumCte as(
select *,
ROW_NUMBER() over(
partition by ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by 
			 UniqueID
			 )row_num
from PortfolioProject1..NashvilleHousings$
--order by ParcelID
)
delete
from RowNumCte
where row_num > 1
--order by PropertyAddress

--delete unused colums 

select *
from PortfolioProject1..NashvilleHousings$

alter table PortfolioProject1..NashvilleHousings$
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject1..NashvilleHousings$
drop column SaleDate
 