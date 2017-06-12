rawData = importfile('../../data/ml_project_train.csv');
myData = AMES(rawData);
myData.dataMatrix = myData.postProcess(myData.zeroList);

%testDataFile = '../../data/ml_project_train.csv';
testDataFile = '../../data/ml_project_test_ensemble.csv'; % 5개의 앙상블모델 학습에 사용되지 않은 데이타

MajorParamsIndices = [2 3 7 8 10 11 16 17 19 20 22 23 24 26 27 28 30 32 40 41 43 44 45 47 49 52 54 59 62 63 65 67 73 75 79 88 92 95 97 98 99 104 105 108 109 116 118 119 130 131 135 140 143 144 145 150 151 154 159 161 171 172 173 174 175 180 183 186 189 190 193 194 195];
RawParams = myData.dataMatrix(:,MajorParamsIndices);
RawPrices = myData.salePrice;
    
RawLabels = RawPrices >= 160000;

minParams = min(RawParams);
maxParams = max(RawParams);
scaleParams = maxParams - minParams;

rawTest = importfile(testDataFile);
myTest = AMES(rawTest);
myTest.dataMatrix = myTest.postProcess(myData.zeroList);
    
TestParams = myTest.dataMatrix(:,MajorParamsIndices);
TestLabels = myTest.salePrice >= 160000;

TestParamsN = (TestParams-minParams)./scaleParams;

load('ffnEnsembleWeights', 'WeightsSet', 'BiasesSet');

numModels = size(WeightsSet, 2);
TotalPred = [];
for m = 1: numModels
    TestPred = Evaluate(TestParamsN, WeightsSet{m}, BiasesSet{m});
    TestPred = TestPred >= 0.5;
    TestPerf = mean(abs(TestPred-TestLabels));
    TotalPred = [TotalPred TestPred];

    display(['ModelNo: ' num2str(m) ', TestPerf = ' num2str(TestPerf)]);
end

TotalPred = sum(TotalPred, 2) > (floor(numModels/2));
TotalPerf = mean(abs(TotalPred-TestLabels));
display(['EnsemblePerf = ' num2str(TotalPerf)]);

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