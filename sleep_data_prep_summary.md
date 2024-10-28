# SLEEP DATA PREP SUMMARY

1. Exported sleep data from mobile application to project folder on my PC.
    * Referred to app documentation to figure out csv file organization, headers and header descriptions.

2. Cleaned, manipulated and prepared sleep data using MySQL.
    * Sleep data could not be reasonably manipulated in Excel due to number of fields and organization of data.
    * See `prepped_sleep_data.sql` for detailed process. This code has been tested multiple times as new sleep data is exported monthly to keep my analysis up-to-date.
    * Alternative methods mentioned in step 6 of `prepped_sleep_data.sql` are as follows:

    ```sql
    /* 6. Reformatted 'Bed_Time', 'Wake_Time' and 'Next_Alarm' entries to match correct format for the DATETIME data type in MySQL.
          
        METHOD 1: Manually
        * Incorrect DATETIME format: "DD. MM. YYYY [h]h:mm".
        * Correct DATETIME format: "YYYY-MM-DD hh:mm:ss".

        * Concatenated the pulled pieces of the the date and time to each other in the correct order including the missing pieces.
          - Pulled 'YYYY' string from Q1 using SUBSTRING_INDEX(Q1, ' ', 1).
          - Q1 = SUBSTRING_INDEX(col_name, ' ', -2) = 'YYYY [h]h:mm'.

          - Pulled 'MM' string from Q2 using SUBSTRING_INDEX(Q2, ' ', -1).
          - Q2 = SUBSTRING_INDEX(col_name, '.', 2) = 'DD. MM'.

          - Pulled 'DD' string from 'DD. MM. YYYY [h]h:mm' using SUBSTRING(col_name, 1, 2).
          - Returns a string of 2 length, starting at the 1st position in 'col_name'.

        * Concatenation continues to the resolution of the conditional function IF.
          - If the length of the indexed substring Q3 is less than the expected length("hh:mm") = 5
            - Condition if true: concatenate to '0' to Q3.
            - Condition if false: concatenate Q3.
              - Q3 = SUBSTRING_INDEX(col_name, ' ', -1) = '[h]h:mm'.

        * Concatenation finalized with ":00" to account for the missing ':ss' in the incorrect format.

        * Verified all records were in the proper format by counting where length = 19
          - LENGTH("YYYY-MM-DD hh:mm:ss") = 19.  
          - There are 2286 rows of data and count is 2286 where the string = 19 so manual reformat worked. */

    UPDATE my_table
    SET col_name = CONCAT(
      SUBSTRING_INDEX(SUBSTRING_INDEX(col_name, ' ', -2), ' ', 1),
      "-", 
      SUBSTRING_INDEX(SUBSTRING_INDEX(col_name, '.', 2), ' ', -1),
      "-", 
      SUBSTRING(col_name, 1, 2),
      " ",
      IF(
        LENGTH(SUBSTRING_INDEX(col_name, ' ', -1)) < 5, CONCAT("0", SUBSTRING_INDEX(col_name, ' ', -1)), 
        SUBSTRING_INDEX(col_name, ' ', -1)
        ),
      ":00"
      );

    SELECT COUNT(col_name)
    FROM my_table
    WHERE LENGTH(col_name) = LENGTH("YYYY-MM-DD hh:mm:ss");
    ```

    ```sql
    /*  METHOD 2: using built-in function CONVERT
        * Simplified reformatting process by using the CONVERT function to auto-add the missing zeros instead of using IF
        function and concatenating zeros.
          - Concatenation of the re-ordering of pulled pieces (as described in Method 1) and "-"s still required.*/

    UPDATE my_table
    SET col_name = CONVERT(
      CONCAT(
        SUBSTRING_INDEX(SUBSTRING_INDEX(col_name, ' ', -2), ' ', 1),
        "-", 
        SUBSTRING_INDEX(SUBSTRING_INDEX(col_name, '.', 2), ' ', -1),
        "-", 
        SUBSTRING(col_name, 1, 2),
        " ", 
        SUBSTRING_INDEX(col_name, ' ', -1)
        ), 
      DATETIME
      );
    ```

3. Performed initial analysis in MySQL on prepped sleep data to validate data quality and answer general questions to prepare for creating visualizations.
    * See `initial_data_analysis.sql` for detailed process.
