filename='ml_project_train.csv';

   
rawData=importfile(filename);

myData=AMES(rawData);

rawData.Properties.VariableNames(2)
cat=categories(rawData.MSZoning)
rawData.MSZoning(1)
if rawData.MSZoning(1)==cat{4}
end
% s=table;
% s(:,1)=rawData(:,1);
% s.Properties.VariableNames(1)=rawData.Properties.VariableNames(1);
% s(:,2)=rawData(:,2);