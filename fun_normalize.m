function out = fun_normalize(in, dim)
    out = in ./ max(0.0001, fun_euclidean_length(in, dim));
end
