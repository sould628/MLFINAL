function [ reducedMat ] = doPCAreduction( dataMat, pcaCoeff, dimension )
%DOPCA �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
pcaCoeff=pcaCoeff(:,1:dimension);
reducedMat=dataMat*pcaCoeff;
end

