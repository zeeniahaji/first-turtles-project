#!/bin/bash

# Define JSON output file
OUTPUT_JSON="test_results.json"

# Initialize JSON structure
echo '{"tests": [' > $OUTPUT_JSON

# Extract all test result text files from Surefire Reports
for file in $(find uk.ac.kcl.inf.mdd1.turtles.tests/target/surefire-reports/ -name "*.txt"); do
    # Get test name from filename
    TEST_NAME=$(basename "$file" .txt)

    # Read the test summary line
    SUMMARY=$(grep "Tests run:" "$file")

    # Extract numbers using awk
    TOTAL_TESTS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $2}' | xargs)
    FAILURES=$(echo "$SUMMARY" | awk -F'[:,]' '{print $4}' | xargs)
    ERRORS=$(echo "$SUMMARY" | awk -F'[:,]' '{print $6}' | xargs)
    SKIPPED=$(echo "$SUMMARY" | awk -F'[:,]' '{print $8}' | xargs)

    # Start JSON object for this test
    echo '  {' >> $OUTPUT_JSON
    echo "    \"name\": \"$TEST_NAME\"," >> $OUTPUT_JSON
    echo "    \"total\": $TOTAL_TESTS," >> $OUTPUT_JSON
    echo "    \"failures\": $FAILURES," >> $OUTPUT_JSON
    echo "    \"errors\": $ERRORS," >> $OUTPUT_JSON
    echo "    \"skipped\": $SKIPPED," >> $OUTPUT_JSON
    echo '    "details": [' >> $OUTPUT_JSON

    # Extract failed test cases
    grep -A3 "FAILURE!" "$file" | while read -r line; do
        if [[ $line == *".xt:"* ]]; then
            TEST_CASE=$(echo "$line" | awk '{print $1}')
            ERROR_MESSAGE=$(grep -A2 "$TEST_CASE" "$file" | grep "ERROR:" | sed 's/ERROR://g' | xargs)
            echo '      {' >> $OUTPUT_JSON
            echo "        \"test\": \"$TEST_CASE\"," >> $OUTPUT_JSON
            echo "        \"status\": \"failed\"," >> $OUTPUT_JSON
            echo "        \"error\": \"$ERROR_MESSAGE\"" >> $OUTPUT_JSON
            echo '      },' >> $OUTPUT_JSON
        fi
    done

    # Remove trailing comma and close details array
    sed -i '$ s/,$//' $OUTPUT_JSON
    echo '    ]' >> $OUTPUT_JSON
    echo '  },' >> $OUTPUT_JSON
done

# Remove trailing comma and close JSON array
sed -i '$ s/,$//' $OUTPUT_JSON
echo ']}' >> $OUTPUT_JSON

# Print output JSON
cat $OUTPUT_JSON
