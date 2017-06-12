rawData = importfile('../../data/ml_project_train.csv');
myData = AMES(rawData);
myData.dataMatrix = myData.postProcess(myData.zeroList);

usePrelearnedWeights = true;
prelearnedWeightsFile = 'ffnWeights6000';
useAdditionalTestData = false;
additionalTestDataFile = '../../data/ml_project_test.csv';

MajorParamsIndices = [2 3 7 8 10 11 16 17 19 20 22 23 24 26 27 28 30 32 40 41 43 44 45 47 49 52 54 59 62 63 65 67 73 75 79 88 92 95 97 98 99 104 105 108 109 116 118 119 130 131 135 140 143 144 145 150 151 154 159 161 171 172 173 174 175 180 183 186 189 190 193 194 195];
%RawParams = myData.dataMatrix;
RawParams = myData.dataMatrix(:,MajorParamsIndices);
RawPrices = myData.salePrice;

minParams = min(RawParams);
maxParams = max(RawParams);
scaleParams = maxParams - minParams;

minPrice = min(RawPrices);
maxPrice = max(RawPrices);
scalePrice = maxPrice - minPrice;

learningRate = 0.1;

numAllSamples = size(RawParams, 1);
numInputNodes = size(RawParams, 2);
numHiddenNodes = [ceil(numInputNodes/2) ceil(numInputNodes/2)];
%numHiddenNodes = [numInputNodes];
numOutputNodes = 1;
numNodesPerLayer = [numInputNodes numHiddenNodes numOutputNodes];
numLayers = length(numHiddenNodes) + 2;

if useAdditionalTestData
    rawTest = importfile(additionalTestDataFile);
    myTest = AMES(rawTest);
    myTest.dataMatrix = myTest.postProcess(myData.zeroList);
    
    TrainingParams = RawParams;
    TrainingPrices = RawPrices;
    
    TestParams = myTest.dataMatrix(:,MajorParamsIndices);
    TestPrices = myTest.salePrice;
else
    K = 5;
    foldSize = floor(numAllSamples/K);
    foldIndex = 1;
    testStartIndex = 1 + (foldIndex-1) * foldSize;
    testEndIndex = testStartIndex + (foldSize-1);

    TrainingParams = RawParams([1:(testStartIndex-1) (testEndIndex+1):end], :);
    TrainingPrices = RawPrices([1:(testStartIndex-1) (testEndIndex+1):end], :);
    numTrainingSamples = size(TrainingParams, 1);
    
    TestParams = RawParams(testStartIndex:testEndIndex, :);
    TestPrices = RawPrices(testStartIndex:testEndIndex, :);
end

TrainingParamsN = (TrainingParams-minParams)./scaleParams;
TrainingPricesN = (TrainingPrices-minPrice)/scalePrice;
TestParamsN = (TestParams-minParams)./scaleParams;
TestPricesN = (TestPrices-minPrice)/scalePrice;

% Weights Init
Weights = cell(1, numLayers-1);
Biases = cell(1, numLayers-1);

if usePrelearnedWeights
    load(prelearnedWeightsFile, 'Weights', 'Biases');
else
    for l = 1: numLayers-1
        Weights{l} = 2*rand(numNodesPerLayer(l), numNodesPerLayer(l+1)) - 1;    
        Biases{l} = rand(1, numNodesPerLayer(l+1)) - 0.5;
        %Biases{l} = zeros(1, numNodesPerLayer(l+1));
    end
end

WeightsGrad = cell(1, numLayers-1);
BiasesGrad = cell(1, numLayers-1);

A = cell(1, numLayers);
B = cell(1, numLayers);
D = cell(1, numLayers);

numEpochIterations = 2000;

