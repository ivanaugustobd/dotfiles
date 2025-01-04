extract-7z() {
  parallel 7z x -o{.} {} ::: *.7z
}
