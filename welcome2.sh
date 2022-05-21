#!/bin/bash

v=0

zenity --question --title=" Welcome to the tool " --text="\n\n\n<span font='16'> Would you like to proceed ? </span>" --width=400 --height=170

[[ $? != 0 ]] && exit 1

zenity --info --title="Welcome to CHOLAR: lncRNA identification tool" --text="<span foreground='red' font='18'>Haneesh Jindal</span>" --width=400 --height=170

zenity --list
