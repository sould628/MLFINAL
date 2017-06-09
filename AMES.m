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
            %%%Initialize Class Variables
            [obj.rawR, obj.rawC]=size(rawData);
            obj.data=table;
            obj.raw=rawData;
            obj.continuous={};
            obj.nominal={};
            obj.discrete={};
            obj.ordinal={};
            j=1;
            for i=1:obj.rawC
                dim=0;
                varName=rawData.Properties.VariableNames{i};
                %%Nominal: 1, 2, 5, 6
                if strcmp(varName,'MSZoning')  %2 (5)
                    [result, dim]=my_one_hot(obj.raw.MSZoning, 'MSZoning');
                    obj.data=[obj.data result];
                    for k=1:dim
                        obj.nominal=[obj.nominal, j+k];
                    end
                elseif strcmp(varName,'Street') %5 (2)
                    [result, dim]=my_one_hot(obj.raw.Street, 'Street');
                    obj.data=[obj.data result];
                    for k=1:dim
                        obj.nominal=[obj.nominal, j+k];
                    end
                elseif strcmp(varName,'Alley') %6 (3)
                    [result, dim]=my_one_hot(obj.raw.Alley, 'Alley');
                    obj.data=[obj.data result];
                    for k=1:dim
                        obj.nominal=[obj.nominal, j+k];
                    end
                    
                %%Ordinal: 7
                elseif strcmp(varName,'LotShape') %6 (3)
                    [result, dim]=my_one_hot(obj.raw.LotShape, 'LotShape');
                    obj.data=[obj.data result];
                    for k=1:dim
                        obj.ordinal=[obj.ordinal, j+k];
                    end                    
                    %%Continuous: 3, 4
                    %%Discrete:
                else
                    obj.data(:,j)=rawData(:,i);
                    obj.data.Properties.VariableNames(j)=rawData.Properties.VariableNames(i);
                    dim=1;
                    if (i==3) || (i==4)
                        obj.continuous=[obj.continuous, j];
                    else
                        obj.discrete=[obj.discrete, j];
                    end
                end
                j=j+dim;
            end
        end
        
        
        
    end
    
end

