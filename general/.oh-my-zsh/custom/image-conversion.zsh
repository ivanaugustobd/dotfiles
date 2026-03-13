# Functions
ico-to-png() {
  find -iname '*.ico' -print0 |
    parallel -0 magick {} {.}.png
}

jpg-to-webp() {
  find -iname '*.jp*g' -print0 |
    parallel -0 magick {} {.}.webp
}

png-to-jpg() {
  parallel magick {} {.}.jpg ::: *.png
}

png-to-webp() {
  find -iname '*.png' -print0 |
    parallel -0 magick {} {.}.webp
}

svg-to-ico() {
  find -iname '*.svg' -print0 |
    parallel -0 inkscape {} -o {.}.png \; magick {.}.png {.}.ico \; rm {.}.png
}

svg-to-png() {
  find -iname '*.svg' -print0 |
    parallel -0 inkscape {} --export-filename {.}.png
}

webp-to-jpg() {
  find -iname '*.webp' -print0 |
    parallel -0 magick {} {.}.jpg
}

webp-to-png() {
  find -iname '*.webp' -print0 |
    parallel -0 magick {} {.}.png
}
