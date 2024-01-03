# Aliases
alias y-mp3="yt-dlp --extract-audio --audio-format mp3 -o '%(title)s.%(ext)s'"
alias y-mp4="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'"

# Functions
mp4-to-mp3() {
  for FILE in *.mp4; do
    ffmpeg -y -i $FILE -vn ${FILE%.*}.mp3
  done
}

y-playlist-to-mp3() {
  PLAYLIST_NAME=$(yt-dlp --no-warnings --dump-single-json $1 | jq -r '.title')
  mkdir "$PLAYLIST_NAME"
  cd "$PLAYLIST_NAME"
  yt-dlp --extract-audio --audio-format mp3 $1 \
    -o '%(playlist_title)s -split- %(playlist_index)s -split- %(title)s.%(ext)s'
  for FILE in *.mp3; do
    ALBUM=$(echo "$FILE" | awk -F ' -split- ' '{print$1}')
    TRACK=$(echo "$FILE" | awk -F ' -split- ' '{print$2}')
    TITLE=$(echo "$FILE" | awk -F ' -split- ' '{print$3}' | awk -F '.' '{print $1}')
    FINAL_FILE=$(echo "$FILE" | awk -F ' -split- ' '{print$3}')
    ffmpeg -i "$FILE" -c copy \
      -metadata album="$ALBUM" -metadata track="$TRACK" -metadata title="$TITLE" \
      "$FINAL_FILE"
    rm $FILE
  done
  cd ..
}
