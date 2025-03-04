#!/bin/bash

# Path to the autograding log file (modify as needed)
LOG_PATH="autograding_log.txt"

# Check if the log file exists
if [[ ! -f "$LOG_PATH" ]]; then
  echo "Log file not found. Please ensure the autograder ran and created this file."
  exit 1
fi

# Process the log to extract passed and failed test feedback
echo "Processing feedback from the autograding log..."

# Look for 'Test Passed' and 'Test Failed' entries in the log and extract them
grep "Test Passed" $LOG_PATH > feedback.txt
grep "Test Failed" $LOG_PATH >> feedback.txt

# Link feedback to a specific panel (this is just an example; modify as needed)
echo "Linking feedback to xtext-grammar panel..." >> feedback.txt

# Save the processed feedback in a feedback folder
mkdir -p ./feedback  # Create the 'feedback' folder if it doesn't exist
mv feedback.txt ./feedback/processed_feedback.txt

# Optional: You can display a message to confirm
echo "Feedback processed and linked to the xtext-grammar panel."
