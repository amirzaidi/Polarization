function out = fun_scaledown2x(img)
    [ny, nx, dim] = size(img);
    out = squeeze(mean(reshape(img, 2, ny / 2, 2, nx / 2, dim), [1 3]));
end
