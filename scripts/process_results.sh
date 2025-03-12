# #!/bin/bash

# # Define JSON output file
# OUTPUT_JSON="test_results.json"

# # Initialize JSON structure
# echo '{"tests": [' > $OUTPUT_JSON

# # Extract all test result text files from Surefire Reports
# for file in $(find uk.ac.kcl.inf.mdd1.turtles.tests/target/surefire-reports/ -name "*.txt"); do
#     # Get test name from filename
#     TEST_NAME=$(basename "$file" .txt)

#     # Read the test summary line
#     SUMMARY=$(grep "Tests run:" "$file")

#     # Extract numbers using awk
#     TOTAL_TESTS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $2}' | xargs)
#     FAILURES=$(echo "$SUMMARY" | awk -F'[:,]' '{print $4}' | xargs)
#     ERRORS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $6}' | xargs)
#     SKIPPED=$(echo "$SUMMARY" | awk -F'[:,]' '{print $8}' | xargs)

#     # Start JSON object for this test
#     echo '  {' >> $OUTPUT_JSON
#     echo "    \"name\": \"$TEST_NAME\"," >> $OUTPUT_JSON
#     echo "    \"total\": $TOTAL_TESTS," >> $OUTPUT_JSON
#     echo "    \"failures\": $FAILURES," >> $OUTPUT_JSON
#     echo "    \"errors\": $ERRORS," >> $OUTPUT_JSON
#     echo "    \"skipped\": $SKIPPED," >> $OUTPUT_JSON
#     echo '    "details": [' >> $OUTPUT_JSON

#     # Extract failed test cases
#     grep -A3 "FAILURE!" "$file" | while read -r line; do
#         if [[ $line == *".xt:"* ]]; then
#             TEST_CASE=$(echo "$line" | awk '{print $1}')
#             ERROR_MESSAGE=$(grep -A2 "$TEST_CASE" "$file" | grep "ERROR:" | sed 's/ERROR://g' | xargs)
#             echo '      {' >> $OUTPUT_JSON
#             echo "        \"test\": \"$TEST_CASE\"," >> $OUTPUT_JSON
#             echo "        \"status\": \"failed\"," >> $OUTPUT_JSON
#             echo "        \"error\": \"$ERROR_MESSAGE\"" >> $OUTPUT_JSON
#             echo '      },' >> $OUTPUT_JSON
#         fi
#     done

#     # Remove trailing comma and close details array
#     sed -i '$ s/,$//' $OUTPUT_JSON
#     echo '    ]' >> $OUTPUT_JSON
#     echo '  },' >> $OUTPUT_JSON
# done

# # Remove trailing comma and close JSON array
# sed -i '$ s/,$//' $OUTPUT_JSON
# echo ']}' >> $OUTPUT_JSON

# # Print output JSON
# cat $OUTPUT_JSON


# #!/bin/bash

# # Define output JSON file
# OUTPUT_JSON="test_results.json"

# # Initialize JSON structure
# echo "[" > $OUTPUT_JSON

# FIRST=true

# # Loop through all text report files
# for file in uk.ac.kcl.inf.mdd1.turtles.tests/target/surefire-reports/*.txt; do
#     if [ -f "$file" ]; then
#         if [ "$FIRST" = true ]; then
#             FIRST=false
#         else
#             echo "," >> $OUTPUT_JSON
#         fi
        
#         # Extract test name
#         TEST_NAME=$(grep -oP '(?<=Test set: ).*' "$file")

#         # Extract summary (Tests run, Failures, Errors)
#         SUMMARY=$(grep -oP 'Tests run: \d+, Failures: \d+, Errors: \d+' "$file")

#         # Extract full error details
#         ERROR_DETAILS=$(awk '/ERROR:/{flag=1} flag' "$file")

