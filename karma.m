function [ fitness ] = karma(soul, input_data)

sz = size(input_data,1);

total_dist = 0;

for(i = 1:sz-1)
    total_dist = total_dist + input_data(soul(i),soul(i+1));
end
    
total_dist = total_dist + input_data(soul(sz),soul(1));

fitness = total_dist;
end
