classdef AMES
    %AMESDATA 이 클래스의 요약 설명 위치
    %   자세한 설명 위치
    properties
        raw, data
        dataMatrix, dataMatrixzc, compressedMat
        discrete, ordinal, nominal, continuous
        salePrice, salePriceB
        zeroList, varList
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
                    cat={'20'; '30'; '40'; '45'; '50'; '60'; '70'; '75'; '80'; '85'; '90'; '120'; '150'; '160'; '180'; '190'};
                    [result, dim]=my_one_hot(obj.raw.MSSubClass, cat, 'MSSubClass');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'MSZoning')  %2 (5)
                    cat={'A'; 'C (all)'; 'FV'; 'I'; 'RH'; 'RL'; 'RP'; 'RM'};
                    [result, dim]=my_one_hot(obj.raw.MSZoning, cat, 'MSZoning');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Street') %5 (2)
                    cat={'Grvl'; 'Pave'};
                    [result, dim]=my_one_hot(obj.raw.Street, cat, 'Street');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Alley') %6 (3)
                    cat={'Grvl'; 'Pave'; 'NA' };
                    [result, dim]=my_one_hot(obj.raw.Alley, cat, 'Alley');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'LotConfig') %10 (5)
                    cat={'Inside'; 'Corner'; 'CulDSac'; 'FR2'; 'FR3'};
                    [result, dim]=my_one_hot(obj.raw.LotConfig, cat, 'LotConfig');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Neighborhood') %12 (25)
                    cat={'Blmngtn'; 'Blueste'; 'BrDale'; 'BrkSide'; 'ClearCr'; 'CollgCr'; 'CrawFor'; 'Edwards'; 'Gilbert'; 'IDOTRR'; 'MeadowV'; 'Mitchel'; 'Names'; 'NoRidge'; 'NPkVill'; 'NridgHt'; 'NWAmes'; 'OldTown'; 'SWISU'; 'Sawyer'; 'SawyerW'; 'Somerst'; 'StoneBr'; 'Timber'; 'Veenker'};
                    [result, dim]=my_one_hot(obj.raw.Neighborhood, cat, 'Neighborhood');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Condition1') %13
                    cat={'Artery'; 'Feedr'; 'Norm'; 'RRNn'; 'RRAn'; 'PosN'; 'PosA'; 'RRNe'; 'RRAe'};
                    [result, dim]=my_one_hot_sp(obj.raw.Condition1, obj.raw.Condition2, cat, 'Condition');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                    i=i+1;
                elseif strcmp(varName,'BldgType') %14
                    cat={'1Fam'; '2FmCon'; 'Duplex'; 'TwnhsE'; 'TwnhsI'};
                    [result, dim]=my_one_hot(obj.raw.BldgType, cat, 'BldgType');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];    
                elseif strcmp(varName,'HouseStyle') %15
                    cat={'1Story'; '1.5Fin'; '1.5Unf'; '2Story'; '2.5Fin'; '2.5Unf'; 'SFoyer'; 'SLvl'};
                    [result, dim]=my_one_hot(obj.raw.HouseStyle, cat, 'HouseStyle');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'RoofStyle') %20
                    cat={'Flat'; 'Gable'; 'Gambrel'; 'Hip'; 'Mansard'; 'Shed'};
                    [result, dim]=my_one_hot(obj.raw.RoofStyle, cat, 'RoofStyle');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'RoofMatl') %21
                    cat={'ClyTile'; 'CompShg'; 'Membran'; 'Metal'; 'Roll'; 'Tar&Grv'; 'WdShake'; 'WdShngl'};
                    [result, dim]=my_one_hot(obj.raw.RoofStyle, cat, 'RoofMatl');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]]; 
                elseif strcmp(varName,'Exterior1st') %22
                    cat={'AsbShng'; 'AsphShn'; 'BrkFace'; 'CBlock'; 'CemntBd'; 'HdBoard';'ImStucc';'MetalSd';'Other';'Plywood';'PreCast';'Stone';'Stucco';'VinylSd';'Wd Sdng'; 'WdShing'};
                    [result, dim]=my_one_hot_sp(obj.raw.Exterior1st, obj.raw.Exterior2nd, cat, 'Exterior');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                    i=i+1;    
                elseif strcmp(varName,'MasVnrType') %23
                    cat={'BrkCmn'; 'BrkFace'; 'CBlock'; 'None'; 'Stone'};
                    [result, dim]=my_one_hot(obj.raw.RoofStyle, cat, 'MasVnrType');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Foundation') %27
                    cat={'BrkTil'; 'CBlock'; 'PConc'; 'Slab'; 'Stone'; 'Wood'};
                    [result, dim]=my_one_hot(obj.raw.Foundation, cat, 'Foundation');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'Heating') %27
                    cat={'Floor'; 'GasA'; 'GasW'; 'Grav'; 'OthW'; 'Wall'};
                    [result, dim]=my_one_hot(obj.raw.Heating, cat, 'Heating');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]]; 
                elseif strcmp(varName,'Electrical') %27
                    cat={'SBrkr'; 'FuseA'; 'FuseF'; 'FuseP'; 'Mix'};
                    [result, dim]=my_one_hot(obj.raw.Electrical, cat, 'Electrical');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'GarageType') %30
                    cat={'2Types'; 'Attchd'; 'Basment'; 'BuiltIn'; 'CarPort'; 'Detchd'; 'NA'};
                    [result, dim]=my_one_hot(obj.raw.GarageType, cat, 'GarageType');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'MiscFeature') %27
                    cat={'Elev'; 'Gar2'; 'Othr'; 'Shed'; 'TenC'; 'NA'};
                    [result, dim]=my_one_hot(obj.raw.MiscFeature, cat, 'MiscFeature');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]];
                elseif strcmp(varName,'SaleType') %27
                    cat={'WD'; 'CWD'; 'VWD'; 'New'; 'COD'; 'Con'; 'ConLw'; 'ConLI'; 'ConLD'; 'Oth'};
                    [result, dim]=my_one_hot(obj.raw.SaleType, cat, 'SaleType');
                    obj.data=[obj.data result];
                    obj.nominal=[obj.nominal; [j,j+dim-1]]; 
                elseif strcmp(varName,'SaleCondition') %27
                    cat={'Normal'; 'Abnorml'; 'AdjLand'; 'Alloca'; 'Family'; 'Partial'};
                    [result, dim]=my_one_hot(obj.raw.SaleCondition, cat, 'SaleCondition');
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
            obj.dataMatrixzc=table2array(obj.data);
            col=size(obj.dataMatrixzc, 2);
            obj.salePrice=obj.dataMatrixzc(:,col);
            obj.dataMatrixzc=obj.dataMatrixzc(:,1:col-1);
            %Sale Price Binary
            obj.salePriceB=double(obj.salePrice>=160000);
            
            %Data Standardization

            
            obj.zeroList=findzeros(obj);
            
            disp("Processing Done");
            drawnow;
        end
        
        function zeroList=findzeros(obj)
            zeroList=any(obj.dataMatrixzc);
        end
        function [dataMatrix, dataVariable]=postProcess(obj, zeroList)
            dataVariable=[];
            numCol=size(zeroList, 2);
            dataMatrix=obj.dataMatrixzc;
            i=1;
            j=1;
            while i<=numCol
                varname=obj.data.Properties.VariableNames(i);
                if zeroList(1, i)==0
                    dataMatrix(:, j)=[];
                    i=i+1;
                else
                    i=i+1;
                    j=j+1;                   
                    dataVariable=[dataVariable; varname];
                end
            end
        end
        function compressedMat=standardize(obj)
            numAttrib=size(obj.dataMatrix,2);
            meanVec=mean(obj.dataMatrix);
            %compressedMat=obj.dataMatrix;
            compressedMat=obj.dataMatrix-meanVec;
            maxVec=max(compressedMat);
            minVec=min(compressedMat);
            maxminusminVec=maxVec-minVec;
            for i=1:numAttrib
                if maxminusminVec(1,i)==0
                    maxminusminVec(1,i)=1;
                end
            end
            compressedMat=(compressedMat-minVec)./maxminusminVec;
            range=2;
            compressedMat=compressedMat.*range-1;
        end
    end

