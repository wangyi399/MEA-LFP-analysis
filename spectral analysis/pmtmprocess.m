function [spec_norm aveallgamma] = pmtmprocess(spec,f,brthindx,base_mode,g_freqs);

% Do signal normalization
% spec input is the pmtm spectrogram from one odor trial from one electrode site
% spec = (time, freq, trial, breath) for each channel(n)
% spec_norm is same size as spec

baseline = find(brthindx <= 1); %get all breaths before stimilus (stim triggered on breath 0, so event occurs on next breath)
signal = find(brthindx > 1); %get all breaths after stimilus
spec_norm = zeros(size(spec));
%% Normalize Spectral density by frequency (over all trials), expresses as Db

if base_mode == 0 %base_mode=0 normalizes to average baseline power in each band individaully
    spec = spec+100;
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(mean(spec(:,i,:,:),1)); %average power for each frequency band (ave over time)
        b = squeeze(mean(a(:,baseline),2)); %average this over baseline breaths
        fmean(i) = mean(b); %average over all trials
        spec_norm(:,i,:,:) = 10.*(log10(spec(:,i,:,:)./fmean(i))); %normalize freq band to ave power of baseline of all trials - express as dB change
    end

elseif base_mode == 1 %base_mode=1 normalizes to average baseline power to the stdev of each frequencies baseline, and sets all baseline specs to zero
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(mean(spec(:,i,:,:),1)); %average power for each frequency band (ave over time)
            b = squeeze(mean(a(:,baseline),2)); %average this over baseline breaths
            fmean(i) = mean(b); %average over all trials
        spec_norm(:,i,:,:) = spec(:,i,:,:)-fmean(i); %subtract each value from the baseline pop average at that frequency
            std1 = squeeze(spec_norm(:,i,:,baseline));
            base_std(i) = std(std1(:));
        spec_norm(:,i,:,:) = 10.*(log10((spec_norm(:,i,:,:)/base_std(i))+100)); %normalize freq band to baseline pop stdev - express as dB change, add 100 to take log of positive number
            c = squeeze(mean(spec_norm(:,i,:,:),1)); %average power for each frequency band (ave over time)
            d = squeeze(mean(c(:,baseline),2)); %average this over baseline breaths
            fnorm_mean(i) = mean(d); %average over all trials, this is a second calculation of the baseline pop average, just after normalization
        spec_norm(:,i,:,:) = spec_norm(:,i,:,:)-fnorm_mean(i); %subtract average of baseline region per freq, bring baseline average to zero
    end
    
elseif base_mode == 2 %base_mode=1 normalizes to average baseline power in each band individaully, and sets all baseline specs to zero
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(mean(spec(:,i,:,:),1)); %average power for each frequency band (ave over time)
        b = squeeze(mean(a(:,baseline),2)); %average this over baseline breaths
        fmean(i) = mean(b); %average over all trials
        spec_norm_a(:,i,:,:) = spec(:,i,:,:)-fmean(i);
        spec_norm(:,i,:,:) = 10.*(log10((spec_norm_a(:,i,:,:)./fmean(i))+100)); %normalize freq band to ave power of baseline of all trials - express as dB change
        c = squeeze(mean(spec_norm(:,i,:,:),1)); %average power for each frequency band (ave over time)
        d = squeeze(mean(c(:,baseline),2)); %average this over baseline breaths
        fnorm_mean(i) = mean(d); %average over all trials
        spec_norm(:,i,:,:) = spec_norm(:,i,:,:)-fnorm_mean(i); %subtract average of baseline region per freq, bring baseline average to zero
    end

elseif base_mode == 3 %base_mode=2 normalizes to max baseline power of all gamma freq bands
    spec = spec+100;
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(max(spec(:,i,:,:),[],1)); %maximum power for each frequency band (ave over time)
        b = squeeze(mean(a(:,baseline),2)); %average this over baseline breaths
        fmean(i) = mean(b); %average over all trials
    end
    fmean_gamma = max(fmean(g_freqs)); %take max baseline gamma power
    spec_norm(:,:,:,:) = 10.*(log10(spec(:,g_freqs,:,:)./fmean_gamma)); % express as dB change

elseif base_mode == 4 %base_mode=3 normalizes to max baseline power averaged over gamma freq bands
    spec = spec+100;
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(max(spec(:,i,:,:),[],1)); %maximum power for each frequency band (ave over time)
        b = squeeze(mean(a(:,baseline),2)); %average this over baseline breaths
        fmean(i) = mean(b); %average over all trials
    end
    fmean_gamma = mean(fmean(g_freqs)); %take aveage of max baseline gamma powers
    spec_norm(:,:,:,:) = 10.*(log10(spec(:,g_freqs,:,:)./fmean_gamma)); % express as dB change

elseif base_mode == 5 %base_mode=4 normalizes to average baseline power in each band individaully, and also adjusts for band dynamic range
    spec = spec+100;
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(mean(mean(spec,4),3)); %average power for each frequency band (ave over time)
        fmean(i) = squeeze(mean(a(i,baseline),2)); %average this over baseline breaths
        fmax(i) = max(a(:,i),[],1);
        fmin(i) = min(a(:,i),[],1);
        spec_dyn_norm(:,i,:,:) = spec(:,i,:,:)./(fmax(i)/fmin(i));
        spec_norm(:,i,:,:) = 10.*(log10(spec_dyn_norm(:,i,:,:)./fmean(i))); %normalize freq band to ave power of baseline of all trials - express as dB change
    end

elseif base_mode == 6 %base_mode=5 normalizes to average baseline power in each band individaully, and also adjusts for band dynamic range after db normalization
    spec = spec+100;
    for i=1:size(spec,2); %iterate over frequency dim
        a = squeeze(mean(mean(spec,4),3)); %average power for each frequency band (ave over time)
        fmean(i) = squeeze(mean(a(i,baseline),2)); %average this over baseline breaths
        spec_norm(:,i,:,:) = 10.*(log10(spec(:,i,:,:)./fmean(i))); %normalize freq band to ave power of baseline of all trials - express as dB change
        b = squeeze(mean(mean(spec_norm,4),3));
        fmax(i) = max(b(:,i),[],1);
        fmin(i) = min(b(:,i),[],1);
        spec_dyn_norm(:,i,:,:) = spec_norm(:,i,:,:)./(fmax(i)/fmin(i));
    end
end

%% Gamma extract
allgamma = squeeze(mean(spec_norm(:,g_freqs,:,:),2)); %average over all gamma frequencies
aveallgamma = squeeze(mean(allgamma,2)); %average over trials
end