function sample = mybootstrap( inputData, inputPrice, inputLabel, numSamples )
%BOOT 이 함수의 요약 설명 위치
%   자세한 설명 위치
    sample=cell(numSamples, 3);

    [numData, numAttrib]=size(inputData);
    for j=1:numSamples
        randomNumber=randi([1 numData], 1, numData);
        randomAttrib=randperm(numAttrib, 20);
        randomAttrib=sort(randomAttrib, 'descend');
        reducedInput=inputData;
        k=1;
        for i=1:numAttrib
            rN=randomAttrib(1,k);
            if (numAttrib+1-i)~=rN
                reducedInput(:, numAttrib+1-i)=[];
            else
                k=k+1;
            end
            if k==21
                k=1;
            end
        end
        sD=zeros(numData, 20);
        sP=zeros(numData, 1);
        sL=zeros(numData, 1);
        for i=1:numData
            rN=randomNumber(1,i);
            sD(i,:)=reducedInput(rN,:);
            sP(i,:)=inputPrice(rN,1);
            sL(i,:)=inputLabel(rN,1);
        end
        sample{j,1}=sD;
        sample{j,2}=sP;
        sample{j,3}=sL;
    end

end

