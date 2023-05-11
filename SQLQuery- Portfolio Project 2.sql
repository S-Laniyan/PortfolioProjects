--CLEANING DATA IN SQL QUERIES

Select *
From NashvilleHousing

--STANDARDIZE DATE FORMAT

Select SaleDate, Convert(Date, SaleDate)
From NashvilleHousing

Update NashvilleHousing
Set SaleDate= Convert(Date, SaleDate)

--OR, if that does not work, first alter the table by adding a new column with the converted information

Alter Table NashvilleHousing
Add SaleDateConverted Date 

--Then update the new column 

Update NashvilleHousing
Set SaleDateConverted= Convert(Date, SaleDate) --or Cast(SaleDate as Date)


--POPULATE PROPERTY ADDRESS DATA- This is to add data to the cells in the PropertyAddress column that are null
--First, look at the table where PropertyAddress is null

Select *
from NashvilleHousing  
where propertyaddress is null


--Create a selfjoin. The ParcelID is not unique and is repeated in several places where the address is populated. 
--Hence, Join based on the parcel ID and also based on the uniqueness of the UniqueID 
--On the first part, it should show the ParcelID and the corresponding PropertyAddress
--on the second side, it will show the ParcelID it matched on and the null property address
--Then add the ISNULL function, which creates a new column. The ISNULL function is basically asking 1.) what do you want to check to see if it null? 2.) if it is null, what do you want to populate it with.

Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
from NashvilleHousing  A
Join NashvilleHousing  B
On A.ParcelID=B.ParcelID and 
A.UniqueID<>B.UniqueID 
where propertyAddressi is null

--Then Update the Table. Because we did a join, we have to update the table based on it alias

UPDATE A
set PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
from NashvilleHousing  A
Join NashvilleHousing  B
On A.ParcelID=B.ParcelID and 
A.UniqueID<>B.UniqueID 


--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

Select PropertyAddress
from NashvilleHousing  

--First, we determined what the common denominator is for the address (the comma) and this where we broke the address. 
--The substring has 3 arguments and is for extracting parts of the content of a column. 
--Argument 1- What column are we pulling data from? In this case 'PropertyAddress'
--Argument 2- Where do you want to start from, that is do you want to start from the first letter? In this case, starting from the first letter is represented with the number 1
--Argument 3- Where do you want the string to stop?
--Because the common denominator across all the data is the comma, we use the CHARINDEX function to identify the comma, add the column name to the CHARINDEX function  and then minus 1 to remove the comma
--Note that the CHARINDEX is not a value, it is a position, if you look at it alone, it will show the position of the ','. Which is why we were able to minus 1

Select PropertyAddress, Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
from NashvilleHousing

-- Here, we want to start in the position of the comma + 1 to draw out the data (City) after the comma.
--The CHARINDEX is the second argument and the LEN function (which basically tells the query to go all the way to the length of the data in the column) is the third argument

Select PropertyAddress, Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
from NashvilleHousing

--Then Alter and update the table

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress= Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255)


Update NashvilleHousing
Set PropertySplitCity= Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

select *
from NashvilleHousing  


--Cleaning the OwnerAddress Column Using ParseName

Select OwnerAddress
From NashvilleHousing 


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing


--Alter and Update Table

Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

Update NashvilleHousing
Set OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255)

Update NashvilleHousing
Set OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255)

Update NashvilleHousing
Set OwnerSplitState= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select *
from NashvilleHousing  


--CHANGE Y AND N TO YES AND NO IN SOLDASVACANT FIELD

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
from [NashvilleHousing ]
Group by SoldAsVacant
order by 2

--Using a Case Statement to change Y and N to Yes and No

Select SoldAsVacant, 
CASE
When SoldAsVacant= 'Y' Then 'Yes'
When SoldAsVacant= 'N' Then 'No'
Else SoldAsVacant
END As UpdatedSoldAsVacant
from [NashvilleHousing ]

--Update the column

Update [NashvilleHousing ]
Set SoldAsVacant= CASE
When SoldAsVacant= 'Y' Then 'Yes'
When SoldAsVacant= 'N' Then 'No'
Else SoldAsVacant
END

--REMOVE DUPLICATES

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
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From NashvilleHousing



-- DELETE UNUSED COLUMNS

Select *
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDateConverted


