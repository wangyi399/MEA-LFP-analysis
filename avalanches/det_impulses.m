%function [imps] = det_impulses(wave_segs)
%imps are 32 vectors of the waveform impulse magnitude in sequential time bins

srate = 3051.76; %sample rate
data_filt = single(filter_data(wave_segs,3051.76,[40 100],200));
data_dims = size(wave_segs);
all_pks = single(NaN(data_dims));

for n = 1:size(data_filt,4);
    dat = data_filt(:,:,:,n);
    dat_lin = dat(:);
    wave_av = mean(dat_lin);
    dat_lin = dat_lin-wave_av;
    dat_dif = diff(dat_lin); %take 1st derivative
    dat_dif = sign(dat_dif); %express all values by sign (+1 or -1)
    kernal = [-1,1];
    dat_dif = conv(kernal,dat_dif); %convolve to isolate zero-crossings
    x = find(dat_dif);
    peaks_t = single(NaN(length(dat_lin),1));
    peaks_t(x) = dat_lin(x);
    peaks = dat_lin(x);
    a = reshape(peaks_t,data_dims(1),data_dims(2),data_dims(3));
    all_pkslin(:,n) = peaks_t;
    all_pks(:,:,:,n) = a;
    save(['peaks_chan' num2str(n)], 'peaks');
    clear peaks_t;
    disp('site'); disp(n);
end
save(['allpeaks'], 'all_pks');
save(['all_peakslin'], 'all_pkslin');

%scatter(imps1,imps2,'.');hold on;plot(1:max(imps1(:,3)),'r');