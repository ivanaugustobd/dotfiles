dualsense-battery-optimization() {
  if ! command -v dualsensectl &> /dev/null; then
    echo "dualsensectl not installed"
    echo "package name on Arch (AUR): dualsensectl-git"
    return 1
  fi

  dualsensectl lightbar off
  dualsensectl microphone off
  dualsensectl player-leds off
  dualsensectl volume 0
}

dualsense-optimize-battery() {
  dualsense-battery-optimization
}
