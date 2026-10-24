hugo := "$HOME/.local/bin/hugo"

# Start local dev server (includes draft posts)
dev:
    {{ hugo }} server -D

# Build site including drafts
build-drafts:
    {{ hugo }} --buildDrafts --minify --cleanDestinationDir

# Production build (excludes drafts)
build:
    {{ hugo }} --minify

local:
    just build-drafts
    just dev
