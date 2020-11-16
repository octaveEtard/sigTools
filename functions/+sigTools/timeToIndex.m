function idx = timeToIndex(times, Fs, func)
if nargin < 3
    func = @round;
end
% see also convertToSamplesAt
idx = func(times * Fs) + 1;
end