#         # Format as JSON
#         echo "  {" >> $OUTPUT_JSON
#         echo "    \"test\": \"$TEST_NAME\"," >> $OUTPUT_JSON
#         echo "    \"summary\": \"$SUMMARY\"," >> $OUTPUT_JSON
#         echo "    \"details\": \"$(echo "$ERROR_DETAILS" | sed 's/"/\\"/g' | tr '\n' ' ' | sed 's/  / /g')\"" >> $OUTPUT_JSON
#         echo "  }" >> $OUTPUT_JSON
#     fi
# done

# # Close JSON array
# echo "]" >> $OUTPUT_JSON

# echo "JSON test results saved to $OUTPUT_JSON"

#PREVIOUS WORKING WORKFLOW 

# #!/bin/bash

# # Define JSON output file
# OUTPUT_JSON="test_results.json"

# # Initialize JSON structure
# echo '{"tests": [' > $OUTPUT_JSON

# FIRST=true

# # Loop through all test report text files
# for file in $(find uk.ac.kcl.inf.mdd1.turtles.tests/target/surefire-reports/ -name "*.txt"); do
#     if [ -f "$file" ]; then
#         if [ "$FIRST" = true ]; then
#             FIRST=false
#         else
#             echo "," >> $OUTPUT_JSON
#         fi

#         # Extract test suite name
#         TEST_NAME=$(grep -oP '(?<=Test set: ).*' "$file")

#         # Extract test summary
#         SUMMARY=$(grep -oP 'Tests run: \d+, Failures: \d+, Errors: \d+' "$file")

#         # Extract individual test counts
#         TOTAL_TESTS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $2}' | xargs)
#         FAILURES=$(echo "$SUMMARY" | awk -F'[:,]' '{print $4}' | xargs)
#         ERRORS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $6}' | xargs)
#         SKIPPED=$(echo "$SUMMARY" | awk -F'[:,]' '{print $8}' | xargs)

#         # Start JSON object for this test suite
#         echo "  {" >> $OUTPUT_JSON
#         echo "    \"name\": \"$TEST_NAME\"," >> $OUTPUT_JSON
#         echo "    \"total\": $TOTAL_TESTS," >> $OUTPUT_JSON
#         echo "    \"failures\": $FAILURES," >> $OUTPUT_JSON
#         echo "    \"errors\": $ERRORS," >> $OUTPUT_JSON
#         echo "    \"skipped\": $SKIPPED," >> $OUTPUT_JSON
#         echo '    "details": [' >> $OUTPUT_JSON

#         FIRST_DETAIL=true

#         # Extract failed test cases and errors
#         while IFS= read -r line; do
#             if [[ "$line" == *".xt:"* ]]; then
#                 if [ "$FIRST_DETAIL" = true ]; then
#                     FIRST_DETAIL=false
#                 else
#                     echo "," >> $OUTPUT_JSON
#                 fi

#                 TEST_CASE=$(echo "$line" | awk '{print $1}')
                
#                 # Extract full error message from the ERROR section
#                 ERROR_MESSAGE=$(awk "/$TEST_CASE/,/^$/" "$file" | grep -A5 "ERROR:" | sed 's/ERROR://g' | tr '\n' ' ' | sed 's/  / /g' | xargs)

#                 echo "      {" >> $OUTPUT_JSON
#                 echo "        \"test\": \"$TEST_CASE\"," >> $OUTPUT_JSON
#                 echo "        \"status\": \"failed\"," >> $OUTPUT_JSON
#                 echo "        \"error\": \"$ERROR_MESSAGE\"" >> $OUTPUT_JSON
#                 echo "      }" >> $OUTPUT_JSON
#             fi
#         done < <(grep -A3 "FAILURE!" "$file")

#         # Close details array
#         echo "    ]" >> $OUTPUT_JSON
#         echo "  }" >> $OUTPUT_JSON
#     fi
# done

# # Close JSON structure
# echo "]}" >> $OUTPUT_JSON

# echo "JSON test results saved to $OUTPUT_JSON"


#PREVIOUS WORKING WORKFLOW 

# #!/bin/bash

# # Define JSON output file
# OUTPUT_JSON="test_results.json"

# # Initialize JSON structure
# echo '{"tests": [' > $OUTPUT_JSON

# FIRST=true

