#!/usr/bin/env bash

## Add padding and to ensure 16:9 AR
echo "Adding padding to ensure 16:9 AR"
ffmpeg -y -hide_banner -loglevel warning -i $1 -vf scale=1080:607:force_original_aspect_ratio=decrease,pad=1080:640:'(ow-iw)/2':'(oh-ih)/2',setsar=1 temp_1.mp4
ffmpeg -y -hide_banner -loglevel warning -i $2 -vf scale=1080:607:force_original_aspect_ratio=decrease,pad=1080:640:'(ow-iw)/2':'(oh-ih)/2',setsar=1 temp_2.mp4
ffmpeg -y -hide_banner -loglevel warning -i $3 -vf scale=1080:607:force_original_aspect_ratio=decrease,pad=1080:640:'(ow-iw)/2':'(oh-ih)/2',setsar=1 temp_3.mp4

## Time
echo "Computing durations"
# Durations of Input Clips
D1="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $1)"
D2="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $2)"
D3="$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $3)"

# Concatenate durations to integers
D1i=${D1%.*}
D2i=${D2%.*}
D3i=${D3%.*}

# Compute maximum duration
DMAX=$D3i
if [ $D1i -ge $D2i -a $D1i -ge $D3i ]; then
	DMAX=$D1i
elif [ $D2i -ge $D3i ]; then
	DMAX=$D2i
fi

# Compute how many of each input video will fit inside the longest
M1=$(( ($DMAX+$D1i/2)/$D1i ))
M2=$(( ($DMAX+$D2i/2)/$D2i ))
M3=$(( ($DMAX+$D3i/2)/$D3i ))

# Repeat input clips so they are roughly the same duration
echo "Repeating input clips to approach equal durations"
cp temp_1.mp4 temp.mp4
for i in $(seq 2 $M1); do
	ffmpeg -y -hide_banner -loglevel warning -i temp_1.mp4 -i temp.mp4 -filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0]concat=n=2:v=1:a=1[outv][outa]" -map "[outv]" -map "[outa]" temp_temp.mp4
	cp temp_temp.mp4 temp_1.mp4
done
cp temp_2.mp4 temp.mp4
for i in $(seq 2 $M2); do
	ffmpeg -y -hide_banner -loglevel warning -i temp_2.mp4 -i temp.mp4 -filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0]concat=n=2:v=1:a=1[outv][outa]" -map "[outv]" -map "[outa]" temp_temp.mp4
	cp temp_temp.mp4 temp_2.mp4
done
cp temp_3.mp4 temp.mp4
for i in $(seq 2 $M3); do
	ffmpeg -y -hide_banner -loglevel warning -i temp_3.mp4 -i temp.mp4 -filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0]concat=n=2:v=1:a=1[outv][outa]" -map "[outv]" -map "[outa]" temp_temp.mp4
	cp temp_temp.mp4 temp_3.mp4
done
rm temp_temp.mp4

# Concatenate clips together to ensure same duration
echo "Concatenating clips together to ensure equal durations"
cp temp_1.mp4 temp_temp_1.mp4
cp temp_2.mp4 temp_temp_2.mp4
cp temp_3.mp4 temp_temp_3.mp4
ffmpeg -y -hide_banner -loglevel warning -i temp_temp_1.mp4 -i temp_temp_2.mp4 -i temp_temp_3.mp4 -filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0]concat=n=3:v=1:a=1[outv][outa]" -map "[outv]" -map "[outa]" temp_1.mp4
ffmpeg -y -hide_banner -loglevel warning -i temp_temp_2.mp4 -i temp_temp_3.mp4 -i temp_temp_1.mp4 -filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0]concat=n=3:v=1:a=1[outv][outa]" -map "[outv]" -map "[outa]" temp_2.mp4
ffmpeg -y -hide_banner -loglevel warning -i temp_temp_3.mp4 -i temp_temp_1.mp4 -i temp_temp_2.mp4 -filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0]concat=n=3:v=1:a=1[outv][outa]" -map "[outv]" -map "[outa]" temp_3.mp4
rm temp_temp_1.mp4 temp_temp_2.mp4 temp_temp_3.mp4

## Stack, flip, and scale to fit screens
echo "Stacking, flipping, and scaling to fit screens"
ffmpeg -y -hide_banner -loglevel warning -i temp_1.mp4 -i temp_2.mp4 -i temp_3.mp4 -filter_complex vstack=inputs=3 $4
ffmpeg -y -hide_banner -loglevel warning -i $4 -vf "transpose=1" temp.mp4
ffmpeg -y -hide_banner -loglevel warning -i temp.mp4 -vf scale=1920:1080 $4
rm temp.mp4 temp_1.mp4 temp_2.mp4 temp_3.mp4