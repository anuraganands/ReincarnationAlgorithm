% Author Anurag Sharma
% School of Computing, Information and Mathematical Sciences,
% The University of the South Pacific, Suva, Fiji
% Copyright (c) 2009-2010, Anuraganand Sharma - All rights reserved.

function reincarnation()
clc;
clear all;


[data file_used] = get_data();
run_no = inputdlg('Enter Next Run No','Get Run Number',1,{'0'});
if (isempty(run_no))
   run_no = '0'; 
else
    run_no = run_no{1};
end

clf reset;
figure(gcf)
echo off

bdebug = false;
file_RA_out = fopen('RAoutput.txt','w'); % for debugging purpose

L = size(data,2);

Generation = 250; % 70 is good.......
population = 25; %max(50, round(L ^ (2/3))) %32; % 60 is good - 16 for rgb403
start_era_count = max(30, round(L/2));  %20; % 85 is good - 200 for rgb403

fpopulation = get_population( 0.5, Generation, population, population); %, population );

SG_specialized_marker = get_specialization_marker( 2, Generation, L );

blind_trust = 0.25; % 0.55 is good 20% are blindly trusting their gurus.
max_death_per_era = 0.1;

binfluence_by_closed_ones = false; % apply influence of closed ones?
    max_closed_ones = 2; % can be variable eg. from 1-5
    closed_ones_influence_prob = 0.5; %

bapply_fate = true;
bself_study = true; % apply self study?
    max_achievment_self_study = 10; % 10% of total L => generally poor solution for higher value.
%     max_self_study(L,max_achievment_self_study) %can be variable eg. from [1-L] or [1-10]
    self_study_probability = 0.5; % percent probability of the population doing self study

bforce_self_study = true;    
bfollow_gurus = false;
blocal_community_progressing = true;
tolerance = 2; % after conversion have tolerance for 2 generations.
full_influence_percent = 0.75;

total_era = get_total_era( 0.2, Generation, start_era_count ); %0.1 
discarded_population = get_discard_population( 1, Generation, population);

[ community_size, guru_size,  percentage_coverts, converts_guru_size, common_people_size, atheist_size] = ...
    set_population_vars(population);

human = struct( 'type','human', ...
            'name','', ... % better name can be 'rank' or 'ID'
            'status',0, ... % 0 => non-guru, 1 => guru; by birth everyone is non-guru
            'karma',0, ... % by birth no karma is attained
            'soul',[], ... % soul's strenght is inherited from previous life 
            'prev_karma', 0, ... % previous(?) recorded karma
            'isprogressing', 0, ...
            'progress_on_era', 0, ... %save latest progress era.
            'fate_rank', 0, ... 
            'bconverted', 0, ...
            'last_gen_human', 0, ...
            'isatheist', 0, ...
            'specialized_marker', 10) ; %round(L/2)); % default - speicalized in half known fields 
        
yonee = human(1:0); % intially empty;

yonee_time = 5; % for first yonee_time generations discarded population is only accumulated
                % but after yonee_time generations discarded population
                % will start coming back into the system
% one community can have many gurus. human can be influence by any one or
% more gurus.

% max_influencing_guru = community_size/2; %not using at the moment

for (i = 1:population)
    human(i).type = 'human object';
    human(i).name = i;
    human(i).status = 0; % 0 - common, 1 - guru, 2 - supreme guru
    human(i).soul = randperm(L);    
    human(i).karma = karma(human(i).soul,data);
    human(i).prev_karma = human(i).karma;
    human(i).progress_on_era = 1;
    human(i).isprogressing = true;
    human(i).bconverted = false;
    human(i).last_gen_human = 0;
    human(i).isatheist = false; %atheists don't follow gurus
    human(i).specialized_marker = 10; % round(L/2);
end

same_supreme_guru = 1;
[x y] = sort([human(:).karma],'ascend');
supreme_guru = human(y(1));

best_atheist = supreme_guru; % just initialized
clear x;
clear y;

nirvana = human(1:0); % intially empty

% should be less then guru_size

fprintf('Please Wait!\n');

