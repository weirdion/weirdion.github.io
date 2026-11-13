# Hugo binary to use. Override to match CI's pinned version
# (HUGO_VERSION in .github/workflows/deploy-gh-pages.yml), e.g.
#   make build HUGO=/path/to/hugo-0.167.0
HUGO ?= hugo

# Default target
all: build

# Build the site the way CI does (minus the CI-only baseURL/cacheDir)
build:
	$(HUGO) --gc --minify

# Serve the site locally
serve:
	$(HUGO) serve -D

# Clean the site
clean:
	rm -rf public

.PHONY: all build serve clean
