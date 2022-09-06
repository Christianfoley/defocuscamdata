function XYZ = xyY2XYZ(xyY)
	x = xyY(:,1); y = xyY(:,2); Y = xyY(:,3);

	% Y is already known, don't recompute
	X = (Y./y) .* x;
	Z = (Y./y) .* (1-y-x);

	XYZ = [X Y Z];
end
