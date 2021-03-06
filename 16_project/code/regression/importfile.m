function mlprojecttrain = importfile(filename, startRow, endRow)
%IMPORTFILE1 텍스트 파일의 숫자형 데이터를 행렬로 가져옵니다.
%   MLPROJECTTRAIN = IMPORTFILE1(FILENAME) 디폴트 선택 항목의 텍스트 파일 FILENAME에서
%   데이터를 읽습니다.
%
%   MLPROJECTTRAIN = IMPORTFILE1(FILENAME, STARTROW, ENDROW) 텍스트 파일
%   FILENAME의 STARTROW 행에서 ENDROW 행까지 데이터를 읽습니다.
%
% Example:
%   mlprojecttrain = importfile1('ml_project_train.csv', 2, 1261);
%
%    TEXTSCAN도 참조하십시오.

% MATLAB에서 다음 날짜에 자동 생성됨: 2017/06/09 19:25:20


%% 변수를 초기화합니다.
disp("Importing Data");
drawnow;

delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% 데이터 열을 텍스트로 읽음:
% 자세한 내용은 도움말 문서에서 TEXTSCAN을 참조하십시오.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% 텍스트 파일을 엽니다.
fileID = fopen(filename,'r');

%% 형식에 따라 데이터 열을 읽습니다.
% 이 호출은 이 코드를 생성하는 데 사용되는 파일의 구조체를 기반으로 합니다. 다른 파일에 대한 오류가 발생하는 경우 가져오기 툴에서
% 코드를 다시 생성하십시오.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% 텍스트 파일을 닫습니다.
fclose(fileID);

%% 숫자형 텍스트가 있는 열의 내용을 숫자로 변환합니다.
% 숫자형이 아닌 텍스트를 NaN으로 바꿉니다.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,4,5,18,19,20,21,27,35,37,38,39,44,45,46,47,48,49,50,51,52,53,55,57,60,62,63,67,68,69,70,71,72,76,77,78,81]
    % 입력 셀형 배열의 텍스트를 숫자로 변환합니다. 숫자형이 아닌 텍스트를 NaN으로 바꿨습니다.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % 숫자형이 아닌 접두사 및 접미사를 검색하고 제거하는 정규 표현식을 만듭니다.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % 천 단위가 아닌 위치에서 쉼표를 검색했습니다.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % 숫자형 텍스트를 숫자로 변환합니다.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% 데이터를 숫자형 열과 string형 열로 분할합니다.
rawNumericColumns = raw(:, [1,4,5,18,19,20,21,27,35,37,38,39,44,45,46,47,48,49,50,51,52,53,55,57,60,62,63,67,68,69,70,71,72,76,77,78,81]);
rawStringColumns = string(raw(:, [2,3,6,7,8,9,10,11,12,13,14,15,16,17,22,23,24,25,26,28,29,30,31,32,33,34,36,40,41,42,43,54,56,58,59,61,64,65,66,73,74,75,79,80]));


%% 숫자형이 아닌 셀을 다음으로 바꾸기: NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % 숫자형이 아닌 셀 찾기
rawNumericColumns(R) = {0}; % 숫자형이 아닌 셀 바꾸기

%% <undefined>를 포함하는 텍스트가 <undefined> categorical형으로 제대로 변환되었는지 확인하십시오.
for catIdx = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43]
    idx = (rawStringColumns(:, catIdx) == "<undefined>");
    rawStringColumns(idx, catIdx) = "";
end

