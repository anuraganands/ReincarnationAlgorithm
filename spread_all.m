function [ human, converts_idx, conformists_idx ] = ...
    spread_all( human, who, population, guru_size, converts_guru_size , type )

if (strcmp(type,'starter') == 1)    
    opp_gurus =  guru_size:-1:1; % %randperm(guru_size); %
    opp_gurus = opp_gurus(1:converts_guru_size);
    
    for ( i = [opp_gurus])
        human(who(i)).bconverted = true;
    end     

%     try
    new_seq = disperse (population,guru_size,'evenly-GG');
%     catch
%         fprintf('\n### %d %d ', population, guru_size);
%         human
%         who
%     end
    for (i = 1: population)
        temp_human(i) = human(who(new_seq(i)));
        temp_human(i).name = i;
    end
    human = temp_human;
    clear temp_human who new_seq;        

    temp = 1;
    converted_gurus_idx = [];
    for (i = 1: population)
        if (human(i).bconverted && human(i).status == 1)
            converted_gurus_idx(temp) = i;
            temp = temp + 1;
        end
    end
    clear temp;

    start_converted_idx = min(converted_gurus_idx); 
    end_converted_idx = max(converted_gurus_idx); 

    % pre-condition: gurus MUST be distributed evenly in sorted order.
    for (i = start_converted_idx : end_converted_idx)
        human(i).bconverted = true;
    end   

%     human = human;
    converts_idx = [find( [human(:).bconverted]  )]; %expensive
    conformists_idx = [find( ~[human(:).bconverted]  )]; %expensive
else
    converts_idx = [find( [human(:).bconverted]  )]; %expensive
    conformists_idx = [find( ~[human(:).bconverted]  )]; %expensive

    total_conformists = size(conformists_idx,2);
    new_seq = disperse (  total_conformists, guru_size - converts_guru_size, 'evenly-GG');

    for (i = 1 : total_conformists)
        temp_human(i) = human( conformists_idx(new_seq(i)) );
        temp_human(i).name = i;
    end

    clear new_seq;

    total_converts = size(converts_idx,2);
    
    if (total_converts > 0)  
        try
            new_seq = disperse (  total_converts, converts_guru_size, 'evenly-GG');

            for (i = total_conformists + 1: population)
                temp_human(i) = human( converts_idx(new_seq(i-total_conformists)) );
                temp_human(i).name = i;
            end
        
        catch
            fprintf('\n### %d %d %d %d', total_converts, converts_guru_size, total_conformists, population );
            who
            new_seq
        end
    end

    human = temp_human;
    clear temp_human new_seq;
    
        
end
