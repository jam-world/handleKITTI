dbclear all;

% compile matlab wrappers
disp('Building wrappers ...');
% mex('readTrackletsMex.cpp','-I../cpp','-lboost_serialization');
mex('readTrackletsMex.cpp','-I../cpp','-I/usr/local/Cellar/boost/1.60.0_1/include','-L/usr/local/Cellar/boost/1.60.0_1/lib','-lboost_serialization.dylib');
disp('...done!');
