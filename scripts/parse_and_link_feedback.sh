#!/bin/bash

# Read mapping file
MAPPING_FILE="feedback-mapping.json"

# Check if mapping file exists
if [[ ! -f "$MAPPING_FILE" ]]; then
    echo "❌ Mapping file not found!"
    exit 1
fi

# Extract the correct file for "edit-grammar"
TARGET_FILE=$(jq -r '.["edit-grammar"]' $MAPPING_FILE)

# Check if the target file exists
if [[ ! -f "$TARGET_FILE" ]]; then
    echo "❌ Target file ($TARGET_FILE) not found!"
    exit 1
fi

# Simulate parsing logs and writing feedback to the correct file
echo "✅ Linking feedback to $TARGET_FILE"
echo "Feedback goes here..." >> "$TARGET_FILE"

echo "✅ Feedback successfully linked!"
