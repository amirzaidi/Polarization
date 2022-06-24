function out = fun_functional_bilateral(cy, cx, Iweight, sigma_spatial, sigma_tonal, kappa, maxRange)
    [nyTotal, nxTotal, ~] = size(Iweight);
    [ny, nx, ~] = size(Iweight(cy, cx, :));

    % Allocate two arrays to calculate the weighted result.
    weights = gpuArray(zeros(ny, nx, 'double'));
    totals = weights;
    
    radius = ceil(sigma_spatial * 3);
    if exist('maxRange', 'var')
        radius = min(radius, maxRange);
    end
    
    for dy = -radius:radius
        cy_shift = max(1, min(nyTotal, cy + dy));
        for dx = -radius:radius
            cx_shift = max(1, min(nxTotal, cx + dx));
            
            [Value, Valid] = kappa(cy, cx, cy_shift, cx_shift, dy, dx);
            
            weight_spatial = fun_gaussian_dist([dy dx], [0 0], 2, sigma_spatial);
            weight_tonal = fun_gaussian_dist(Iweight(cy_shift, cx_shift, :), Iweight(cy, cx, :), 3, sigma_tonal);
            weight = Valid .* weight_spatial .* weight_tonal;
            
            totals = totals + weight .* Value;
            weights = weights + weight;
        end
    end
    
    out = totals ./ max(0.0001, weights);
end

