# Enable syntax highlighting (needs package "source-highlight" installed)
if [ -e /usr/bin/src-hilite-lesspipe.sh ]; then
  export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
  export LESS=' -R '
fi
