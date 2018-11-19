function p = parameters(type)
% Create parameter structure for diffusion encoding optimization and design
% and set default values for all parameters
%
% Input:	type	Type ['sym, 'asym', 'coco']
% Output:	p		Parameter structure

if nargin < 1, type = 'sym'; end

%% Basic simulation and system parameters
p = struct();			% Parameter structure
p.type = type;			% Set waveform type
p.interp = false;		% Flag to perform interpolation to 10us for Siemens
p.dt =  100e-6;			% Timestep of optimization [s] (1us < dt < 1ms)
p.B0 = 3.0;				% Static magnetic field strength [T]
p.gamma = 42.577e6;		% Gyromagnetic ratio [Hz/T]


%% Gradient limits and diffusion encoding targets
p.MMT = 2;				% Desired waveform moments (M0, M1, M2)
p.Gmax = 80e-3;			% Maximum gradient field strenth [T/m]
p.Smax = 100;			% Maximum slew rate [T/m/s]
p.bTarget = 500e6;		% Target b-value [s/m^2]
p.bTol = 2e6;			% Absolute b-value tolerance [s/m^2]


%% Set orientations
p.encodeDir = [1 1 1];	% Encoding direction vector [x y z]
p.phaseDir = [0 1 0];	% Phase encoding direction [x y z]
p.sliceDir = [0 0 1];	% Slice encoding direction [x y z]

% Normalize values
p.encDir = p.encodeDir;	% Store original input for later use
p.encodeDir = p.encodeDir / norm(p.encodeDir);
p.phaseDir = p.phaseDir / norm(p.phaseDir);
p.sliceDir = p.sliceDir / norm(p.sliceDir);


%% Imaging parameters
p.T2star = 25e-3;					% T2* decay rate of tissue [s]
p.FOV = [25 25 15]*1e-2;			% Field of view [x y z] [m]
p.ST = 5e-3;						% Slice thickness [m]
p.R = 1;							% In-plane acceleration factor
p.dk = p.R / dot(p.phaseDir,p.FOV);	% k spacing in phase direction [1/m]


%% Sequence durations
p.tMax = 0.2;			% Terminate bisection search when tEnc>=tMax [s]
p.mix = true;			% Include mixing time in symmetric encoding [Bool]
p.tPre = 2.3e-3;		% Diffusion preparation time [ms]
p.tRF = 4.62e-3;		% Inversion pulse duration [s]
p.tEPI = 16e-3;			% Readout time to center of EPI [s]
p.ESP = 0.242e-3;		% EPI echo spacing [s]

% Discretize and round timings
dt = p.dt;
p.tPre = round(p.tPre/dt)*dt;
p.nPre = round(p.tPre/dt);
p.tRF = round(p.tRF/dt)*dt;
p.nRF = round(p.tRF/dt);
p.tEPI = round(p.tEPI/dt)*dt;
p.nEPI = round(p.tEPI/dt);


%% Inversion pulse specification
inv = struct();
inv.tRF = p.tRF;		% RF pulse duration [s]
inv.nRF = p.nRF;		% RF pulse length
inv.profile = 'delta';	% RF pulse profile ['delta','rect','sinc','none']
inv.phaseDefect = 0;	% Deviation of flip angle from ideal pulse [rad]
inv.U = cos(pi-inv.phaseDefect);	% Inversion value [-1 .. 1]
p.inv = inv;


%% Optimization-specific values
p.x = NaN;			% Manually set symmetry factor [0..1] (auto if NaN)

% Concomitant field correction
p.coco = strcmp(type,'coco');	% Concomitant field compensation flag [Bool]
p.mMin = 4e-6;		% Minimum Maxwell index value [s*T^2/m^2]