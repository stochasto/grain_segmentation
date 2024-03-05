function nMin = getNmin(marker)
rc = regionprops(marker);
nMin = numel(rc);
end