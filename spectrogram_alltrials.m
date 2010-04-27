% must load desired "spec_norm" and "f" matrix for this script to run
% spec_norm is [time,freqs,trials,breaths]
figure
data = spec_norm;
channel = 13;
gamma = [10 100];
g_freqs = find(f>gamma(1) & f<gamma(2));

allspecs = data(:,g_freqs,:,:,channel);
for t = 1:size(allspecs,3)
    for b = 1:size(allspecs,4)
        if b == 1
            allspecs_mergebreaths = allspecs(:,:,t,b);
        else 
            allspecs_mergebreaths = [allspecs_mergebreaths; allspecs(:,:,t,b)]; %merge columns, concatenating over time (dim1)
        end
    end
    allspecs_alltrials(:,:,t) = allspecs_mergebreaths;
end

spec_max = squeeze(max(max(max(max(data(:,g_freqs,:,:,channel))))));
spec_min = squeeze(min(min(min(min(data(:,g_freqs,:,:,channel))))));
spec_std1 = data(:,g_freqs,:,:,channel);
spec_std = std(spec_std1(:));

for x = 1:size(data,3) %for all trials
    subplot(size(data,3),1,x,'align');
    imagesc(allspecs_alltrials(:,:,x)', [spec_std*-1 spec_std*5]);
    axis off;
    axis tight;
    h = colorbar;
end