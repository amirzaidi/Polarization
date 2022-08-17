function out = fun_scaleup2x(img)
    [ny, nx, dim] = size(img);
    out = reshape(repmat(reshape(img, 1, ny, 1, nx, dim), 2, 1, 2, 1, 1), ny * 2, nx * 2, dim);
end
