function data = lowfreq_filt(data, cutoff, ind, nyquist)
% wrapper for low frequency filter using butterworth filter useful for BOLD
% fMRI data
% data: time x other dimension (e.g. space)
% make sure that nyquist frequency is correct!
% ind is a logical describing data points to be included/excluded (handy in
% the case of data scrubbing, defaults to all data points)

if nargin<3; ind = []; end

if nargin<4; nyquist = .25; end % assumes TR = 2 sec if no nyquist input

if isempty(ind); ind = true(size(data,1),size(data,2)); end

if size(data,1)~=size(ind,1);
    error('data and logical ind should be same size!')
end

[b,a]=butter(4,cutoff/nyquist,'low');

data = filtfilt(b,a,data);

if size(data,2)~=size(ind,2);
    warning('expanding columns of ind to match data');
    data(~ind,:) = NaN;
else
    data(~ind) = NaN;
end