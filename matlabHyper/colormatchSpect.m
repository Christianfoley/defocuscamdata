function [RGB, XYZ] = colormatchSpect(spect)
	wlns = csvread('hyperWavelengths.csv');
    cmfData = csvread('ciexyz31_1.csv');
    wavelength_cmf = cmfData(:,1);
    x_bar = cmfData(:,2);
    y_bar = cmfData(:,3);
    z_bar = cmfData(:,4);
    if length(spect) == 400
        cmf = interp1(wavelength_cmf(20:422), [x_bar(20:422) y_bar(20:422) z_bar(20:422)], wlns(5:364), 'spline');
    else % we have a spectrum from a compressed DAT file
        cmf = interp1(wavelength_cmf(20:422), [x_bar(20:422) y_bar(20:422) z_bar(20:422)], wlns(20:364), 'spline');
    end

    cmf(cmf < 0) = 0;

    XYZ = zeros(3,1);

    if size(DAT, 3) == 400
        stepSize = [diff(wlns(5:364)); 0];
    else
        stepSize = [diff(wlns(20:364)); 0];
    end
    corrCMF(:,1) = 683 .* cmf(:,1) .* stepSize;
    corrCMF(:,2) = 683 .* cmf(:,2) .* stepSize;
    corrCMF(:,3) = 683 .* cmf(:,3) .* stepSize;

    if length(spect) == 400
        XYZ = spect(5:364)'*corrCMF;
    else
        XYZ = spect'*corrCMF;
    end

    monxyY = csvread('OLEDxyY.csv');

    RGB = XYZ2RGB(XYZ', monxyY);
end
