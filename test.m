filename='ml_project_train.csv';

%%Constant Variables
PCADIMENSION=40;
NUMKFOLDS=10;

%% DataProcessing
%%%ImportData
%rawData=importfile(filename);
%%%ProcessData

%myData=AMES(rawData);

%% DimensionReduction
% Data Standardization

compressedMat=myData.compressedMat;
dataLabel=myData.salePriceB;

%PCA
pcaCoeff=pca(compressedMat);
pcaCoeff=pcaCoeff(:,1:PCADIMENSION);
reducedMat=compressedMat*pcaCoeff;

%% Make Training and Test Set for K-Fold Cross-Validation
kfold_part={};
numData_in_partition=size(compressedMat,1)/NUMKFOLDS;
for i=1:NUMKFOLDS
    if i==1
        trainingd=compressedMat(i*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :);
        testd=compressedMat(0*numData_in_partition+1:1*numData_in_partition, :);
        trainingl=dataLabel(i*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :);
        testl=dataLabel(0*numData_in_partition+1:1*numData_in_partition, :);
    elseif i~=NUMKFOLDS
        trainingd=compressedMat(0*numData_in_partition+1:(i-1)*numData_in_partition, :);
        testd=compressedMat((i-1)*numData_in_partition+1:i*numData_in_partition, :);
        trainingd=[trainingd; compressedMat(i*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :)];
        trainingl=dataLabel(0*numData_in_partition+1:(i-1)*numData_in_partition, :);
        testl=dataLabel((i-1)*numData_in_partition+1:i*numData_in_partition, :);
        trainingl=[trainingl; dataLabel(i*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :)];
    else
        trainingd=compressedMat(0*numData_in_partition+1:(NUMKFOLDS-1)*numData_in_partition, :);
        testd=compressedMat((NUMKFOLDS-1)*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :);
        trainingl=dataLabel(0*numData_in_partition+1:(NUMKFOLDS-1)*numData_in_partition, :);
        testl=dataLabel((NUMKFOLDS-1)*numData_in_partition+1:NUMKFOLDS*numData_in_partition, :);
    end
    
    kfold_part{i,1}=trainingd;
    kfold_part{i,2}=trainingl;
    kfold_part{i,3}=testd;
    kfold_part{i,4}=testl;
end

%% Regression


%% BinaryClassification

%knn classifier
myknn={};
for i=1:NUMKFOLDS
    workingFold=i
    myknn{i,1}=myKnnClassifier(kfold_part{i,1}, kfold_part{i,2}, kfold_part{i,3}, kfold_part{i,4}, 5);
end
myknnDR={};
for i=1:NUMKFOLDS
    workingFold=i
    pcaCoeff=pca(kfold_part{i,1});
    reducedTrainSet=doPCAreduction(kfold_part{i,1}, pcaCoeff, PCADIMENSION);
    reducedTestSet=doPCAreduction(kfold_part{i,3}, pcaCoeff, PCADIMENSION);
    myknnDR{i,1}=myKnnClassifier(reducedTrainSet, kfold_part{i,2}, reducedTestSet, kfold_part{i,4}, 5);
end

rawData.Properties.VariableNames(2)
cat=categories(rawData.MSZoning)
rawData.MSZoning(1)
if rawData.MSZoning(1)==cat{4}
end
% s=table;
% s(:,1)=rawData(:,1);
% s.Properties.VariableNames(1)=rawData.Properties.VariableNames(1);
% s(:,2)=rawData(:,2);