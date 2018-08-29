function [tDomain] = plotIFT(fDomain, dt, name)
% Takes a frequency domain input and plots the one-sided inverse FT
%   fDomain     DC-centered frequency domain input
%   dt          Sampling period / time resolution [s] 
%   tDomain     One-sided time domain output

    if not(exist('name','var'))
        name = 'Fourier transform plot';
    end

    % Calculate characteristics
    N = length(fDomain);        % Number of samples
    Fs = 1 / dt;                % Sampling frequency [Hz]
    Ts = N * dt;                % Total sampling duration [s]
    df = 1 / Ts;                % Frequency resolution [Hz]
    t = (0:N-1) * dt;           % Time domain x-axis [s]
    f = ceil(-N/2:N/2-1) * df;  % Frequency domain x-axis[Hz]

    % Perform FFT
    tDomain = ift(fDomain, dt);

    % Draw plots
    figure ('Name',name);

    subplot(1,2,1);
    plot (t, real(tDomain));
    title('Time domain');
    xlabel( {'','t [s]'});

    subplot(1,2,2);
    plot (f, abs(fDomain));
    title('Frequency domain');
    xlabel( {'','f [Hz]'});

end