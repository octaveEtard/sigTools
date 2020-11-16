function xc = xcorr(x,y,maxLag)
%
% ----
% Old. Use sigTools.xcorrFFT instead which also provide control of memory
% use.
% TODO remove?
%
%
% Adapted from Matlab xcorr function
%
% Works with matrix x input -- in this case, computes the xcorr of y with
% each column of x
%
% Always scale based on 1 autocorr (option 'coeff' in xcorr)
%
% Does all the computation in Fourier domain
%
%
assert( size(y,2) == 1 && ismatrix(y) );
assert( ismatrix(x) );

m = size(x,1);
assert( m == size(y,1) );

if ~exist('maxLag','var')
    mxl = m - 1;
else
    mxl = min(maxLag,m - 1);
end
m2 = 2^nextpow2(2*m - 1);

X = fft(x,m2,1);
Y = fft(y,m2,1);

if isreal(x) && isreal(y)
    xc = real(ifft(X.*conj(Y),[],1));
else
    xc = ifft(X.*conj(Y),[],1);
end
% Keep only the lags we want and move negative lags before positive
% lags.
xc = [xc(m2 - mxl + (1:mxl),:); xc(1:mxl+1,:)];

% scaling
xc = xc ./ (  sqrt(sum(abs(x).^2)) .* norm(y)  );

end
%
%