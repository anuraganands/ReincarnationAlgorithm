function [ data, filename] = get_data( )

[filename path] = uigetfile('*.*');

if (path == 0)
    error(['file not selected' ' :-(']);
    exit
end

filepath = [path filename]

[fid,msg] = fopen(filepath,'r');

if (fid<0)
    error(['Cannot open ' filename]); 
    exit
end

% 
% 
% %     God(:,row) = reshape(temp, 120, 1);
% 

fprintf('file (%s) opened successfully\n', filename);

%%% Uncomment this for STSP
%%%<<<<<<
% % % file_data = fscanf(fid,'%g %g', [3 inf]);
% % % file_data = file_data';
% % % 
% % % row = size(file_data,1);
% % % 
% % % TSP = zeros(row,row);
% % % 
% % % for (i = 1:row)
% % %     for (j = 1:row)
% % %         TSP(i,j) = sqrt((file_data(i,2)-file_data(j,2))^2 + (file_data(i,3)-file_data(j,3))^2);
% % %     end    
% % % end
%%%>>>>>>>

%%%% Uncomment following for ATSP
%%<<<<
row = fscanf(fid,'%d',1);

format = '';
for (i = 1:row)
    format = [format ' %g'];
end

file_data = fscanf(fid,format, [row inf]);
file_data = file_data';

TSP = file_data;
%%>>>>>


% % % % % % % Testing data % % %% % % % % %  %% % %% 
        % read file abc.txt then do the following
%         temp = fscanf(fid,'%d %d %d %d %d', [5 4]);
%         God = temp;
        
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
fclose(fid);

data = TSP;
