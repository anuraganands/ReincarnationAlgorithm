function ...
    [ human, bsupreme_guru_changed, population_supreme_guru ] = ...
    spiritualize_commoners( data, human, community_size, influence_size, inf_type, blind_trust,  ...
        bapply_fate, population_supreme_guru, era, bself_study, self_study_probability, ...
        max_achievment_self_study, btolerant, ashram, SG_specialized_marker)


population = size(human,2); %% population with one religion only?

if (population == 0)
    bsupreme_guru_changed = false;
    population_supreme_guru = population_supreme_guru;
    return;
end

L = size(human(1).soul,2);
bsupreme_guru_changed = false;

% NOTE: this idx_to refers to first and last index of the current given
% population
idx_to = human(1).name; 
idx_from = human(population).name;

all_commoners = find(  ([human(:).status] == 0)  &  ~[human(:).isatheist]  );

all_gurus = find([human(:).status] == 1);
c = floor(community_size/2);

local_guru_size = size([ all_gurus ], 2); %gurus in the given population

if (local_guru_size > 0)
    guru_common_ratio = population/local_guru_size;
else
    guru_common_ratio = 0; 
end


%STEP1: influence towards local gurus
%<<S1<<....................................................................
% %     cur_step = 1;
% %     if (find( follow_steps == cur_step))
        counter = 0;
        for (idx = [all_gurus])
            low_idx = mod(idx -1 + (-1*c),population);
            low_idx = low_idx + 1;

            high_idx = mod(idx -1 + (1*c),population);
            high_idx = high_idx + 1;

            range = [low_idx : high_idx];

            if (high_idx < low_idx )
                range = [   [1:high_idx] [low_idx:population]    ];
            end

            commoners = find( ([human([range]).status] == 0)  & ~[human([range]).isatheist]);    
            commoners = range(commoners);

            counter = counter + 1;
            community{counter} = commoners; % refers to community of commoners only

            if (human(idx).isprogressing) % guru is progressive
                blocal_community_progressing = true; % community has guru who is progressive

                sz = size(community{counter},2);

                for (i = 1:sz)  
                    [degree_of_influence, last_influence_marker] = influence_degree(L,influence_size, SG_specialized_marker); %human(idx).specialized_marker);

                    changed_soul = influence3(human(community{counter}(i)).soul,human(idx).soul,degree_of_influence, inf_type);
                    changed_karma = karma(changed_soul,data);

                    if ( changed_karma < human(community{counter}(i)).karma) 
                        human(community{counter}(i)).progress_on_era = era;
                        human(community{counter}(i)).isprogressing = true;
                    end

                    % just trust guru blindly and follow him. you might not realize today but in future you will (possibly)
                    if ( changed_karma < human(community{counter}(i)).karma ) %|| community{counter}(i) > (1-blind_trust) * population)%%TE
                        human(community{counter}(i)) = upgrade_human( human(community{counter}(i)), changed_soul, changed_karma, last_influence_marker );                
                    end                     
                end

            % change common people to guru n guru to common people
            else  %(~human(idx).isprogressing)  

                [val loc] = min([  human([community{counter}]).karma   ]);

                i = community{counter}(loc);

                if(~isempty(i))        
                    if (human(i).karma < human(idx).karma && ~btolerant)
                        blocal_community_progressing = true; % even though community has no guru progressing but commoners are progressing
                        human(i).status = 1; %human(idx).status; %1
                        human(i).isprogressing = true;
                        human(i).progress_on_era = era;
                        human(idx).status = 0;

                        temp_human = human(i);
                        human(i) = human(idx);
                        human(idx) = temp_human;

                        temp = human(i).name;
                        human(i).name = human(idx).name;
                        human(idx).name = temp;

                        clear temp_human temp;
                    end
                end
            end  
        end
% %     end
    %>>S1>>....................................................................





if (bapply_fate)
    [sorted_karma idx_fate] = sort ([human(:).karma], 'ascend');
end

% In some special case it is possible that one particular faction/ religious group has NO GURUS.         

for (i = [all_commoners])     
    new_self_study_probability = self_study_probability;
    new_max_achievment_self_study = max_achievment_self_study;
    blocal_community_progressing = false;                  
    
    %STEP 2: individually influence by supreme guru
    %<<S2<<................................................................
