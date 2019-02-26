function [output] = count_occurrencies(data)
%COUNT_OCCURRENCIES Function that count the number of occurrencies of  set
%of values
%   Detailed explanation goes here
output = table(unique(data), histc(data, unique(data)), 'VariableNames', {'PV', 'orders_count'});
end

