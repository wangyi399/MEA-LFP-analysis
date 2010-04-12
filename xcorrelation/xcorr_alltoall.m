function[Corr_Per_Breath]= xcorr_alltoall(data,FirstChannel,LastChannel,sampFreq,filttype,filtorder)

%function outputs the zerolag correlation per breath, (averaging along
%events) in the matrix Corr_Per_Breath(32X32X11 matrix, last dimension is the number of breaths). It is for plotting correlations
%versus distance per channel
%the data is wavesegs 4d matrix [samples,events,breaths,channels]
%FirstChannel and LastChannel are specified first and last channels
%SampFreq is the sampling frequency, in our case 3051.76
%filttype= filttype for sinofilt.m specifies frequency band e.g. [40 100]
%filtorder is order for SimoFilt.m, 200 typically works best for gamma
data_filtered= filter_data(data,sampFreq,filttype,filtorder);

for breath=1:length(data(1,1,:,1))     %go over all breaths
    for event=1:length(data(1,:,1,1))      %go through all events
       t7=clock;
        %[specificbreath_per_event_corr]= Specific_breath_per_event(data_filtered,event,breath);                 %takes the specific breath
        [specificbreath_per_event_corr] = squeeze(data_filtered(:,event,breath,:));
        [newA1_channel]= remap2(specificbreath_per_event_corr,FirstChannel,LastChannel) ;      %reorderees the mapping
        finalcorr11 = xcorr(newA1_channel,'coeff');
        [qq,ww]=size(newA1_channel);
        m=1;
        for x=1:((LastChannel-FirstChannel)+1)          % we are referencing every channels correlation into a separated third dimension
            newmatrix(:,:,x) = finalcorr11(:,(m):(m+(LastChannel-FirstChannel)));
            m=m+((LastChannel-FirstChannel)+1);
        end
        Corr_Per_Event(:,:,event)= newmatrix(qq,:,:);   %Check from here, supposed to get the zerolag correlation for all channels, per reference channel, per event
        t9=etime(clock,t7)
    end
    Corr_Per_Breath(:,:,:,breath)=Corr_Per_Event;
    %Corr_Per_Breath(:,:,breath)=mean(Corr_Per_Event,3); %average over all events to get the breath correlations
end