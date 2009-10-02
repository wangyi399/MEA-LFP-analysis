% empirical map collected on July 1-2 by Armen and Matt by systematically pulling electrode out of solution one electrode at a time.  
empirical_map = [5, 2,31,30;...
                16,11,20,17;...
                 4, 9,29,19;... %4 is dead
                 7,12,18,32;... %12 may equal 14
                 3, 6,27,28;...
                14,13,22,21;... %14 may equal 12
                15, 8,23,26;...
                10, 1,24,25]; 

numodors = size(sig_breaths_allodors,3);
rows = 8;
cols = 4;
%order_concs = [1 5 4 3 2]; %order of concentrations (event types) from low to high


sum_sigs = squeeze(sum(sig_breaths_allodors(:,2,:,:),1)); %sig_breaths_allodors dimensions (breaths,sigtype,channel,event_type)

% 
% for i=1:numodors
%     for x=1:rows
%         for y=1:cols
%             indx = empirical_map(x,y);
%             remap_sigodors(x,y,i) = sum_sigs(indx,i);
%         end
%     end
%     subplot(numodors,1,i);imagesc(squeeze(remap_sigodors(:,:,i)));
%     hold on;
% end

for x=1:rows
    for y=1:cols
        indx = empirical_map(x,y);
        subplot(rows,cols,(x*cols)-cols+y,'align');
        plot(sum_sigs(indx,:));
    end
end

% for h=1:numodors 
% subplot(numodors,1,h);imagesc(squeeze(sig_breaths_allodors(:,:,h)));
% hold on;
% end