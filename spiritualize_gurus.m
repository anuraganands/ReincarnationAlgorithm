function [ human, bsupreme_guru_changed, population_supreme_guru  ] = ...
    spiritualize_gurus( data, human, influence_size, inf_type, blind_trust, ...
    population_supreme_guru, era, btolerant, bself_study, SG_specialized_marker)


population = size(human,2);

if (population == 0)
    bsupreme_guru_changed = false;
    population_supreme_guru = population_supreme_guru;
    return;
end

L = size(human(1).soul,2);

bsupreme_guru_changed = false;
all_gurus = find([human(:).status] == 1);

idx_to = human(1).name; 
idx_from = human(population).name;


follow_steps = [1 2];
if( strcmp(inf_type,'partial') == 1)
    follow_steps = [1 2];
end


for (i = [all_gurus])
    %influenced only with supreme guru and influence with each other
    %***********************************  superguru is always trusted for every karma => super guru is ideal for everthing he does...
    
    %Step1: influence from super guru
    %<<S1<<................................................................
    cur_step = 1;
    
    if (find( follow_steps == cur_step))
        [degree_of_influence, last_influence_marker] = influence_degree(L, min(1,influence_size), SG_specialized_marker );

        changed_soul = influence3(human(i).soul,population_supreme_guru.soul,degree_of_influence, 'partial');
        changed_karma = karma(human(i).soul,data);

        if (changed_karma < human(i).karma)
            human(i).progress_on_era = era;
        end

        %changing blindly....... 
        if (changed_karma < human(i).karma) % || i > (1-blind_trust) * population)
            human(i) = upgrade_human( human(i), changed_soul, changed_karma, last_influence_marker );
        end


        if (changed_karma < population_supreme_guru.karma && ~btolerant) % if improved        
            population_supreme_guru = human(i);
            population_supreme_guru.soul = changed_soul;
            population_supreme_guru.karma = changed_karma;
            human(i).progress_on_era = era;
            bsupreme_guru_changed = true;
        end
    end
    %>>S1>>................................................................
    

    %Step2: Self Study
    %<<S2<<................................................................
    cur_step = 2;
    if (find( follow_steps == cur_step))
        if(era > human(i).progress_on_era + 4) % progress not made from 4 year
            human(i).isprogressing = false;
            % don't remove the following getting very good results
            for (search_direction = [-1 1])
                idx = mod(i -1 + (search_direction*1),population);
                idx = idx + 1;

                if (human(i).karma <= human(idx).karma) % but guru is still better than common
                    human(i).isprogressing = true;
                    break;
                end
            end
        end

            if (bself_study)
                [changed_soul, changed_karma] = self_study(human(i).soul,human(i).karma,'normal',data, 1);
        
                if (changed_karma < human(i).karma)
                    human(i).karma = changed_karma;
                    human(i).soul = changed_soul;
                end
            end
    end
    %>>S2>>................................................................
end


