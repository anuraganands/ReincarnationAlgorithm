function [ max_influence ] = get_max_influence( ro, cur_era_count, L, varargin  )

if (nargin > 4)
   error('Wrong number of input arguments') 
end

if(nargin == 4)
    max_limit = varargin{1};
else
    max_limit = round(L*0.1);
end

% influence from gurus
% % ro = 3.5; %2.7;
% norm_data = norm_scale01([1:era_count]); % normalize data over the interval [0,1]
norm_data = norm_scale01([1:cur_era_count]);
influence_tendency = exp(-ro*norm_data); % humans are moving away from spirituality hence decay curve is used
%the new generations have low influence tendecy towards spirituality
% suggestion => ceil(L/9)+1
max_influence = min(ceil(influence_tendency*L),max_limit); 