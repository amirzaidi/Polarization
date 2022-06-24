function out = fun_pyramid_gaussian(in, scales)
    remaining = in;
    out = cell(scales, 1);
    
    for i=1:scales-1
        out{i} = remaining;
        remaining = imresize(imgaussfilt(remaining, 1.36), 0.5);
    end
    
    out{scales} = remaining;
end
