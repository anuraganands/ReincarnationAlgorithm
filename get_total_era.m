function [ total_era ] = get_total_era( ro, Generation, start_era_count )

% % ro = 1; %2.7;
% norm_data = norm_scale01([1:era_count]); % normalize data over the interval [0,1]
norm_data = norm_scale01([1:Generation]);
total_era = exp(-ro*norm_data); % humans are moving away from spirituality hence decay curve is used
%the new generations have low influence tendecy towards spirituality
total_era = ceil(total_era*start_era_count); 