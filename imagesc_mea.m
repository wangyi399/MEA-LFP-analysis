function imagesc_mea(specs, spec_min, spec_max);

tdt_map = [8,16,24,32;...
    7,15,23,31;...
    6,14,22,30;...
    5,13,21,29;...
    4,12,20,28;...
    3,11,19,27;...
    2,10,18,26;...
    1,9,17,25];

rows = 8;
cols = 4;

if nargin == 1;
    spec_max = max(max(max(specs)));
    spec_min = min(min(min(specs)));
end

for x=1:rows
    for y=1:cols
        indx = tdt_map(x,y);
        subplot(rows,cols,(x*cols)-cols+y,'align');
        imagesc(specs(:,:,indx), [spec_min spec_max]);
    end
end