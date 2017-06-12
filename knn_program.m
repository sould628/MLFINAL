filename='ml_project_train.csv';
%%Constant Variables
PCADIMENSION=40;
NUMKFOLDS=10;
NUMBOOTSAMPLE=100;

%%Initialize
if initialize==true
    MODE=1;
    importdata=true;
    dataprocess=1;
    dimreduction=1;
    kfold=1;
    doKnn=true;
    doKnnEnsemble=true;
    doTree=false;
    initialize=0;
end

%% DataProcessing
if dataprocess==true
    %%%ImportData
    if importdata==true
    rawData=importfile(filename);
    rawTest=importfile(testfile);
    importdata=false;
    end
    %%%ProcessData
    myData=AMES(rawData);
    [myData.dataMatrix, myData.varList]=myData.postProcess(myData.zeroList);
    myData.compressedMat=myData.standardize;
    myTest=AMES(rawTest);
    [myTest.dataMatrix, myTest.varList]=myTest.postProcess(myData.zeroList);
    myTest.compressedMat=myTest.standardize;
    dataprocess=0;
end

compressedMat=myData.compressedMat;
dataLabel=myData.salePriceB;
dataPrice=myData.salePrice;

%% DimensionReduction
% Data Standardization
if dimreduction==true
    disp("performing dimension reduction");
    drawnow;
    %PCA
    pcaCoeff=pca(compressedMat);
    pcaCoeff=pcaCoeff(:,1:PCADIMENSION);
    reducedMat=compressedMat*pcaCoeff;
    dimreduction=0;
end
%% Make Training and Test Set for K-Fold Cross-Validation
if kfold==true
    disp("Making K-Fold Cross-Validation Set kfold_part");
    drawnow;
    kfold_part=cell(NUMKFOLDS, 6);
    bootSample=cell(NUMKFOLDS, 1);
    numData_in_partition=size(compressedMat,1)/NUMKFOLDS;
    for i=1:NUMKFOLDS
        kfold_bootstrap_process=i/NUMKFOLDS
        if i==1
            trainingd=compressedMat(i*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :);
            testd=compressedMat(0*numData_in_partition+1:1*numData_in_partition, :);
            
            trainingl=dataLabel(i*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :);
            testl=dataLabel(0*numData_in_partition+1:1*numData_in_partition, :);
            
            trainingp=dataPrice(i*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :);
            testp=dataPrice(0*numData_in_partition+1:1*numData_in_partition, :);
        elseif i~=NUMKFOLDS
            trainingd=compressedMat(0*numData_in_partition+1:(i-1)*numData_in_partition, :);
            testd=compressedMat((i-1)*numData_in_partition+1:i*numData_in_partition, :);
            trainingd=[trainingd; compressedMat(i*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :)];
            
            trainingl=dataLabel(0*numData_in_partition+1:(i-1)*numData_in_partition, :);
            testl=dataLabel((i-1)*numData_in_partition+1:i*numData_in_partition, :);
            trainingl=[trainingl; dataLabel(i*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :)];
            
            trainingp=dataPrice(0*numData_in_partition+1:(i-1)*numData_in_partition, :);
            testp=dataPrice((i-1)*numData_in_partition+1:i*numData_in_partition, :);
            trainingp=[trainingl; dataPrice(i*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :)];
        else
            trainingd=compressedMat(0*numData_in_partition+1:(NUMKFOLDS-1)*numData_in_partition, :);
            testd=compressedMat((NUMKFOLDS-1)*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :);
            
            trainingl=dataLabel(0*numData_in_partition+1:(NUMKFOLDS-1)*numData_in_partition, :);
            testl=dataLabel((NUMKFOLDS-1)*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :);
            
            trainingp=dataPrice(0*numData_in_partition+1:(NUMKFOLDS-1)*numData_in_partition, :);
            testp=dataPrice((NUMKFOLDS-1)*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :);
        end
        
        kfold_part{i,1}=trainingd;
        kfold_part{i,2}=trainingp;
        kfold_part{i,3}=trainingl;
        kfold_part{i,4}=testd;
        kfold_part{i,5}=testp;
        kfold_part{i,6}=testl;
        %make BootStrap
        bootSample{i,1}=mybootstrap(trainingd, trainingp, trainingl, NUMBOOTSAMPLE);
    end
    kfold=0;
end




