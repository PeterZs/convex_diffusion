function GIRF_out = downsampleGIRF(GIRF_in, Fs_in, Fs_out)
% This function downsamples the input GIRF to the desired sampling rate
%
% INPUT:    GIRF_in     Fourier domain GIRF to be resampled
%			FS_in		Original sampling frequency
%           Fs_out      Desired sampling frequency
% OUTPUT:   GIRF_out    Resampled GIRF in Fourier domain

% Init constants
N_in = numel(GIRF_in)/2;			% Input signal length
N_out = round(N_in*Fs_out/Fs_in);	% Output signal length

% Resample GIRF
girf = ift(GIRF_in);
if Fs_out < 50e3
	coeffsFile = ['girfDecimNum_' num2str(Fs_out,'%2.0f') '.mat'];
	coeffsPath = [fileparts(which(mfilename)), '/filterCoefficients/', coeffsFile];
	if exist(coeffsPath,'file') == 2
		load(coeffsPath)
	else
		girfDecimNum = girfDecimator(2*Fs_in,0.95*Fs_out,Fs_out);
		save(coeffsPath,'girfDecimNum');
	end
    girf = filtfilt(girfDecimNum,1,girf);	% Zero-phase filter
end
GIRF = ft(girf);
GIRF_out = GIRF (N_in - N_out+1:N_in + N_out);

return