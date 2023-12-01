function out = fun_normalize(in, dim)
    out = in ./ fun_euclidean_length(in, dim);
end
