function [sig_breaths,sig_vals,cis,all_spec] = test_breathsig(spec_norm,brthindx,g_freqs);

%input: "spec_norm" is [time, freq, trials, breaths], defined per channel

baseline = find(brthindx <= 0); %get all breaths before stimilus (stim triggered on breath 0, so event occurs on next breath)
signal = find(brthindx >= 1); %get all breaths after stimilus
alpha = .05;

%     base_mean = squeeze(mean(spec_norm(:,g_freqs,:,baseline),1));
%     base_gmean = squeeze(mean(base_mean,1));
%     all_mean = squeeze(mean(spec_norm(:,g_freqs,:,:),1));
%     all_gmean = squeeze(mean(all_mean,1));
%     for i=1:size(all_gmean,2) %for each breath
%         [sig_breaths(i,n),sig_vals(i,n),cis(i,:,n)] = ttest2(all_gmean(:,i),base_gmean(:),alpha/size(all_gmean,2),'both'); %do two-tailed t-test
%     end
%     all_spec = all_gmean;

base_max = squeeze(max(spec_norm(:,g_freqs,:,baseline),[],1));
base_gmax = squeeze(max(base_max,[],1));
all_max = squeeze(max(spec_norm(:,g_freqs,:,:),[],1));
all_gmax = squeeze(max(all_max,[],1));
for i=1:size(all_gmax,2) %for each breath
    [sig_breaths(i),sig_vals(i),cis(i,:)] = ttest2(all_gmax(:,i),base_gmax(:),alpha/size(all_gmax,2),'both'); %do two-tailed t-test, use bonferroni correction for n=all breaths
end
all_spec = all_gmax;
end