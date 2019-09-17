function [ seq ] = disperse( population, size_small_group, type )
% disperse ([human(:).karma],guru_size);
% 'evenly-GG' - evenly distribute. good gurus with good commoners
% 'evenly-GB' - evenly distribute. good gurus with bad commoners
% 'evenly-RN' - evenly distribure. Randomly distribute gurus in the population of commoners

% % population = size(fitness,2);

if (population <= 0)
   seq = [];
   return;
end

if (size_small_group <= 0 )
    seq = [1:population];
    return;
end

if (size_small_group > population )
    seq = [1:population];
    return;
end

if (strcmp(type,'evenly-GG') == 1 || strcmp(type,'evenly-GB') == 1 || strcmp(type,'evenly-RN') == 1) % (good with good) or (good with bad)
% % %     [x who] = sort(fitness,'ascend');
% % %     clear x;
% % % 
% % %     population = size(fitness,2);
% % % 
% % %     ratio = population/size_small_group;
% % % 
% % %     Gs = sort(who(1:size_small_group),'ascend');
% % %     Gb = sort(who(size_small_group + 1 : population),'ascend');

    % It is assumed that fitness is already sorted.....
    
    ratio = floor(population/size_small_group);
    Gs = [1:size_small_group];
    if (strcmp(type,'evenly-GB') == 1)
        Gs = [size_small_group:-1:1];
    elseif (strcmp(type,'evenly-RN') == 1)
        Gs = randperm(size_small_group);
    end
    Gb = [size_small_group + 1 : population];

    r = 1;
    g = 1;
    i = 1;
    prev_ratio = 1;

    while ( r <= population)   
        if (floor(i*ratio - 1) > population ... % check seq
            || floor(i*(ratio -1)) > (population - size_small_group) ... %check common
            || g > size_small_group) %check guru

            seq_size = size(seq,2);
            n = 1;
            for (x = g:size_small_group)
                seq(seq_size + n) = Gs(x);
                n = n + 1;
            end

            n = 1;
            for (x = prev_ratio:population - size_small_group)
                seq(seq_size + n) = Gb(x);
                n = n + 1;
            end
            break;
        end

        try
        seq(r:floor(i*ratio) - 1) = Gb(prev_ratio : floor(i*(ratio - 1)));
        catch
            population
            size_small_group
            i
            ratio
            r
            floor(i*ratio) - 1
            prev_ratio
            floor(i*(ratio - 1))
        end
        
        r = floor(i*ratio);
        seq(r) = Gs(g);
        r = r + 1;
        g = g + 1;
        prev_ratio = floor(i*(ratio-1)) + 1;
        i = i + 1;
    end
    
elseif (strcmp(type,'randomly') == 1)
    seq = randperm(population);
else
    error('Wrong parameters');
end
    