still_same_supreme_guru = 1;
supreme_guru_changed_at = 1; % for plotting purpose only
supreme_change_cum_freq = 1; % note down the total changes
Gen_noted = -2;
new_supreme_guru = supreme_guru;
disperse_type = 'evenly-GG';
bstagnant = false; 
same_count_nirvana = 10; % 5 was good -- used for nirvan frequency 
same_count_conversion = 4; % used to check same SG for conversion purpose


tic;
tend = 0;
RAG_counter = 1;

population_deducted_thru_nirvana = 0;

for (Gen = 1:Generation)
    
    discarded_population = get_discard_population( 1, Generation,population);
    
    total_deaths = max_death_per_era;
    population
    
    if (population == 0)
        fprintf('NO MORE POPULATION\n');
        return;
    end

    learn_ratio = L/total_era(Gen);
    influence_impact = ceil(L * log(L*learn_ratio*population)/1000);
    max_influence = get_max_influence( 7.5, total_era(Gen), L, influence_impact); 
    
    prev_best = supreme_guru.karma;
    
    fprintf([int2str(Gen) ', ']);

    % assign gurus
    [good_karma who] = sort([human(:).karma],'ascend');   
        
    best_convert = min(find([human(1:guru_size).bconverted] == true));
    best_conformist = min(find([human(1:guru_size).bconverted] == false));

    if (~isempty(human(who(best_conformist))))    
        if (human(who(best_conformist)).karma < supreme_guru.karma)
            human(who(best_conformist)).name = who(best_conformist);
            supreme_guru = human(who(best_conformist)); % the best guru  
            same_supreme_guru = 1;
            supreme_guru_changed_at = Gen;
            supreme_change_cum_freq = supreme_change_cum_freq +1;
        end 
    end    
   
    if (~isempty(human(who(best_convert))))    
        if (human(who(best_convert)).karma < new_supreme_guru.karma)
            human(who(best_convert)).name = who(best_convert);
            new_supreme_guru = human(who(best_convert)); % the best guru  
            same_supreme_guru = 1;
            supreme_guru_changed_at = Gen;
            supreme_change_cum_freq = supreme_change_cum_freq +1;
        end                                
    end
    
    % Nirvana Out
    [ nirvana_per_gen, nirvana, who ] = ...
    attain_nirvana( nirvana, same_supreme_guru, same_count_nirvana, human, who, good_karma, guru_size );
    
   
    for (i = 1:population)
        human(i).name = i;
        human(i).status = 0;
        human(i).progress_on_era = 1;
        human(i).isprogressing = true;
        human(i).last_gen_human = Gen - 1;
        human(i).isatheist = false;
%         human(i).bconverted = false;
    end


    for (i = 1:guru_size)
        human(who(i)).status = 1;
    end      

    [ population, community_size, guru_size,  percentage_coverts, converts_guru_size, ...
    common_people_size, atheist_size, discarded_population, ...
    yonee, human, bstop] ...
    = yonee_process( yonee, yonee_time, nirvana_per_gen, human, data, who, Gen, Generation, discarded_population, ...
        guru_size, community_size, percentage_coverts, converts_guru_size, common_people_size, atheist_size);


    if(bstop)
        return;
    end
  
    for (i = 1:population)
        human(i).fate_rank = i;
    end
  
    % it is possible that no supreme guru is alive in current generation.    
       
