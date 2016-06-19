function [satelliteRaw] = googleMap(lat, lon)
	latstr = num2str(lat,'%2.13f'); lonstr = num2str(lon,'%2.13f');

	url = ['https://maps.googleapis.com/maps/api/staticmap?', ...
	       'center=',latstr,',',lonstr, '&', ...
	       'zoom=19&', 'size=640x640&', ...
				 'maptype=satellite&', ...
				 'key=[API KEY GOES HERE]'];

	filename = urlwrite(url,'tmp.gif');
	[tmpMap,Mcolor] = imread(filename);
	satelliteRaw = ind2rgb(tmpMap,Mcolor);
	delete(filename);

	% Get rid of google logo
	satelliteRaw = satelliteRaw(21:620,21:620,:);% size: 600 x 600
end
