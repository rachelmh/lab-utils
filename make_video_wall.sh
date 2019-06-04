#!/usr/bin/env bash

ffmpeg -y -i $1 -i $2 -i $3 -filter_complex vstack=inputs=3 $4
ffmpeg -y -i $4 -vf "transpose=1" temp.mp4
ffmpeg -y -i temp.mp4 -vf scale=1920:1080 $4
rm temp.mp4