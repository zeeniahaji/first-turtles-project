#PREVIOUS WORKING SCRIPT 

# #!/bin/bash

# # Read mapping file
# MAPPING_FILE="feedback-mapping.json"

# # Check if mapping file exists
# if [[ ! -f "$MAPPING_FILE" ]]; then
#     echo "❌ Mapping file not found!"
#     exit 1
# fi

# # Extract the correct file for "edit-grammar"
# TARGET_FILE=$(jq -r '.["edit-grammar"]' $MAPPING_FILE)

# # Check if the target file exists
# if [[ ! -f "$TARGET_FILE" ]]; then
#     echo "❌ Target file ($TARGET_FILE) not found!"
#     exit 1
# fi

# # Simulate parsing logs and writing feedback to the correct file
# echo "✅ Linking feedback to $TARGET_FILE"
# echo "Feedback goes here..." >> "$TARGET_FILE"

# echo "✅ Feedback successfully linked!"




#!/bin/bash

# Path to feedback-mapping.json (activity-to-file mapping)
MAPPING_FILE="./feedback-mapping.json"
ACTIVITY_JSON="./activity.json"  # Contains panel mappings to activities
LOG_FILE="test_results.log"  # Name of the log file

# Initialize an empty array for test mappings
test_mappings=()

# Check if the test log file exists
if [ ! -f "$LOG_FILE" ]; then
  echo "Error: $LOG_FILE not found. Please ensure that the test results log file is generated before running the script."
  exit 1
fi

# Function to parse each line in the test log
parse_log() {
  while IFS= read -r line; do
    # Example: Check if line contains test result info (e.g., MoveTest)
    echo "Processing line: $line"  # Debugging line
    if [[ $line =~ (MoveTest|Turn\ Test|Mixed\ Test)\ \[([A-Za-z]+)\] ]]; then
      test_name="${BASH_REMATCH[1]}"  # e.g., MoveTest
      test_status="${BASH_REMATCH[2]}"  # PASSED or FAILED
      test_output=$(extract_output "$line")  # Function to clean up the output
      echo "Test found: $test_name, Status: $test_status"  # Debugging line

      # Get the file and panel associated with this activity
      activity="edit-grammar"  # Example, you may want to map based on some condition
      file_path=$(get_file_for_activity "$activity")
      panel=$(get_panel_for_activity "$activity")

      echo "File: $file_path, Panel: $panel"  # Debugging line

      # Construct the test mapping (test -> file)
      test_mapping="{\"test\": \"$test_name\", \"status\": \"$test_status\", \"output\": \"$test_output\"}"
      test_mappings+=("$test_mapping")
    fi
  done < "$LOG_FILE"
}

# Function to extract the relevant output from the log line
extract_output() {
  # This function would clean and extract the relevant output (no warnings or unnecessary info)
  echo "Cleaned output from test log"
}

# Function to get the file associated with a given activity (using activity.json)
get_file_for_activity() {
  activity=$1
  # Read the mapping from activity.json
  file_path=$(jq -r --arg activity "$activity" '.activities[] | select(.id == $activity) | .panels[] | select(.id == "panel-xtext") | .file' "$ACTIVITY_JSON")
  
  if [ "$file_path" == "null" ]; then
    echo "Unknown File"
  else
    echo "$file_path"
  fi
}

# Function to get the panel associated with a given activity (using activity.json)
get_panel_for_activity() {
  activity=$1
  # Read the panel mapping from activity.json
  panel=$(jq -r --arg activity "$activity" '.activities[] | select(.id == $activity) | .panels[] | select(.id == "panel-xtext") | .id' "$ACTIVITY_JSON")
  
  if [ "$panel" == "null" ]; then
    echo "Unknown Panel"
  else
    echo "$panel"
  fi
}

# Main execution flow
# Parse the log file if it exists
parse_log "$LOG_FILE"

# Generate the feedback-mapping.json file
echo "[" > feedback-mapping.json
echo "{ \"file\": \"$file_path\", \"activity\": \"$activity\", \"panel\": \"$panel\", \"tests\": [" >> feedback-mapping.json
for mapping in "${test_mappings[@]}"; do
  echo "$mapping," >> feedback-mapping.json
done
# Remove the last comma and close the JSON structure
sed -i '$ s/,$//' feedback-mapping.json
echo "]}" >> feedback-mapping.json
echo "]" >> feedback-mapping.json

echo "Feedback mapping generated successfully!"
