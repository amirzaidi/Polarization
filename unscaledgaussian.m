function out = unscaledgaussian(d, s)
    out = exp(-0.5 .* (d ./ s) .^ 2);
end
