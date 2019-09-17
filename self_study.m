function [ after_study, after_karma ] = self_study( before_study, before_karma, type, data, varargin) % max_self_study or data
% type => 'extensive' => always returns better or same results
% type => 'extra extensive'  => always returns better or same results
% type => 'normal' => can be better, can be worse..
% 

% % usage: human(i).soul = self_study(human(i).soul,human(i).karma, 'normal', max_self_study)
% % human(i).soul = self_study(human(i).soul,human(i).karma, 'extensive', data)
% % human(i).soul = self_study(human(i).soul,human(i).karma, 'extra extensive', data)

L = size(before_study,2);

if (nargin > 5)
   error('Wrong number of input arguments') 
end


if (strcmp(type, 'normal') == 1)
    max_self_study = varargin{1};
    amount_of_self_study = randperm(L); 

    minval = 1;
    maxval = max_self_study;

    study = round( minval + (maxval-minval) * rand);
    amount_of_self_study = amount_of_self_study(1:study);
    
    after_study = before_study;
    after_karma = before_karma;
    new_karma = after_karma;   
    
    for (idx = [amount_of_self_study])                
        before_study = [before_study(idx) before_study(1: idx-1) before_study(idx+1:L)];
        
        new_karma = karma(before_study,data); % can be expensive...

        if (new_karma < after_karma)  % as soon as new_karma is better than initial karma
            % changed after_study and after_karma will be returned.
            break;
        end
    end
    
    after_karma = new_karma; %karma(before_study,data);
    after_study = before_study;
    return;
    
% study extensively and evaluate oneself
elseif (strcmp(type,'extensive') == 1) 
    after_study = before_study;
    after_karma = before_karma;
    new_karma = after_karma;
    
    for (idx = [1:L])
        before_study = [before_study(idx) before_study(1: idx-1) before_study(idx+1:L)];
        
        new_karma = karma(before_study,data); % can be expensive...

        % as soon as better karma is found , stop the process
        if (new_karma < after_karma)  % new_karma is better than first karma
            % changed after_study and after_karma will be returned.
            break;
        end
    end   

    after_karma = new_karma; %karma(before_study,data);
    after_study = before_study;

    return;
elseif (strcmp(type,'XXXextra extensiveXXX') == 1) 
    after_study = before_study; % don't change soul if getter poorer solution.
    after_karma = before_karma;
    new_karma = after_karma;
    
    total_study = ceil(1.0 * L); %how many areas of study?? 
    minval = 1;
    maxval = ceil(0.2*L); %how much in one particular area. Because of circular nature max possible is 0.5*L
    amount_of_self_study = randperm(L);
    amount_of_self_study = amount_of_self_study(1:total_study);
    
    for (s = [amount_of_self_study])
%         before_study = after_study; 
        study = round( minval + (maxval-minval) * rand);
%         study = max(study,4);???
    
        temp1 = before_study(s);                    
        temp2 = mod((temp1 + study)-1,L) + 1; % temp1 + 4; % look for diverse solution
        temp_index = find(before_study == temp2);  

        before_study(s) = temp2;
        before_study(temp_index) = temp1;

% % %         new_karma = karma(before_study,data); 
% % % 
% % %         if (new_karma < after_karma) % better than first karma
% % % %             varargout{1} = true;
% % %             break;
% % %         end
    end
%     varargout{1} = false;

    after_karma = karma(before_study,data);
    after_study = before_study;
    

% % %     after_study = before_study;
% % %     after_karma = new_karma;
    return;
    
elseif (strcmp(type,'XXXpioneerXXX') == 1) % find better name... 
    after_study = before_study; % don't change soul if getting poorer solution.
    after_karma = before_karma;
    new_karma = after_karma;
    
    total_study = ceil(L * 1.0);  %how many areas of study?? 
    minval = ceil(L * 0.2);
    maxval = ceil(L * 1.0); %how much in one particular area. Because of circular nature max possible is 0.5*L
    amount_of_self_study = randperm(L);
    amount_of_self_study = amount_of_self_study(1:total_study);
    
    for (s = [amount_of_self_study])
        before_study = after_study; %?
        study = round( minval + (maxval-minval) * rand);
        
        temp1 = before_study(s);                    
        temp2 = mod((temp1 + study)-1,L) + 1; % temp1 + 4; % look for diverse solution
        temp_index = find(before_study == temp2);  

        before_study(s) = temp2;
        before_study(temp_index) = temp1;

    end
    after_study = before_study;
    after_karma = karma(before_study,data);
    return;
else
    error('Wrong study type <%s>!',type);
end

