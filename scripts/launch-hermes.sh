#!/usr/bin/env sh
set -eu

case "$0" in
  */*) script_dir=${0%/*} ;;
  *) script_dir=. ;;
esac

repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd -P)
context_file="$repo_root/.hermes.md"
hermes_bin="${HERMES_BIN:-hermes}"

if [ ! -f "$context_file" ]; then
  echo "Missing Hermes project context: $context_file" >&2
  exit 1
fi

if ! command -v "$hermes_bin" >/dev/null 2>&1; then
  printf '%s\n' \
    "Hermes was not found as \"$hermes_bin\"." \
    "" \
    "Install Hermes or set HERMES_BIN to the executable path, then rerun:" \
    "" \
    "  HERMES_BIN=/path/to/hermes $0" \
    "" \
    "This script launches from the repository root so Hermes loads" \
    ".hermes.md as project context before the first prompt." >&2
  exit 127
fi

cd "$repo_root"

printf '%s\n' \
  "Starting Hermes for Tent of Trials." \
  "Project context: .hermes.md" \
  "Validation rule: always run \"python3 build.py\" after changes and" \
  "include the generated diagnostic .logd artifact in the PR notes."

exec "$hermes_bin" "$@"
