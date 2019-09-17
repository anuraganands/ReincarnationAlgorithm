function plot_generation( range, all_humans, cur_Gen, total_generations,super_guru, supreme_guru_changed_at, new_supreme_guru)

color_code = get_color_code(range,cur_Gen);
hold on % you are not making it hold off; at the end

all_karmas = [all_humans.karma];
all_status = [all_humans.status];
sz = size(all_humans,2);

x_range = [1:size(all_karmas,2)];
y_range = [all_karmas];

h = plot(x_range, y_range, '.', ...
    'MarkerEdgeColor',color_code, ...
    'MarkerSize',0.01);
% axis([0  total_generations+1 0  total_generations+1]);

str_title = sprintf('Gen: (%d of %d) super guru(i=%d): %1.2f, Last Updated: %d, converted guru: %1.2f', ...
    cur_Gen, total_generations, super_guru.name, super_guru.karma, supreme_guru_changed_at, new_supreme_guru.karma); 
title(str_title,'color',[0 0 0]); %color_code);


% identify gurus...
printdata = num2str(ones(sz,1)*cur_Gen);
printdata = cellstr(printdata);
gurus_idx = find(all_status == 1); % gurus and super guru

printdata([gurus_idx]) = strcat(printdata([gurus_idx]),'G');

% % % sg = find(all_status == 2); % gurus and super guru
% % % printdata([sg]) = strcat(printdata([sg]),'SG');


text(x_range, y_range, printdata,'FontSize', 6, 'color', color_code);

set(h,'EraseMode','xor');
drawnow


if (cur_Gen == total_generations)
   hold off
end
   


