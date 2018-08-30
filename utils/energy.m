function E = energy (x)
% Returns the energy content of the input signal as per Parseval's Theorem
%
% Input:	x 	Signal in either time or frequency domain
% Output: 	E 	Energy of the signal

	N = numel(x);
	E = sum(abs(x.^2)) / N;

end