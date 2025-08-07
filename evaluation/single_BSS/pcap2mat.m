clear all
close all
clc

import_fn = 'test_new_all.csv';

inp = importfile(import_fn);
[rows, columns] = size(inp);
%%
% extract column headers
column_headers = cell(1,columns);
for c = 1:columns
    tmp = inp{1,c};
    if ischar(tmp)==0
        tmp = char(tmp);
    end
%     tmp = strrep(tmp,'["','');
    column_headers{c} = tmp;
end


% extract data
data = cell(rows-1, columns);

for r = 2:rows
    for c = 1:columns
        tmp = inp{r,c};
        
        if isstring(tmp)
            
            if strfind(tmp,"0x")==1 % this is to convert hexadecimal numbers
                tmp = char(tmp);
                tmp = hex2dec(tmp(3:end));
            elseif contains(tmp,"\302\265s") % this is to reinterpret the µs statements
                tmp = char(tmp);
                tmp = str2num(tmp(1:end-9)).*1e-6;
            else
                tmp = char(tmp);
            end
        end

        if ~isempty(tmp) % this is not to save empty entries
            data{r,c} = tmp;
        end
        
    end
end

export_fn = [import_fn(1:end-3) 'mat'];

save(export_fn,'column_headers','data')