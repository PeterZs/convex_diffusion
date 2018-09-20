function [vals] = readValues(inFolder,range,fieldName)
% readValues loads a specified field from each of the files in the
% specified range of the given folder.
%
% inFolder      Input folder from which to read the data
% range         Specifies which of the numbered recons to read
% fieldName     Field of the output struct contained in the recon files
%               e.g. 'nrSmpl,'parameters','metrics.rmse.magnitude'
%
% vals          Output cell array

% (c) Alen Mujkanovic 2017


oldFolder = cd(inFolder);           % Change to specified folder

fields = strsplit(fieldName,'.');   % Split fields
files = getfield(what, 'mat');      % Get list of all files
k = numel(files);
vals = cell(size(range));
for i = 1:k
    if isempty(sscanf(files{i},'%u'))
        continue
    elseif any(sscanf(files{i},'%u')==range(:))	% Skip unneeded files
        val = load(files{i},fields{1});         % Get struct
        for j = 1:numel(fields)                 % Get field
            val = getfield(val,fields{j});
        end
        vals(sscanf(files{i},'%u')==range) = {val};
    end
end

cd(oldFolder);                      % Change back to original folder