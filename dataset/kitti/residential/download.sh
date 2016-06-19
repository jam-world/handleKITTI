#! bin/sh
mkdir -p Tract
cp residentialTract.txt Tract
cd Tract
while read line; do
    wget line
done < residentialTract.txt
cd ..

mkdir -p Sync
cp residentialSyn.txt Sync
cd Sync
while read line; do
    wget $line
done < residentialSyn.txt
cd ..

mkdir -p Calib
cp residentialCalib.txt Calib
cd Calib
while read line; do
    wget $line
done < residentialCalib.txt
cd ..

mkdir -p Extract
cp residentialExtract.txt Extract
cd Extract
while read line; do
    wget $line
done < residentialExtract.txt
cd ..


