function [ population, community_size, guru_size,  percentage_coverts, converts_guru_size, ...
    common_people_size, atheist_size, discarded_population, ...
    yonee, human, bstop] ...
    = yonee_process( yonee, yonee_time, nirvana_per_gen, human, data, who, Gen, Generation, discarded_population, ...
        guru_size, community_size, percentage_coverts, converts_guru_size, common_people_size, atheist_size)
        

    % may select worse r% to be removed in next generation.
    % indicates they are no longer human beings
    % so new r%??? may come from other yoni.
    
    % bad population from previous life is dicarded from human population
    % and new ones have joined the population
    % assume bad population will not over write gurus population
    
    bstop = false;
    population = size(human,2);
    L = size(human(1).soul,2);
    
    
    yonee_sz = size(yonee,2);
    yonee(yonee_sz+1 : yonee_sz+ (discarded_population(Gen))) = human( who(population - discarded_population(Gen) + 1 : population));
    
    if( (discarded_population(Gen)+nirvana_per_gen) > population)
        fprintf('discarded_population + nirvana_per_gen is more than total population\n');
        bstop = true;
        return;
    end
    
    if (Gen < yonee_time)
        for (i = 1:(discarded_population(Gen)+nirvana_per_gen) )
            human(who(population - i + 1)).status = 0;
            human(who(population - i + 1)).soul = randperm(L);
            human(who(population - i + 1)).karma = karma(human(who(population - i + 1)).soul,data);
    % %         if (bstagnant)
    % %             if (rand > percentage_coverts)
    % %                 human(who(population - i + 1)).bconverted = false;
    % %             else
    % %                 human(who(population - i + 1)).bconverted = true;
    % %             end
    % %         end
        end
        
    else
        yonee_commers = (discarded_population(Gen)+nirvana_per_gen);
        
        if (yonee_commers > population)
            %catered above
        end
        
        if (yonee_commers > size(yonee,2))   
            human(who(population - (yonee_commers - size(yonee,2)) + 1 : population) ) = [];  
%             who(population - (yonee_commers - size(yonee,2)) + 1 : population) = [];
            clear who;
            [good_karma who] = sort([human(:).karma],'ascend'); 
            yonee_commers = size(yonee,2);
            
            population  = size(human,2);
            
            if (population == 0)
                fprintf('NO MORE POPULATION\n');
                bstop = true;
                return;
            end
            
            [ community_size, guru_size,  percentage_coverts, converts_guru_size, common_people_size, atheist_size] = ...
            set_population_vars(population);
            discarded_population = get_discard_population( 1, Generation, population);

            for (i = 1:population)
                human(i).name = i;
                human(i).status = 0;
                human(i).progress_on_era = 1;
                human(i).isprogressing = true;
                human(i).last_gen_human = Gen - 1;
%         human(i).bconverted = false;
            end

            for (i = 1:guru_size)
                human(who(i)).status = 1;
            end      
            
        end
                    
        human(who(population - yonee_commers + 1 : population) ) = yonee(1:yonee_commers);        
        yonee(1:yonee_commers) = [];       
    end
