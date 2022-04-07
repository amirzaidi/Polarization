function out = gpulab2lin(in)
    out = gpuArray(lab2rgb(gather(in), 'ColorSpace', 'linear-rgb'));
end

