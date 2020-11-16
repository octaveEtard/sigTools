function xc = xcorrFFT(x,y,maxLag,maxMem)
%
% Adapted from Matlab xcorr function
%
% Works with matrix x input -- in this case, computes the xcorr of y with
% each column of x
%
% Always scale based on 1 autocorr (option 'coeff' in xcorr)
%
% Does all the computation in Fourier domain.
%
% This function computes xcorr by batch (columns of x) to attempt not to
% exceed maxMem memory.
%
% TODO: simply use convfft to implement this?
%
assert( size(y,2) == 1 && ismatrix(y) );
assert( ismatrix(x) );

if nargin < 4
    maxMem = 15;
end

[nx,ndims_x] = size(x);
assert( nx == size(y,1) );

if nargin < 3
    mxl = nx - 1;
else
    mxl = min(maxLag,nx - 1);
end
% 2 * mxl +1 points in xc
nxc = 2 * mxl +1 ;

nFFT = 2^nextpow2(2*nx - 1);
isr = isreal(x) && isreal(y);

% will need up to
% 8 bytes * 2 (complex) * nFFT * 3  for (each dim of) X, Y & X.* conj(Y)
k = 48 * nFFT / 1e9; % in Gb
% and then:
memxc = (2-isr) * ndims_x * 8 * nxc / 1e9; % to store the result

if maxMem < memxc
    error('Will exceed max memory to store the result only');
end

% max batch size
nd = floor((maxMem-memxc)/k);

% pre-allocation
xc = nan([nxc,ndims_x],'double');
if ~isr
    xc = complex(xc);
end

Y = fft(y,nFFT);
norm_y = norm(y);

nBatch = ceil(ndims_x / nd);
bSize = sigTools.distribute(ndims_x,nBatch);
ie = 0;

for iBatch = 1:nBatch
    ib = ie + 1;
    ie = ib + bSize(iBatch) - 1;
    
    xc(:,ib:ie) = xcorr_YFFT(x(:,ib:ie),Y,nFFT,mxl,isr,norm_y);
end
end


function xc = xcorr_YFFT(x,Y,nFFT,mxl,isr,norm_y)

X = fft(x,nFFT,1);

if isr
    xc = real(ifft(X.*conj(Y),[],1));
else
    xc = ifft(X.*conj(Y),[],1);
end
% Keep only the lags we want and move negative lags before positive
% lags.
xc = [xc(nFFT - mxl + (1:mxl),:); xc(1:mxl+1,:)];

% scaling
xc = xc ./ (  sqrt(sum(abs(x).^2)) .* norm_y  );

end
