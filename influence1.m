function [ influencee ] = influence1(influencee, influencer, degree_of_influence )
% influencee - person being influenced
% influencer - person influencing others
% degree - degree of influence 

sz = size(degree_of_influence,2);

L = size(influencee,2);
results = zeros(1,L);

a = influencee([degree_of_influence]);
b = influencer([degree_of_influence]);
temp = zeros(1,L);
temp([degree_of_influence]) = b;


for ( i = 1:sz)
    results = results + (influencee == b(i));
end

map_from = find(~results);

map_to = find(~temp);
temp([map_to]) = influencee([map_from]);

influencee = temp;

    
