function PC = PhaseCoherence(freq, timeSeries, FS)
% PC = PhaseCoherence(freq, timeSeries, FS)
% 
%   Inputs:
%       freq              	Frequency to be analysed (Hz).
%       timeSeries          Matrix containing time series data. Should be
%                           in the format measurements x time.
%       FS                  Sampling rate value.
%   Outputs:
%       PC                  Phase coherence value at frequency of interest.
% 
%
% This function calculates phase coherence at a frequency of interest 
% across different measurements, i.e. cosistency of phase at a given 
% frequency. The output phase coherence value lies between 0 and 1: 
% 1 indicates perfect phase coherence and 0 indicates no phase coherence.
%
% -------------------------------------------------------------------------
% Emma Holmes
% Created on 31st July 2017


% Get parameters of input data
nMeasures	= size(timeSeries, 1);
nSamples 	= size(timeSeries, 2);
nSecs       = nSamples / FS;
fprintf('\n\nNumber of measurements = %d', nMeasures);
fprintf('\n\nNumber of time samples = %d (%.2f seconds)', nSamples, nSecs);

% Calculate FFT for each measurement (spect is freq x measurements)
spect       = fft(timeSeries'); 

% Normalise by amplitude
spect       = spect ./ abs(spect);

% Find spectrum values for frequency bin of interest
freqRes     = 1 / nSecs;
foibin      = round(freq / freqRes + 1);
spectFoi	= spect(foibin,:);

% Find individual phase angles per measurement at frequency of interest
anglesFoi	= atan2(imag(spectFoi), real(spectFoi));

% PC is root mean square of the sums of the cosines and sines of the angles
PC = sqrt((sum(cos(anglesFoi)))^2 + (sum(sin(anglesFoi)))^2) ...
    / length(anglesFoi);