function [RGBimg, XYZimg] = colormatch(DAT)
	wlns = csvread('hyperWavelengths.csv');
	cmfData = csvread('ciexyz31_1.csv');
    wavelength_cmf = cmfData(:,1);
    x_bar = cmfData(:,2);
    y_bar = cmfData(:,3);
    z_bar = cmfData(:,4);
    if size(DAT, 3) == 400
        cmf = interp1(wavelength_cmf(20:422), [x_bar(20:422) y_bar(20:422) z_bar(20:422)], wlns(5:364), 'spline');
    else % then we have a compressed DAT file
        cmf = interp1(wavelength_cmf(20:422), [x_bar(20:422) y_bar(20:422) z_bar(20:422)], wlns(20:364), 'spline');
    end

    cmf(cmf < 0) = 0;

    w = size(DAT,2);
    h = size(DAT,1);
	XYZimg = zeros(h,w,3);

    if size(DAT, 3) == 400
        stepSize = [diff(wlns(5:364)); 0];
    else
        stepSize = [diff(wlns(20:364)); 0];
    end
    corrCMF(:,1) = 683 .* cmf(:,1) .* stepSize;
    corrCMF(:,2) = 683 .* cmf(:,2) .* stepSize;
    corrCMF(:,3) = 683 .* cmf(:,3) .* stepSize;

    DATvis = [];
    if size(DAT, 3) == 400
        DATvis = DAT(:,:,5:364);
    else
        DATvis = DAT;
    end

    DATvis = reshape(DATvis, w*h, size(DATvis, 3));
    XYZimg = (corrCMF'*DATvis')';
    XYZimg = reshape(XYZimg, h, w, 3);

    X = XYZimg(:,:,1);
    Y = XYZimg(:,:,2);
    Z = XYZimg(:,:,3);

    XYZ = [X(:) Y(:) Z(:)];

    monxyY = csvread('OLEDxyY.csv');

    RGBimg = XYZ2RGB(XYZ', monxyY);
    RGBimg = cat(3, reshape(RGBimg(1,:), h, w), reshape(RGBimg(2,:), h, w), reshape(RGBimg(3,:), h, w));
end
