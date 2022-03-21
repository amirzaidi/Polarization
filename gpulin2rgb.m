function out = gpulin2rgb(in)
    out = gpuArray(lin2rgb(gather(in)));
end

