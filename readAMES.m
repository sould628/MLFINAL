function [ M ] = readAMES( filename )
%readData : read csv file "filename"
%   �ڼ��� ���� ��ġ
formatSpec = '%u%u%s%u%u%s%s%s%s%s%s%s%s';

M=readtable(filename);

end

