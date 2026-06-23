_extract-files() {
  emulate -L zsh
  setopt local_options null_glob

  local pattern="$1"
  reply=( ${~pattern} )

  (( ${#reply} )) || {
    print "No ${pattern} files found."
    return 1
  }
}

extract-7z() {
  local -a files
  _extract-files '*.7z' || return
  files=( "${reply[@]}" )

  parallel '7z x -o{.} -- {}' ::: "${files[@]}"
}

extract-gz() {
  local -a files
  _extract-files '*.gz' || return
  files=( "${reply[@]}" )

  parallel '
    archive={}
    case "$archive" in
      *.tar.gz)
        out="${archive%.tar.gz}"
        mkdir -p -- "$out" && tar -xvzf "$archive" -C "$out"
        ;;
      *.tgz)
        out="${archive%.tgz}"
        mkdir -p -- "$out" && tar -xvzf "$archive" -C "$out"
        ;;
      *)
        gunzip -vk -- "$archive"
        ;;
    esac
  ' ::: "${files[@]}"
}

extract-rar() {
  local -a files
  _extract-files '*.rar' || return
  files=( "${reply[@]}" )

  parallel 'mkdir -p -- {.} && unrar x -- {} {.}/' ::: "${files[@]}"
}

extract-zip() {
  local -a files
  _extract-files '*.zip' || return
  files=( "${reply[@]}" )

  parallel 'unzip -- {} -d {.}' ::: "${files[@]}"
}
