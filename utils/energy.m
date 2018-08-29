function E = energy (x)
% Returns the energy content of the signal

	N = numel(x);
	E = sum(abs(x.^2)) / N;

end