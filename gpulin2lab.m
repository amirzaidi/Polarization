function out = gpulin2lab(in)
    out = gpuArray(rgb2lab(gather(in), 'ColorSpace', 'linear-rgb'));
end

