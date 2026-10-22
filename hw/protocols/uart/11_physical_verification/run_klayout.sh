#!/usr/bin/env bash
# Use the extracted full KLayout application; klayout-stream has no DRC engine.
set -euo pipefail
root="${KLAYOUT_GUI_ROOT:-$HOME/Crucible/tools/klayout-gui/root}"
application="$root/usr/lib/klayout/klayout"
libraries="$root/usr/lib/x86_64-linux-gnu"
if [[ ! -x "$application" ]]; then
    echo "Full KLayout runtime missing: $application. Set KLAYOUT_GUI_ROOT." >&2
    exit 1
fi
export LD_LIBRARY_PATH="$root/usr/lib/klayout:$libraries:$libraries/pulseaudio${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export QT_PLUGIN_PATH="$libraries/qt5/plugins"
export QT_QPA_PLATFORM_PLUGIN_PATH="$QT_PLUGIN_PATH/platforms"
export RUBYLIB="$root/usr/lib/ruby/3.3.0:$libraries/ruby/3.3.0${RUBYLIB:+:$RUBYLIB}"
export GEM_PATH="$root/usr/lib/ruby/gems/3.3.0:$root/usr/share/rubygems-integration/all"
exec "$application" "$@"
