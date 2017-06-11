%rawTable = importfile('ml_project_train.csv');

%RawSamples = table2array(rawTable(:, [4, 5, 18, 19, 20, 21 27, 39, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 55]));
%RawTargetValues = table2array(rawTable(:, size(rawTable, 2)));

RawSamples = myData.dataMatrix;
RawTargetValues = myData.salePrice;

minSamples = min(RawSamples);
maxSamples = max(RawSamples);
scaleSamples = maxSamples - minSamples;

minTarget = min(RawTargetValues);
maxTarget = max(RawTargetValues);
scaleTarget = maxTarget - minTarget;

Samples = ((RawSamples - minSamples)./scaleSamples);
TargetValues = ((RawTargetValues - minTarget)./scaleTarget);
%Samples = table2array(rawTable(:, [4, 5, 18, 19, 20, 21 27, 39, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 55]));
%TargetValues = table2array(rawTable(:, size(rawTable, 2)));

%net = feedforwardnet([size(X, 1), size(X, 1), size(X, 1)]);
% net.trainParam.showWindow = true;
% net.trainParam.epochs = 1000;
% 
% [net, tr] = train(net, X, Y);
% Yapp = sim(net, X);

learningRate = 0.05;

%numInputNodes = size(X, 1);
numSamples = size(Samples, 1);
numInputNodes = size(Samples, 2);
%numHiddenNodes = [ceil(numInputNodes/2) ceil(numInputNodes/2)];
numHiddenNodes = [numInputNodes];
numOutputNodes = 1;
numNodesPerLayer = [numInputNodes numHiddenNodes numOutputNodes];
numLayers = length(numHiddenNodes) + 2;

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
    
    for s = 1: numSamples
        % feedforward
        B{1} = Samples(s, :);
        for l = 2: numLayers
            outputLayer = l == numLayers;            
            A{l} = B{l-1} * Weights{l-1} + Biases{l-1};
            B{l} = ActivationFunc(A{l}, outputLayer);
        end
        
        % BP
        A{1} = Samples(s, :);
        %D{numLayers} = ActivationFuncDerivative(TargetValues(s) - B{numLayers}, true);
        %D{numLayers} = sign(ActivationFuncDerivative(TargetValues(s) - B{numLayers}, true));        
        D{numLayers} = B{numLayers} - TargetValues(s);
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
        Weights{l} = Weights{l} - ((learningRate/numSamples)*WeightsGrad{l});
        Biases{l} = Biases{l} - ((learningRate/numSamples)*BiasesGrad{l});
    end    
    
    TargetEval = Evaluate(Samples, Weights, Biases);
    %MSE = MeasureError(Samples, TargetValues, Weights, Biases);
    diff = (TargetValues - TargetEval);
    display(['Epochs = ' num2str(epoch) ', MSE = ' num2str(sum(diff.*diff)/numSamples)]);
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

function MSE = MeasureError(X, Y, W, B)
    N = size(X, 1);
    MSE = 0;
        
    for s = 1: N
        result = X(s, :);
        for l = 1: size(B, 2)
            result = ActivationFunc(result * W{l} + B{l}, l == size(B, 2));
        end
        
        diff = result - Y(s);
        MSE = MSE + (diff*diff);
    end
    
    MSE = MSE / N;    
end
    