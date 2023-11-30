#!/bin/bash

# PostCreateCommand script for devcontainer.json

# Git configuration
git config core.fileMode false
git config --global core.autocrlf input
git config pull.rebase false

# Change workspace owner from root
chown -R \"${USER:-$(id -un)}\"
