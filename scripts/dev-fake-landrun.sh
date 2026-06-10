#!/usr/bin/env bash
set -euo pipefail

args=("$@")
i=0
while (( i < ${#args[@]} )); do
  case "${args[$i]}" in
    --best-effort|-ldd|-add-exec)
      ((i += 1))
      ;;
    --ro|--rw|--rwx|--rox|--env)
      ((i += 2))
      ;;
    --)
      ((i += 1))
      break
      ;;
    *)
      break
      ;;
  esac
done

if (( i >= ${#args[@]} )); then
  echo "dev-fake-landrun: no command found" >&2
  exit 127
fi

exec "${args[@]:$i}"
