function [ influencee ] = influence2( influencee, influencer, degree_of_influence )

sz = size(degree_of_influence,2);

total_study_area = size(influencer,2);

sz = size(degree_of_influence,2);
L = size(influencee,2);
results = zeros(1,L);

a = influencee([degree_of_influence]);
b = influencer([degree_of_influence]);

b_sz = size(b,2);

for (i = 1:b_sz)
    study_area = b(i) - 1;
    if (study_area == 0)
        study_area = L;
    end    

    b(i) = study_area;
end

temp = zeros(1,L);
temp([degree_of_influence]) = b;

for ( i = 1:sz)
    results = results + (influencee == b(i));
end
map_from = find(~results);

map_to = find(~temp);
temp([map_to]) = influencee([map_from]);

influencee = temp;