function [values, files] = readValues(inFolder,parameters,fieldName)
% readValues loads a specified field from each of the files matching
% specified parameters in the given folder.
%
% Input:	inFolder	Input folder from which to read the data
%			parameters	List of strings of parameters specifying files to read
%						e.g. ["G150", "S100", "EPI16"] or ["sym","coco"]
%			fieldName	Field of the output struct contained in the file struct
%						e.g. 'nrSmpl','parameters','metrics.rmse.magnitude'
%
% Output:	values		Output cell array containing requested values
%			files		Filenames from which the output values were read


% Change to specified folder
oldFolder = cd(inFolder);
addpath(genpath(pwd));

% Get list of matching .mat files
allFiles = dir('**/*.mat');
allFiles = string({allFiles.name})';
matches = ones(numel(allFiles),1);
for i = 1:numel(parameters)
	matches = matches & contains(allFiles,parameters(i));
end
files = allFiles(matches);

% Load specified fields from files in range
fields = strsplit(fieldName,'.');	% Split fields
values = cell(size(files));
for i = 1:numel(files)
	value = load(files{i},fields{1});
	for j = 1:numel(fields)
		value = getfield(value,fields{j});
	end
	values(i) = {value};
end

% Change back to original folder
rmpath(genpath(pwd));
cd(oldFolder);