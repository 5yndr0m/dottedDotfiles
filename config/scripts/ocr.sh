#!/bin/bash

# Create temp file
temp_file=$(mktemp --suffix=.png)

# Take screenshot of selected area
grim -g "$(slurp)" "$temp_file"

# Check if screenshot was taken
if [ -f "$temp_file" ]; then
    # Run OCR and copy to clipboard
    tesseract "$temp_file" stdout | wl-copy

    # Get the text for notification (first 50 chars)
    ocr_text=$(tesseract "$temp_file" stdout 2>/dev/null | head -c 50)

    if [ -n "$ocr_text" ]; then
        notify-send "OCR Complete" "Text copied to clipboard: ${ocr_text}..."
    else
        notify-send "OCR Failed" "No text found in selected area"
    fi

    # Clean up
    rm "$temp_file"
else
    notify-send "OCR Failed" "No area selected"
fi
