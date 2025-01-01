# Default target
all: install build

# Install dependencies
install:
	bundle install --path "vendor/bundle"

# Build the site
build:
	bundle exec jekyll build

# Serve the site locally
serve:
	bundle exec jekyll serve --watch

# Clean the site
clean:
	bundle exec jekyll clean
