function [ fpopulation ] = get_population( ro, Generation, population, varargin  )

if (nargin > 4)
   error('Wrong number of input arguments') 
end


if(nargin == 4)
    min_limit = varargin{1};
else
    min_limit = 0;
end


norm_data = norm_scale01([1:Generation]);
fpopulation = exp(-ro*norm_data);
fpopulation = ceil(fpopulation * population);

if (min_limit ~= 0)
    fpopulation = max(fpopulation, min_limit);
end