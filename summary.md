# SUMMARY

1. #### Exported data from the relevant apps and saved to my PC.
    * Health data was exported in two batches based on two separate accounts with different date ranges. One export is referred to as "health_data_1" and the other "health_data_2" for this summary.
2. #### Cleaned and manipulated data using Microsoft Excel.
    * Sleep data could not be opened in Excel due to its size. It was imported into MySQL to clean, manipulate and prep. 
        - See `prepped_sleep_data.sql` for detailed process.
    * Health data files were opened side-by-side in separate Excel windows for initial cleaning to merge.
        - Deleted columns with private information or that were irrelevant.
        - Copied headers from "health_data_2" in a new row under headers of "health_data_1"  
        - Compared headers in new row using formula: `=IF(Header_1 = Header_2, 1, 0)`, where 1 = headers match
        - Rearranged and added columns to ensure homogeneous datasets
        - Color-coded data to easily identify separate datasets after merge: "health_data_1" dataset = Orange, "health_data_2" dataset = Green
        - Copied Green dataset from "health_data_2" and pasted it under the Orange dataset in "health_data_1."
3. #### Merged and prepared health data for analysis in Excel. 
    * Updated 'Workout' column to consider 'Exercise' column values as boolean (played with 3 methods).
        - Method 1:
            - Created new column 'temp_col' with formula: `=IF(ISBLANK(Exercise), “No”, “Yes”)`.
            - Created new column 'temp_col_2' with formula: `=IF(OR(ISBLANK(Exercise), ISBLANK(temp_col)), “No”, “Yes”)`.
            - Copied and pasted values only from 'temp_col_2' to 'Workout'.
            - Deleted 'temp_col' and 'temp_col_2'.
        - Method 2:
            - Created new column 'temp_col' with formula: `=IF(ISBLANK(Exercise), “No”, “Yes”)`.
            - Created new column 'temp_col_2' with formula: `=IF(ISBLANK(Workout), temp_col, Workout)`.
            - Copied and pasted values only from 'temp_col_2' to 'Workout'.
            - Deleted 'temp_col' and 'temp_col_2'.
        - Method 3:
            - Created new column 'temp_col' with formula: `=IF(AND(ISBLANK(Exercise), ISBLANK(Workout)), “No”, “Yes”)`. -> *most efficient*
            - Copied and pasted values only from 'temp_col' to 'Workout'.
            - Deleted 'temp_col'. 
    * Merged 'Hallucination' column (boolean) with 'Hallucinated' column (non-boolean).
        - Filtered out *blanks* in 'Hallucinated' column.
        - Typed "Yes" in the 1st corresponding 'Hallucination' row.
        - Auto-filled down 'Hallucination' while still filtered to only copy to the relevant rows.
        - Removed filter from and deleted 'Hallucinated'
    * Created new column 'Alcohol Consumed' to convert 'Alcoholic Drinks', 'Alcohol Consumption' and 'Ounces of Alcohol' values to boolean.
        - Filtered 'Alcoholic Drinks' to only display "None" values
        - Selected and deleted extraneous "None" values from filtered data, (we want "None" values to be *blank*)
        - Filtered 'Ounces of Alcohol' to only display 0 values
        - Selected and deleted extraneous 0 values from filtered data, (we want "0" values to be *blank*)
        - Filled 'Alcohol Consumed' with formula: `=IF(AND(ISBLANK(Alcoholic Drinks), ISBLANK(Alcohol Consumption), ISBLANK(Ounces of Alcohol)), "No", "Yes")`.
            - Alternative formula: `=IF(OR(NOT(ISBLANK(Alcoholic Drinks)), NOT(ISBLANK(Alcohol Consumption)), NOT(ISBLANK(Ounces of Alcohol))), "Yes", "No")`.
        - Copied and pasted values only from 'Alcohol Consumed' into 'Alcohol Consumed'.
