%function [imps] = det_impulses(wave_segs)
%imps are 32 vectors of the waveform impulse magnitude in sequential time bins

dt = 10; %win size in ms
srate = 3051.76; %sample rate
win = ceil(srate*(dt/1000)); %win in samples

data_filt = filter_data(wave_segs,3051.76,2);

for n = 1:size(data_filt,4);
    dat = data_filt(:,:,:,n);
    dat_std = std(dat(:));
    dat_lin = dat(:);
    for i = 2:floor(length(dat_lin)/win);
        w = ((i*win)-win):(i*win);
        imp_max = max(dat_lin(w));
        imp_min = min(dat_lin(w));
        if imp_max - imp_min <= dat_std*2
            imps(i,n) = NaN;
        elseif find(max(dat_lin(w))) == 1|size(w);
            imps(i,n) = NaN;
        else
            imps(i,n) = imp_max-imp_min;
        end
    end
end

%scatter(imps1,imps2,'.');hold on;plot(1:max(imps1(:,3)),'r');
%end