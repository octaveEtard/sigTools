function [win,idx] = makeTaperWin(T,Fs,type,func)
%
% Half Hann window (raised cosine) of duration T as sampling freq Fs.
% type = 'B' (0->1) or 'E' (1->0). func controls the operation used to
% convert from time to number of samples (round [default], floor, or ceil)
% 
% To taper begining of signal:
% [win,idx] = makeTaperWin(T,Fs,'B',@round); % or @floor or @ceil as needed
% x(idx) = x(idx) . * win; 
%
% To taper end of signal:
% [win,idx] = makeTaperWin(T,Fs,'E',@round);
% x(idx+end) = x(idx+end) . * win;
%
%
nWin = sigTools.timeToIndex(T,Fs,func); % this used @round by default
t = linspace(0,pi,nWin);

win = (1-cos(t)')/2; % 0 --> 1
idx = (1:nWin);

if strcmp(type,'E')
    win = 1-win; % 1 --> 0
    idx = idx-nWin;
end
end
%