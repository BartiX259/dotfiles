#!/usr/bin/env bash
cache=~/.cache/ewwtimeout
if ! [ -d ~/.cache ]; then
    mkdir ~/.cache
fi
if ! [ -f $cache ]; then
    touch $cache
fi

reopen=false
while getopts "c:a:r" flag; do
 case $flag in
   "c")config="-c $OPTARG";;
   "a")args="$args --arg $OPTARG";;
   "r")reopen=true;;
 esac
done
shift "$((OPTIND - 1))"
usage="Usage: ewwtimeout [eww window] [timeout (seconds)]"
if [[ $1 = "" ]]; then
    echo "Specify eww window"
    echo "$usage"
    exit
fi

if [[ $2 = "" ]]; then
    echo "Specify timeout"
    echo "$usage"
    exit
fi
activeWindow=$(sed '1q;d' $cache)
activePid=$(sed '2q;d' $cache)
echo $$
echo $activePid
echo $activeWindow

dock=false
if [ -e ~/.cache/dock_hover ] || [ -e ~/.cache/desktop_empty ]; then
  dock=true
  eww close dock
fi

if [[ $activeWindow != "" ]]; then
    if [[ $activeWindow == $1 && $reopen == false ]]; then
        kill $activePid
    else
        eval "eww $config close $activeWindow"
        kill $activePid
        eval "eww $config open $args $1"
    fi
else
  eval "eww $config open $args $1"
fi
echo $1 > $cache
echo $$ >> $cache

sleep $2
eval "eww $config close $1"
> $cache
if [ $dock = true ]; then
  eww open dock
fi

