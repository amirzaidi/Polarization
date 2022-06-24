function a = fun_line_intersect_3d(Astart, Adir, Bstart, Bdir)
    Cdir = cross(Adir, Bdir, 3);
    RHS = gpuArray(Bstart - Astart);
    
    % Vector form:  Astart + Adir*a + Cdir*c = Bstart + Bdir*b
    %               Adir*a + Cdir*c -Bdir*b = Bstart - Astart
    % Matrix form:	[Adir Cdir -Bdir][a c b]' = [Bstart - Astart]
    % Find [a c b] using Cramer's Rule.
    
    % Optimization: Reuse determinants Mxa1, Mya2, Mza3 where possible.
    D1 = Cdir(:, :, 2) .* -Bdir(:, :, 3) + Bdir(:, :, 2) .* Cdir(:, :, 3);
    D2 = Adir(:, :, 2) .* -Bdir(:, :, 3) + Bdir(:, :, 2) .* Adir(:, :, 3);
    D3 = Adir(:, :, 2) .* Cdir(:, :, 3) - Cdir(:, :, 2) .* Adir(:, :, 3);
    D = Adir(:, :, 1) .* D1 - Cdir(:, :, 1) .* D2 - Bdir(:, :, 1) .* D3;
    
    % Optimization: Do not copy to matrix, but manually calculate determinant.
    % Everything in column 1 is replaced with RHS (Right-Hand Side).
    %%DMxa1 = MAll(:, :, 2, 2) .* MAll(:, :, 3, 3) - MAll(:, :, 2, 3) .* MAll(:, :, 3, 2);
    Dx2 = RHS(:, :, 2) .* -Bdir(:, :, 3) + Bdir(:, :, 2) .* RHS(:, :, 3);
    Dx3 = RHS(:, :, 2) .* Cdir(:, :, 3) - Cdir(:, :, 2) .* RHS(:, :, 3);
    Dx = RHS(:, :, 1) .* D1 - Cdir(:, :, 1) .* Dx2 - Bdir(:, :, 1) .* Dx3;
    clear D1;
    clear Dx2;
    clear Dx3;
    
    % Everything in column 2 is replaced with RHS.
    %Dy1 = RHS(:, :, 2) .* -Bdir(:, :, 3) + Bdir(:, :, 2) .* RHS(:, :, 3);
    %%Dy2 = MAll(:, :, 2, 1) .* MAll(:, :, 3, 3) - MAll(:, :, 2, 3) .* MAll(:, :, 3, 1);
    %Dy3 = Adir(:, :, 2) .* RHS(:, :, 3) - RHS(:, :, 2) .* Adir(:, :, 3);
    %Dy = Adir(:, :, 1) .* Dy1 - RHS(:, :, 1) .* D2 - Bdir(:, :, 1) .* Dy3;
    %clear Dy1;
    %clear D2;
    %clear Dy3;
    
    % Everything in column 3 is replaced with RHS.
    %Dz1 = Cdir(:, :, 2) .* RHS(:, :, 3) - RHS(:, :, 2) .* Cdir(:, :, 3);
    %Dz2 = Adir(:, :, 2) .* RHS(:, :, 3) - RHS(:, :, 2) .* Adir(:, :, 3);
    %%Dz3 = MAll(:, :, 2, 1) .* MAll(:, :, 3, 2) - MAll(:, :, 2, 2) .* MAll(:, :, 3, 1);
    %Dz = Adir(:, :, 1) .* Dz1 - Cdir(:, :, 1) .* Dz2 + RHS(:, :, 1) .* D3;
    %clear Dz1;
    %clear Dz2;
    %clear D3;
    
    % Found [x y z] = [a c b]
    a = squeeze(Dx ./ D);
    %c = squeeze(Dy ./ D);
    %b = squeeze(Dz ./ D);
end

