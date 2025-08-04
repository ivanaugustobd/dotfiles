# Aliases
alias y-mp3="yt-dlp --extract-audio --audio-format mp3 -o '%(title)s.%(ext)s'"
alias y-mp4="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'"

# Functions
mp4-to-mp3() {
  find -iname '*.mp4' -print0 |
    parallel -0 ffmpeg -y -i {} -vn {.}.mp3
}
