#!/usr/bin/env bash

# AI Service Integration Module
# -----------------------------------------------------------------------------
# Provides unified AI service command generation with service class abstraction.
# Service classes: alpha (claude), beta (gemini), gamma (aichat)
# Model tiers: fast, mid, pro

MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

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

  # Map service classes to actual services and models
  local actual_service=""
  local model=""

  case "${service_class}" in
    alpha) # claude
      actual_service="claude"
      case "${model_tier}" in
        fast) model="claude-3-haiku-20240307" ;;
        mid) model="claude-3-5-sonnet-20241022" ;;
        pro) model="claude-3-5-sonnet-20241022" ;;
        *) echo "ERROR: Invalid model_tier '${model_tier}' for alpha" >&2; return 1 ;;
      esac
      ;;
    beta) # gemini
      actual_service="gemini"
      case "${model_tier}" in
        fast) model="vertexai:gemini-2.5-flash-lite" ;;
        mid) model="vertexai:gemini-2.5-flash" ;;
        pro) model="vertexai:gemini-2.5-pro" ;;
        *) echo "ERROR: Invalid model_tier '${model_tier}' for beta" >&2; return 1 ;;
      esac
      ;;
    gamma) # aichat
      actual_service="aichat"
      case "${model_tier}" in
        fast) model="gpt-4o-mini" ;;
        mid) model="gpt-4o" ;;
        pro) model="gpt-4o" ;;
        *) echo "ERROR: Invalid model_tier '${model_tier}' for gamma" >&2; return 1 ;;
      esac
      ;;
    *)
      echo "ERROR: Invalid service_class '${service_class}'. Use alpha, beta, or gamma" >&2
      return 1
      ;;
  esac

  # Build the base command
  local command="${actual_service} --model ${model}"

  # Add service-specific system prompt handling if provided
  if [[ -n "${system_prompt_file}" ]]; then
    case "${actual_service}" in
      claude)
        command="${command} --append-system-prompt \"$(cat \"${system_prompt_file}\")\""
        # Add permission mode for interactive usage
        command="${command} --permission-mode acceptEdits"
        ;;
      gemini)
        command="GEMINI_SYSTEM_MD=\"${system_prompt_file}\" ${command} --approval-mode auto_edit --prompt-interactive"
        ;;
      aichat)
        command="${command} --system \"$(cat \"${system_prompt_file}\")\""
        ;;
    esac
  fi

  # Add prompt if provided
  if [[ -n "${prompt}" ]]; then
    command="${command} \"${prompt}\""
  fi

  printf "%s" "${command}"
}
