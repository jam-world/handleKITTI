function [mx, mz] = calPos(lat, lon, originLat, originLon)
    scaleFactor = earthCircumference(originLat);
    originZ = latToZ(originLat) * scaleFactor;
    originX = lonToX(originLon) * scaleFactor;

    mx = lonToX(lon) * scaleFactor - originX;
    mz = latToZ(lat) * scaleFactor - originZ;
    mx = round(mx * 1000) / 1000.0;
    mz = - round(mz * 1000) / 1000.0;
end


function [c] = R_MAJOR() 
    c = 6378137.0; 
end

function [c] = R_MINOR()
    c = 6356752.3142;
end

function [c] = EARTH_CIRCUMFERENCE()
    c = 40075016.686;
end

function [c] = RATIO()
    c = R_MINOR / R_MAJOR;
end

function [c] = ECCENT()
    c = sqrt(1.0 - (RATIO * RATIO));
end

function [c] = COM()
    c = 0.5 * ECCENT;
end

function [r] = degToRad(d)
    r = ((d)*pi)/180.0;
end

function [r] = radToDeg(d)
    r = ((d)*180.0)/pi;
end

function [cir] = earthCircumference(lat)
% Caculate earth circumference at given latitude
    cir = EARTH_CIRCUMFERENCE * cos(degToRad(lat)); 
end


% Covert longitude to Mercator projection ([0, 1])
function [x] = lonToX(lon)
    x = (lon + 180.0) / 360.0;
end

function [lon] = xToLon(x)
    lon = 360.0 * (x - 0.5);
end

function [z] = latToZ(lat)
    sinLat = sin(degToRad(lat));
    z = log((1.0 + sinLat) ./ (1.0 - sinLat)) / (4.0 * pi) + 0.5;
end

function [lat] = zToLat(z)
    lat =  360.0 * atan(exp((z - 0.5) * (2.0 * pi))) / pi - 90.0;
end

function [y] = latToYEllipitical(lat)
    lat = fmin(89.5, fmax(lat, -89.5));
    phi = degToRad(lat);
    sinphi = sin(phi);
    con = ECCENT * sinphi;
    con = pow(((1.0 - con) / (1.0 + con)), COM);
    ts = tan(0.5 * ((pi * 0.5) - phi)) / con;
    y =  0 - R_MAJOR * log(ts);
end

function [lat] =  zToLatEllipitical(z)
    ts = exp(-z / R_MAJOR);
    phi = pi / 2.0 - 2 * atan(ts);
    dphi = 1.0;
    i = 0;
    while ((abs(dphi) > 0.000000001) && (i < 15))
        con = ECCENT * sin(phi);
        dphi = pi / 2.0 - 2 * atan(ts * pow((1.0 - con) / (1.0 + con), COM)) - phi;
        phi = phi + dphi;
        i = i + 1;
    end
    lat =  radToDeg(phi);
end