%% 출력 변수 만들기
mlprojecttrain = table;
mlprojecttrain.Id = cell2mat(rawNumericColumns(:, 1));
mlprojecttrain.MSSubClass = categorical(rawStringColumns(:, 1));
mlprojecttrain.MSZoning = categorical(rawStringColumns(:, 2));
mlprojecttrain.LotFrontage = cell2mat(rawNumericColumns(:, 2));
mlprojecttrain.LotArea = cell2mat(rawNumericColumns(:, 3));
mlprojecttrain.Street = categorical(rawStringColumns(:, 3));
mlprojecttrain.Alley = categorical(rawStringColumns(:, 4));
mlprojecttrain.LotShape = categorical(rawStringColumns(:, 5));
mlprojecttrain.LandContour = categorical(rawStringColumns(:, 6));
mlprojecttrain.Utilities = categorical(rawStringColumns(:, 7));
mlprojecttrain.LotConfig = categorical(rawStringColumns(:, 8));
mlprojecttrain.LandSlope = categorical(rawStringColumns(:, 9));
mlprojecttrain.Neighborhood = categorical(rawStringColumns(:, 10));
mlprojecttrain.Condition1 = categorical(rawStringColumns(:, 11));
mlprojecttrain.Condition2 = categorical(rawStringColumns(:, 12));
mlprojecttrain.BldgType = categorical(rawStringColumns(:, 13));
mlprojecttrain.HouseStyle = categorical(rawStringColumns(:, 14));
mlprojecttrain.OverallQual = cell2mat(rawNumericColumns(:, 4));
mlprojecttrain.OverallCond = cell2mat(rawNumericColumns(:, 5));
mlprojecttrain.YearBuilt = cell2mat(rawNumericColumns(:, 6));
mlprojecttrain.YearRemodAdd = cell2mat(rawNumericColumns(:, 7));
mlprojecttrain.RoofStyle = categorical(rawStringColumns(:, 15));
mlprojecttrain.RoofMatl = categorical(rawStringColumns(:, 16));
mlprojecttrain.Exterior1st = categorical(rawStringColumns(:, 17));
mlprojecttrain.Exterior2nd = categorical(rawStringColumns(:, 18));
mlprojecttrain.MasVnrType = categorical(rawStringColumns(:, 19));
mlprojecttrain.MasVnrArea = cell2mat(rawNumericColumns(:, 8));
mlprojecttrain.ExterQual = categorical(rawStringColumns(:, 20));
mlprojecttrain.ExterCond = categorical(rawStringColumns(:, 21));
mlprojecttrain.Foundation = categorical(rawStringColumns(:, 22));
mlprojecttrain.BsmtQual = categorical(rawStringColumns(:, 23));
mlprojecttrain.BsmtCond = categorical(rawStringColumns(:, 24));
mlprojecttrain.BsmtExposure = categorical(rawStringColumns(:, 25));
mlprojecttrain.BsmtFinType1 = categorical(rawStringColumns(:, 26));
mlprojecttrain.BsmtFinSF1 = cell2mat(rawNumericColumns(:, 9));
mlprojecttrain.BsmtFinType2 = categorical(rawStringColumns(:, 27));
mlprojecttrain.BsmtFinSF2 = cell2mat(rawNumericColumns(:, 10));
mlprojecttrain.BsmtUnfSF = cell2mat(rawNumericColumns(:, 11));
mlprojecttrain.TotalBsmtSF = cell2mat(rawNumericColumns(:, 12));
mlprojecttrain.Heating = categorical(rawStringColumns(:, 28));
mlprojecttrain.HeatingQC = categorical(rawStringColumns(:, 29));
mlprojecttrain.CentralAir = categorical(rawStringColumns(:, 30));
mlprojecttrain.Electrical = categorical(rawStringColumns(:, 31));
mlprojecttrain.stFlrSF = cell2mat(rawNumericColumns(:, 13));
mlprojecttrain.ndFlrSF = cell2mat(rawNumericColumns(:, 14));
mlprojecttrain.LowQualFinSF = cell2mat(rawNumericColumns(:, 15));
mlprojecttrain.GrLivArea = cell2mat(rawNumericColumns(:, 16));
mlprojecttrain.BsmtFullBath = cell2mat(rawNumericColumns(:, 17));
mlprojecttrain.BsmtHalfBath = cell2mat(rawNumericColumns(:, 18));
mlprojecttrain.FullBath = cell2mat(rawNumericColumns(:, 19));
mlprojecttrain.HalfBath = cell2mat(rawNumericColumns(:, 20));
mlprojecttrain.BedroomAbvGr = cell2mat(rawNumericColumns(:, 21));
mlprojecttrain.KitchenAbvGr = cell2mat(rawNumericColumns(:, 22));
mlprojecttrain.KitchenQual = categorical(rawStringColumns(:, 32));
mlprojecttrain.TotRmsAbvGrd = cell2mat(rawNumericColumns(:, 23));
mlprojecttrain.Functional = categorical(rawStringColumns(:, 33));
mlprojecttrain.Fireplaces = cell2mat(rawNumericColumns(:, 24));
mlprojecttrain.FireplaceQu = categorical(rawStringColumns(:, 34));
mlprojecttrain.GarageType = categorical(rawStringColumns(:, 35));
mlprojecttrain.GarageYrBlt = cell2mat(rawNumericColumns(:, 25));
mlprojecttrain.GarageFinish = categorical(rawStringColumns(:, 36));
mlprojecttrain.GarageCars = cell2mat(rawNumericColumns(:, 26));
mlprojecttrain.GarageArea = cell2mat(rawNumericColumns(:, 27));
mlprojecttrain.GarageQual = categorical(rawStringColumns(:, 37));
mlprojecttrain.GarageCond = categorical(rawStringColumns(:, 38));
mlprojecttrain.PavedDrive = categorical(rawStringColumns(:, 39));
mlprojecttrain.WoodDeckSF = cell2mat(rawNumericColumns(:, 28));
mlprojecttrain.OpenPorchSF = cell2mat(rawNumericColumns(:, 29));
mlprojecttrain.EnclosedPorch = cell2mat(rawNumericColumns(:, 30));
mlprojecttrain.SsnPorch = cell2mat(rawNumericColumns(:, 31));
mlprojecttrain.ScreenPorch = cell2mat(rawNumericColumns(:, 32));
mlprojecttrain.PoolArea = cell2mat(rawNumericColumns(:, 33));
mlprojecttrain.PoolQC = categorical(rawStringColumns(:, 40));
mlprojecttrain.Fence = categorical(rawStringColumns(:, 41));
mlprojecttrain.MiscFeature = categorical(rawStringColumns(:, 42));
mlprojecttrain.MiscVal = cell2mat(rawNumericColumns(:, 34));
mlprojecttrain.MoSold = cell2mat(rawNumericColumns(:, 35));
mlprojecttrain.YrSold = cell2mat(rawNumericColumns(:, 36));
mlprojecttrain.SaleType = categorical(rawStringColumns(:, 43));
mlprojecttrain.SaleCondition = categorical(rawStringColumns(:, 44));
mlprojecttrain.SalePrice = cell2mat(rawNumericColumns(:, 37));

disp("Importing Done");
drawnow;
