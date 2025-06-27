# BookPalm Makefile
# Provides convenient commands for common development tasks

.PHONY: help test test-watch test-coverage test-verbose test-sequential clean deps

# Default target
help:
	@echo "BookPalm Development Commands"
	@echo ""
	@echo "Available targets:"
	@echo "  test           - Run all tests"
	@echo "  test-watch     - Run tests in watch mode"
	@echo "  test-coverage  - Run tests with coverage report"
	@echo "  test-verbose   - Run tests with verbose output"
	@echo "  test-sequential- Run tests sequentially (slower but more stable)"
	@echo "  test-fast      - Run tests with maximum concurrency"
	@echo "  deps           - Get Flutter dependencies"
	@echo "  clean          - Clean build artifacts"
	@echo "  format         - Format Dart code"
	@echo "  analyze        - Run static analysis"
	@echo ""
	@echo "Examples:"
	@echo "  make test                # Run all tests"
	@echo "  make test-coverage       # Run tests with coverage"
	@echo "  make test-watch          # Run tests in watch mode"

# Run all tests
test:
	@echo "🧪 Running all tests..."
	@flutter test --concurrency=1

# Run tests in watch mode
test-watch:
	@echo "👀 Running tests in watch mode..."
	@flutter test --watch

# Run tests with coverage
test-coverage:
	@echo "📊 Running tests with coverage..."
	@flutter test --coverage
	@echo "📈 Coverage report generated in coverage/"

# Run tests with verbose output
test-verbose:
	@echo "🔍 Running tests with verbose output..."
	@flutter test --concurrency=1 --verbose

# Run tests sequentially (most stable)
test-sequential:
	@echo "🐌 Running tests sequentially..."
	@flutter test --concurrency=1

# Run tests with maximum concurrency
test-fast:
	@echo "🚀 Running tests with maximum concurrency..."
	@flutter test --concurrency=4

# Get dependencies
deps:
	@echo "📦 Getting Flutter dependencies..."
	@flutter pub get

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	@flutter clean
	@flutter pub get

# Format code
format:
	@echo "✨ Formatting Dart code..."
	@dart format .

# Run static analysis
analyze:
	@echo "🔍 Running static analysis..."
	@flutter analyze

# Full check (analyze, format check, and test)
check: deps
	@echo "🔍 Running full code check..."
	@dart format --set-exit-if-changed .
	@flutter analyze
	@flutter test --concurrency=1

# Quick test for CI/CD
ci-test:
	@echo "🤖 Running CI tests..."
	@flutter pub get
	@flutter test --concurrency=1 --reporter=compact
