function [loadedData] = load_data(fileName, sheet, range)
%LOAD_DATA Function that loads data from xls spreadsheet

[data, dates] = xlsread(fileName, sheet, range);
loadedData = [table(datetime(dates, 'Format', 'dd-MM-yyyy'), 'VariableNames', {'Data'}), array2table(data, 'VariableNames',{'PV', 'GBLU', 'GAS', 'BSP'})];
end

