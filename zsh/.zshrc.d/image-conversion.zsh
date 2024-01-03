# Functions
ico-to-png() {
  for FILE in *.ico; do
    convert $FILE ${FILE%.*}.png
  done
  optimize-png
}

jpg-to-webp() {
  optimize-jpg
  for FILE in *.jp*g; do
    convert $FILE ${FILE%.*}.webp
  done
}

png-to-jpg() {
  optimize-png
  for FILE in *.png; do
    convert $FILE -background white -flatten -alpha off ${FILE%.*}.jpg
  done
  optimize-jpg
}

png-to-webp() {
  optimize-png
  for FILE in *.png; do
    convert $FILE ${FILE%.*}.webp
  done
}

svg-to-ico() {
  optimize-svg
  for FILE in *.svg; do
    inkscape -o ${FILE%.*}.png $FILE
    convert ${FILE%.*}.{png,ico}
    rm ${FILE%.*}.png
  done
}

svg-to-png() {
  optimize-svg
  for FILE in *.svg; do
    inkscape $FILE --export-filename ${FILE%.*}.png
  done
  optimize-png
}

webp-to-jpg() {
  for FILE in *.webp; do
    convert $FILE ${FILE%.*}.jpg
  done
  optimize-jpg
}

webp-to-png() {
  for FILE in *.webp; do
    convert $FILE ${FILE%.*}.png
  done
  optimize-png
}
