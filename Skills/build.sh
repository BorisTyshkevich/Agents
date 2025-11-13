#!/bin/bash

# Exit on error
set -e

echo "📦 Building artifact builder package..."

# Get the directory name for the zip file
REPO_NAME=$1
BUILD_DIR="build"
ZIP_NAME="${REPO_NAME}.zip"

# Create build directory if it doesn't exist
mkdir -p "$BUILD_DIR"

# Remove old zip if it exists
if [ -f "$BUILD_DIR/$ZIP_NAME" ]; then
  echo "🧹 Removing old build: $BUILD_DIR/$ZIP_NAME"
  rm "$BUILD_DIR/$ZIP_NAME"
fi

# Create zip excluding CLAUDE.md and scripts/openapi-spec.json
echo "🗜️  Creating zip archive (excluding CLAUDE.md and scripts/openapi-spec.json)..."
zip -r "$BUILD_DIR/$ZIP_NAME" $REPO_NAME \
  -x "*/.*" \
  -x "*/CLAUDE.md" \
  -x "*/AGENTS.md" \
  -x "*/README.md" \
  -x "*/examples/*" \
  -x "*/scripts/openapi-spec.json"

# Get file size
FILE_SIZE=$(du -h "$BUILD_DIR/$ZIP_NAME" | cut -f1)

echo "✅ Build complete!"
echo "📄 Output: $BUILD_DIR/$ZIP_NAME ($FILE_SIZE)"
#unzip -t  $BUILD_DIR/$ZIP_NAME