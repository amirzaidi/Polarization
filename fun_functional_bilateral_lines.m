function out = fun_functional_bilateral_lines(cy, cx, Imean, Iamp, Idif, k, kMin, kMax, sigma_spatial, sigma_tonal)
    % Line 1: From DiffuseRGB_Center to MeanRGB_Center, inverted.
    % Astart = Imean_center;
    % Adir = -Iamp_center;
    Imean_center = Imean(cy, cx, :);
    Iamp_center = Iamp(cy, cx, :);

    function [Value, Valid] = kappa(~, ~, cy_shift, cx_shift, dy, dx)        
        if (dy == 0 && dx == 0)
            Value = k(cy, cx, :); % Take the current estimate.
            Valid = 1;
        else
            % Ensure this is positive.
            Idif_shift = Idif(cy_shift, cx_shift, :);

            % Line 2: from O to Idif_shift.
            % Bstart = 0 .* Idif_shift;
            % Bend = Idif_shift;
            Value = fun_line_intersect_3d(Imean_center, -Iamp_center, 0.0, Idif_shift);
            Value = min(max(Value, kMin), kMax);
            % What we get: The k to get from total (mean) to diffuse.

            % Weight by how close we can get to the shifted value.
            Idif_center_new = max(0.0001, Imean_center - Value .* Iamp_center);
            Valid = ~isnan(Value) .* fun_gaussian_dist(Idif_center_new, Idif_shift, 3, 9990.01);
        end
    end
    
    out = fun_functional_bilateral(cy, cx, Imean - Iamp, sigma_spatial, sigma_tonal, @kappa, 1);
end
