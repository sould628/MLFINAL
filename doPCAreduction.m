function [ reducedMat ] = doPCAreduction( dataMat, pcaCoeff, dimension )
%DOPCA 이 함수의 요약 설명 위치
%   자세한 설명 위치
pcaCoeff=pcaCoeff(:,1:dimension);
reducedMat=dataMat*pcaCoeff;
end

