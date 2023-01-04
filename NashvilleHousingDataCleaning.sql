-- Showing our data

select * from nashvillehousing n 

-- Standardizing Date Format

select SaleDate -- , convert(Date,SaleDate)
from nashvillehousing n 

-- update nashvillehousing 
-- set SaleDateC = convert(Date,SaleDate)

-- i did it in the extraction process so you can use the comments as a guide.
---------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address Data
select *  from nashvillehousing n 
-- where nullif(PropertyAddress ,'') is  null 
order by ParcelID  

select n.ParcelID, n.PropertyAddress,n2.ParcelID ,n2.PropertyAddress, IFNULL(nullif(n.PropertyAddress,''),nullif(n2.PropertyAddress,''))
from nashvillehousing n
join nashvillehousing n2 
	on n.ParcelID = n2.ParcelID 
	and n.UniqueID <> n2.UniqueID 
where nullif(n.PropertyAddress ,'') is null 

update nashvillehousing  n
join nashvillehousing n2
	on n.ParcelID = n2.ParcelID
	and n.UniqueID <> n2.UniqueID 
SET n.PropertyAddress = IFNULL(nullif(n.PropertyAddress,''),nullif(n2.PropertyAddress,''))
where
nullif(n.PropertyAddress ,'') is null

-- breaking out Address into individual Columns (Address, City, State)

select PropertyAddress  
from nashvillehousing 
-- where nullif(PropertyAddress ,'') is  null 
-- order by ParcelID  

select 
substring(PropertyAddress, 1, locate(',', PropertyAddress) -1 )  as  Address,
substring(PropertyAddress, locate(',', PropertyAddress) +1 , length (PropertyAddress))  as  Address
from nashvillehousing

alter table nashvillehousing 
add PropertySplitAddress nvarchar(255)


 update nashvillehousing 
 set PropertySplitAddress = substring(PropertyAddress, 1, locate(',', PropertyAddress) -1 )

 alter table nashvillehousing 
add PropertySplitCity Nvarchar(255)

update nashvillehousing  
set PropertySplitCity = substring(PropertyAddress, locate(',', PropertyAddress) +1 , length (PropertyAddress))


select * from nashvillehousing n 

select OwnerAddress
from nashvillehousing n 


select
substring_index(OwnerAddress,',',1),
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress , ',', 2), ',', -1),
SUBSTRING_INDEX(OwnerAddress, ',', -1)     
from nashvillehousing n  

alter table nashvillehousing 
add OwnerSplitAddress nvarchar(255)


 update nashvillehousing 
 set OwnerSplitAddress = substring_index(OwnerAddress,',',1)

 alter table nashvillehousing 
add OwnerSplitCity Nvarchar(255)

update nashvillehousing  
set OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress , ',', 2), ',', -1)

alter table nashvillehousing 
add OwnerSplitState nvarchar(255)


 update nashvillehousing 
 set OwnerSplitState = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress , ',', 3), ',', -1)
 
 
 
 -- Changing from y and n to Yes and no 
 
 select distinct  SoldAsVacant ,count(SoldAsVacant) 
 from nashvillehousing n 
group by SoldAsVacant 
order by 2


select SoldAsVacant,
CASE
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else  SoldAsVacant
END
from nashvillehousing n

update nashvillehousing 
set SoldAsVacant = CASE
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else  SoldAsVacant
END
-- And it workd gladdly








 -- Remove duplicates

with RowNumCTE as (
select *,
row_number() over(
	partition by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
		order by  UniqueID	
			 
				) row_num
				
 from nashvillehousing n 
-- order by ParcelID 
)

delete   from RowNumCTE
where row_num > 1
-- order by PropertyAddress


