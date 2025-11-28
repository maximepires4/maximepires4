#!/bin/bash

# Get the directory where the script is located to allow execution from anywhere
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Navigate to the script directory (cv-latex) where latexmkrc is located
cd "$SCRIPT_DIR" || {
  echo "Failed to enter directory $SCRIPT_DIR"
  exit 1
}

# Define directories and filenames
# Output dir matches what is defined in latexmkrc ($out_dir = 'output')
OUT_DIR="output"
ROOT_DIR=".."

# English CV configuration
EN_SRC="cv_en.tex"
EN_OUT="Resume_Maxime_Pires_AI_Engineer.pdf"

# French CV configuration
FR_SRC="cv_fr.tex"
FR_OUT="CV_Maxime_Pires_Ingenieur_IA.pdf"

echo "Building French CV..."
# We rely on local latexmkrc for settings (xelatex mode, output dir, etc.)
latexmk -interaction=nonstopmode "$FR_SRC"

if [ $? -eq 0 ]; then
  # Move the generated PDF from the output directory to the project root
  if [ -f "$OUT_DIR/${FR_SRC%.tex}.pdf" ]; then
    mv "$OUT_DIR/${FR_SRC%.tex}.pdf" "$ROOT_DIR/$FR_OUT"
    echo "Success: French CV created at $ROOT_DIR/$FR_OUT"
  else
    echo "Error: Output file $OUT_DIR/${FR_SRC%.tex}.pdf not found even though compilation seemed successful."
  fi
else
  echo "Error: Failed to build French CV"
fi

echo "--------------------------------------------------"

echo "Building English CV..."
latexmk -interaction=nonstopmode "$EN_SRC"

if [ $? -eq 0 ]; then
  if [ -f "$OUT_DIR/${EN_SRC%.tex}.pdf" ]; then
    mv "$OUT_DIR/${EN_SRC%.tex}.pdf" "$ROOT_DIR/$EN_OUT"
    echo "Success: English CV created at $ROOT_DIR/$EN_OUT"
  else
    echo "Error: Output file $OUT_DIR/${EN_SRC%.tex}.pdf not found."
  fi
else
  echo "Error: Failed to build English CV"
fi

echo "--------------------------------------------------"

# Clean up auxiliary files
echo "Cleaning up..."
latexmk -c

echo "Done."

