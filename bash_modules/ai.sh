#!/usr/bin/env bash

# AI Service Integration Module
# -----------------------------------------------------------------------------
# Provides unified AI service command generation with service class abstraction.
# Service classes: alpha (claude), beta (gemini), gamma (aichat)
# Model tiers: fast, mid, pro

MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

declare CLAUDE_MODEL_FAST="claude-3-5-haiku-latest"
declare CLAUDE_MODEL_MID="claude-sonnet-4@20250514"
declare CLAUDE_MODEL_PRO="claude-opus-4-1"
declare GEMINI_MODEL_FAST="vertexai:gemini-2.5-flash-lite"
declare GEMINI_MODEL_MID="vertexai:gemini-2.5-flash"
declare GEMINI_MODEL_PRO="vertexai:gemini-2.5-pro"


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
        fast) model="${CLAUDE_MODEL_FAST}" ;;
        mid) model="${CLAUDE_MODEL_MID}" ;;
        pro) model="${CLAUDE_MODEL_PRO}" ;;
        *) echo "ERROR: Invalid model_tier '${model_tier}' for alpha" >&2; return 1 ;;
      esac
      ;;
    beta) # gemini
      actual_service="gemini"
      case "${model_tier}" in
        fast) model="${GEMINI_MODEL_FAST}" ;;
        mid) model="${GEMINI_MODEL_MID}" ;;
        pro) model="${GEMINI_MODEL_PRO}" ;;
        *) echo "ERROR: Invalid model_tier '${model_tier}' for beta" >&2; return 1 ;;
      esac
      ;;
    gamma) # aichat
      actual_service="aichat"
      case "${model_tier}" in
        fast) model="${GEMINI_MODEL_FAST}" ;;
        mid) model="${GEMINI_MODEL_MID}" ;;
        pro) model="${GEMINI_MODEL_PRO}" ;;
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
    # Read and properly escape the system prompt content
    local system_prompt_content
    system_prompt_content="$(cat "${system_prompt_file}")"
    # Escape single quotes in the content
    system_prompt_content="${system_prompt_content//\'/\'\\\'\'}"

    case "${actual_service}" in
      claude)
        command="${command} --append-system-prompt '${system_prompt_content}'"
        # Add permission mode for interactive usage
        command="${command} --permission-mode acceptEdits"
        ;;
      gemini)
        command="GEMINI_SYSTEM_MD=\"${system_prompt_file}\" ${command} --approval-mode auto_edit --prompt-interactive"
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
