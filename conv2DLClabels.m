clear all
fclose all

%% changes depending on the project
source_path = 'E:\chiara_antscoil\12460003 (2-21-2024 10-53-56 AM)\';
original_video = strsplit(source_path,{'\',' '});
original_video = original_video{3};
dlc_project_path = 'E:\chiara_antscoil\12460003 (2-21-2024 10-53-56 AM)\';
dest_path = [dlc_project_path, 'Labeled\',original_video,'\'];
scorer = 'ct';
%% changes depending on your computer (so probably you dont have to change it ever)
dlc_env_path = 'C:\Users\TobisS2P\.conda\envs\DEEPLABCUT\pythonw.exe'; % points to the python environment your deeplabcut is installed


%% should be constant with digilite
line_bodyparts = 2;
line_axiscoor = 3;


%%
pos_files = dir([source_path,'*.pos']);
file_amount = length(pos_files);

if ~exist(dest_path, 'dir')
    mkdir(dest_path)
end
%%
for file_idx = 1:file_amount
    source_id = fopen([source_path, pos_files(file_idx).name]);
    
    tline = fgetl(source_id);
    lidx = 1;
    frame_idx = 0;
    while true
        tline = fgetl(source_id); 
        lidx = lidx + 1;
        if lidx == line_bodyparts
            bodyparts = strsplit(tline,' ','CollapseDelimiters',true); 
            bodyparts = bodyparts(~cellfun('isempty',bodyparts));
            continue
        elseif lidx == line_axiscoor
            ax = strsplit(tline,' ','CollapseDelimiters',true); 
            ax = ax(~cellfun('isempty',ax));
            continue
        elseif ~ischar(tline)
            break
        end

        frame_idx = frame_idx + 1;
        contents = strsplit(tline,' ','CollapseDelimiters',true); 
        frame{file_idx}(frame_idx) = str2double(contents{1});
        coords{file_idx}(frame_idx, :) = cellfun(@str2double,contents(2:end));
    end
end

%% filling the empty spaces in nest and north, as they where only marked once per video and are constant.
for i = 1:file_amount
    coords{i}(coords{i}(:,5)==0,5:end) = repmat(coords{i}(coords{i}(:,5)~=0,5:end),length(coords{i}(coords{i}(:,5)==0)),1);
end

coord_width = length(bodyparts)*2;

%% create csv file
dest_id = fopen([dest_path, 'CollectedData_',scorer,'.csv'],'wt');
% scorer line
l = 'scorer,,,';
for i = 1:coord_width
    l=[l,scorer,','];
end
l = l(1:end-1);

fprintf(dest_id,'%s\n',l);

% individual line
l = 'individual,,,';

for ii = 1 : coord_width
    l=[l,sprintf('individual%i,',1)];
end

l = l(1:end-1);

fprintf(dest_id,'%s\n',l);

% bodyparts line
l = 'bodyparts,,,';

for ii = 1 : length(bodyparts)
    l=[l,sprintf('%s,%s,',bodyparts{ii},bodyparts{ii})];
end

l = l(1:end-1);

fprintf(dest_id,'%s\n',l);

% coords line
l = 'coords,,,';

for ii = 1 : length(bodyparts)
    l=[l,sprintf('%s,%s,','x','y')];
end

l = l(1:end-1);

fprintf(dest_id,'%s\n',l);

% labeled data lines
lidx = 0;
template1 = zeros(1,coord_width);
for i = 1:file_amount  
    for point = 1:length(frame{i})
        lidx = lidx+1;
        l = sprintf('labeled-data,%s.mp4,%s %05d.jpg,%i,%i,%i,%i,%i,%i,%i,%i',...
            original_video,original_video,frame{i}(point),coords{i}(point,:));
        l = l(1:end-1);
        fprintf(dest_id,'%s\n',l);
    end
end

%% copy frames
for i = 1:file_amount
    for f = 1:length(frame{i})
        frame_name = sprintf('%s %05d.jpg',original_video,frame{i}(f));

        copyfile([source_path,frame_name], dest_path)

    end
end

%% do hdf5 file
pyenv('Version','C:\Users\TobisS2P\.conda\envs\DEEPLABCUT\pythonw.exe')

dlc = py.importlib.import_module('deeplabcut.utils');
conf = [dlc_project_path,'config.yaml'];
dlc.convertcsv2h5(conf, userfeedback=True, scorer=None)

%%
disp yay
fclose all


    %%

