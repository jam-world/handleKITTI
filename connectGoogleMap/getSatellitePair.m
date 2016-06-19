% Outputs:
% 1. positionGT.txt: records positionGT in the satelliteAll image.
% 2. cropped image that corresponds to each ground image.
function getSatellitePair(foldername, saveDir, ll2yx, satelliteRaw, cropSize, forwardSize)
  % Read oxts/data directory
  gpsDirectory = dir(strcat(foldername, '/oxts/data'));
  gpsDirectory = gpsDirectory(3:end);% Take care the error of '.' & '..'

  % Extract latitude and longitude information from txt file
  for index = 1:length(gpsDirectory)
    datafilename = strcat(foldername, '/oxts/data/', gpsDirectory(index).name);
    data = textread(datafilename);
    lat(index) = data(1);
    lon(index) = data(2);
    oriRad(index) = data(6);% In rad
  end

  % Change to degree for orientation
  oriDegree = radtodeg(oriRad);
  oriDegree = 90-oriDegree;% KITTI's data setup: 0 degree means east, but in satellite is in north.

  % Open PositionGT txt file that records where GT is in the satelliteAll image
  positionGT = fopen(strcat(foldername, '/positionInSat.txt'),'wt');

  % Extract necessary info from ll2yx
  latmax = ll2yx(1,1);
  lonmin = ll2yx(1,2);

  latUnitPixel = ll2yx(3,1);% y-direction (row)
  lonUnitPixel = ll2yx(3,2);% x-direction (column)

  % Convert lat-lon to y,x (row,column)
  for index = 1:length(lat)
  	y(index) = 300+(latmax-lat(index))/0.001*latUnitPixel;
    x(index) = 300+(lon(index)-lonmin)/0.001*lonUnitPixel;
  end

  % Crop
  % Because KITTI's ground camera is forward-facing, corresponding satellite images
  % should consider that. So I am not cropping centered around its lat-lon, but
  % centering around below that.
  for index = 1:1:length(lat)
  	% Step 1. Crop with a bigger size
  	windowSize = 2*(forwardSize*sqrt(2));
  	yBegin = y(index)-windowSize/2;
  	yEnd = y(index)+windowSize/2;

  	xBegin = x(index)-windowSize/2;
  	xEnd = x(index)+windowSize/2;

  	imgBig = satelliteRaw(yBegin:yEnd, xBegin:xEnd, :);

  	% Step 2. Rotate img: (+) ccw, (-) cw
  	rotImg = imrotate(imgBig, oriDegree(index));

  	% Step 3. Final Crop
  	[ySize, xSize, ~] = size(rotImg);% Watch out! RGB!
  	yBegin = ySize/2-forwardSize;
  	yEnd = ySize/2+(cropSize-forwardSize)-1;

  	xBegin = xSize/2-round(cropSize/2);
  	xEnd = xSize/2+round(cropSize/2)-1;

  	saveImg = rotImg(yBegin:yEnd, xBegin:xEnd, :);

    % Step 4. Save result
	  imgSaveName = gpsDirectory(index).name;
    imgSaveName(end-2:end) = 'png';
    imwrite(saveImg,strcat(foldername, saveDir, imgSaveName));

    fprintf(positionGT, [num2str(y(index)), ' ', num2str(x(index)), '\n']);
  end

  % Clsoe txt file
  fclose(positionGT);
end
