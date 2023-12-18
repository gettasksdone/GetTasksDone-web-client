#!/bin/bash

# PostCreateCommand script for devcontainer.json

# Git configuration
git config --global --add safe.directory .
git config --global core.fileMode false
git config --global core.autocrlf true
git config --global pull.rebase false
git add --renormalize .
