#!/usr/bin/env bash

# AI Service Integration Module
# -----------------------------------------------------------------------------
# Provides unified AI service command generation.
# Services: claude, gemini, aichat
# Model tiers: fast, mid, pro

MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${MODULES_DIR}/config.sh"
source "${MODULES_DIR}/utils.sh"

function ai_get_command() {
  local service="${1}"
  local model_tier="${2}"
  local system_prompt_file="${3:-}"
  local prompt="${4:-}"

  # Validate required parameters
  if [[ -z "${service}" || -z "${model_tier}" ]]; then
    echo "ERROR: ai_get_command requires service and model_tier" >&2
    return 1
  fi

  # Validate service
  case "${service}" in
    claude|gemini|aichat)
      ;;
    *)
      echo "ERROR: Invalid service '${service}'. Use claude, gemini, or aichat" >&2
      return 1
      ;;
  esac

  # Get model from settings
  local service_upper
  service_upper="$(to_upper "${service}")"
  local tier_upper
  tier_upper="$(to_upper "${model_tier}")"
  local model_key="AI_${service_upper}_${tier_upper}"
  
  local model
  model="$(config_get "${model_key}")"

  if [[ -z "${model}" ]]; then
    echo "ERROR: No model configured for ${service} ${model_tier}. Run 'set-aiconfig' to configure." >&2
    return 1
  fi

  # Build base command with service-specific defaults
  local command="${service} --model ${model}"
  local env_prefix=""

  case "${service}" in
    claude)
      command="${command} --permission-mode default"
      ;;
    gemini)
      command="${command} --include-directories ${HOME}/reference --approval-mode default --prompt-interactive"
      ;;
    aichat)
      # aichat has no default flags
      ;;
  esac

  # Define quoting variables for safe replacement
  local q="'"
  local escaped_q="'\\''"

  # Add service-specific system prompt handling if provided
  if [[ -n "${system_prompt_file}" ]]; then
    case "${service}" in
      claude)
        command="${command} --append-system-prompt-file '${system_prompt_file}'"
        ;;
      gemini)
        env_prefix="GEMINI_SYSTEM_MD=\"${system_prompt_file}\" "
        ;;
      aichat)
        local system_prompt_content
        system_prompt_content="$(cat "${system_prompt_file}")"
        system_prompt_content="${system_prompt_content//${q}/${escaped_q}}"
        command="${command} --prompt '${system_prompt_content}'"
        ;;
    esac
  fi

  # Add user prompt if provided
  if [[ -n "${prompt}" ]]; then
    local escaped_prompt="${prompt//${q}/${escaped_q}}"
    command="${command} '${escaped_prompt}'"
  fi

  printf "%s%s" "${env_prefix}" "${command}"
}
