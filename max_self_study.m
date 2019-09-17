function [ mss ] = max_self_study(L, max_achievment_self_study)

mss = round(L * max_achievment_self_study/100); %can be variable eg. from [1-L] or [1-10]
