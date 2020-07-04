#!/usr/bin/env zsh
set -x
jekyll clean && jekyll build --drafts && jekyll serve --incremental --drafts