% %     cur_step = 2; 
% %     if (find( follow_steps == cur_step))
        [degree_of_influence_SG, last_influence_marker_SG] = influence_degree(L,min(influence_size,1), SG_specialized_marker);

        changed_soul= influence3(human(i).soul, population_supreme_guru.soul, degree_of_influence_SG, inf_type);
        changed_karma = karma(changed_soul,data);

        if ( changed_karma < human(i).karma)
            human(i).progress_on_era = era;
            human(i).isprogressing = true;
            blocal_community_progressing = true;
        end

        if ( changed_karma < human(i).karma || i > (1-blind_trust) * population) %%TE               
            human(i) = upgrade_human( human(i), changed_soul, changed_karma, last_influence_marker_SG );        
        end

        if (changed_karma < population_supreme_guru.karma && ~btolerant) % Gen > Gen_noted - 2) % if improved
            human(i).status = 1; % supreme guru of current generation ???
            population_supreme_guru = human(i);
            population_supreme_guru.soul = changed_soul;
            population_supreme_guru.karma = changed_karma;
            bsupreme_guru_changed = true;
            continue;
        end  
% %     end
    %>>S2>>................................................................
    
    %STEP 3: try fate....
    %<<S3<<................................................................
% %     cur_step = 3;
% %     if (find( follow_steps == cur_step))
        if (local_guru_size > 0)
            if(bapply_fate)        
                if(era > human(i).progress_on_era + 4)
                    helper_guru_idx = ceil(i/ guru_common_ratio);
                    %human(i).fate_rank name won't matter because sequence is in sorted order 
    %                 [sorted_karma idx_fate] = sort ([human(:).karma], 'ascend');

                    [degree_of_influence, last_influence_marker] = influence_degree(L,influence_size, SG_specialized_marker); %human(idx_fate(helper_guru_idx)).specialized_marker);    
                    changed_soul= influence3(human(i).soul,human(idx_fate(helper_guru_idx)).soul,degree_of_influence, inf_type);                
                    changed_karma = karma(changed_soul,data);

                    if(changed_karma < human(i).karma)                    
                        human(i) = upgrade_human( human(i), changed_soul, changed_karma, last_influence_marker );
                    end
                end
            end
        end
% %     end
    %>>S3>>................................................................    
    
    if(~blocal_community_progressing )
        new_self_study_probability = 1;
        new_max_achievment_self_study = 90;
    else
        new_self_study_probability = self_study_probability;
        new_max_achievment_self_study = max_achievment_self_study;
    end    
    
    %STEP 4: self study component this one can make karma worse..... 
    %<<S4<<................................................................
% %     cur_step = 4;
% %     if (find( follow_steps == cur_step))
        if(bself_study && rand < new_self_study_probability) % only certain percent will do self study.                
    % %         [changed_soul, changed_karma] = self_study(human(i).soul,human(i).karma, 'normal', data, max_self_study(L,new_max_achievment_self_study)); %max_self_study(L,max_achievment_self_study));
            [changed_soul, changed_karma] = self_study(human(i).soul,human(i).karma, 'normal', data, 1); %max_self_study(L,max_achievment_self_study));

            if (changed_karma < human(i).karma) % && human(i).status == 1) % is gurus
                blocal_community_progressing = true;
                human(i).progress_on_era = era;
            end;                

            % Those who do self don't blindly trust people hence ">" is used...... 
            if (changed_karma < human(i).karma ) % || i > blind_trust * population) 
                human(i).soul = changed_soul;
                human(i).karma = changed_karma;
            end
        end
% %     end
    %>>S4>>................................................................       
end

% fprintf('\nafter commoner\n');
% size(find([human(:).status] == 0), 2)
% size([ find([human(:).status] == 1) ], 2)
% size([ find([human(:).status] == 2) ], 2)

% very expensive
%STEP 5: closed ones influence
%<<S5<<....................................................................
% % cur_step = 5;
% % if (find( follow_steps == cur_step))
    [human] = make_closed_ones_influence( data, human, all_commoners, inf_type, influence_size, SG_specialized_marker ); % influence_size = 1
% % end
%>>s5>>....................................................................
