#! bin/sh
mkdir -p Tract
cp tracklets.txt Tract
cd Tract
while read line; do
    wget line
done < tracklets.txt
cd ..

mkdir -p Sync
cp sync.txt Sync
cd Sync
while read line; do
    wget $line
done < sync.txt
cd ..

mkdir -p Calib
cp calib.txt Calib
cd Calib
while read line; do
    wget $line
done < calib.txt
cd ..

mkdir -p Extract
cp extract.txt Extract
cd Extract
while read line; do
    wget $line
done < extract.txt
cd ..


