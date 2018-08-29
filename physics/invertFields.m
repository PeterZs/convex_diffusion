function B = invertFields(B, p)
% invertFileds returns an appropriately inverted gradient waveform for
% given inversion pulse parameters
%
% Input:	B	Field [T] or gradient waveform [T/m]
%			p	Inversion pulse parameter struct
%			  nInv			Pulse position
%			  nRF			Pulse length
%			  profile		Pulse profile ['delta','rect','sinc','none']
%			  phaseDefect	Deviation of flip angle from ideal pulse [rad]
%
% Output:	B	Inverted field [T] or gradient waveform [T/m]


% Initialize
if p.n < 0, return; end
inv = ones(size(B));
rfStart = p.n - floor(p.nRF/2);
rfEnd = p.n + ceil(p.nRF/2);
rfPulse = max(rfStart, 1) : min(rfEnd, numel(B));

% Create inversion profile
switch p.profile
	case 'delta'
		inv(p.n:end,:) = p.U;
	case 'rect'
		inv(rfPulse,:) = 0;
		inv(p.n+ceil(p.nRF/2):end,:) = p.U;
	case 'sinc'
		% Pulse modeled as a sinc over a [-10*pi,10*pi] interval
		sincPulse = sinc(20*pi*(rfPulse-p.n)/p.nRF);
		inv(rfPulse,:) = -cumtrapz(abs(ft(sincPulse)));
		inv(rfPulse,:) = rescale(inv(rfPulse),p.U,1);
		inv(p.n+ceil(p.nRF/2):end,:) = p.U;
	otherwise
		% no inversion
end

% Invert waveform using generated profile
B = B .* inv;