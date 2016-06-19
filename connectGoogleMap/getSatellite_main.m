clear all; close all; clc; warning off;

%% City
% General param
datasetFolderDir = '../dataset/kitti/residential';
citySeq = {'2011_09_26_drive_0001_sync', '2011_09_26_drive_0005_sync', ...
           '2011_09_26_drive_0009_sync', '2011_09_26_drive_0011_sync', ...
           '2011_09_26_drive_0051_sync', '2011_09_26_drive_0056_sync', ...
           '2011_09_26_drive_0059_sync', '2011_09_26_drive_0084_sync', ...
           '2011_09_26_drive_0095_sync', '2011_09_26_drive_0096_sync', ...
           '2011_09_26_drive_0104_sync', '2011_09_26_drive_0117_sync'};
citySeq = {'2011_09_26_drive_0001_sync', '2011_09_26_drive_0005_sync'};
boundary = 0.003;

for index = 1:numel(citySeq)
  disp(['Processing: ', citySeq{index}]);

  % GetAreaMap
  [satelliteRaw, areaLatLonRange, ll2yx] = getAreaMap(strcat(datasetFolderDir, citySeq{index}), boundary);

  % Save image
  imwrite(satelliteRaw, strcat(datasetFolderDir, citySeq{index},'/satellite/raw.png'));

end


%% Residential
datasetFolderDir = '/media/dkkim930122/My Passport/dataset/kitti/residential/';
resSeq = {'2011_09_26_drive_0022_sync', '2011_09_26_drive_0035_sync', ...
          '2011_09_26_drive_0036_sync', '2011_09_26_drive_0039_sync', ...
          '2011_09_26_drive_0046_sync', '2011_09_26_drive_0064_sync', ...
          '2011_09_30_drive_0018_sync', '2011_09_30_drive_0020_sync', ...
          '2011_09_30_drive_0027_sync', '2011_09_30_drive_0028_sync', ...
          '2011_09_30_drive_0033_sync', '2011_09_30_drive_0034_sync', ...
          '2011_10_03_drive_0027_sync', '2011_10_03_drive_0034_sync'};

for index = 1:numel(resSeq)
  disp(['Processing: ', resSeq{index}]);

  % GetAreaMap
  [satelliteRaw, areaLatLonRange, ll2yx] = getAreaMap(strcat(datasetFolderDir, resSeq{index}), boundary);

  % Save image
  imwrite(satelliteRaw, strcat(datasetFolderDir, resSeq{index},'/satellite/raw.png'));
end


%% Road
datasetFolderDir = '/media/dkkim930122/My Passport/dataset/kitti/road/';
roadSeq = {'2011_09_26_drive_0029_sync', '2011_09_26_drive_0070_sync', ...
           '2011_09_30_drive_0016_sync'};

for index = 1:numel(roadSeq)
  disp(['Processing: ', roadSeq{index}]);

  % GetAreaMap
  [satelliteRaw, areaLatLonRange, ll2yx] = getAreaMap(strcat(datasetFolderDir, roadSeq{index}), boundary);

  % Save image
  imwrite(satelliteRaw, strcat(datasetFolderDir, roadSeq{index},'/satellite/raw.png'));
end
