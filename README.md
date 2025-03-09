# Nashville Housing Data Cleaning with SQL

## Project Title: Nashville Housing Data Cleaning

## Project Description:

This project focuses on cleaning and preparing a raw dataset of Nashville housing data using SQL. The data, originally containing inconsistencies, null values, and formatting issues, has been processed to create a standardized and ready-to-analyze dataset. The queries perform various data cleaning tasks, including standardizing date formats, populating missing addresses, separating address components into individual columns, correcting inconsistent data entries, removing duplicate records, and deleting unnecessary columns.

## Technologies Used:

* **Microsoft SQL Server Management Studio (SSMS):** Used to execute and manage the SQL queries.
* **SQL (Structured Query Language):** The primary language used for data manipulation and cleaning.

## Installation Instructions:

### Prerequisites:

* Ensure you have Microsoft SQL Server installed and running.
* Install SQL Server Management Studio (SSMS) to interact with the SQL Server.

### Database Setup:

1. Open SSMS and connect to your SQL Server instance.
2. Create a new database. For example, name it `NashvilleHousingData`.
3. Import the Nashville housing data into a new table named `NashvilleHousings$`. You can import the data from a CSV or Excel file using the SQL Server Import and Export Wizard or by using the `BULK INSERT` command. Make sure the table structure matches the original data.

### Running the Queries:

1. Clone or download this repository to your local machine.
2. Open the `NashvilleHousingDataCleaning.sql` file in SSMS.
3. Ensure you are connected to the `NashvilleHousingData` database.
4. Execute the SQL queries in the order they appear in the file. Each section is commented to explain its purpose.

## Usage Examples:

The `NashvilleHousingDataCleaning.sql` file contains the following data cleaning operations:

* **Standardizing Date Format:** The `SaleDate` column is converted to a consistent `DATE` format.
* **Populating Property Address Data:** Missing `PropertyAddress` values are filled in by matching `ParcelID` values from other rows.
* **Separating Address Components:** * The `PropertyAddress` column is split into `PropertySplitAddress` and `PropertySplitCity` columns.
    * The `OwnerAddress` column is split into `OwnerSplitAddress`, `OwnerSplitCity`, and `OwnerSplitState`.
* **Standardizing "SoldAsVacant" Field:** The `SoldAsVacant` column is standardized to use "Yes" and "No" instead of "Y" and "N".
* **Removing Duplicate Records:** Duplicate rows are identified and removed using a Common Table Expression (CTE) and the `ROW_NUMBER()` function.
* **Deleting Unused Columns:** Columns like `OwnerAddress`, `TaxDistrict`, `PropertyAddress`, and `SaleDate` are removed after the necessary data transformations.

**Example Query (Standardizing Date):**

```sql
UPDATE NashvilleHousings$
SET SaleDate = CONVERT(DATE, SaleDate);

```
**Example Query (Removing Duplicates):**

```sql
WITH RowNumCTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
            ORDER BY
                UniqueID
        ) row_num
    FROM NashvilleHousings$
)
DELETE FROM RowNumCTE
WHERE row_num > 1;
```

## License Information:
This project is open-source and available for use under the MIT License. Feel free to use and modify the code as needed.

## Contact Information:

For questions or feedback, please contact:

Fareeha

fareeha.theanalyst@gmail.com

https://github.com/faririz2001

