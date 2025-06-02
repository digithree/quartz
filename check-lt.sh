#!/bin/bash

set -e

# Check that the 'languagetool' CLI is installed
if ! command -v languagetool > /dev/null 2>&1; then
  echo "Error: 'languagetool' command not found."
  echo "Install it with: brew install languagetool"
  exit 1
fi

# Check input file
if [ -z "$1" ]; then
  echo "Usage: $0 path/to/file.md"
  exit 1
fi

INPUT="$1"
BASENAME=$(basename "$INPUT")
BASENAME_NOEXT="${BASENAME%.*}"
OUTPUT_DIR="private"
OUTPUT_FILE="${OUTPUT_DIR}/${BASENAME_NOEXT}.log"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Clean input: remove code blocks and emoji (macOS-safe)
CLEANED=$(cat "$INPUT" \
  | sed '/^```/,/^```/d' \
  | perl -CSD -pe 's/[\x{1F600}-\x{1F64F}\x{1F300}-\x{1F5FF}\x{1F680}-\x{1F6FF}\x{2600}-\x{26FF}\x{2700}-\x{27BF}]//g')

# Run LanguageTool CLI
echo "$CLEANED" | languagetool --language en-GB - > "$OUTPUT_FILE"

echo "Grammar check complete. Output written to: $OUTPUT_FILE"
