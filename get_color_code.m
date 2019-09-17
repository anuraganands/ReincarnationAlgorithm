function [ color_code ] = get_color_code( range, cur_Gen )
color_range = [0:range:1];

sz = size(color_range,2);

cur_Gen = cur_Gen - 1;

cur_Gen = mod(cur_Gen, sz^3);

remainder = rem(cur_Gen,sz);
div = floor(cur_Gen/sz);

% color is allocated from following technique
% for (i = 0:color_range)
%     for (j = 0: color_range)
%         for (k = 0; color_range)
%             allocated_color = [i,j,k];
%             %Do something  
%         end
%     end
% end 

c1 = 1; c2 = 1; c3 = 1; % white color
if (div < 1)
    % go to last col pick from last col
    c3 = color_range(remainder+1);
    c2 = color_range(div + 1); %div = 0
    c1 = 0;
elseif (div < 1*sz)
    % go to second col
    c2 = color_range(div + 1);
    c3 = color_range(remainder+1);
    c1 = 0;
elseif (div < sz*sz )
    % go to first col
    div2 = floor(div/sz);
    c1 = color_range(div2+1);
    remainder2 = rem(div, sz);    
    c2 = color_range(remainder2 + 1);
    c3 = color_range(remainder+1);
else
    c1 = 1; c2 = 1; c3 = 1;
end

color_code = [c1, c2, c3];
   


