classdef AMES
    %AMESDATA 이 클래스의 요약 설명 위치
    %   자세한 설명 위치
    properties
        compressedMat
        data
        discrete
        ordinal
        nominal
        continuous
        raw
        dataMatrix
        salePrice
        salePriceB
    end
    properties
        rawR
        rawC
    end
    
    methods
        
    end
    
    methods
        function obj=AMES(rawData)
            disp("DataProcessing");
            drawnow;
            %%%Initialize Class Variables
            [obj.rawR, obj.rawC]=size(rawData);
            obj.data=table;
            obj.raw=rawData;
            obj.continuous={};
            obj.nominal={};
            obj.discrete={};
            obj.ordinal={};
            j=1;
            i=2;
            while (i<=obj.rawC)
                prcoess=i/obj.rawC
                dim=1;
                varName=rawData.Properties.VariableNames{i};
                %%Nominal: 1, 2, 5, 6, 10, 12, 13, 14, 15, 20
                if strcmp(varName,'MSSubClass')  %2 (5)
                    [result, dim]=my_one_hot(obj.raw.MSSubClass, 'MSSubClass');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'MSZoning')  %2 (5)
                    [result, dim]=my_one_hot(obj.raw.MSZoning, 'MSZoning');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Street') %5 (2)
                    [result, dim]=my_one_hot(obj.raw.Street, 'Street');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Alley') %6 (3)
                    [result, dim]=my_one_hot(obj.raw.Alley, 'Alley');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'LotConfig') %10 (5)
                    [result, dim]=my_one_hot(obj.raw.LotConfig, 'LotConfig');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Neighborhood') %12 (25)
                    [result, dim]=my_one_hot(obj.raw.Neighborhood, 'Neighborhood');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Condition1') %13
                    [result, dim]=my_one_hot_sp(obj.raw.Condition1, obj.raw.Condition2, 'Condition');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                    i=i+1;
                elseif strcmp(varName,'BldgType') %14
                    [result, dim]=my_one_hot(obj.raw.BldgType, 'BldgType');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];    
                elseif strcmp(varName,'HouseStyle') %15
                    [result, dim]=my_one_hot(obj.raw.HouseStyle, 'HouseStyle');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'RoofStyle') %20
                    [result, dim]=my_one_hot(obj.raw.RoofStyle, 'RoofStyle');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'RoofMatl') %21
                    [result, dim]=my_one_hot(obj.raw.RoofStyle, 'RoofMatl');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]]; 
                elseif strcmp(varName,'Exterior1st') %22
                    [result, dim]=my_one_hot_sp(obj.raw.Exterior1st, obj.raw.Exterior2nd, 'Exterior');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                    i=i+1;    
                elseif strcmp(varName,'MasVnrType') %23
                    [result, dim]=my_one_hot(obj.raw.RoofStyle, 'MasVnrType');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Foundation') %27
                    [result, dim]=my_one_hot(obj.raw.Foundation, 'Foundation');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Heating') %27
                    [result, dim]=my_one_hot(obj.raw.Heating, 'Heating');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]]; 
                elseif strcmp(varName,'Electrical') %27
                    [result, dim]=my_one_hot(obj.raw.Electrical, 'Electrical');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'MiscFeature') %27
                    [result, dim]=my_one_hot(obj.raw.MiscFeature, 'MiscFeature');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'SaleType') %27
                    [result, dim]=my_one_hot(obj.raw.SaleType, 'SaleType');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]]; 
                elseif strcmp(varName,'SaleCondition') %27
                    [result, dim]=my_one_hot(obj.raw.SaleCondition, 'SaleCondition');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];                     
                    
                %%Ordinal: 7, 8, 9, 11, 16, 17, 25, 26
                elseif strcmp(varName,'LotShape') %7
                    result=my_ordinal(obj.raw.LotShape, {'IR3', 'IR2', 'IR1', 'Reg'}, 'LotShape');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'LandContour') %8
                    result=my_ordinal(obj.raw.LandContour, {'Low', 'HLS', 'Bnk', 'Lvl'}, 'LandContour');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];      
                elseif strcmp(varName,'Utilities') %9
                    result=my_ordinal(obj.raw.Utilities, {'ELO', 'NoSeWa', 'NoSewr', 'AllPub'}, 'Utilities');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];      
                elseif strcmp(varName,'LandSlope') %11
                    result=my_ordinal(obj.raw.LandSlope, {'Sev', 'Mod', 'Gtl'}, 'LandSlope');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'OverallQual') %16
                    obj.data(:,j)=rawData(:,i);
                    obj.data.Properties.VariableNames(j)=rawData.Properties.VariableNames(i);
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'OverallCond') %17
                    obj.data(:,j)=rawData(:,i);
                    obj.data.Properties.VariableNames(j)=rawData.Properties.VariableNames(i);
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'ExterQual') %25
                    result=my_ordinal(obj.raw.ExterQual, {'Po', 'Fa', 'TA', 'Gd', 'Ex'}, 'ExterQual');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'ExterCond') %26
                    result=my_ordinal(obj.raw.ExterCond, {'Po', 'Fa', 'TA', 'Gd', 'Ex'}, 'ExterCond');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'BsmtQual') %28
                    result=my_ordinal(obj.raw.BsmtQual, {'NA', 'Po', 'Fa', 'TA', 'Gd', 'Ex'}, 'BsmtQual');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];     
                elseif strcmp(varName,'BsmtCond') %29
                    result=my_ordinal(obj.raw.BsmtCond, {'NA', 'Po', 'Fa', 'TA', 'Gd', 'Ex'}, 'BsmtCond');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j]; 
                elseif strcmp(varName,'BsmtExposure') %30
                    result=my_ordinal(obj.raw.BsmtExposure, {'NA', 'Po', 'Fa', 'TA', 'Gd', 'Ex'}, 'BsmtExposure');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'BsmtFinType1') %29
                    result=my_ordinal(obj.raw.BsmtFinType1, {'NA', 'Unf', 'LwQ', 'Rec', 'BLQ', 'ALQ', 'GLQ'}, 'BsmtFinType1');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];                    
                elseif strcmp(varName,'BsmtFinType2') %29
                    result=my_ordinal(obj.raw.BsmtFinType2, {'NA', 'Unf', 'LwQ', 'Rec', 'BLQ', 'ALQ', 'GLQ'}, 'BsmtFinType2');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'HeatingQC') %26
                    result=my_ordinal(obj.raw.HeatingQC, {'Po', 'Fa', 'TA', 'Gd', 'Ex'}, 'HeatingQC');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];    
                elseif strcmp(varName,'CentralAir') %26
                    result=my_ordinal(obj.raw.CentralAir, {'Y', 'N'}, 'CentralAir');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];                       
                elseif strcmp(varName,'KitchenQual') %26
                    result=my_ordinal(obj.raw.KitchenQual, {'Po', 'Fa', 'TA', 'Gd', 'Ex'}, 'KitchenQual');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];  
                elseif strcmp(varName,'Functional') %26
                    result=my_ordinal(obj.raw.Functional, {'Sal', 'Sev', 'Maj2', 'Maj1', 'Mod', 'Min2', 'Min1', 'Typ'}, 'Functional');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];     
                elseif strcmp(varName,'FireplaceQu') %30
                    result=my_ordinal(obj.raw.FireplaceQu, {'NA', 'Po', 'Fa', 'TA', 'Gd', 'Ex'}, 'FireplaceQu');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'GarageType') %30
                    result=my_ordinal(obj.raw.GarageType, {'NA', 'Detchd', 'CarPort', 'BuiltIn', 'Basement', 'Attchd', '2Types'}, 'GarageType');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];                 
                elseif strcmp(varName,'GarageFinish') %29
                    result=my_ordinal(obj.raw.GarageFinish, {'NA', 'Unf', 'RFn', 'Fin'}, 'GarageFinish');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'GarageQual') %30
                    result=my_ordinal(obj.raw.GarageQual, {'NA', 'Po', 'Fa', 'TA', 'Gd', 'Ex'}, 'GarageQual');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'GarageCond') %30
                    result=my_ordinal(obj.raw.GarageCond, {'NA', 'Po', 'Fa', 'TA', 'Gd', 'Ex'}, 'GarageCond');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                elseif strcmp(varName,'PavedDrive') %30
                    result=my_ordinal(obj.raw.PavedDrive, {'N', 'P', 'Y'}, 'PavedDrive');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                 elseif strcmp(varName,'PoolQC') %30
                    result=my_ordinal(obj.raw.PoolQC, {'NA', 'Fa', 'TA', 'Gd', 'Ex'}, 'PoolQC');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];
                 elseif strcmp(varName,'Fence') %30
                    result=my_ordinal(obj.raw.Fence, {'NA', 'MnWw', 'GdWo', 'MnPrv', 'GdPrv'}, 'Fence');
                    obj.data=[obj.data result];
                    obj.ordinal=[obj.ordinal; j];                    
                    
                %%Continuous: 3, 4, 24
                %%Discrete: 18, 19
                else
                    obj.data(:,j)=rawData(:,i);
                    obj.data.Properties.VariableNames(j)=rawData.Properties.VariableNames(i);
                    if (strcmp(varName,'LotFrontage') || strcmp(varName,'LotArea') )
                        obj.continuous=[obj.continuous; j];
                    elseif(strcmp(varName,'MasVnrArea')|| strcmp(varName,'BsmtFinSF1')|| strcmp(varName,'BsmtFinSF2'))
                        obj.continuous=[obj.continuous; j];
                    elseif (strcmp(varName,'BsmtUnfSF')||strcmp(varName,'BsmtUnfSF')||strcmp(varName,'TotalBsmtSF'))
                        obj.continuous=[obj.continuous; j];
                    elseif (strcmp(varName,'stFlrSF')||strcmp(varName,'ndFlrSF')||strcmp(varName,'LowQualFinSF')||strcmp(varName,'GrLivArea'))
                        obj.continuous=[obj.continuous; j];                      
                    elseif (strcmp(varName,'GarageArea')||strcmp(varName,'WoodDeckSF')||strcmp(varName,'OpenPorchSF'))
                        obj.continuous=[obj.continuous; j];                      
                    elseif (strcmp(varName,'EnclosedPorch')||strcmp(varName,'SsnPorch')||strcmp(varName,'ScreenPorch'))
                        obj.continuous=[obj.continuous; j];                      
                    elseif (strcmp(varName,'PoolArea')||strcmp(varName,'MiscVal')||strcmp(varName,'SalePrice'))
                        obj.continuous=[obj.continuous; j];   
                    else
                        obj.discrete=[obj.discrete; j];
                    end
                end
                j=j+dim;
                i=i+1;
            end
            
            %Matrix Form Data
            obj.dataMatrix=table2array(obj.data);
            col=size(obj.dataMatrix, 2);
            obj.salePrice=obj.dataMatrix(:,col);
            obj.dataMatrix=obj.dataMatrix(:,1:col-1);
            %Sale Price Binary
            obj.salePriceB=double(obj.salePrice>=160000);
            
            %Data Standardization
            meanVec=mean(obj.dataMatrix);
            compressedMat=obj.dataMatrix-meanVec;
            maxVec=max(compressedMat);
            minVec=min(compressedMat);
            maxminusminVec=maxVec-minVec;
            compressedMat=(compressedMat-minVec)./maxminusminVec;
            range=2;
            obj.compressedMat=compressedMat.*range-1;
            
            disp("Processing Done");
            drawnow;
        end
        
        
        
    end

end

