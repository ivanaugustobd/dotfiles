# Aliases
alias optimize-jpg="parallel -j 16 jpegoptim -st ::: *.jp*g"
alias optimize-png="parallel -j 16 optipng -strip all ::: *.png"
alias optimize-svg="parallel -j 16 svgo ::: *.svg"