# # Loop through all test report text files
# for file in $(find uk.ac.kcl.inf.mdd1.turtles.tests/target/surefire-reports/ -name "*.txt"); do
#     if [ -f "$file" ]; then
#         if [ "$FIRST" = true ]; then
#             FIRST=false
#         else
#             echo "," >> $OUTPUT_JSON
#         fi

#         # Extract test suite name
#         TEST_NAME=$(grep -oP '(?<=Test set: ).*' "$file")

#         # Extract test summary
#         SUMMARY=$(grep -oP 'Tests run: \d+, Failures: \d+, Errors: \d+' "$file")

#         # Extract individual test counts
#         TOTAL_TESTS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $2}' | xargs)
#         FAILURES=$(echo "$SUMMARY" | awk -F'[:,]' '{print $4}' | xargs)
#         ERRORS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $6}' | xargs)
#         SKIPPED=$(echo "$SUMMARY" | awk -F'[:,]' '{print $8}' | xargs)

#         # If SKIPPED is empty, set it to null
#         if [ -z "$SKIPPED" ]; then
#             SKIPPED=null
#         fi

#         # Start JSON object for this test suite
#         echo "  {" >> $OUTPUT_JSON
#         echo "    \"name\": \"$TEST_NAME\"," >> $OUTPUT_JSON
#         echo "    \"total\": $TOTAL_TESTS," >> $OUTPUT_JSON
#         echo "    \"failures\": $FAILURES," >> $OUTPUT_JSON
#         echo "    \"errors\": $ERRORS," >> $OUTPUT_JSON
#         echo "    \"skipped\": $SKIPPED," >> $OUTPUT_JSON
#         echo '    "details": [' >> $OUTPUT_JSON

#         FIRST_DETAIL=true

#         # Extract failed test cases and errors
#         while IFS= read -r line; do
#             if [[ "$line" == *".xt:"* ]]; then
#                 if [ "$FIRST_DETAIL" = true ]; then
#                     FIRST_DETAIL=false
#                 else
#                     echo "," >> $OUTPUT_JSON
#                 fi

#                 TEST_CASE=$(echo "$line" | awk '{print $1}')
                
#                 # Extract full error message from the ERROR section
#                 ERROR_MESSAGE=$(awk "/$TEST_CASE/,/^$/" "$file" | grep -A5 "ERROR:" | sed 's/ERROR://g' | tr '\n' ' ' | sed 's/  / /g' | xargs)

#                 # Escape error message to make it safe for JSON
#                 ERROR_MESSAGE=$(echo "$ERROR_MESSAGE" | sed 's/"/\\"/g' | sed 's/\n/\\n/g')

#                 echo "      {" >> $OUTPUT_JSON
#                 echo "        \"test\": \"$TEST_CASE\"," >> $OUTPUT_JSON
#                 echo "        \"status\": \"failed\"," >> $OUTPUT_JSON
#                 echo "        \"error\": \"$ERROR_MESSAGE\"" >> $OUTPUT_JSON
#                 echo "      }" >> $OUTPUT_JSON
#             fi
#         done < <(grep -A3 "FAILURE!" "$file")

#         # Close details array
#         echo "    ]" >> $OUTPUT_JSON
#         echo "  }" >> $OUTPUT_JSON
#     fi
# done

# # Close JSON structure
# echo "]}" >> $OUTPUT_JSON

# echo "JSON test results saved to $OUTPUT_JSON"


# #!/bin/bash

# # Define JSON output file
# OUTPUT_JSON="test_results.json"

# # Initialize JSON structure
# echo '{"tests": [' > $OUTPUT_JSON

# FIRST=true

# # Loop through all test report text files
# for file in $(find uk.ac.kcl.inf.mdd1.turtles.tests/target/surefire-reports/ -name "*.txt"); do
#     if [ -f "$file" ]; then
#         if [ "$FIRST" = true ]; then
#             FIRST=false
#         else
#             echo "," >> $OUTPUT_JSON
#         fi

#         # Extract test suite name
#         TEST_NAME=$(grep -oP '(?<=Test set: ).*' "$file")

