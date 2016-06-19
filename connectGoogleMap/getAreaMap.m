function [satelliteRaw, areaLatLonRange, ll2yx] = getAreaMap(foldername, boundary)
  directory = dir(strcat(foldername, '/oxts/data'));
  directory = directory(3:end);% Take care the error of '.' & '..'

  % Extract latitude and longitude information from txt file
  parfor index = 1:length(directory)
      datafilename = strcat(foldername, '/oxts/data/', directory(index).name);
      data = textread(datafilename);
      lat(index) = data(1);
      lon(index) = data(2);
  end

  % Calculate latitude max, min & longitude max, min
  latmax = max(lat)+boundary;
  latmin = min(lat)-boundary;

  lonmax = max(lon)+boundary;
  lonmin = min(lon)-boundary;

  % areaLatLonRange
  areaLatLonRange = [latmin, latmax; lonmin, lonmax;];

  % Change 0.001 to meter scale
  [m,n] = calPos(latmin, lonmin, latmin+0.001, lonmin+0.001);% lat, lon, originLat, originLon

  latUnitPixel = abs(n)*5.126;% For latitude: 0.001 in pixel scale
  lonUnitPixel = abs(m)*5.126;% For longitude: 0.001 in pixel scale

  ymax = 300+(latmax-latmin)/0.001*latUnitPixel;
  xmax = 300+(lonmax-lonmin)/0.001*lonUnitPixel;

  lls = [latmax, lonmin;
         latmax, lonmax;
         latmin, lonmin;
         latmin, lonmax];

  yxs = [300, 300;
         300, xmax;
         ymax, 300;
         ymax, xmax;];

  % For by-passing Google limit ...
  for nowlat = [latmax:-0.001:latmin, latmin]
    for nowlon = [lonmin:0.001:lonmax, lonmax]
      lls = [lls; nowlat, nowlon;];

      nowy = 300+(latmax-nowlat)/0.001*latUnitPixel;
      nowx = 300+(nowlon-lonmin)/0.001*lonUnitPixel;
      yxs = [yxs; nowy, nowx;];
    end
  end

  % Satellite map
  satelliteRaw = zeros(round(ymax)+300,round(xmax)+300,3);
  for index = 1:size(lls,1)
      [map] = googleMap(lls(index,1), lls(index,2));

      nowy = round(yxs(index,1));
      nowx = round(yxs(index,2));

      satelliteRaw((nowy-299):(nowy+300), (nowx-299):(nowx+300), :) = map;
  end

  ll2yx = [latmax, lonmin; -0.001, 0.001; latUnitPixel, lonUnitPixel; 300, 300;];
end
