function out = fun_functional_bilateral_direct_solve(Imeani, Iampi, sigma_spatial, sigma_tonal)    
    function [Value, Valid] = kappa(cy, cx, cy_shift, cx_shift, ~, ~)
        Diff_Start = Imeani(cy, cx, :) - Imeani(cy_shift, cx_shift, :);
        Diff_Add = Iampi(cy, cx, :) - Iampi(cy_shift, cx_shift, :);
        % How many times to add "Add" to "Start" for smallest vector?
        % Decompose Start into two orthogonal vectors: Add and Orthogonal_Add
        % Project Start onto Add to find how often Add is included.
        
        StartProjAdd1 = dot(Diff_Start, Diff_Add, 3);
        StartProjAdd2 = dot(Diff_Add, Diff_Add, 3);
        Value = StartProjAdd1 ./ max(0.0001, StartProjAdd2);
        % This is how much it is included. By removing it, you minimize the
        % Start vector by only keeping the orthogonal vector.
        
        % Only values with significant differences (>= 0.08) are valid.
        %Valid = StartProjAdd2 >= 0.0064;
        Valid = 1;
    end
    
    [ny, nx, ~] = size(Imeani);
    out = fun_functional_bilateral(1:ny, 1:nx, Imeani, sigma_spatial, sigma_tonal, @kappa);
end