#         # Extract test summary
#         SUMMARY=$(grep -oP 'Tests run: \d+, Failures: \d+, Errors: \d+' "$file")

#         # Extract individual test counts
#         TOTAL_TESTS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $2}' | xargs)
#         FAILURES=$(echo "$SUMMARY" | awk -F'[:,]' '{print $4}' | xargs)
#         ERRORS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $6}' | xargs)
#         SKIPPED=$(echo "$SUMMARY" | awk -F'[:,]' '{print $8}' | xargs)

#         # Ensure skipped tests are set to a valid number (default to 0 if empty)
#         if [ -z "$SKIPPED" ]; then
#             SKIPPED=0
#         fi

#         # Start JSON object for this test suite
#         echo "  {" >> $OUTPUT_JSON
#         echo "    \"name\": \"$TEST_NAME\"," >> $OUTPUT_JSON
#         echo "    \"total\": $TOTAL_TESTS," >> $OUTPUT_JSON
#         echo "    \"failures\": $FAILURES," >> $OUTPUT_JSON
#         echo "    \"errors\": $ERRORS," >> $OUTPUT_JSON
#         echo "    \"skipped\": $SKIPPED," >> $OUTPUT_JSON
#         echo '    "details": [' >> $OUTPUT_JSON

#         FIRST_DETAIL=true

#         # Extract failed test cases and errors
#         while IFS= read -r line; do
#             if [[ "$line" == *".xt:"* ]]; then
#                 if [ "$FIRST_DETAIL" = true ]; then
#                     FIRST_DETAIL=false
#                 else
#                     echo "," >> $OUTPUT_JSON
#                 fi

#                 TEST_CASE=$(echo "$line" | awk '{print $1}')
                
#                 # Extract full error message (ensures multi-line errors are captured)
#                 ERROR_MESSAGE=$(sed -n "/$TEST_CASE/,/^$/"p "$file" | sed 's/ERROR://g' | tr '\n' ' ' | sed 's/  / /g' | xargs)

#                 # Debugging output (remove this after confirming it works)
#                 echo "Extracted Error for $TEST_CASE: $ERROR_MESSAGE"

#                 echo "      {" >> $OUTPUT_JSON
#                 echo "        \"test\": \"$TEST_CASE\"," >> $OUTPUT_JSON
#                 echo "        \"status\": \"failed\"," >> $OUTPUT_JSON
#                 echo "        \"error\": \"$ERROR_MESSAGE\"" >> $OUTPUT_JSON
#                 echo "      }" >> $OUTPUT_JSON
#             fi
#         done < <(grep -A3 "FAILURE!" "$file")

#         # Close details array
#         echo "    ]" >> $OUTPUT_JSON
#         echo "  }" >> $OUTPUT_JSON
#     fi
# done

# # Close JSON structure
# echo "]}" >> $OUTPUT_JSON

# echo "JSON test results saved to $OUTPUT_JSON"





# #!/bin/bash

# # Define JSON output file
# OUTPUT_JSON="test_results.json"

# # Initialize JSON structure
# echo '{"tests": [' > $OUTPUT_JSON

# FIRST=true

# # Loop through all test report text files
# for file in $(find uk.ac.kcl.inf.mdd1.turtles.tests/target/surefire-reports/ -name "*.txt"); do
#     if [ -f "$file" ]; then
#         if [ "$FIRST" = true ]; then
#             FIRST=false
#         else
#             echo "," >> $OUTPUT_JSON
#         fi

#         # Extract test suite name
#         TEST_NAME=$(grep -oP '(?<=Test set: ).*' "$file")

#         # Extract test summary
#         SUMMARY=$(grep -oP 'Tests run: \d+, Failures: \d+, Errors: \d+' "$file")

#         # Extract individual test counts
#         TOTAL_TESTS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $2}' | xargs)
#         FAILURES=$(echo "$SUMMARY" | awk -F'[:,]' '{print $4}' | xargs)
#         ERRORS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $6}' | xargs)
#         SKIPPED=$(echo "$SUMMARY" | awk -F'[:,]' '{print $8}' | xargs)