[ bstagnant, human, new_supreme_guru, supreme_guru, converts_idx, conformists_idx, Gen_noted ] = ...
    spread_converts_conformists( bstagnant, same_supreme_guru, same_count_conversion, human, who, data, ...
    guru_size, converts_guru_size, new_supreme_guru, supreme_guru, Gen_noted, Gen);
           
    if (Gen < Gen_noted + 2)
        btolerant = true;
    else
        btolerant = false;
    end
      
    %atheist
    clear atheist_idx;
    
    [ atheist_idx, human ] = make_atheists( human, atheist_size );
      
    clear who;

    % influence - community influenced by local gurus + global guru
    % gurus are influenced by  supreme guru.

    bchanged = false;
       
    
    for (era = 1:total_era(Gen)) 
        
        if (era < full_influence_percent * total_era(Gen))
            inf_type = 'full'; % we have confidence on gurus
        else
            inf_type = 'partial'; % not full confidence
        end

        % Record prev_karma...
        for (i = 1:population) 
            human(i).prev_karma = human(i).karma;
            human(i).name = i;                
        end             
            
        % degree of influence should depend on the type of guru      
        self_study_probability = 0.5;
        max_achievment_self_study = 10;          
       
        % << guru
        [ out_human, bsupreme_guru_changed, supreme_guru  ] = ...
        spiritualize_gurus( data, human(conformists_idx), max_influence(era), inf_type, blind_trust, supreme_guru, era, btolerant, bself_study, SG_specialized_marker(Gen) );
        human(conformists_idx) = out_human;

        if (bsupreme_guru_changed)
            supreme_guru_changed_at = Gen;
            same_supreme_guru = 1;
        end
        
        if (bdebug)
            fprintf(file_RA_out,'(%d) conformist gurus\n',Gen);
            fprintf(file_RA_out,'%1.2f ',out_human.karma);
            fprintf(file_RA_out,'\n');
        end
        
        [ out_human, bsupreme_guru_changed, new_supreme_guru  ] = ...
        spiritualize_gurus( data, human(converts_idx), max_influence(era), inf_type, blind_trust, new_supreme_guru, era, btolerant, bself_study, SG_specialized_marker(Gen));
        human(converts_idx) = out_human;

        if (bsupreme_guru_changed)
            supreme_guru_changed_at = Gen;
            same_supreme_guru = 1;
        end
        
        if(bdebug)
            fprintf(file_RA_out,'(%d) converts gurus\n',Gen);
            fprintf(file_RA_out,'%1.2f ',out_human.karma);
            fprintf(file_RA_out,'\n');
        end
        % >> guru
        
        % common person  
        % << common
        ashram = 1;
        [ out_human, bsupreme_guru_changed, supreme_guru ] = ...
        spiritualize_commoners( data, human(conformists_idx), community_size, max_influence(era), inf_type, blind_trust, ...
            bapply_fate, supreme_guru, era, bself_study, self_study_probability, max_achievment_self_study, btolerant, ashram, SG_specialized_marker(Gen));
        human(conformists_idx) = out_human;

        if (bsupreme_guru_changed)
            supreme_guru_changed_at = Gen;
            same_supreme_guru = 1;
        end
        
        if(bdebug)
            fprintf(file_RA_out,'(%d) conformist commoners\n',Gen);
            fprintf(file_RA_out,'%1.2f ',out_human.karma);
            fprintf(file_RA_out,'\n');
        end

        [ out_human, bsupreme_guru_changed, new_supreme_guru ] = ...
        spiritualize_commoners( data, human(converts_idx), community_size, max_influence(era), inf_type, blind_trust, ...
            bapply_fate, new_supreme_guru, era, bself_study, self_study_probability, max_achievment_self_study, btolerant, ashram, SG_specialized_marker(Gen));
        human(converts_idx) = out_human;

        if (bsupreme_guru_changed)
            supreme_guru_changed_at = Gen;
            same_supreme_guru = 1;
        end
        
        if(bdebug)
            fprintf(file_RA_out,'(%d) converts gurus\n',Gen);
            fprintf(file_RA_out,'%1.2f ',out_human.karma);
            fprintf(file_RA_out,'\n');
        end        
        
        %atheists.........
        %atheist can do self study component this one can make karma worse..... CHECK.........
        %<<<<
        for (i = [atheist_idx])            
