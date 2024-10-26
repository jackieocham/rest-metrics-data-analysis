# HEALTH DATA PREP SUMMARY

1. Exported health data from mobile application to project folder on my PC.
    * Health data was exported in two batches based on two separate accounts with different overlapping date ranges. One export is referred to as "health_data_1" and the other "health_data_2" for this summary.

2. Cleaned and manipulated both health data files side by side using Microsoft Excel.
    * Deleted columns with private information or that were irrelevant.
    * Copied headers from "health_data_2" into an inserted row 2 under the headers of "health_data_1".
    * Compared headers in inserted row 3 of "health_data_1" using formula: `=IF('Header_1' = 'Header_2', 1, 0)`, where 1 = headers match.
    * Rearranged and added columns to ensure homogeneous fields between datasets validated by output in row 3.
    * Deleted row 2 and row 3 in "health_data_1."
    * Color-coded data to easily identify separate datasets after merge: "health_data_1" = orange, "health_data_2" = green.
        * This allows for quick and accurate identifying of duplicates due to the overlap in the date ranges.
    * Saved "health_data_1" and "health_data_2" as .xlsx file types to retain a copy of each prepped dataset before merge.
    * Copied the green dataset from "health_data_2" and pasted it under the orange dataset in "health_data_1" to merge all health data.
    * Deleted the row of headers from the green dataset in "health_data_1" and closed "health_data_2."

3. Merged and scrubbed health data using Microsoft Excel.
    * Saved merged health data as "prepped_health_data.xlsx" and changed the name of the sheet to match file name.
    * Deleted duplicate record dates after manually verifying complete information transfer.
        * Added filters to headers, sorted dataset by 'Date' oldest-to-newest, selected the two years of known overlap in filter.
        * Freezed top row and scrolled to overlapping date range, which was quickly noted due to alternating green and orange rows.
        * Deleted empty rows.
        * Copied missing data from orange rows to green rows and deleted the duplicate orange row.
            * There were less than 10 duplicate entries where manual moving of information was required.
    * Verified no duplicate dates.
        * Method 1:
            * Inserted 'temp_col' with formula: `=IF(OR(('Date1'='Date2'-1),(NOT('Date1'='Date2'))), 1, 0)`.
            * `=SUM('temp_col')` should equal the total number of rows minus 1 (the last row will be zero).
            * Deleted 'temp_col'.
        * Method 2:
            * Inserted 'temp_col' with formula: `=IF(OR(('Date1'='Date2'-1),(NOT('Date1'='Date2'))), 1, 0)`.
            * Reapply filters to headers and filter 'temp_col' to only show rows with value '0'.
            * Deleted 'temp_col'.

