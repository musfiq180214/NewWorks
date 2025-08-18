#!/bin/bash

# Check if feature name is provided
if [ -z "$1" ]; then
  echo "🚨 Please provide a feature name!"
  echo "Usage: ./generate_feature.sh <feature_name>"
  exit 1
fi

FEATURE_NAME=$1
FEATURE_PATH="lib/features/$FEATURE_NAME"

# Create the directory structure
mkdir -p $FEATURE_PATH/{data,domain,presentation,providers,widgets}

# Create basic files
touch $FEATURE_PATH/data/${FEATURE_NAME}_repository.dart
touch $FEATURE_PATH/domain/${FEATURE_NAME}_model.dart
touch $FEATURE_PATH/presentation/${FEATURE_NAME}_screen.dart
touch $FEATURE_PATH/providers/${FEATURE_NAME}_provider.dart

echo "✅ Feature '$FEATURE_NAME' structure created successfully!"