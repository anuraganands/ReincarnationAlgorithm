function [ specialization_marker ] = get_specialization_marker( ro, Generation, L )

norm_data = norm_scale01([Generation:-1:1]);
specialization_marker = exp(-ro*norm_data);
specialization_marker = ceil(specialization_marker * L);
