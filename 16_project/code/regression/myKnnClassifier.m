classdef myKnnClassifier
    %MYKNNCLASSIFIER 이 클래스의 요약 설명 위치
    %   자세한 설명 위치
    
    properties
        regressionResult
        regressionMSE, regressionBias, regressionMaxDev, regressionMAD
        classifierResult
        classifierPrecision
        classifierNumCorrect
    end
    
    methods
        function obj=myKnnClassifier(trainingdata, trainingPrice, traininglabel, testdata, testPrice, testlabel, k)
            [trainingrow trainingcol]=size(trainingdata);
            [testrow testcol]=size(testdata);
            obj.classifierResult=zeros(testrow, 1);
            testTranspose=transpose(testdata);
            for i=1:testrow
                nearestNeighbor(1:k, 1:4)=10000;
                for j=1:trainingrow
                    distance=norm(trainingdata(j,:)-testdata(i,:));
                    [maxval, maxarg]=max(nearestNeighbor);
                    if maxval(1, 1)>distance
                        nearestNeighbor(maxarg(1),:)=[distance, j, trainingPrice(j,1), traininglabel(j,1)];
                    end
                end
                modeval=mode(nearestNeighbor);
                obj.classifierResult(i, 1)=modeval(1,4);
                meaneval=mean(nearestNeighbor);
                obj.regressionResult(i,1)=meaneval(1,3);
            end
            
            %obj.regressionMSE=norm(obj.regressionResult-testPrice)/testrow;
            predmreal=obj.regressionResult-testPrice;
            obj.regressionMSE=mean(predmreal.*predmreal);
            obj.regressionBias=mean(predmreal);
            obj.regressionMaxDev=max(abs(predmreal));
            obj.regressionMAD=mean(abs(predmreal));
            numCorrect=0;
            for i=1:testrow
                if obj.classifierResult(i,1)==testlabel(i,1)
                    numCorrect=numCorrect+1;
                end
            end
            obj.classifierNumCorrect=numCorrect;
            obj.classifierPrecision=numCorrect/testrow;
        end
        function showResult(obj)
            fprintf("Bias: %d\n", obj.regressionBias);
            fprintf("Maximum Deviation: %d\n", obj.regressionMaxDev);
            fprintf("Mean Absolute Deviation: %d\n", obj.regressionMAD);
            fprintf("Mean Square Error: %d\n", obj.regressionMSE);
            
            drawnow;
        end
    end
    
end

