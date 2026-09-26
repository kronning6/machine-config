#!/usr/bin/env bash

set -euo pipefail

if ! command -v aws >/dev/null 2>&1; then
  echo "AWS CLI is not installed or is not available on PATH." >&2
  exit 1
fi

profile_exists() {
  local profile="$1"
  local configured_profile

  while IFS= read -r configured_profile; do
    if [ "$configured_profile" = "$profile" ]; then
      return 0
    fi
  done < <(aws configure list-profiles)

  return 1
}

confirm() {
  local prompt="$1"
  local response

  read -r -p "${prompt} [y/N] " response
  case "$response" in
    y | Y | yes | YES | Yes) return 0 ;;
    *) return 1 ;;
  esac
}

setup_sso_profile() {
  local profile

  read -r -p "SSO profile name: " profile
  if [ -z "$profile" ]; then
    echo "Profile name cannot be empty."
    return
  fi

  if profile_exists "$profile"; then
    echo "AWS profile '${profile}' is already configured."
  else
    echo "Configuring AWS SSO profile '${profile}'."
    aws configure sso --profile "$profile"
  fi

  aws sso login --profile "$profile"
  aws sts get-caller-identity --profile "$profile"
}

setup_credentials_profile() {
  local profile

  read -r -p "Profile name: " profile
  if [ -z "$profile" ]; then
    echo "Profile name cannot be empty."
    return
  fi

  if profile_exists "$profile" && ! confirm "Profile '${profile}' already exists. Reconfigure it?"; then
    echo "Profile '${profile}' was not changed."
    return
  fi

  aws configure --profile "$profile"
  echo "Configured credential-based profile '${profile}'."
  echo "Verify it with: aws sts get-caller-identity --profile ${profile}"
}

while true; do
  printf '\nAWS CLI setup\n'
  printf '1. Configure or log in to an SSO profile\n'
  printf '2. Configure a credential-based profile\n'
  printf '3. Exit\n'

  if ! read -r -p "Select an option: " choice; then
    printf '\n'
    exit 0
  fi

  case "$choice" in
    1) setup_sso_profile ;;
    2) setup_credentials_profile ;;
    3 | q | Q) exit 0 ;;
    *) echo "Invalid option: $choice" ;;
  esac
done
