#!/bin/bash

# Function to append contents of a Bash file to the rc file
append_to_rc() {
    local file="$1"
    local start_pattern="#--$file-start"
    local end_pattern="#--$file-end"

    # Check if the file exists
    if [ ! -f "$file" ]; then
        echo "Error: File $file not found."
        return
    fi

    sed -i -e "/$start_pattern/,/$end_pattern/d" "$RC_FILE"

    # Append start pattern
    echo "$start_pattern" >> "$RC_FILE"

    if [ "$(head -n 1 "$file")" = "#!/bin/bash" ]; then
        tail -n +2 "$file" >> "$RC_FILE"
    else
        cat "$file" >> "$RC_FILE"
    fi

    # Append end pattern
    echo "$end_pattern" >> "$RC_FILE"
}

# Check if the system is macOS or Linux
if [[ "$OSTYPE" == *"darwin"* ]]; then
    # System is macOS
    RC_FILE="$HOME/.zshrc"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # System is Linux
    RC_FILE="$HOME/.bashrc"
else
    echo "Unsupported operating system."
    exit 1
fi

# List of Bash files to append to the rc file
BASH_FILES=(
    "obsidian.sh"
    # Add more Bash files as needed
)

# Append contents of each Bash file to the rc file
for file in "${BASH_FILES[@]}"; do
    append_to_rc "$file"
done

echo "Setup complete."

