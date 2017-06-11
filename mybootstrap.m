function sample = mybootstrap( inputData, inputPrice, inputLabel, numSamples )
%BOOT �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
    sample=cell(numSamples, 3);

    [numData, numAttrib]=size(inputData);
    for j=1:numSamples
        randomNumber=randi([1 numData], 1, numData);
        sD=zeros(numData, numAttrib);
        sP=zeros(numData, 1);
        sL=zeros(numData, 1);
        for i=1:numData
            rN=randomNumber(1,i);
            sD(i,:)=inputData(rN,:);
            sP(i,:)=inputPrice(rN,1);
            sL(i,:)=inputLabel(rN,1);
        end
        sample{j,1}=sD;
        sample{j,2}=sP;
        sample{j,3}=sL;
    end

end

