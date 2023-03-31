--Cleaning data in SQL

SELECT * 
FROM Test..NashvilleHousing

--Standardize date

SELECT SaleDateConverted,  CAST(SaleDate as Date) -- CONVERT(Date,SaleDate)
FROM Test..NashvilleHousing

UPDATE NashvilleHousing 
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing 
SET SaleDateConverted  = CONVERT(Date,SaleDate)

--Populate Property Address Data


SELECT *
FROM Test..NashvilleHousing

--Where PropertyAddress is null
ORDER BY ParcelID

--SELECT a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) ISNULL(where to populate, from where/whatto populate)
--FROM Test..NashvilleHousing a
--JOIN Test..NashvilleHousing b
--	ON a.ParcelID=b.ParcelID
--	AND a.[UniqueID ]<>b.[UniqueID ]
--Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Test..NashvilleHousing a
JOIN Test..NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]


--Breaking out address into idv columns (Address, City, State)


SELECT PropertyAddress
FROM Test..NashvilleHousing
--ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address


FROM Test..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitAddress  = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitCity  = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

--owner address
SELECT owneraddress
FROM Test..NashvilleHousing

SELECT 
PARSENAME(REPLACE(owneraddress, ',', '.'),3),
PARSENAME(REPLACE(owneraddress, ',', '.'),2),
PARSENAME(REPLACE(owneraddress, ',', '.'),1)
FROM Test..NashvilleHousing 


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing 
SET OwnerSplitAddress  = PARSENAME(REPLACE(owneraddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing 
SET OwnerSplitCity  = PARSENAME(REPLACE(owneraddress, ',', '.'),2)


ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing 
SET OwnerSplitState  = PARSENAME(REPLACE(owneraddress, ',', '.'),1)


SELECT *
FROM NashvilleHousing

--Change Y and NI to Yes and No in 'Sold as Vacant' Field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing


UPDATE NashvilleHousing 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


--Remove Duplicates

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

FROM Test..NashvilleHousing
)

SELECT *
FROM RowNumCTE
WHERE row_num>1
ORDER BY PropertyAddress





SELECT *
FROM Test..NashvilleHousing

--Delete unused columns

SELECT *
FROM Test..NashvilleHousing

ALTER TABLE Test..NashvilleHousing
DROP COLUMN SaleDate