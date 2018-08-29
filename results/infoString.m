function info = infoString(s)
% resultsString creates a formatted string containing basic information
% about the given diffusion encoding gradient waveform
%
% Input:	s		Waveform data structure
%			  G			Gradient amplitude time series [T/m]
%			  dt		Time step of waveform [s]
%			  b			DW encoding value [s/m^2]
%			  tE		Echo time of SE sequence [s]
%			  tEnc		Diffusion encoding time [s]
%			  tRead		EPI Readout time [s]
%
% Output	info	Returned output string

% Calculate derivative operator
n = length(s.G);
D = diag(-ones(n,1),0) + diag(ones(n-1,1),1);
D = D(1:end-1,:);

% Generate string
info = ['b = ' num2str(round(s.b*1e-6)) ' s/mm^2,  ' ...
		'tE = ' num2str(s.tE*1e3,'%2.1f') ' ms,  ' ...
		'tEnc = ' num2str(s.tEnc*1e3,'%2.1f') ' ms,  ' ...
		'tRead = ' num2str(s.param.tRead*1e3,'%2.1f') ' ms,  ' ...
		'Gmax = ' num2str(max(abs(s.G)*1e3),'%2.1f') ' mT/m,  ' ...
		'Smax = ' num2str(max(abs(D*s.G/s.param.dt)),'%2.1f') ' T/m/s'];