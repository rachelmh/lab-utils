#!/usr/bin/env bash

# Add padding and to ensure 16:9 AR
ffmpeg -y -i $1 -vf scale=1080:607:force_original_aspect_ratio=decrease,pad=1080:640:'(ow-iw)/2':'(oh-ih)/2',setsar=1 temp_0.mp4
ffmpeg -y -i $2 -vf scale=1080:607:force_original_aspect_ratio=decrease,pad=1080:640:'(ow-iw)/2':'(oh-ih)/2',setsar=1 temp_1.mp4
ffmpeg -y -i $3 -vf scale=1080:607:force_original_aspect_ratio=decrease,pad=1080:640:'(ow-iw)/2':'(oh-ih)/2',setsar=1 temp_2.mp4

# Time
D0="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $1)"
D1="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $2)"
D2="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $3)"

# Stack, flip, and scale to fit screens
ffmpeg -y -i temp_0.mp4 -i temp_1.mp4 -i temp_2.mp4 -filter_complex vstack=inputs=3 $4
ffmpeg -y -i $4 -vf "transpose=1" temp.mp4
ffmpeg -y -i temp.mp4 -vf scale=1920:1080 $4
rm temp.mp4 temp_0.mp4 temp_1.mp4 temp_2.mp4