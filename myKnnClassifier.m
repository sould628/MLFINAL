classdef myKnnClassifier
    %MYKNNCLASSIFIER 이 클래스의 요약 설명 위치
    %   자세한 설명 위치
    
    properties
        result
        precision
        numCorrect
    end
    
    methods
        function obj=myKnnClassifier(trainingdata, traininglabel, testdata, testlabel, k)
            [trainingrow trainingcol]=size(trainingdata);
            [testrow testcol]=size(testdata);
            obj.result=zeros(testrow, 1);
            testTranspose=transpose(testdata);
            for i=1:testrow
                nearestNeighbor(1:k, 1:3)=10000;
                for j=1:trainingrow
                    distance=sqrt(trainingdata(j,:)*testTranspose(:,i));
                    [maxval, maxarg]=max(nearestNeighbor);
                    if maxval(1, 1)>distance
                        nearestNeighbor(maxarg(1),:)=[distance, j, traininglabel(j,1)];
                    end
                end
                modeval=mode(nearestNeighbor);
                obj.result(i, 1)=modeval(1,3);
            end
            numCorrect=0;
            for i=1:testrow
                if obj.result(i,1)==testlabel(i,1)
                    numCorrect=numCorrect+1;
                end
            end
            obj.numCorrect=numCorrect;
            obj.precision=numCorrect/testrow;
        end
        
    end
    
end

