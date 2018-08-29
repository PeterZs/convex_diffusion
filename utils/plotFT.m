function [fDomain] = plotFT(tDomain, dt, name)
% Takes a time domain input and plots the DC-centered Fourier transform
%   tDomain     One-sided time domain input
%   dt          Sampling period / time resolution [s] 
%   fDomain     DC-centered frequency domain output

    if not(exist('name','var'))
        name = 'Fourier transform plot';
    end

    % Calculate characteristics
    N = length(tDomain);    % Number of samples
    Ts = N * dt;            % Total sampling duration [s]
    Fs = 1 / dt;            % Sampling Frequency [Hz]
    df = 1 / Ts;            % Frequency resolution [Hz]
    t = (0:N-1)' * dt;       % Time domain x-axis [s]
    f = ceil(-N/2:N/2-1)' * df;  % Frequency domain x-axis[Hz]

    % Perform FFT
    fDomain = ft(tDomain,dt);

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