%% MODE1 CrossValidationMode
if MODE==1
    
    
    %% Regression
    
    
    %% BinaryClassification
    if doKnn==true
        %knn classifier
        myknn=cell(NUMKFOLDS, 1);
        for i=1:NUMKFOLDS
            originalWorkingFold=i
            myknn{i,1}=myKnnClassifier(kfold_part{i,1}, kfold_part{i,2}, kfold_part{i,3}, kfold_part{i,4}, kfold_part{i,5}, kfold_part{i,6}, 5);
        end
        myknnDR=cell(NUMKFOLDS, 1);
        for i=1:NUMKFOLDS
            reducedWorkingFold=i
            pcaCoeff=pca(kfold_part{i,1});
            reducedTrainSet=doPCAreduction(kfold_part{i,1}, pcaCoeff, PCADIMENSION);
            reducedTestSet=doPCAreduction(kfold_part{i,4}, pcaCoeff, PCADIMENSION);
            myknnDR{i,1}=myKnnClassifier(reducedTrainSet, kfold_part{i,2}, kfold_part{i,3}, reducedTestSet, kfold_part{i,5}, kfold_part{i,6}, 5);
        end
        averagePrecision=0;
        averagePrecisionDR=0;
        for i=1:NUMKFOLDS
            fprintf("%d validation set\n", i);
            averagePrecision=averagePrecision+myknn{i,1}.classifierPrecision;
            averagePrecisionDR=averagePrecisionDR+myknnDR{i,1}.classifierPrecision;
            myknn{i,1}.showResult;
            myknnDR{i,1}.showResult;
        end
        averagePrecision=averagePrecision/NUMKFOLDS
        averagePrecisionDR=averagePrecisionDR/NUMKFOLDS
    end
    if doKnnEnsemble==true
        forestResult=zeros(numData_in_partition, NUMKFOLDS);
        precisionWithBootSample=zeros(1,NUMKFOLDS);
        for i=1:NUMKFOLDS
            forest=zeros(numData_in_partition, NUMBOOTSAMPLE);
            for j=1:NUMBOOTSAMPLE
                if(rem((j/NUMBOOTSAMPLE),0.1)==0)
                bootsampleprocess=i+j/NUMBOOTSAMPLE
                end
                reduceTest=reduceattrib2bootattrib(kfold_part{i,4}, bootSample{i,1}{j,4});
                result=myKnnClassifier(bootSample{i,1}{j,1}, bootSample{i,1}{j,2}, bootSample{i,1}{j,3}, reduceTest, kfold_part{i,5}, kfold_part{i,6},5);
                forest(:,j)=result.classfierResult;
            end
            forestResult(:,i)=mode(forest,2);
            %Validate
            numCorrect=0;
            for j=1:numData_in_partition
                if forestResult(j,i)==kfold_part{i,6}(j,1)
                    numCorrect=numCorrect+1;
                end
            end
            precisionWithBootSample(1,i)=numCorrect/numData_in_partition;
        end
        
        
    end
    
    %tree classifier
    if doTree==true
        disp("doing tree classifier");
        drawnow;
        tc=myTreeClassifier(myData);
        tc.getEntropy(1);
        disp("stop");
    end
    
    if false
        rawData.Properties.VariableNames(2)
        cat=categories(rawData.MSZoning)
        rawData.MSZoning(1)
        if rawData.MSZoning(1)==cat{4}
        end
    end
end
%% MODE=2 (With Test Sets)
if MODE==2
    %remove zeros from
    
    zeroList=myTest.zeroList&myData.zeroList;
    [myTest.dataMatrix, myTest.varList]=myTest.postProcess(zeroList);
    [myData.dataMatrix, myTest.varList]=myData.postProcess(zeroList);
    compressedTest=myTest.standardize;
    compressedMat=myData.standardize;
    %compressedTest=myTest.compressedMat;
    testLabel=myTest.salePriceB;
    testPrice=myTest.salePrice;
    
    %%%knn
    if doKnn==true
        myknnwTD=myKnnClassifier(compressedMat, dataPrice, dataLabel, compressedTest, testPrice, testLabel, 5);
        
        pcaCoeff=pca(compressedMat);
        reducedTrainSet=doPCAreduction(compressedMat, pcaCoeff, PCADIMENSION);
        reducedTestSet=doPCAreduction(compressedTest, pcaCoeff, PCADIMENSION);
        myknnDRwTD=myKnnClassifier(reducedTrainSet, dataPrice, dataLabel, reducedTestSet, testPrice, testLabel, 5);
        
        myknnwTD.showResult;
        myknnDRwTD.showResult;
    end
    
end

function [ reducedMat ] = doPCAreduction( dataMat, pcaCoeff, dimension )
%DOPCA 이 함수의 요약 설명 위치
%   자세한 설명 위치
pcaCoeff=pcaCoeff(:,1:dimension);
reducedMat=dataMat*pcaCoeff;
end

function [ reduceMat ] = reduceattrib2bootattrib( inputTest, attribList )
%REDUCETEST 이 함수의 요약 설명 위치
%   자세한 설명 위치
[numData, numAttrib]=size(inputTest);
reduceMat=inputTest;
k=1;
for i=1:numAttrib
    rN=attribList(1,k);
    if (numAttrib+1-i)~=rN
        reduceMat(:, numAttrib+1-i)=[];
    else
        k=k+1;
    end
    if k==21
        k=1;
    end
end
end



