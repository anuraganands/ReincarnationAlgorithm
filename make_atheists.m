function [ atheist_idx, human ] = make_atheists( human, atheist_size )
    atheist_idx = find([human(:).status] == 0); % commoners...
    
    if (atheist_idx <= 0)
        atheist_idx = [];
    end
    
    sz = size(atheist_idx,2);
    ath_seq = randperm(sz);
    ath_seq = ath_seq(1:atheist_size);
    atheist_idx = atheist_idx([ath_seq]);
    
    for (i = [atheist_idx])
        human(i).isatheist = true;
    end
