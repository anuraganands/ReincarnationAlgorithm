function [ influencee ] = influence3(influencee, influencer, degree_of_influence, type )

% influencee - person being influenced
% influencer - person influencing others
% degree - degree of influence 

if (strcmp(type,'partial') == 1)
   influencee = influence2(influencee, influencer, degree_of_influence ); 
elseif(strcmp(type,'full') == 1)
   influencee = influence1(influencee, influencer, degree_of_influence ); 
else
    error('incorrect input variable');
end

