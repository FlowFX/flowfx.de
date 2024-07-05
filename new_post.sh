#!/bin/bash

# Prompt for input
read -p "Enter the title: " title

# Check if title is empty or just whitespace
if [[ -z "$title" || -z "$(echo $title | tr -d '[:space:]')" ]]; then
  echo "No valid title given. Aborting."
  exit 1
fi

read -p "Enter the category: " category
read -p "Enter tags (comma-separated): " tags_input

# Process title for filename
title_slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Get the current date
current_date=$(date +%Y-%m-%d)

# Create filename
filename="${current_date}_${title_slug}.md"

# Process tags
IFS=',' read -r -a tags_array <<< "$tags_input"

# Generate tags YAML
tags_yaml=""
for tag in "${tags_array[@]}"; do
  tags_yaml+="    - $(echo "$tag" | xargs)\n"
done

# Create file content
file_content=$(cat <<EOF
---
title: "$title"
taxonomies:
  tags:
$tags_yaml  categories:
    - $category
---


EOF
)

# Ensure the target directory exists
mkdir -p content/blog

# Write content to file
echo -e "$file_content" > "content/blog/$filename"

echo "File created: content/blog/$filename"
