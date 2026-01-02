#!/bin/bash
# Usage: bash package_lambda.sh

set -e

echo "Packaging Lambda function..."

# Navigate to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LAMBDA_MODULE="$PROJECT_ROOT/modules/lambda"

echo "Project root: $PROJECT_ROOT"
echo "Lambda module: $LAMBDA_MODULE"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
echo "Temporary directory: $TEMP_DIR"

# Copy lambda.py to temp directory
LAMBDA_SOURCE="$PROJECT_ROOT/aws/lambda.py"
if [ ! -f "$LAMBDA_SOURCE" ]; then
    echo "Error: lambda.py not found in aws folder"
    rm -rf "$TEMP_DIR"
    exit 1
fi

cp "$LAMBDA_SOURCE" "$TEMP_DIR/"
echo "[OK] Copied lambda.py"

# Create zip file
cd "$TEMP_DIR"
zip -q lambda_payload.zip lambda.py
echo "[OK] Created lambda_payload.zip"

# Move zip to lambda module
mkdir -p "$LAMBDA_MODULE"
mv lambda_payload.zip "$LAMBDA_MODULE/"
echo "[OK] Moved to $LAMBDA_MODULE/lambda_payload.zip"

# Cleanup
rm -rf "$TEMP_DIR"
echo "[OK] Cleaned up temporary files"

echo ""
echo "Lambda function packaged successfully!"
echo "Location: $LAMBDA_MODULE/lambda_payload.zip"
echo ""
echo "Next steps:"
echo "  cd $PROJECT_ROOT"
echo "  tofu init"
echo "  tofu plan"
echo "  tofu apply"