#         # Ensure skipped tests are set to a valid number (default to 0 if empty)
#         if [ -z "$SKIPPED" ]; then
#             SKIPPED=0
#         fi

#         # Start JSON object for this test suite
#         echo "  {" >> $OUTPUT_JSON
#         echo "    \"name\": \"$TEST_NAME\"," >> $OUTPUT_JSON
#         echo "    \"total\": $TOTAL_TESTS," >> $OUTPUT_JSON
#         echo "    \"failures\": $FAILURES," >> $OUTPUT_JSON
#         echo "    \"errors\": $ERRORS," >> $OUTPUT_JSON
#         echo "    \"skipped\": $SKIPPED," >> $OUTPUT_JSON
#         echo '    "details": [' >> $OUTPUT_JSON

#         FIRST_DETAIL=true

#         # Extract failed test cases and errors
#         while IFS= read -r line; do
#             if [[ "$line" == *".xt:"* ]]; then
#                 if [ "$FIRST_DETAIL" = true ]; then
#                     FIRST_DETAIL=false
#                 else
#                     echo "," >> $OUTPUT_JSON
#                 fi

#                 TEST_CASE=$(echo "$line" | awk '{print $1}')
                
#                 # Extract full error message (ensures multi-line errors are captured)
#                 ERROR_MESSAGE=$(sed -n "/$TEST_CASE/,/^$/p" "$file" | sed 's/ERROR://g' | tr '\n' ' ' | sed 's/  / /g' | xargs)

#                 echo "      {" >> $OUTPUT_JSON
#                 echo "        \"test\": \"$TEST_CASE\"," >> $OUTPUT_JSON
#                 echo "        \"status\": \"failed\"," >> $OUTPUT_JSON
#                 echo "        \"error\": \"$ERROR_MESSAGE\"" >> $OUTPUT_JSON
#                 echo "      }" >> $OUTPUT_JSON
#             fi
#         done < <(grep -A3 "FAILURE!" "$file")

#         # Extract passed test cases
#         if [ "$FAILURES" -eq 0 ] && [ "$ERRORS" -eq 0 ]; then
#             while IFS= read -r line; do
#                 if [[ "$line" == *".xt:"* ]]; then
#                     if [ "$FIRST_DETAIL" = true ]; then
#                         FIRST_DETAIL=false
#                     else
#                         echo "," >> $OUTPUT_JSON
#                     fi
#                     TEST_CASE=$(echo "$line" | awk '{print $1}')
#                     echo "      {" >> $OUTPUT_JSON
#                     echo "        \"test\": \"$TEST_CASE\"," >> $OUTPUT_JSON
#                     echo "        \"status\": \"passed\"" >> $OUTPUT_JSON
#                     echo "      }" >> $OUTPUT_JSON
#                 fi
#             done < "$file"
#         fi

#         # Close details array
#         echo "    ]" >> $OUTPUT_JSON
#         echo "  }" >> $OUTPUT_JSON
#     fi

# done

# # Close JSON structure
# echo "]}" >> $OUTPUT_JSON

# echo "JSON test results saved to $OUTPUT_JSON"




#!/bin/bash

# Define JSON output file
OUTPUT_JSON="test_results.json"

# Initialize JSON structure
echo '{"tests": [' > $OUTPUT_JSON

FIRST=true

# Parse the feedback-mapping.json to get the file
FEEDBACK_FILE=$(jq -r '.[0].file' feedback-mapping.json)

# Parse activity.json to get the panel that displays the file
PANEL_ID=$(jq -r --arg FEEDBACK_FILE "$FEEDBACK_FILE" '.activities[].panels[] | select(.file == $FEEDBACK_FILE) | .id' activity.json)

# Ensure a panel was found for the file
if [ -z "$PANEL_ID" ]; then
  echo "Error: No panel found for file $FEEDBACK_FILE in activity.json"
  exit 1
fi

echo "Panel ID for file $FEEDBACK_FILE is $PANEL_ID"

