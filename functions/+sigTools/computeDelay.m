function [im, mxc] = computeDelay(signal,pattern,doPlot,useAbs)
%
% Compute the delay between two time series signal and pattern. Return:
%
% im: index in 'signal' of the first point of 'pattern'
% mxc: max(abs(cross_correlation(signal,pattern))) (scaled for max possible
% value of 1);
%
% e.g. if im == 1 : no delay
%
% This function does not apply any pre-processing to signal or pattern, you
% may want to it before (e.g. remove strong drift).
%
if nargin < 4
    useAbs = true; % allow for the signal to be inverted
end

[nPnts,nSig] = size(signal,1:2);
pattern = [pattern;zeros(nPnts - numel(pattern),1)];

% cross-correlation
xc = sigTools.batch_xcorr(signal,pattern);
if useAbs
    [mxc,im] = max(abs(xc),[],1);
else
    [mxc,im] = max(xc,[],1);
end

nxc = (size(xc,1)-1)/2;
im = im - (nxc + 1) + 1;

if doPlot
    t = 1:nPnts;
    figure;
    for iSig = 1:nSig
        ax = subplot(nSig,1,iSig); hold on;
        plot(t,signal(:,iSig));
        plot(t + im(iSig) - 1,pattern);
        xline(im(iSig));
        
        legend(ax,{sprintf('Signal %i',iSig),'Pattern','x = im'},'box','off');
    end
    ax.XAxis.Label.String = 'Samples';
end
end
%
%