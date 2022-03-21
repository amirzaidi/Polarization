function out = gpurgb2lin(in)
    out = gpuArray(rgb2lin(gather(in)));
end

