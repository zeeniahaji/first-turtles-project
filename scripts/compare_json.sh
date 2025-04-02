#!/bin/bash

# Define file paths
GENERATED_JSON="./artifacts/json-test-results.json"  # Path to the downloaded JSON from the artifact
EXPECTED_JSON="expected_output.json"  # Path to your expected output JSON file

# Use jq to compare the JSON files by sorting the keys
diff <(jq -S . "$GENERATED_JSON") <(jq -S . "$EXPECTED_JSON") > diff_output.txt

# Check if there are differences
if [ $? -eq 0 ]; then
  echo "The generated JSON matches the expected output!"
else
  echo "There are differences between the generated JSON and the expected output."
  echo "Check 'diff_output.txt' for details."
fi
