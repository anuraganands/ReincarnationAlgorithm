function [ degree_of_influence, last_influence_marker] = influence_degree( length, influence_size, varargin )

if (nargin > 3)
   error('Wrong number of input arguments') 
end

% NO LONGER USING SPECIALIZATION

% % if(nargin == 3)
% %     human_specialization_marker = varargin{1};
% %     degree_of_influence = randperm(human_specialization_marker);
% % else
% %     human_specialization_marker = length;
% %     degree_of_influence = randperm(human_specialization_marker);
% % end

degree_of_influence = randperm(length); %%DELETE THIS LINE .....................

degree_of_influence = degree_of_influence(1:influence_size); %max_influence(era));
% last_influence_marker = max(degree_of_influence);
last_influence_marker = 0;




deg = degree_of_influence;
sz = influence_size;

L = length;

if (sz > L)
    error ('sz too big...');
end

low = deg(1);
high = mod(deg(1) + sz - 1, L);

if (high < low)
%     seq = [[1: high] [low : L] ];
    seq = [low : L];
else
    seq = [low : high];
end

degree_of_influence = seq;

