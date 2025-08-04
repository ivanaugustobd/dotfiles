# Functions
function optimize-jpg() {
  find -iname '*.jp*g' -print0 |
    parallel -0 jpegoptim -st {}
}

function optimize-png() {
  find -iname '*.png' -print0 |
    parallel -0 optipng -strip all {}
}

function optimize-svg() {
  find -iname '*.svg' -print0 |
    parallel -0 svgo {}
}
