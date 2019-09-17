function [ nirvana_per_gen, nirvana, who ] = ...
    attain_nirvana( nirvana, same_supreme_guru, same_count, human, who, good_karma, guru_size )

population = size(human, 2);

nirvana_per_gen = 0;
if (mod(same_supreme_guru, ceil(same_count)) == 0)        
    nirvana_per_gen = size(find (good_karma == min (good_karma)),2);
    nirvana_per_gen = min(nirvana_per_gen, guru_size);
end

nirvana_size = size(nirvana,2); % may get 0...
nirvana(nirvana_size+1 : nirvana_size + nirvana_per_gen) = human(who(1:nirvana_per_gen)); 

temp = who(1:nirvana_per_gen); 
who = who(nirvana_per_gen + 1 : population);    
who(population - nirvana_per_gen + 1 : population) = temp;