# HEALTH DATA PREP SUMMARY

1. Exported health data from Ovuview to project folder on my PC.
    * Health data was exported in two batches based on two separate accounts with different overlapping date ranges. One export is referred to as "health_data_1" and the other "health_data_2" for this summary.

2. Cleaned and manipulated health data using Microsoft Excel.
    * Both health data files were opened side-by-side in separate Excel windows for initial cleaning to prepare for merge.
        * Deleted columns with private information or that were irrelevant.
        * Copied headers from "health_data_2" into a new row under the headers of "health_data_1".
        * Compared headers in a 3rd new row in "health_data_1" using formula: `=IF('Header_1' = 'Header_2', 1, 0)`, where 1 = headers match.
        * Rearranged and added columns to ensure homogeneous fields between datasets validated by output in row 3.
        * Deleted both newly created rows (row 2 and row 3) in "health_data_1."
        * Color-coded data to easily identify separate datasets after merge: "health_data_1" = orange, "health_data_2" = green.
            * This is important for identifying duplicates since there is an overlap in the date ranges.
        * Saved both "health_data_1" and "health_data_2" as .xlsx file types to retain a copy of each prepped before merge dataset.
        * Copied the green dataset from "health_data_2" and pasted it under the orange dataset in "health_data_1" to merge all health data.
        * Deleted the row of headers from the green dataset and closed "health_data_2."

3. Merged, scrubbed and prepared health data using Microsoft Excel.
    * Saved merged health data as "prepped_health_data.xlsx" in project folder and changed the name of the sheet to match file name.
    * Deleted duplicate dates after manually verifying merged records.
        * Added filters to headers, filtered by date oldest-to-newest, selected the two years of known overlap in filter.
        * Freezed top row and scrolled to overlapping date range, which was quickly noted due to alternating green and orange rows.
        * Deleted empty rows. As data entry switches from orange to green, copied missing data from orange rows to green rows and deleted the duplicate orange row.
            * There were less than 10 duplicate entries where manually moving information was required.
    * Verified no duplicate dates.
        * Method 1:
            * Inserted 'temp_col' with formula: `=IF(OR(('Date1'='Date2'-1),(NOT('Date1'='Date2'))), 1, 0)`.
            * `=SUM('temp_col')` should equal the total number of rows minus 1 (the last row will be zero).
            * Deleted 'temp_col'.
        * Method 2:
            * Inserted 'temp_col' with formula: `=IF(OR(('Date1'='Date2'-1),(NOT('Date1'='Date2'))), 1, 0)`.
            * Reapply filters to headers and filter 'temp_col' to only show rows with value '0'.
            * Deleted 'temp_col'.
    * Determined number of missing date ranges.
        * Inserted 'temp_col' with formula: `=IF(NOT('Date1'='Date2'-1), 1, 0)`.
            * `=SUM('temp_col')` = (the beginning of every missing date range) - 1 (subtract the last row).
                * Answer: 181
            * Deleted 'temp_col'.
    * Created new boolean column 'Noted_Nap' with formula: `=IF(ISNUMBER(SEARCH("nap", 'Note')), 1, 0)`.
    * Updated 'Workout' column to consider 'Exercise' column values as boolean (played with 3 methods).
        * Method 1:
            * Inserted 'temp_col' with formula: `=IF(ISBLANK(Exercise), “No”, “Yes”)`.
            * Inserted 'temp_col_2' with formula: `=IF(OR(ISBLANK(Exercise), ISBLANK(temp_col)), “No”, “Yes”)`.
            * Copied and pasted values only from 'temp_col_2' to 'Workout'.
            * Deleted 'temp_col' and 'temp_col_2'.
        * Method 2:
            * Inserted 'temp_col' with formula: `=IF(ISBLANK(Exercise), “No”, “Yes”)`.
            * Inserted 'temp_col_2' with formula: `=IF(ISBLANK(Workout), temp_col, Workout)`.
            * Copied and pasted values only from 'temp_col_2' to 'Workout'.
            * Deleted 'temp_col' and 'temp_col_2'.
        * Method 3:
            * Inserted 'temp_col' with formula: `=IF(AND(ISBLANK(Exercise), ISBLANK(Workout)), “No”, “Yes”)`.
            * Copied and pasted values only from 'temp_col' to 'Workout'.
            * Deleted 'temp_col'.

    * Merged 'Hallucination' column (boolean) with 'Hallucinated' column (non-boolean).
        * Filtered out *blanks* in 'Hallucinated' column.
        * Typed "Yes" in the 1st corresponding 'Hallucination' row.
        * Auto-filled down 'Hallucination' while still filtered to only copy to the relevant rows.
        * Removed filter from and deleted 'Hallucinated'.

    * Created new column 'Alcohol Consumed' to convert 'Alcoholic Drinks', 'Alcohol Consumption' and 'Ounces of Alcohol' values to boolean.
        * Filtered 'Alcoholic Drinks' to only display "None" values.
        * Selected and deleted extraneous "None" values from filtered data, (wanted "None" values to be *blank*).
        * Filtered 'Ounces of Alcohol' to only display 0 values.
        * Selected and deleted extraneous 0 values from filtered data, (wanted "0" values to be *blank*).
        * Filled 'Alcohol Consumed' with formula: `=IF(AND(ISBLANK(Alcoholic Drinks), ISBLANK(Alcohol Consumption), ISBLANK(Ounces of Alcohol)), "No", "Yes")`.
            * Alternative formula: `=IF(OR(NOT(ISBLANK(Alcoholic Drinks)), NOT(ISBLANK(Alcohol Consumption)), NOT(ISBLANK(Ounces of Alcohol))), "Yes", "No")`.
        * Copied and pasted values only from 'Alcohol Consumed' into 'Alcohol Consumed'.

4. Exported prepped health data as a single-sheet .csv file to project folder.

5. Imported .csv file into MySQL using table data import wizard for final prep and initial analysis.
    * See `prepped_health_data.sql` for detailed process.
    * See `initial_data_analysis.sql` for initial non-graphical analysis.

6. Exported finalized prepped health data as a .csv file to project folder.
    * Used `prepped_health_data.csv` for graphical analysis and visualizations.
