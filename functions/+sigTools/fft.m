function [fT, F] = fft(data,varargin)
% fft performs and return one sided FFT & associated frequencies
%
%   Usage: fft(data, ...)
%
%   Required input:
%       data        array npoints x ndimension: FFT will be performed for
%                   each column separately
%
%   Optional inputs:
%       Fs          integer                         default = 1
%       nFFT        integer                         default = 2^(nextpow2(npoints))
%       maxF        double                          default = Fs / 2
%       minF        double                          default = 0


%% default values
ip = inputParser;
npoints = size(data,1);

ip.addRequired('data', @isnumeric);
ip.addOptional('Fs', 1, @isnumeric);
ip.addOptional('nFFT', 2^(nextpow2(npoints)), @isnumeric);
ip.addOptional('maxF', -1, @isnumeric);
ip.addOptional('minF', 0, @isnumeric);


ip.parse(data,varargin{:});

Fs = ip.Results.Fs;
nFFT = ip.Results.nFFT;
maxF = ip.Results.maxF;
minF = ip.Results.minF;



%% the FFT will return nF frequencies, integer multiples of df = Fs/nFFT
nF = ceil((nFFT+1)/2);
df = Fs / nFFT;
F = (0:(nF-1)) * df;


%% Fourier coefficients
% scaling to account for how Matlab scales coefficients
fT = 2 * fft(data, nFFT) / nFFT;
% keeping only half of the spectrum
fT = fT(1:nF, :);


%% only keeping the required frequencies
if maxF > 0 && maxF < F(end)
    kmax = floor(maxF / df ) + 1; 
else
    kmax = nF;
end
if minF > 0 && minF < (Fs/2)
    kmin = floor(minF / df ) +1; 
else
    kmin = 1;
end   

fT = fT(kmin:kmax, :);

% in case fT has more than 2 dimensions 
s = size(data);
s(1) = kmax-kmin+1;
fT = reshape(fT,s);

F = F(kmin:kmax);


end
%
%