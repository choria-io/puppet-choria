#!/bin/sh
for p in /usr/share/bash-completion /usr/local/etc/bash_completion.d; do
  if [ -d "$p" ]; then
    choria completion --bash > "$p/choria"
  fi
done
for p in /usr/share/zsh/vendor-completions /usr/local/share/zsh/site-functions; do
  if [ -d "$p" ]; then
    choria completion --zsh > "$p/_choria"
  fi
done
