#!/usr/bin/env bash
set -euo pipefail

# RPI Workflow Scaffolder
# Creates a new .rpi/projects/NNNN-slug/research.md directory structure

title="${*}"

if [[ -z "$title" ]]; then
  echo 'Usage: bash .github/skills/rpi-workflow/scripts/rpi-new.sh "Project Title"' >&2
  exit 1
fi

rpi_root=".rpi"
projects_root="${rpi_root}/projects"

if [[ ! -d "$projects_root" ]]; then
  echo "Error: .rpi/projects directory not found at repository root." >&2
  exit 1
fi

# Find max prefix from existing NNNN- directories
max_prefix=0
prefix_regex='^([0-9]{4})-'

while IFS= read -r entry; do
  [[ -z "$entry" ]] && continue
  if [[ "$entry" =~ $prefix_regex ]]; then
    value="${BASH_REMATCH[1]}"
    # Remove leading zeros for arithmetic
    value=$((10#$value))
    if (( value > max_prefix )); then
      max_prefix=$value
    fi
  fi
done < <(find "$projects_root" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)

# Calculate next prefix
next_prefix=$(printf "%04d" $((max_prefix + 1)))

# Generate slug from title
# Convert to lowercase, replace non-alphanumeric with hyphens, trim leading/trailing hyphens
slug=$(echo "$title" | \
  tr '[:upper:]' '[:lower:]' | \
  sed -e 's/[^a-z0-9]/-/g' -e 's/^-\+//' -e 's/-\+$//' -e 's/-\+/-/g')

if [[ -z "$slug" ]]; then
  echo "Error: title produces an empty slug." >&2
  exit 1
fi

project_dir_name="${next_prefix}-${slug}"
project_dir="${projects_root}/${project_dir_name}"

if [[ -d "$project_dir" ]]; then
  echo "Error: ${project_dir_name} already exists." >&2
  exit 1
fi

mkdir -p "$project_dir"

# Render research.md from the shared template resource.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
research_template="${script_dir}/../resources/research-template.md"

if [[ ! -f "$research_template" ]]; then
  echo "Error: research template not found at ${research_template}" >&2
  exit 1
fi

{
  printf "# Research - %s\n\n" "$title"
  tail -n +2 "$research_template"
} > "${project_dir}/research.md"

echo "Created .rpi/projects/${project_dir_name}/research.md"
