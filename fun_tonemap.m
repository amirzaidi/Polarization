function tonemapped = fun_tonemap(img, basepow, detailpow)
    lum = max(0.0001, fun_euclidean_length(img, 3));
    lumlow = fun_cross_bilateral(lum, img, 2.00, 0.15);
    lumhigh = lum ./ lumlow;
    lumnew = fun_tonemap_curve(lumlow, lumhigh, basepow, detailpow);
    
    tonemapped = img .* lumnew ./ lum;
end
