function mlprojecttrain = importfile(filename, startRow, endRow)
%IMPORTFILE1 �ؽ�Ʈ ������ ������ �����͸� ��ķ� �����ɴϴ�.
%   MLPROJECTTRAIN = IMPORTFILE1(FILENAME) ����Ʈ ���� �׸��� �ؽ�Ʈ ���� FILENAME����
%   �����͸� �н��ϴ�.
%
%   MLPROJECTTRAIN = IMPORTFILE1(FILENAME, STARTROW, ENDROW) �ؽ�Ʈ ����
%   FILENAME�� STARTROW �࿡�� ENDROW ����� �����͸� �н��ϴ�.
%
% Example:
%   mlprojecttrain = importfile1('ml_project_train.csv', 2, 1261);
%
%    TEXTSCAN�� �����Ͻʽÿ�.

% MATLAB���� ���� ��¥�� �ڵ� ������: 2017/06/09 19:25:20


%% ������ �ʱ�ȭ�մϴ�.
disp("Importing Data");
drawnow;

delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% ������ ���� �ؽ�Ʈ�� ����:
% �ڼ��� ������ ���� �������� TEXTSCAN�� �����Ͻʽÿ�.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% �ؽ�Ʈ ������ ���ϴ�.
fileID = fopen(filename,'r');

%% ���Ŀ� ���� ������ ���� �н��ϴ�.
% �� ȣ���� �� �ڵ带 �����ϴ� �� ���Ǵ� ������ ����ü�� ������� �մϴ�. �ٸ� ���Ͽ� ���� ������ �߻��ϴ� ��� �������� ������
% �ڵ带 �ٽ� �����Ͻʽÿ�.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% �ؽ�Ʈ ������ �ݽ��ϴ�.
fclose(fileID);

%% ������ �ؽ�Ʈ�� �ִ� ���� ������ ���ڷ� ��ȯ�մϴ�.
% �������� �ƴ� �ؽ�Ʈ�� NaN���� �ٲߴϴ�.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,4,5,18,19,20,21,27,35,37,38,39,44,45,46,47,48,49,50,51,52,53,55,57,60,62,63,67,68,69,70,71,72,76,77,78,81]
    % �Է� ���� �迭�� �ؽ�Ʈ�� ���ڷ� ��ȯ�մϴ�. �������� �ƴ� �ؽ�Ʈ�� NaN���� �ٲ���ϴ�.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % �������� �ƴ� ���λ� �� ���̻縦 �˻��ϰ� �����ϴ� ���� ǥ������ ����ϴ�.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % õ ������ �ƴ� ��ġ���� ��ǥ�� �˻��߽��ϴ�.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % ������ �ؽ�Ʈ�� ���ڷ� ��ȯ�մϴ�.
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


%% �����͸� ������ ���� string�� ���� �����մϴ�.
rawNumericColumns = raw(:, [1,4,5,18,19,20,21,27,35,37,38,39,44,45,46,47,48,49,50,51,52,53,55,57,60,62,63,67,68,69,70,71,72,76,77,78,81]);
rawStringColumns = string(raw(:, [2,3,6,7,8,9,10,11,12,13,14,15,16,17,22,23,24,25,26,28,29,30,31,32,33,34,36,40,41,42,43,54,56,58,59,61,64,65,66,73,74,75,79,80]));


%% �������� �ƴ� ���� �������� �ٲٱ�: NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % �������� �ƴ� �� ã��
rawNumericColumns(R) = {0}; % �������� �ƴ� �� �ٲٱ�

%% <undefined>�� �����ϴ� �ؽ�Ʈ�� <undefined> categorical������ ����� ��ȯ�Ǿ����� Ȯ���Ͻʽÿ�.
for catIdx = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43]
    idx = (rawStringColumns(:, catIdx) == "<undefined>");
    rawStringColumns(idx, catIdx) = "";
end

%% ��� ���� �����
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