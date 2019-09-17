function [ discarded_population ] = get_discard_population( ro, Generation, population , varargin)

if (nargin > 4)
   error('Wrong number of input arguments') 
end

if(nargin == 4)
    population_portion_discard_percent = varargin{1};
else
    population_portion_discard_percent = 0.3;
end



% % ro = 1;
norm_data = norm_scale01([Generation:-1:1]);
discard_percent = exp(-ro*norm_data);
discarded_population = ceil(discard_percent * (population_portion_discard_percent * population));