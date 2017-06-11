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

