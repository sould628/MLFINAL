filename='../../data/ml_project_train.csv';
%%Constant Variables
PCADIMENSION=40;
NUMKFOLDS=10;
NUMBOOTSAMPLE=100;
initialize=true;
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
        importdata=false;
    end
    %%%ProcessData
    myData=AMES(rawData);
    [myData.dataMatrix, myData.varList]=myData.postProcess(myData.zeroList);
    myData.compressedMat=myData.standardize;
    dataprocess=0;
end

compressedMat=myData.compressedMat;
dataLabel=myData.salePriceB;
dataPrice=myData.salePrice;

%% DimensionReduction
% Data Standardization
% if dimreduction==true
%     disp("performing dimension reduction");
%     drawnow;
%     %PCA
%     pcaCoeff=pca(compressedMat);
%     pcaCoeff=pcaCoeff(:,1:PCADIMENSION);
%     reducedMat=compressedMat*pcaCoeff;
%     dimreduction=0;
% end
%% MODE1 CrossValidationMode
if MODE==1
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
                trainingp=[trainingp; dataPrice(i*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :)];
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
        end
        kfold=0;
    end
    
    
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
        for i=1:NUMKFOLDS
            disp("Result of")
            validationset = i
            disp("Naive")
            myknn{i,1}.showResult;
            disp("Dimension Reduced")
            myknnDR{i,1}.showResult;
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
    rawTest=importfile(testfile);
    myTest=AMES(rawTest);
    zeroList=myTest.zeroList&myData.zeroList;
    [myTest.dataMatrix, myTest.varList]=myTest.postProcess(zeroList);
    [myData.dataMatrix, myData.varList]=myData.postProcess(zeroList);
    compressedTest=myTest.standardize;
    compressedMat=myData.standardize;
    %compressedTest=myTest.compressedMat;
    testLabel=myTest.salePriceB;
    testPrice=myTest.salePrice;
    disp("Making Bootstrap")
    drawnow;
    %bootSamplewTD=mybootstrap(compressedMat, dataPrice, dataLabel, NUMBOOTSAMPLE);
    %%%knn
    if doKnn==true
        disp("Processing knn with external test data");
        drawnow;
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



