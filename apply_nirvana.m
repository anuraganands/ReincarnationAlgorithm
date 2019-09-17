function [ human, nirvana ] = apply_nirvana( human, nirvana, same_supreme_guru, Gen,  ...
    discarded_population, nirvana_per_generation, who, guru_size)

    population = size(human,2);

    if (size(nirvana,2) == 0)
        return;
    end
               
    [unq_nirvana, loc] = unique([nirvana.karma]);
    new_gurus_size = min(ceil(0.2*guru_size),size(unq_nirvana,2)); % taking 20% ..
    new_gurus_idx = randperm(size(unq_nirvana,2));
    new_gurus_idx = new_gurus_idx(1:new_gurus_size);


    fprintf('nirvana bhajan \n');

    already_replaced = discarded_population+nirvana_per_generation;
    % bad commons replaced by bad gurus => bad commons are
    % discarded => %These gurus are now commoners
    human(who(population - new_gurus_size + 1 - already_replaced: population - already_replaced)) = human(who(guru_size-new_gurus_size + 1: guru_size));

    % bad gurus are replaced by new nirvana gurus.
    human(who(guru_size-new_gurus_size + 1 : guru_size)) = nirvana([loc(new_gurus_idx)]); %loc(?) if unique

    % Delete these nirvana from nirvana array.. these are back into the world
    nirvana([new_gurus_idx]) = [];
%                 same_supreme_guru = 1; % no need to count any further....    
%   end
  