4. Prepared and validated merged health data using Microsoft Excel.
    * Created new boolean column 'Noted_Nap' with formula: `=IF(ISNUMBER(SEARCH("nap", 'Note')), 1, 0)`.
    * Created new boolean column 'Noted_Dreams' with formula: `=IF(ISNUMBER(SEARCH("dream", 'Note')), 1, 0)`.
    * Created new boolean column 'Noted_Hallucination' with formula: `=IF(ISNUMBER(SEARCH("hallucin", 'Note')), 1, 0)`.
    * Created new boolean column 'Low_Energy' derived using categorical column 'Energy' with formula: `=IF(OR('Energy'="Low", 'Energy'="Medium"), 1, 0)`.
        * 'Energy' column category key: "None" = *blank* = 0; "High" = 0; "Low" = 1; "Medium" = 1.
        * Copied and pasted values only from 'Low_Energy' to 'Low_Energy'.
    * Updated 'Workout' column to boolean format and to merge categorical column 'Exercises' values.
        * Inserted 'temp_col' with formula: `=IF(OR(NOT(ISBLANK('Exercises'))), 'Workout' = "Yes"), 1, 0)`.
        * Copied and pasted values only from 'temp_col' to 'Workout'.
        * Deleted 'temp_col'.
    * Merged 'Hallucination' column (boolean) with 'Hallucinated' column (categorical).
        * Filtered out *blanks* in 'Hallucinated' column.
        * Typed "Yes" in the 1st corresponding 'Hallucination' row.
        * Auto-filled down 'Hallucination' while still filtered to only copy to the relevant rows.
        * Cleared filter and deleted 'Hallucinated'.
    * Created new boolean column 'Alcohol' to merge columns 'Drinks', 'Alcohol_Consumption' and 'Ounces_Alcohol' values.
        * Filtered categorical column 'Alcohol_Consumption' to only display value "None".
            * Selected and deleted extraneous "None" values from filtered data as "None" and *blanks* are redundant.
            * 'Alcohol_Consumption' values are now: "Low", "Medium", "High", *blanks*.
        * Changed filter on 'Alcohol_Consumption' to remove *blanks*.
            * Inserted dashes in corresponding blank cells of 'Ounces_Alcohol' while filtered as these are all instances where there *should* be a numerical value rather than a blank cell.
        * Cleared filters.
        * Filtered categorical column 'Drinks' to remove *blanks*.
            * Inserted dashes in corresponding blank cells of 'Ounces_Alcohol' while filtered as these are all instances where there *should* be a numerical value rather than a blank cell.
        * Cleared filters.
        * Filtered decimal column 'Ounces_Alcohol' to only display *blanks*.
            * Filled all cells with 0 as these are entries where no alcohol was logged.
            * Verified no entries in columns 'Drinks' and 'Alcohol_Consumption'.
        * Cleared filters.
        * Filled 'Alcohol' using formula: `=IF(NOT('Ounces_Alcohol'=0), 1, 0)`.
            * Verified accuracy by filtering 'Drinks', 'Alcohol_Consumption' and 'Ounces_Alcohol' to remove *blanks* and 0, respectively and ensuring the only value in 'Alcohol' was 1.
                * Cleared filters between each check and after all three checks.
        * Copied and pasted values only from 'Alcohol' into 'Alcohol'.
    * Created new boolean column 'Caffeine' to merge categorical columns 'Supplements' and 'Caffeine_Consumption' values.
        * Filled with formula: `=IF(OR(ISNUMBER(SEARCH("caffein", 'Supplements')), ISNUMBER(SEARCH("coffee", 'Supplements')), ISNUMBER(SEARCH("tea", 'Supplements')), NOT(ISBLANK('Caffeine_Consumption'))), 1, 0)`.
        * Copied and pasted values only from 'Caffeine' to 'Caffeine'.
    * Created new boolean column 'Treatment_1' with formula: `=IF(ISNUMBER(SEARCH("[med_name1]", 'Medication')), 1, 0)`.
        * Copied and pasted values only from 'Treatment_1' to 'Treatment_1'.
    * Created new boolean column 'Treatment_2' with formula: `=IF(ISNUMBER(SEARCH("[med_name2]", 'Medication')), 1, 0)`.
        * Copied and pasted values only from 'Treatment_1' to 'Treatment_2'.
    * Created new boolean column 'Treatment_3' with formula: `=IF(ISNUMBER(SEARCH("[med_name3]", 'Medication')), 1, 0)`.
        * Copied and pasted values only from 'Treatment_1' to 'Treatment_3'.
    * Created new boolean column 'Treatment_4' with formula: `=IF(ISNUMBER(SEARCH("[med_name4]", 'Medication')), 1, 0)`.
        * Copied and pasted values only from 'Treatment_1' to 'Treatment_4'.
    * Created new categorical column 'Treatment_Type'.
        * step i - Filtered 'Treatment_1' to only show values of 1.
        * step ii - Filled 'Treatment_Type' with value "T1" in corresponding rows.
        * step iii - Cleared filter.
        * Repeated steps i-iii for 'Treatment_2', 'Treatment_3', and 'Treatment_4'.
        * Filtered 'Treatment_Type' to only show *blanks* and filled all blank cells with "T0".
        * Cleared filter.
    * Created new column 'Treatment_0'.
        * Filtered 'Treatment_Type' to only show T0.
            * Filled 'Treatment_0' with 1 in corresponding rows.
        * Cleared filter.
        * Filtered 'Treatment_0' to only show *blanks*.
            * Filled all blank cells with 0.
        * Cleared filter.

5. Saved "prepped_health_data" sheet as `prepped_health_data.csv`.

6. Imported "prepped_health_data" into the same MySQL database as "prepped_sleep_data".
    * Executed additional prep and some initial analysis.
        * See file `prepped_health_data.sql`.

## Notes

### Preservation of old code after improved iteration

#### Reformating of 'Entry_Date' to match MySQL's format for DATE data type

    UPDATE prepped_health_data
    SET Entry_Date = CONVERT(
    CONCAT_WS("-", SUBSTRING_INDEX(Entry_Date, '/', -1), 
    SUBSTRING_INDEX(Entry_Date, '/', 1),
    SUBSTRING_INDEX(SUBSTRING_INDEX(Entry_Date, '/', -2), '/', 1)), DATE);

### Initial analysis performed in Microsoft Excel out of curiosity

#### Determined number of missing date ranges

    * Inserted 'temp_col' with formula: `=IF(NOT('Date1'='Date2'-1), 1, 0)`.
        * `=SUM('temp_col')` = (the beginning of every missing date range) - 1 (subtract the last row).
            * Answer: 181
        * Deleted 'temp_col'.
