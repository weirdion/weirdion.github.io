# Default target
all: build

# Build the site
build:
	hugo

# Serve the site locally
serve:
	hugo serve -D

# Clean the site
clean:
	rm -rf public
