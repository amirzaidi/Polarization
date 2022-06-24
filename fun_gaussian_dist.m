function out = fun_gaussian_dist(in1, in2, dim, s)
    indiff = in2 - in1;
    d2 = sum(indiff .* indiff, dim);
    out = exp(-0.5 .* d2 ./ (s .^ 2));
end
