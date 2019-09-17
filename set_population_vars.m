function [ community_size, guru_size,  percentage_coverts, converts_guru_size, common_people_size, atheist_size] ...
    = set_population_vars( population, varargin)

if (nargin > 4)
   error('Wrong number of input arguments') 
end

guru_percent = 0.15; %0.15;
converts_percent = 0.4;
atheist_percent = 0.1; 

switch nargin
    case 1
        ;
    case 2
        guru_percent = varargin{1};
    case 3
        guru_percent = varargin{1};
        converts_percent = varargin{2};
    case 4
        guru_percent = varargin{1};
        converts_percent = varargin{2}; 
        atheist_percent = varargin{3};
    otherwise
        error('invalid number of input arguments')
end

%guru size may depend on community size
community_size = max(4, ceil(0.15 * population)); %atleast 4
guru_size = ceil(population * guru_percent); % 1/4 of population
percentage_coverts = converts_percent;
converts_guru_size = ceil(percentage_coverts*guru_size); % was 0.4
common_people_size = population - guru_size; %3/4 of population
atheist_size = ceil(common_people_size * atheist_percent);