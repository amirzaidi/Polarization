function out = fun_pyramid_upscale(in)
    [cellsize, ~] = size(in);
    out = cell(cellsize - 1, 1);
    for i = 1:cellsize-2
        out{i} = in{i};
    end
    
    blurred = imgaussfilt(imresize(in{cellsize}, 2.0), 1.36);
    out{cellsize - 1} = blurred; % + in{cellsize - 1};
end
