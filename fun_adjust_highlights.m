function Is2 = fun_adjust_highlights(Is, Sigma, AdjustFactor)
    IsMean = fun_euclidean_length(Is, 3);
    IsMeanAvg = imgaussfilt(IsMean, Sigma);
    IsMean2 = IsMeanAvg .* ((IsMean ./ IsMeanAvg) .^ AdjustFactor);
    Is2 = Is .* IsMean2 ./ IsMean;
end
