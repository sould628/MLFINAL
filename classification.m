%RawTable = importfile('ml_project_train.csv');
%RawParams = table2array(RawTable(:, [4, 5, 18, 19, 20, 21 27, 39, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 55]));
%RawPrices = table2array(RawTable(:, size(RawTable, 2)));

% rawData = importfile('ml_project_train.csv');
% myData = AMES(rawData);
% myData.dataMatrix = myData.postProcess(myData.zeroList);

%RawParams = myData.dataMatrix;
RawParams = myData.dataMatrix(:,MajorParamsIndices);
RawPrices = myData.salePrice;

RawLabels = RawPrices >= 160000;

minParams = min(RawParams);
maxParams = max(RawParams);
scaleParams = maxParams - minParams;

learningRate = 0.1;

numAllSamples = size(RawParams, 1);
numInputNodes = size(RawParams, 2);
%numHiddenNodes = [ceil(numInputNodes/2) ceil(numInputNodes/2)];
numHiddenNodes = [numInputNodes];
numOutputNodes = 1;
numNodesPerLayer = [numInputNodes numHiddenNodes numOutputNodes];
numLayers = length(numHiddenNodes) + 2;

K = 5;
foldSize = floor(numAllSamples/K);
foldIndex = 1;
testStartIndex = 1 + (foldIndex-1) * foldSize;
testEndIndex = testStartIndex + (foldSize-1);

TrainingParams = RawParams([1:(testStartIndex-1) (testEndIndex+1):end], :);
TrainingLabels = RawLabels([1:(testStartIndex-1) (testEndIndex+1):end], :);
numTrainingSamples = size(TrainingParams, 1);

TestParams = RawParams(testStartIndex:testEndIndex, :);
TestLabels = RawLabels(testStartIndex:testEndIndex, :);

TrainingParamsN = (TrainingParams-minParams)./scaleParams;
TestParamsN = (TestParams-minParams)./scaleParams;

% Weights Init
Weights = cell(1, numLayers-1);
Biases = cell(1, numLayers-1);

for l = 1: numLayers-1
    Weights{l} = 2*rand(numNodesPerLayer(l), numNodesPerLayer(l+1)) - 1;    
    Biases{l} = rand(1, numNodesPerLayer(l+1)) - 0.5;
    %Biases{l} = zeros(1, numNodesPerLayer(l+1));
end

WeightsGrad = cell(1, numLayers-1);
BiasesGrad = cell(1, numLayers-1);

A = cell(1, numLayers);
B = cell(1, numLayers);
D = cell(1, numLayers);

numEpochIterations = 1000;

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
        %D{numLayers} = ActivationFuncDerivative(TargetValues(s) - B{numLayers}, true);
        %D{numLayers} = sign(ActivationFuncDerivative(TargetValues(s) - B{numLayers}, true));
        D{numLayers} = ActivationFuncDerivative(A{numLayers});
        if B{numLayers} < TrainingLabels(s)
            D{numLayers} = -D{numLayers};
        end
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
    
    TrainingPred = Evaluate(TrainingParamsN, Weights, Biases);
    TrainingPred = TrainingPred >= 0.5;
    TrainPerf = mean(abs(TrainingPred-TrainingLabels));
        
    TestPred = Evaluate(TestParamsN, Weights, Biases);
    TestPred = TestPred >= 0.5;
    TestPerf = mean(abs(TestPred-TestLabels));
        
    display(['Epoch = ' num2str(epoch) ', TrainPerf = ' num2str(TrainPerf) ', TestPerf = ' num2str(TestPerf)]);
end

function fx = ActivationFunc(x, linear)
    fx = 1./(1 + exp(-x));
end

function fx = ActivationFuncDerivative(x, linear)
    fx = exp(-x)/(exp(-x) + 1).^2;
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