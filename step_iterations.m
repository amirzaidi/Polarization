function k0 = step_iterations(k)
    global Imean;
    global Iamp;
    
    [qyTotal, qxTotal, ~] = size(Imean);
    divCount = 4;
    qyPart = qyTotal / divCount;
    qxPart = qxTotal / divCount;

    kMax = min(max(0.0001, Imean) ./ max(0.0001, Iamp), [], 3);
    kMax = max(1.0, kMax);
    
    % Starting point.
    k = min(kMax, k);

    % Init pyramids.
    PyrLevel = 4;
    ImeanPyr = fun_pyramid_gaussian(Imean, PyrLevel);
    IampPyr = fun_pyramid_gaussian(max(0.001, Iamp), PyrLevel);
    kPyr = fun_pyramid_gaussian(k, PyrLevel);
    kMaxPyr = fun_pyramid_gaussian(kMax, PyrLevel);
    clear k;

    % For each level of the pyramid.
    while PyrLevel >= 1
        PyrLevelDiv = 2 ^ (PyrLevel - 1);
        qyPartDiv = qyPart / PyrLevelDiv;
        qxPartDiv = qxPart / PyrLevelDiv;

        % Projection onto nearest colour plane.
        kMax = kMaxPyr{PyrLevel};
        
        % Direct solver. More noise means worse result, so use as lower bound.
        kSolve = fun_functional_bilateral_direct_solve(ImeanPyr{PyrLevel}, IampPyr{PyrLevel}, 0.33, 0.10);
        kMin = min(kMax, max(1.0, kSolve));
        clear kSolve;

        IterCount1 = 2 * PyrLevel;
        for i = 1:IterCount1
            % Iterative improvements.
            Idif = max(0.0001, ImeanPyr{PyrLevel} - kPyr{PyrLevel} .* IampPyr{PyrLevel});
            kCopy = fun_cross_bilateral(kPyr{PyrLevel}, Idif, 2.00, 0.05);
            
            % Bring the diffuse components close together.
            for qy = 0:(divCount-1)
                yOffset = qyPartDiv * qy;
                cy = (yOffset+1):(yOffset+qyPartDiv);
                for qx = 0:(divCount-1)
                    xOffset = qxPartDiv * qx;
                    cx = (xOffset+1):(xOffset+qxPartDiv);

                    kPyr{PyrLevel}(cy, cx) = fun_functional_bilateral_lines(...
                        cy, cx, ImeanPyr{PyrLevel}, IampPyr{PyrLevel}, Idif, kCopy, ...
                        kMin(cy, cx), kMax(cy, cx), 0.66, 0.02);
                end
            end
        end

        % Bilateral-filter the resulting polarization map.
        IterCount2 = 2;
        for i = 1:IterCount2
            % Do this with the Mean to always diffuse towards edges.
            kPyr{PyrLevel} = fun_cross_bilateral(kPyr{PyrLevel}, ImeanPyr{PyrLevel}, 2.00, 0.01);
        end

        if PyrLevel > 1
            kPyr = fun_pyramid_upscale(kPyr);
        else
            % Final bound.
            k0 = min(max(kPyr{1}, kMin), kMax);
        end

        PyrLevel = PyrLevel - 1;
    end
end

