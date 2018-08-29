function p = parameters(type)
% Create parameter structure for diffusion encoding optimization and design
% and set default values for all parameters
%
% Input:	type	Type ['sym, 'cvx']
% Output:	p		Parameter structure

if nargin < 1, type = 'cvx'; end

%% Basic simulation and system parameters
p = struct();			% Parameter structure
p.dt = 100e-6;			% Timestep of optimization [s] (10us < dt < 1ms)
p.B0 = 3.0;				% Static magnetic field strength [T]
p.gamma = 42.577e6;		% Gyromagnetic ratio [Hz/T]


%% Gradient limits and diffusion encoding targets
p.MMT = 1;				% Desired waveform moments (M0, M1, M2)
p.Gmax = 150e-3;		% Maximum gradient field strenth [T/m]
p.Smax = 150;			% Maximum slew rate [T/m/s]
p.bTarget = 400e6;		% Target b-value [s/m^2]


%% Set orientations
p.encodeDir = [1 1 0];	% Encoding direction vector [x y z]
p.phaseDir = [1 1 0];	% Phase encoding direction [x y z]
p.sliceDir = [0 0 1];	% Slice encoding direction [x y z]

% Normalize values
p.encodeDir = p.encodeDir / norm(p.encodeDir);
p.phaseDir = p.phaseDir / norm(p.phaseDir);
p.sliceDir = p.sliceDir / norm(p.sliceDir);


%% Imaging parameters
p.T2star = 80e-3;		% T2* decay rate of tissue [s]
p.FOV = [.1 .1 .2];		% Field of view [x y z] [m]
p.ST = 5e-3;			% Slice thickness [m]
p.R = 2;				% In-plane acceleration factor

% Calculate additional values
p.dk = p.R / dot(p.phaseDir,p.FOV);	% k spacing in phase direction [1/m]


%% Sequence durations
p.tRF = 4.62e-3;		% Inversion pulse duration [s]
p.tRead = 32e-3;		% EPI readout time [s]
p.ESP = 0.5e-3;			% EPI echo spacing [s]

% Discretize and round timings
dt = p.dt;
p.tRF = round(p.tRF/dt)*dt;
p.nRF = round(p.tRF/dt);
p.tRead = round(p.tRead/dt)*dt;
p.nRead = round(p.tRead/dt);


%% Inversion pulse specification
inv = struct();
inv.tRF = p.tRF;		% RF pulse duration [s]
inv.nRF = p.nRF;		% RF pulse length
inv.profile = 'delta';	% RF pulse profile ['delta','rect','sinc','none']
inv.phaseDefect = 0;	% Deviation of flip angle from ideal pulse [rad]
inv.U = cos(pi-inv.phaseDefect);	% Inversion value [-1 .. 1]
p.inv = inv;


%% Optimization-specific values
if strcmp(type,'cvx')
	
	p.x = 0.815;		% Waveform asymmetry factor [0 .. 1]
	
	% Total variation regularization
	p.TV = false;		% Slew rate TV regularization flag [Bool]
	p.lambda = 1e0;		% Gradient slew rate TV regularization weight
	
	% Concomitant field correction
	p.coco = true;		% Concomitant field correction flag [Bool]
	p.mMax = 2e-2;		% Maxwell-index limit [s^1/2*T/m]
	
	% Optimization limits
	p.tMax = 0.2;		% Terminate bisection search when tEnc>=tMax [s]
	p.nMax = round(p.tMax/dt);
	
end