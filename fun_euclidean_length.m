function out = fun_euclidean_length(in, dim)
    out = sqrt(sum(in .* in, dim));
end
