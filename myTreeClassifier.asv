classdef myTreeClassifier
    %MYTREECLASSIFIER 이 클래스의 요약 설명 위치
    %   자세한 설명 위치
    
    properties
        cont, ord, disc
        data
    end
    
    methods
        function obj=myTreeClassifier(data)
            obj.data=data.dataMatrix;
            obj.cont=cell2mat(data.continuous);
            obj.ord=cell2mat(data.ordinal);
            obj.disc=cell2mat(data.discrete);
        end
        
        function Ent = getEntropy(obj, targetAttrib);
            entropyRange=0;
            if any(abs(obj.cont-targetAttrib)<1e-10)
                disp("Continuous Attribute");
                drawnow;
            elseif any(abs(obj.ord-targetAttrib)<1e-10)
                disp("Ordinal Attribute");
                drawnow;
            elseif any(abs(obj.disc-targetAttrib)<1e-10)
                disp("Discrete Attribute");
                drawnow;
            else
                disp("Nominal Attribute");
                drawnow;
                entropyRange=2;
            end            
        end
        
        
    end
    
end

