function step_load_image(path, maxVal)
    global Imean;
    global Iamp;

    [Y, X, ~] = size(imread(strcat(path, '0.tif')));
    I = gpuArray(zeros(4, Y, X, 3, 'double'));

    for x=0:3
        deg = num2str(45 * x);
        buf = gpuArray(imread(strcat(path, deg, '.tif')));
        I(x+1, :, :, :) = fun_srgb_to_linearrgb(double(buf) ./ maxVal);
    end
    
    if mod(Y, 2) == 1
        I = I(:, 1:end-1, :, :);
    end
    if mod(X, 2) == 1
        I = I(:, :, 1:end-1, :);
    end
    
    I(1, :, :, :) = max(I(1, :, :, :), I(2, :, :, :) + I(4, :, :, :) - I(3, :, :, :));
    I(2, :, :, :) = max(I(2, :, :, :), I(1, :, :, :) + I(3, :, :, :) - I(4, :, :, :));
    I(3, :, :, :) = max(I(3, :, :, :), I(2, :, :, :) + I(4, :, :, :) - I(1, :, :, :));
    I(4, :, :, :) = max(I(4, :, :, :), I(1, :, :, :) + I(3, :, :, :) - I(2, :, :, :));
    
    I = fft(I, 4, 1) * 0.5;
    
    Imean = squeeze(abs(I(1, :, :, :))) * 0.5; % 0.5 * Diffuse + 0.5 * Perp + 0.5 * Parallel
    Iamp = squeeze(abs(I(2, :, :, :))); % 0.5 * (Perp - Parallel)
    
    clear I;
    
    Iamp = min(Imean, Iamp);
    fun_edge_extend(64);
end
