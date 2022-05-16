function [] = imshowphase(Amp, Phase, Ch)
    HSV(:, :, 1) = (Phase(:, :, Ch) ./ pi + 1.0) ./ 2.0;
    HSV(:, :, 2) = 1.0;
    HSV(:, :, 3) = min(1.0, 100 .* Amp(:, :, Ch));
    imshow(hsv2rgb(gather(HSV)));
end

