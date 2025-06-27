#!/bin/bash

# BookPalm Test Runner
echo "🧪 Running tests..."

# Check Flutter
command -v flutter >/dev/null 2>&1 || { echo "❌ Flutter not found"; exit 1; }

# Run tests
flutter pub get && flutter test --concurrency=1

# Show result
[ $? -eq 0 ] && echo "✅ Tests passed" || echo "❌ Tests failed"
