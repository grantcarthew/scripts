#!/usr/bin/env bash

# AI Service Integration Module
# -----------------------------------------------------------------------------
# Provides unified AI service command generation with service class abstraction.
# Service classes: alpha (claude), beta (gemini), gamma (aichat)
# Model tiers: fast, mid, pro

MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${MODULES_DIR}/settings.sh"


function ai_get_command() {
  local service_class="${1}"
  local model_tier="${2}"
  local system_prompt_file="${3:-}"
  local prompt="${4:-}"

  # Validate required parameters
  if [[ -z "${service_class}" || -z "${model_tier}" ]]; then
    echo "ERROR: ai_get_command requires service_class and model_tier" >&2
    return 1
  fi

  # Get model from settings
  local model_key="AI_${service_class^^}_${model_tier^^}"
  local model
  model="$(settings_get "${model_key}")"

  if [[ -z "${model}" ]]; then
    echo "ERROR: No model configured for ${service_class} ${model_tier}. Run 'set-aiconfig' to configure." >&2
    return 1
  fi

  # Map service classes to actual services
  local actual_service=""
  case "${service_class}" in
    alpha) actual_service="claude" ;;
    beta) actual_service="gemini" ;;
    gamma) actual_service="aichat" ;;
    *)
      echo "ERROR: Invalid service_class '${service_class}'. Use alpha, beta, or gamma" >&2
      return 1
      ;;
  esac

  # Build the base command
  local command="${actual_service} --model ${model}"
  if [[ "${actual_service}" == "gemini" ]]; then
    command="${command} --include-directories ${HOME}/reference"
  fi

  # Add service-specific system prompt handling if provided
  if [[ -n "${system_prompt_file}" ]]; then
    # Read and properly escape the system prompt content
    local system_prompt_content
    system_prompt_content="$(cat "${system_prompt_file}")"
    # Escape single quotes in the content
    system_prompt_content="${system_prompt_content//\'/\'\\\'\'}"

    case "${actual_service}" in
      claude)
        command="${command} --append-system-prompt '${system_prompt_content}'"
        # Add permission mode for interactive usage
        command="${command} --permission-mode default"
        ;;
      gemini)
        command="GEMINI_SYSTEM_MD=\"${system_prompt_file}\" ${command} --approval-mode default --prompt-interactive"
        ;;
      aichat)
        command="${command} --prompt '${system_prompt_content}'"
        ;;
    esac
  fi

  # Add prompt if provided
  if [[ -n "${prompt}" ]]; then
    # Escape single quotes in the prompt
    local escaped_prompt="${prompt//\'/\'\\\'\'}"
    command="${command} '${escaped_prompt}'"
  fi

  printf "%s" "${command}"
}
