# Copies piped input to the local clipboard using OSC 52.
# Requires a modern terminal (Ghostty, iTerm2, etc.).
mc() {
  # The 'cat' command here ensures that this function works correctly
  # with input from a pipe. base64 reads from stdin by default.
  local input
  input=$(cat)

  if [ -n "$TMUX" ]; then
    # If in tmux, wrap the OSC 52 sequence to pass through.
    printf '\ePtmux;\e\e]52;c;%s\a\e\\' "$(echo -n "$input" | base64 -w0)"
  else
    # Send the standard OSC 52 sequence.
    printf '\e]52;c;%s\a' "$(echo -n "$input" | base64 -w0)"
  fi
}
