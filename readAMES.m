function [ M ] = readAMES( filename )
%readData : read csv file "filename"
%   자세한 설명 위치
formatSpec = '%u%u%s%u%u%s%s%s%s%s%s%s%s';

M=readtable(filename);

end

