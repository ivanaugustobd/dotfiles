# General
alias a-poweroff="adb shell reboot -p"

# Android Virtual Device (AVD) Management

function avd() {
  local ANDROID_SDK_ROOT="$HOME/Android/Sdk"
  "${ANDROID_SDK_ROOT}/emulator/emulator" "${@:---help}"
}

alias avd-list="avd -list-avds"

function avd-launch() {
  local AVD_NAME=$1
  [ -z "$AVD_NAME" ] && AVD_NAME="$(avd-list | head -n 1)"
  echo "Launching Android Virtual Device: $AVD_NAME"

  avd -avd "$AVD_NAME" \
    -writable-system \
    -no-snapshot \
    -no-boot-anim
}
