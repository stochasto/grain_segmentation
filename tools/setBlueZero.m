function i2BlueNil = setBlueZero(I, redTol, greenTol)

s = size(I);

%x = find( ((I(:,:,3) - 15) > I(:,:,1)) & ((I(:,:,3)) > I(:,:,2)) ); % GOOD

x = find( ((I(:,:,3) - redTol) > I(:,:,1)) & ((I(:,:,3) - greenTol) > I(:,:,2)) );

i2BlueNil = zeros(s(1),s(2));

i2BlueNil(x) = 1;

i2BlueNil = ~i2BlueNil;