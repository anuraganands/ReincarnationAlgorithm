function [ results ] = find_all( inarray, invals )
L = size(inarray,2);
sz = size(invals,2);

% % results = zeros(1,L);

% % for ( i = 1:sz)
% %     results = results + (inarray == invals(i));
% % end

for ( i = 1:sz)
    results(i) = find(inarray == invals(i));
end