# Loop through all test report text files
for file in $(find uk.ac.kcl.inf.mdd1.turtles.tests/target/surefire-reports/ -name "*.txt"); do
    if [ -f "$file" ]; then
        if [ "$FIRST" = true ]; then
            FIRST=false
        else
            echo "," >> $OUTPUT_JSON
        fi

        # Extract test suite name
        TEST_NAME=$(grep -oP '(?<=Test set: ).*' "$file")

        # Extract test summary
        SUMMARY=$(grep -oP 'Tests run: \d+, Failures: \d+, Errors: \d+' "$file")

        # Extract individual test counts
        TOTAL_TESTS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $2}' | xargs)
        FAILURES=$(echo "$SUMMARY" | awk -F'[:,]' '{print $4}' | xargs)
        ERRORS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $6}' | xargs)
        SKIPPED=$(echo "$SUMMARY" | awk -F'[:,]' '{print $8}' | xargs)

        # Ensure skipped tests are set to a valid number (default to 0 if empty)
        if [ -z "$SKIPPED" ]; then
            SKIPPED=0
        fi

        # Start JSON object for this test suite
        echo "  {" >> $OUTPUT_JSON
        echo "    \"name\": \"$TEST_NAME\"," >> $OUTPUT_JSON
        echo "    \"total\": $TOTAL_TESTS," >> $OUTPUT_JSON
        echo "    \"failures\": $FAILURES," >> $OUTPUT_JSON
        echo "    \"errors\": $ERRORS," >> $OUTPUT_JSON
        echo "    \"skipped\": $SKIPPED," >> $OUTPUT_JSON
        echo '    "details": [' >> $OUTPUT_JSON

        FIRST_DETAIL=true

        # Extract failed test cases and errors
        while IFS= read -r line; do
            if [[ "$line" == *".xt:"* ]]; then
                if [ "$FIRST_DETAIL" = true ]; then
                    FIRST_DETAIL=false
                else
                    echo "," >> $OUTPUT_JSON
                fi

                TEST_CASE=$(echo "$line" | awk '{print $1}')
                
                # Extract full error message (ensures multi-line errors are captured)
                ERROR_MESSAGE=$(sed -n "/$TEST_CASE/,/^$/p" "$file" | sed 's/ERROR://g' | tr '\n' ' ' | sed 's/  / /g' | xargs)

                echo "      {" >> $OUTPUT_JSON
                echo "        \"test\": \"$TEST_CASE\"," >> $OUTPUT_JSON
                echo "        \"status\": \"failed\"," >> $OUTPUT_JSON
                echo "        \"linked-panel\": \"$PANEL_ID\"," >> $OUTPUT_JSON
                echo "        \"error\": \"$ERROR_MESSAGE\"" >> $OUTPUT_JSON
                echo "      }" >> $OUTPUT_JSON
            fi
        done < <(grep -A3 "FAILURE!" "$file")

        # Extract passed test cases
        if [ "$FAILURES" -eq 0 ] && [ "$ERRORS" -eq 0 ]; then
            while IFS= read -r line; do
                if [[ "$line" == *".xt:"* ]]; then
                    if [ "$FIRST_DETAIL" = true ]; then
                        FIRST_DETAIL=false
                    else
                        echo "," >> $OUTPUT_JSON
                    fi
                    TEST_CASE=$(echo "$line" | awk '{print $1}')
                    echo "      {" >> $OUTPUT_JSON
                    echo "        \"test\": \"$TEST_CASE\"," >> $OUTPUT_JSON
                    echo "        \"status\": \"passed\"," >> $OUTPUT_JSON
                    echo "        \"linked-panel\": \"$PANEL_ID\"" >> $OUTPUT_JSON
                    echo "      }" >> $OUTPUT_JSON
                fi
            done < "$file"
        fi

        # Close details array
        echo "    ]" >> $OUTPUT_JSON
        echo "  }" >> $OUTPUT_JSON
    fi

done

# Close JSON structure
echo "]}" >> $OUTPUT_JSON

echo "JSON test results saved to $OUTPUT_JSON"
