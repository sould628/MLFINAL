filename='ml_project_train.csv';

i=0;
temp=whos;
for i=1:size(whos)
    if strcmp(temp(i).name, 'rawData')
        break
    elseif [i 1]==size(whos)         %#ok<BDSCA>
        rawData=importfile(filename);
    end
end

i=0;
temp=whos;

myData=AMES(rawData);

rawData.Properties.VariableNames(2)
cat=categories(rawData.MSZoning)
rawData.MSZoning(1)
if rawData.MSZoning(1)==cat{4}
    "here123"
end
% s=table;
% s(:,1)=rawData(:,1);
% s.Properties.VariableNames(1)=rawData.Properties.VariableNames(1);
% s(:,2)=rawData(:,2);