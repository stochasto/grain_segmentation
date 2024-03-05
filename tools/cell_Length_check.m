function sizeList = cell_Length_check(c,isHist)

s = numel(c);

sizeList = zeros(s,1);

for i = 1:1:s
    sizeList(i) = numel(c{i});
end

if(isHist)
    figure
    hist(sizeList,sqrt(s))
    title('Histogram of cluster sizes')
end