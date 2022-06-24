function out = fun_cross_bilateral(in, Iweight, sigma_spatial, sigma_tonal)
    function [Value, Valid] = kappa(~, ~, cy_shift, cx_shift, ~, ~)
        Value = in(cy_shift, cx_shift, :);
        Valid = 1;
    end
    
    [ny, nx, ~] = size(Iweight);
    out = fun_functional_bilateral(1:ny, 1:nx, Iweight, sigma_spatial, sigma_tonal, @kappa);
end
