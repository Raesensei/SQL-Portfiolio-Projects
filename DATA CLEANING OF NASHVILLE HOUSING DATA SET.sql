

--Cleaning Data in SQL Queries

select *
From [Portfolio project]..Nashvillehousing$

 -- Standardize Date Format
 select SaleDate, CONVERT(Date, SaleDate)
from [Portfolio project]..Nashvillehousing$

UPDATE [Portfolio project]..[Nashvillehousing$]
SET SaleDate = CONVERT(Date, SaleDate);

-- Populate Property Address data

Select *
From [Portfolio project]..Nashvillehousing$
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio project]..Nashvillehousing$ a
JOIN [Portfolio project]..Nashvillehousing$ b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [Portfolio project]..Nashvillehousing$
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
--CHARINDEX(',', PropertyAddress)
From [Portfolio project]..Nashvillehousing$

ALTER TABLE [Portfolio project]..[Nashvillehousing$]
Add PropertySplitAddress Nvarchar(255);

Update [Portfolio project]..[Nashvillehousing$]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Portfolio project]..[Nashvillehousing$]
Add PropertySplitCity Nvarchar(255);

Update [Portfolio project]..[Nashvillehousing$]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Portfolio project]..[Nashvillehousing$]



ALTER TABLE [Portfolio project]..[Nashvillehousing$]
Add OwnerSplitAddress Nvarchar(255);

Update [Portfolio project]..[Nashvillehousing$]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Portfolio project]..[Nashvillehousing$]
Add OwnerSplitCity Nvarchar(255);

Update [Portfolio project]..[Nashvillehousing$]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Portfolio project]..[Nashvillehousing$]
Add OwnerSplitState Nvarchar(255);

Update [Portfolio project]..[Nashvillehousing$]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [Portfolio project]..[Nashvillehousing$]
order by 2, 3



-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio project]..[Nashvillehousing$]
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio project]..[Nashvillehousing$]


Update [Portfolio project]..[Nashvillehousing$]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




-- Removing Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Portfolio project]..[Nashvillehousing$]

)
SELECT *
--DELETE
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [Portfolio project]..[Nashvillehousing$]



-- Delete Unused Columns



Select *
From [Portfolio project]..[Nashvillehousing$]


ALTER TABLE [Portfolio project]..[Nashvillehousing$]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
































