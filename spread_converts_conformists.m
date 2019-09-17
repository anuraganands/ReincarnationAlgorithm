function [ bstagnant, human, new_supreme_guru, supreme_guru, converts_idx, conformists_idx, Gen_noted ] = ...
    spread_converts_conformists( bstagnant, same_supreme_guru, same_count, human, who, data, ...
    guru_size, converts_guru_size, new_supreme_guru, supreme_guru, ...
    Gen_noted, Gen)

    population = size(human,2);
    L = size(human(1).soul,2);


    if (~bstagnant && same_supreme_guru == same_count)  % compulsory change..
        bstagnant = true;
        disperse_type = 'randomly';
        
        for ( i = 1:population)
            human(i).bconverted = false;
        end 
        
        Gen_noted = Gen;
        
        new_supreme_guru = supreme_guru;
        new_supreme_guru.soul = (L+1) - supreme_guru.soul; % this new one is totally opposite
        new_supreme_guru.karma = karma(new_supreme_guru.soul,data);   
        
        [human, converts_idx, conformists_idx ] = ...
            spread_all( human, who, population, guru_size, converts_guru_size , 'starter' );
       
       for ( i = [converts_idx])
            if ( human(i).status ~= 0)
                human(i).soul = (L+1) - human(i).soul;
                human(i).karma = karma(human(i).soul, data);
            end
       end
        
    elseif (bstagnant && mod(same_supreme_guru, same_count) == 0 && new_supreme_guru.karma >= supreme_guru.karma)
        new_supreme_guru.soul = (L+1) - new_supreme_guru.soul; % this new one is totally opposite ...
        new_supreme_guru.karma = karma(new_supreme_guru.soul,data); 
        
        Gen_noted = Gen;
        
        [ human, converts_idx, conformists_idx ] = ...
            spread_all( human, who, population, guru_size, converts_guru_size, 'repeat'  );    
 
    elseif (bstagnant && mod(same_supreme_guru, same_count) == 0 && new_supreme_guru.karma < supreme_guru.karma) 
        disperse_type = 'randomly';
        
        Gen_noted = Gen;       

        supreme_guru.soul = (L+1) - supreme_guru.soul; % this new one is totally opposite ...
        supreme_guru.karma = karma(supreme_guru.soul,data); 
        
        [ human, converts_idx, conformists_idx ] = ...
            spread_all( human, who, population, guru_size, converts_guru_size, 'repeat'  );
        
    else
        [ human, converts_idx, conformists_idx ] = ...
            spread_all( human, who, population, guru_size, converts_guru_size, 'repeat'  );
    end