end

function result= my_ordinal( input, valueset, attribName )
%MY_ORDINAL 이 함수의 요약 설명 위치
%   자세한 설명 위치
rawR=size(input,1);
result=zeros(rawR, 1);
for i=1:length(valueset)
    for j=1:rawR
        if strcmp(valueset(i), char(input(j,1)))
            result(j)=i-1;
        end
    end
end
result=array2table(result);
result.Properties.VariableNames(1)=cellstr(attribName);

end


function [ result, j ] = my_one_hot( input, cat, attribName )
%MY_ONE_HOT 이 함수의 요약 설명 위치
%   자세한 설명 위치
%One-Hot Encoding

%cat=categories(input);
j=size(cat,1 ); %#ok<ASGLU>
rawR=size(input,1);
result=zeros(rawR, j);
for k=1:rawR
    for z=1:j
        if strcmp(char(input(k,1)), cat{z})
            result(k, z)=1;
            break;
        else
        end
    end
end
result=array2table(result);
for z=1:j
    varname=strcat(attribName,"_",char(cat{z}));
    if contains(varname, '(')
        varname=strrep(varname, '(', '_');
    end
    if contains(varname, ')')
        varname=strrep(varname, ')', '_');
    end
    if contains(varname, '_')
        varname=strrep(varname, ' ', '_');
    end
    if contains(varname, '.')
        varname=strrep(varname, '.', '_');
    end
    if contains(varname, '&')
        varname=strrep(varname, '&', '_');
    end
    result.Properties.VariableNames(z)=cellstr(varname);
end

end

function [ result, j ] = my_one_hot_sp( input, input2, cat, attribName )
%MY_ONE_HOT_SP 이 함수의 요약 설명 위치
%   자세한 설명 위치

%cat=categories(input);
j=size(cat,1 );
rawR=size(input,1);
result=zeros(rawR, j);
for k=1:rawR
    for z=1:j
        if strcmp(char(input(k,1)), cat{z})
            result(k, z)=1;
        end
        if strcmp(char(input2(k,1)), cat{z})
            result(k, z)=1;    
        else
        end
    end
end
result=array2table(result);
for z=1:j
    varname=strcat(attribName,"_",char(cat{z}));
        varname=strcat(attribName,"_",char(cat{z}));
    if contains(varname, '(')
        varname=strrep(varname, '(', '_');
    end
    if contains(varname, ')')
        varname=strrep(varname, ')', '_');
    end
    if contains(varname, '_')
        varname=strrep(varname, ' ', '_');
    end
    if contains(varname, '.')
        varname=strrep(varname, '.', '_');
    end   
    result.Properties.VariableNames(z)=cellstr(varname);
end

end


