#!/usr/bin/env bash

# AI Module for Bash Scripts
# -------------------------------
# Handy functions to interact with AI services for generating reviews, summaries, or other text-based outputs.

# Environment setup
BASH_MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

# Model Ids
# -----------------------------------------------------------------------------
export AI_MODEL_FAST="vertexai:gemini-2.5-flash-lite"
export AI_MODEL_PRO="vertexai:gemini-2.5-pro"
