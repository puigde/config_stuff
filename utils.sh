#!/bin/bash

setup_rc_file() {
    local rc_file
    local bash_files=("$@")

    case "$OSTYPE" in
        *"darwin"*)
            rc_file="$HOME/.zshrc"
            ;;
        "linux-gnu"*)
            rc_file="$HOME/.bashrc"
            ;;
        *)
            echo "Unsupported operating system." >&2
            exit 1
            ;;
    esac

    for file in "${bash_files[@]}"; do
        local start_pattern="#--$file-start"
        local end_pattern="#--$file-end"

        if [ ! -f "$file" ]; then
            echo "Error: File $file not found."
            continue
        fi

        sed -i -e "/$start_pattern/,/$end_pattern/d" "$rc_file"
        echo "$start_pattern" >> "$rc_file"

        if [ "$(head -n 1 "$file")" = "#!/bin/bash" ]; then
            tail -n +2 "$file" >> "$rc_file"
        else
            cat "$file" >> "$rc_file"
        fi

        echo "$end_pattern" >> "$rc_file"
    done

    echo "Setup complete. Updated $rc_file."
}

