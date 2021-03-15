#! /usr/bin/env zsh

cd /home/juhyung/jhconfig/
git push jh main

if [ $? -eq 0 ]; then
    echo upload success
    notify-send "dotconfig push success"
else
    echo upload fail
    notify-send "dotconfig push fail"
    exit -1
fi
