function result= my_ordinal( input, valueset, attribName )
%MY_ORDINAL �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
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

