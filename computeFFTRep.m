function F = computeFFTRep(Q, model, parameter)
% 
%   Input:
%	Q is a CQT struct
%
%   parameter is a struct specifying various arguments:
%     parameter.m is the number of context frames to use in the time-delay
%       embedding.
%     parameter.tao is the separation (in frames) between consecutive frames
%       in the time-delay embedding.
%     parameter.hop is the hop size (in frames) between consecutive
%       time delay embedded features.
%     parameter.numFeatures specifies the number of spectrotemporal features.
%     parameter.deltaDelay specifies the delay (in hops) to use for the 
%       delta feature computation.

if nargin < 3
    parameter=[];
end

if isfield(Q,'c')~=0
    Q = Q.c;
end

%% step 2: preprocessing
prepQ = preprocessQspec_FFT(Q, parameter);

%% step 3: 2D FFT
F = fft2(prepQ);

if isfield(model,'I_top') ~= 0
	%% step 4a: throw away the first column and keep only the top-left corner
	F = F(1 : floor(size(F, 1) / 2), 2 : floor(size(F, 2) / 2));
	% step 4b: stack real and imaginary part
	F = [real(F); imag(F)];
	%% step 5: take the top N pixels with greatest variance
    F = F(model.I_top);
    %% step 6: threshold by zero
    F = F > 0;
end