%             [changed_soul, changed_karma] = self_study(human(i).soul,human(i).karma, 'normal', data, max_self_study(L,max_achievment_self_study)); %max_self_study(L,max_achievment_self_study));
            [changed_soul, changed_karma] = self_study(human(i).soul,human(i).karma, 'normal', data, 1); %max_self_study(L,max_achievment_self_study));
            
            if (changed_karma < human(i).karma) % && human(i).status == 1) % is gurus
                human(i).progress_on_era = era;
            end;

            % Those who do self don't blindly trust people hence ">" is used...... 'hardly get better'
            if (changed_karma < human(i).karma) 
                human(i).soul = changed_soul;
                human(i).karma = changed_karma;
            end
            
            if (changed_karma < best_atheist.karma)
                best_atheist.karma = changed_karma;
                best_atheist.soul = changed_soul;
            end
        end
        %>>>>        
        % >> common     
        
        % note progress...
        for (i = 1:population) 
            if(human(i).karma < human(i).prev_karma) % new karma is better
                human(i).isprogressing = true;
                progress_on_era = era;
            end
        end           
        
        % Death 
        if (single(total_deaths) >=  1 ) 
            death_pick = randperm(population);
            death_pick = death_pick(1:round(total_deaths));
            
            total_deaths = max_death_per_era;
            if (~isempty(death_pick))
                for (i = [death_pick])
                    human(i).status = 10; % status changed so they will not take part in any event. there karma will not change
                end
            end        
            
        else
            total_deaths = total_deaths + max_death_per_era;
        end
                
    end %  %era end
    

    store_supreme_gurus(Gen) = supreme_guru.karma;
    store_new_supreme_gurus(Gen) = new_supreme_guru.karma;
    
    same_supreme_guru = same_supreme_guru + 1;  
    cur_best = supreme_guru.karma;
    
    if (prev_best == cur_best)
        still_same_supreme_guru = still_same_supreme_guru + 1;
    else
        still_same_supreme_guru = 1;
    end
    
    tend = toc;
    fprintf('Sol: %1.2f Elapsed time is %1.2f seconds\n',supreme_guru.karma, tend);

    RAgraph(1,RAG_counter) = tend; %###
    RAgraph(2,RAG_counter) = supreme_guru.karma; %###
    RAG_counter = RAG_counter + 1; %###

end % for Gen

%<<<
    file_used = [run_no file_used '.out']
   file_RA_out = fopen(file_used,'w')
   fprintf(file_RA_out,'%1.2f %1.2f\n',RAgraph);
   fclose(file_RA_out);
      
   fid = fopen(file_used,'r');
   file_data = fscanf(fid,'%f %f', [2 inf]);
   file_data = file_data';
   
   fclose(fid);
   
   x_range = file_data(:,1);
   y_range = file_data(:,2);
   
   hold on;
   plot(x_range, y_range, 'r.', ...
    'MarkerSize',8);

%>>>

%% used to draw average graph
% % <<<
% %     av_file = 'ft53.atsp.out';
% %     fid = fopen(['1' av_file],'r');
% %     file_data1 = fscanf(fid,'%f %f', [2 inf]);   
% %     fclose(fid);
% %  
% %     fid = fopen(['2' av_file],'r');
% %     file_data2 = fscanf(fid,'%f %f', [2 inf]);
% %     fclose(fid);
% %    
% %     fid = fopen(['3' av_file],'r');
% %     file_data3 = fscanf(fid,'%f %f', [2 inf]);
% %     fclose(fid);
% % 
% %     fid = fopen(['4' av_file],'r');
% %     file_data4 = fscanf(fid,'%f %f', [2 inf]);
% %     fclose(fid);
% % 
% %     fid = fopen(['5' av_file],'r');
% %     file_data5 = fscanf(fid,'%f %f', [2 inf]);
% %     fclose(fid);
% % 
% %     av1 = mean([file_data1(1,:) ; file_data2(1,:) ; file_data3(1,:) ; file_data4(1,:) ; file_data5(1,:)]);
% %     av2 = mean([file_data1(2,:) ; file_data2(2,:) ; file_data3(2,:) ; file_data4(2,:) ; file_data5(2,:)]);
% % 
% %     x_range = av1';
% %     y_range = av2';
% % 
% %     hold on;
% %     plot(x_range, y_range, 'r.', 'MarkerSize',8);

% >>>    
    
    

    fprintf('\n');


if (supreme_guru.karma < new_supreme_guru.karma)
    solution = supreme_guru;
else
    solution = new_supreme_guru;
end

solution
solution.soul

fprintf('Elapsed time is %1.2f seconds',tend);

fprintf('\n atheist \n');
best_atheist.karma
best_atheist.soul

% % % hold off
% % % figure
% % % plot(store_supreme_gurus,'b.');
% % % hold on
% % % plot(store_new_supreme_gurus,'r.');

% fclose(file_RA_out);


 

