Select *
From [Portfolio Project].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)
Select *
From [Portfolio Project].dbo.NashvilleHousing


--Filling up address with same Parcel Id

Select *
From [Portfolio Project].dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


Select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS Null

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS Null

SELECT PropertyAddress
FROM NashvilleHousing

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1 ) AS Address

, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress)) AS Address

FROM NashvilleHousing


ALTER TABLE NashvilleHousing
Add Propertysplitaddress Nvarchar(255);

Update NashvilleHousing
SET Propertysplitaddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1 ) 



Select 
PARSENAME(REPLACE(Owneraddress,',','.'),3),
PARSENAME(REPLACE(Owneraddress,',','.'),2),
PARSENAME(REPLACE(Owneraddress,',','.'),1)
From [Portfolio Project].dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add Ownersplitaddress Nvarchar(255);

Update NashvilleHousing
SET Ownersplitaddress = PARSENAME(REPLACE(Owneraddress,',','.'),3)


ALTER TABLE NashvilleHousing
Add ownersplitcity Nvarchar(255);

Update NashvilleHousing
SET ownersplitcity = PARSENAME(REPLACE(Owneraddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add ownersplitstate Nvarchar(255);

Update NashvilleHousing
SET ownersplitstate = PARSENAME(REPLACE(Owneraddress,',','.'),1)


--UPDATING SOLDASVACANT

Select SoldAsVacant,
CASE WHEN SoldAsVacant ='Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END
From [Portfolio Project].dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant= CASE WHEN SoldAsVacant ='Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END
Select DISTINCT(SoldAsVacant)
From [Portfolio Project].dbo.NashvilleHousing


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

From NashvilleHousing
--order by ParcelID
)

DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY Propertyaddress


--DELETING UNUSED COLOUMNS

SELECT *
From [Portfolio Project].dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate