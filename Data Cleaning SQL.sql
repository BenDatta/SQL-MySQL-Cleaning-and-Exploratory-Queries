Select * from dbo.Nashvilledb

-----------------------------------------------------------------------------------------------------

--Standardized Date Format

Select SaleDate, CONVERT(Date,SaleDATE) 
From dbo.Nashvilledb

Update dbo.Nashvilledb
Set SaleDate = CONVERT(Date,SaleDATE)

Alter table dbo.Nashvilledb
Add SaleDateConveetred Date;

Update dbo.Nashvilledb
Set SaleDateConverted=Convert(Date,SaleDate)

---------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

select * from dbo.Nashvilledb 
--where PropertyAddress is null
order by ParcelID 

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
from dbo.Nashvilledb a
join dbo.Nashvilledb b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress) 
from dbo.Nashvilledb a
join dbo.Nashvilledb b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null
--------------------------------------------------------------------------------------------------------
--Breaking out Address into individual columns(Address,City.State)

------------------------------------------------------------------------------------------------------

select * from dbo.Nashvilledb 
--where PropertyAddress is null
order by ParcelID 

select SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address
from dbo.Nashvilledb

alter table dbo.Nashvilledb  
add PropertySplitAdress Nvarchar(255);

update Nashvilledb
set PropertySplitAdress= SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1)

alter table dbo.Nashvilledb  
add PropertySplitCity Nvarchar(255);

update Nashvilledb
set PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

Select OwnerAddress from dbo.Nashvilledb

Select 
PARSENAME(Replace(OwnerAddress ,',' , '.'),3),
PARSENAME(replace(OwnerAddress ,',' , '.'),2), 
PARSENAME(replace(OwnerAddress ,',' , '.'),1) from dbo.Nashvilledb

alter table dbo.Nashvilledb  
add OwnerSplitState Nvarchar(255);

update Nashvilledb
set OwnerSplitState= PARSENAME(replace(OwnerAddress ,',' , '.'),2) 

alter table dbo.Nashvilledb  
add OwnerSplitCity Nvarchar(255);

update Nashvilledb
set OwnerSplitCity= PARSENAME(replace(OwnerAddress ,',' , '.'),2) 

alter table dbo.Nashvilledb  
add OwnerSplitAddress Nvarchar(255);

update Nashvilledb
set OwnerSplitAddress= PARSENAME(replace(OwnerAddress ,',' , '.'),1) 

select * from dbo.Nashvilledb

-------------------------------------------------------------------------------------------------------------------------

---Chnage Y and N to Yes and No in 'sold as vacant' field

select distinct(SoldAsVacant),count (SoldAsVacant)
from dbo.Nashvilledb
group by SoldAsVacant
order by 2

select SoldAsVacant ,Case when SoldAsVacant ='Y' then 'YES'
when SoldAsVacant= 'N' then 'No' 
Else SoldAsVacant
end
from dbo.Nashvilledb

update dbo.Nashvilledb
set SoldAsVacant = Case when SoldAsVacant ='Y' then 'YES'
when SoldAsVacant= 'N' then 'No' 
Else SoldAsVacant
end
from dbo.Nashvilledb

-------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE as(
select *, ROW_NUMBER() over(
    partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
Order by UniqueID
) row_num
from dbo.Nashvilledb
--order by ParcelID
)
delete 
from RowNumCTE
where row_num > 1
Order by PropertyAddress


---------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

Alter table dbo.Nashvilledb
Drop Column OwnerAddress,TaxDistrict,PropertyAddress

Alter table dbo.Nashvilledb
Drop Column SaleDate

select * from dbo.Nashvilledb

--------------------------------------------------------------------------------------------------------------------------------------