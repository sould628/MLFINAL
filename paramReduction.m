RawParams = myData.dataMatrix;

minParams = min(RawParams);
maxParams = max(RawParams);
scaleParams = maxParams - minParams;

Params = (RawParams-minParams)./scaleParams;

[coeff score latent] = pca(Params);

MinorPC = coeff(31:end, :);
MinorPCsum = sum((MinorPC.*MinorPC), 1);
MinorParams = MinorPCsum >= 0.85;
MajorParamsIndices = find(~MinorParams)