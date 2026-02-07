#!/bin/bash

choice=$(wofi --show dmenu --prompt="Layout Tweaks" <<< $'Pseudo (P)\nSplit Toggle (J)\nSplit Ratio - ([)\nSplit Ratio + (])\nSwapsplit (S)\nMove to Root (R)\nExit (Q)')
case "$choice" in
  "Pseudo (P)")
    hyprctl dispatch pseudo
    ;;
  "Split Toggle (J)")
    hyprctl dispatch togglesplit
    ;;
  "Split Ratio - ([)")
    hyprctl dispatch splitratio -0.1
    ;;
  "Split Ratio + (])")
    hyprctl dispatch splitratio +0.1
    ;;
  "Swapsplit (S)")
    hyprctl dispatch swapsplit
    ;;
  "Move to Root (R)")
    hyprctl dispatch movetoroot
    ;;
  "Exit (Q)")
    hyprctl dispatch submap reset
    ;;
esac
