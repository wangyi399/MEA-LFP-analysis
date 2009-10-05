clear all;
% Define Global VARS
srate = 3051.76;  %Hz
%eventcode = 2;
winsize = .7;
brthindx = [-10:1:20];
maxfreq = 120;
dead_chans = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
             %1 2 3 4 5 6 7 8 9 1 1 2 3 4 5 6 7 8 9 1 1 2 3 4 5 6 7 8 9 1 1 2   
%sigtype = 0; %0 gives mean power, 1 gives max power
base_mode = 0; % 0 = normalizes to average baseline power in each band individaully
% 1 = normalizes to max baseline power of all gamma freq bands
% 2 = normalizes to max baseline power averaged over gamma freq bands

% upload the breath file - "breaths" in workspace
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick breath file');
for n = 1:length(datafile);
    cd(pathname);
    load(datafile);
end
% upload the event file - "events" in workspace
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick event file');
for n = 1:length(datafile);
    cd(pathname);
    load(datafile);
end

% sequentially open all channels
[datafile, pathname] = uigetfile(...
    '*.mat',...
    'Please pick a wave files for each ',...
    'MultiSelect', 'on');
cd(pathname);
datafile = datafile([2:32 1]); %fix uigetfile bug, 32chan

for odor = 1:5;
    eventcode = odor;
    for n = 1:length(datafile); %n to number of channels 
        if dead_chans(n)==1
            continue
        end
        load(datafile{n}); % name of array must be "wave"
        for x = 1:length(brthindx) %x to num of breaths
            wave_segs(:,:,x,n) = parsechans(wave,events,breaths,srate,eventcode,brthindx(x),winsize);
            [S, t, f] = pmtm_cust(squeeze(wave_segs(:,:,x,n)),srate,maxfreq);
            spec(:,:,:,x) = S; clear S; %spec = (time, freq, trial, breath)
            disp('breath'); disp(x);
        end
        g_freqs = find(f>50 & f<100);
        disp('site'); disp(n);
        [spec_norm(:,:,:,:,n) aveallgamma(:,:,n) allgamma(:,:,:,n)] = pmtmprocess(spec(:,:,:,:),f,brthindx,base_mode,g_freqs);
        [sig_breaths(:,:,n),sig_vals(:,:,n),cis(:,:,:,n),all_spec(:,:,:,n)] = test_breathsig(spec_norm(:,:,:,:,n),brthindx,g_freqs);
    end
    save(['spec_norm_odor' num2str(odor)], 'spec_norm');
    clear spec_norm;
    save(['spec_odor' num2str(odor)], 'spec');
    clear spec;
    save(['wave_segs' num2str(odor)], 'wave_segs');
    aveallgamma_allodors(:,:,:,odor) = aveallgamma;
    sig_breaths_allodors(:,:,:,odor) = sig_breaths;
end