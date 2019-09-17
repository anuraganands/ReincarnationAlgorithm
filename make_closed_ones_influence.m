function [ human ] = make_closed_ones_influence( data, human, human_type_idxs, inf_type, influence_size, SG_specialized_marker )

population = size(human,2);
L = size(human(1).soul,2);

for (i = [human_type_idxs])    
% %     degree_of_influence = randperm(L);
% %     degree_of_influence = degree_of_influence(1:influence_size); %max_influence(era));     
   
    for (search_direction = [-1 1])
        
        idx = mod(i -1 + (search_direction*1),population);
        idx = idx + 1;

        [ degree_of_influence, last_influence_marker] = influence_degree(L,influence_size, SG_specialized_marker); %human(idx).specialized_marker);

        changed_soul = influence3(human(i).soul,human(idx).soul,degree_of_influence,inf_type);
        changed_karma = karma(changed_soul,data);

        if(changed_karma < human(i).karma) % ||  i > blind_trust * population) % very strict.. only influence if observed
            human(i) = upgrade_human( human(i), changed_soul, changed_karma, last_influence_marker );
        end
    end     
end
