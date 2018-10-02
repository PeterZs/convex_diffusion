function values = readValues(inFolder,range,fieldName)
% readValues loads a specified field from each of the files in the
% specified range of the given folder.
%
% Input:	inFolder	Input folder from which to read the data
%			range		Specifies which of the numbered recons to read
%			fieldName	Field of the output struct contained in the recon files
%						e.g. 'nrSmpl,'parameters','metrics.rmse.magnitude'
%
% Output:	values		Output cell array


% Change to specified folder
oldFolder = cd(inFolder);
addpath(genpath(pwd));

% Get list of all .mat files recursively
files = dir('**/*.mat');
files = string({files.name})';
k = numel(files);

% Load specified fields from files in range
fields = strsplit(fieldName,'.');	% Split fields
values = cell(size(range));
for i = 1:k
    if any(i==range(:))		% Skip unneeded files
        value = load(files{i},fields{1});
        for j = 1:numel(fields)
            value = getfield(value,fields{j});
        end
        values(i==range) = {value};
    end
end

% Change back to original folder
rmpath(genpath(pwd));
cd(oldFolder);