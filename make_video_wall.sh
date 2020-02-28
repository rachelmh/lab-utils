#!/usr/bin/env bash

# Get dimensions of input videos.
W1="$(ffprobe -v error -show_entries stream=width,height -of csv=p=0:s=x $1 | perl -lane 'print $1 if /(\d+)x/')"
H1="$(ffprobe -v error -show_entries stream=width,height -of csv=p=0:s=x $1 | perl -lane 'print $1 if /x(\d+)/')"
W2="$(ffprobe -v error -show_entries stream=width,height -of csv=p=0:s=x $2 | perl -lane 'print $1 if /(\d+)x/')"
H2="$(ffprobe -v error -show_entries stream=width,height -of csv=p=0:s=x $2 | perl -lane 'print $1 if /x(\d+)/')"
W3="$(ffprobe -v error -show_entries stream=width,height -of csv=p=0:s=x $3 | perl -lane 'print $1 if /(\d+)x/')"
H3="$(ffprobe -v error -show_entries stream=width,height -of csv=p=0:s=x $3 | perl -lane 'print $1 if /x(\d+)/')"
echo "${W1}x${H1}"
# TODO: Use https://trac.ffmpeg.org/wiki/Scaling to make them all the same size.

exit 0

ffmpeg -y -i $1 -i $2 -i $3 -filter_complex vstack=inputs=3 $4
ffmpeg -y -i $4 -vf "transpose=1" temp.mp4
ffmpeg -y -i temp.mp4 -vf scale=1920:1080 $4
rm temp.mp4