for epoch = 1: numEpochIterations
    
    for l = 1: numLayers-1
        WeightsGrad{l} = zeros(numNodesPerLayer(l), numNodesPerLayer(l+1));
        BiasesGrad{l} = zeros(1, numNodesPerLayer(l+1));
    end
    
    for s = 1: numTrainingSamples
        % feedforward
        B{1} = TrainingParamsN(s, :);
        for l = 2: numLayers
            outputLayer = l == numLayers;            
            A{l} = B{l-1} * Weights{l-1} + Biases{l-1};
            B{l} = ActivationFunc(A{l}, outputLayer);
        end
        
        % BP
        A{1} = TrainingParamsN(s, :);        
        D{numLayers} = B{numLayers} - TrainingPricesN(s);
        for l = numLayers - 1: -1: 1
            for node = 1: numNodesPerLayer(l)                
                D{l}(node) = sum(D{l+1} .* Weights{l}(node,:) .* ActivationFuncDerivative(A{l}(node), l == 1));
            end
        end
        
        %
        for l = 1: numLayers-1
            WeightsGrad{l} = WeightsGrad{l} + (B{l}'*D{l+1});
            BiasesGrad{l} = BiasesGrad{l} + D{l+1};
        end
    end
    
    for l = 1: numLayers-1
        Weights{l} = Weights{l} - ((learningRate/numTrainingSamples)*WeightsGrad{l});
        Biases{l} = Biases{l} - ((learningRate/numTrainingSamples)*BiasesGrad{l});
    end    
    
    TrainingPredN = Evaluate(TrainingParamsN, Weights, Biases);
    TrainingPred = (TrainingPredN * scalePrice) + minPrice;
    [TrainBias TrainMD TrainMAD TrainMSE] = CalculateErrorMetrics(TrainingPred, TrainingPrices);
    
    TestPredN = Evaluate(TestParamsN, Weights, Biases);
    TestPred = (TestPredN * scalePrice) + minPrice;
    [TestBias TestMD TestMAD TestMSE] = CalculateErrorMetrics(TestPred, TestPrices);    
    
    displayBias = false;
    displayMD = true;
    displayMAD = true;
    displayMSE = true;
    
    displayStrTrain = [];
    displayStrTest = [];
    
    if displayBias
        displayStrTrain = [displayStrTrain ', TrainBias: ' num2str(TrainBias)];
        displayStrTest = [displayStrTest ', TestBias: ' num2str(TestBias)];
    end
    if displayMD
        displayStrTrain = [displayStrTrain ', TrainMD: ' num2str(TrainMD)];
        displayStrTest = [displayStrTest ', TestMD: ' num2str(TestMD)];
    end
    if displayMAD
        displayStrTrain = [displayStrTrain ', TrainMAD: ' num2str(TrainMAD)];
        displayStrTest = [displayStrTest ', TestMAD: ' num2str(TestMAD)];
    end
    if displayMSE
        displayStrTrain = [displayStrTrain ', TrainMSE: ' num2str(TrainMSE)];
        displayStrTest = [displayStrTest ', TestMSE: ' num2str(TestMSE)];
    end    
    
    display(['Ep: ' num2str(epoch) displayStrTrain displayStrTest]);        
end

function fx = ActivationFunc(x, linear)
    if ~linear
        %fx = tanh(x);
        fx = 1./(1 + exp(-x));
    else
        fx = x;        
    end    
end

function fx = ActivationFuncDerivative(x, linear)
    if ~linear
        %fx = 1 - tanh(x).^2;
        fx = exp(-x)/(exp(-x) + 1).^2;
    else
        fx = ones(size(x));
    end
end

function Yeval = Evaluate(X, W, B)
    N = size(X, 1);
    
    Yeval = zeros(N, 1);
    
    for s = 1: N
        result = X(s, :);
        for l = 1: size(B, 2)
            result = ActivationFunc(result * W{l} + B{l}, l == size(B, 2));
        end
        
        Yeval(s) = result;
    end
end

function [Bias MD MAD MSE] = CalculateErrorMetrics(Pred, Actual)
    diff = Pred - Actual;
    absDiff = abs(diff);
    Bias = mean(diff);
    MD = max(absDiff);
    MAD = mean(absDiff);
    MSE = mean(diff.*diff);
end