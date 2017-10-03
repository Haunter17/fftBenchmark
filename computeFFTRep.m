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
%
%   F is a matrix of logical values containing the computed fingerprint
%   bits.  The rows correspond to different bits in the fingerprint, and
%   the columns correspond to different frames.
%
%  2016-07-08 TJ Tsai ttsai@g.hmc.edu
if nargin < 3
    parameter=[];
end

if isfield(Q,'c')~=0
    Q = Q.c;
end

%% step 2: normalize with L1-norm 1
l1Sum = sum(sum(abs(Q)));
if l1Sum ~= 0
	Q = Q / l1Sum;
end

%% step 3: preprocessing
prepQ = preprocessQspec_FFT(Q, parameter);

%% step 4 & 5: 2D FFT with abs
F = abs(fft2(prepQ));

%% step 6 & 7: find the features with top variance and the
% corresponding threshold
if isfield(model,'I_top') ~= 0
	F = F(1 : floor(size(F, 1) / 2), 1 : floor(size(F, 2) / 2));
    F = F(model.I_top);
    F = F > model.T;
end
