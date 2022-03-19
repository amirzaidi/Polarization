function out = euclidianlength(in, dim)
    out = sqrt(sum(in .^ 2, dim));
end

