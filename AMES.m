classdef AMES
    %AMESDATA 이 클래스의 요약 설명 위치
    %   자세한 설명 위치
    properties
      compressedData
      data
      discrete
      ordinal
      nominal
      continuous
      raw
    end
    properties
        rawR
        rawC
    end
    
    methods

    end
    
    methods
        function obj=AMES(rawData)
            [obj.rawR, obj.rawC]=size(rawData);
            obj.data=table;
            obj.raw=rawData;
            j=1;
            for i=1:obj.rawC
                dim=0;
                varName=rawData.Properties.VariableNames{i};
                %Nominal: 1, 2, 5, 6
                if strcmp(varName,'MSZoning')  %2 (5)
                    [result, dim]=my_one_hot(obj.raw.MSZoning, 'MSZoning');
                    obj.data=[obj.data result];
                elseif strcmp(varName,'Street') %5 (2)
                    [result, dim]=my_one_hot(obj.raw.Street, 'Street');
                    obj.data=[obj.data result];
                elseif strcmp(varName,'Alley') %6 (3)
                    [result, dim]=my_one_hot(obj.raw.Alley, 'Alley');
                    obj.data=[obj.data result];
                %Ordinal: 
                
                %Continuous: 3, 4
                %Discrete:
                else
                    obj.data(:,j)=rawData(:,i);
                    obj.data.Properties.VariableNames(j)=rawData.Properties.VariableNames(i);
                    dim=1;
                end
                j=j+dim;
            end
        end
        

        
    end
    
end

