function k = step_tile_estimate(halfSize)
    global Imean;
    global Iamp;
    
    [qyTotal, qxTotal, ~] = size(Imean);
    tileSize = halfSize * 2;
    qyTiles = qyTotal / halfSize;
    qxTiles = qxTotal / halfSize;

    k = gpuArray(zeros([qyTotal, qxTotal], 'double'));
    kWeights = gpuArray(zeros([qyTotal, qxTotal], 'double'));

    % Cos window used for weights.
    CosWindow = 0.5 - 0.5 .* cos(pi / tileSize + linspace(0, 2 * pi * (tileSize - 1) / tileSize, tileSize));
    CosWindow = CosWindow' * CosWindow;

    % 2D Coord Arrays for each tile.
    yCoords = (0:qyTiles-2)' * halfSize + (1:tileSize);
    xCoords = (0:qxTiles-2)' * halfSize + (1:tileSize);

    ImeanTiles = reshape(Imean(yCoords, xCoords, :), [qyTiles-1, tileSize, qxTiles-1, tileSize, 3]);
    IampTiles = reshape(Iamp(yCoords, xCoords, :), [qyTiles-1, tileSize, qxTiles-1, tileSize, 3]);

    % The tiles to compare.
    ImeanTilesGrad = ImeanTiles - mean(ImeanTiles, [2 4]);
    IampTilesGrad = IampTiles - mean(IampTiles, [2 4]);

    % Add window to gradients.
    CosWindowMult = gpuArray(zeros([1 tileSize 1 tileSize 1]));
    CosWindowMult(1, :, 1, :, 1) = CosWindow;
    ImeanTilesGrad = ImeanTilesGrad .* CosWindowMult;
    IampTilesGrad = IampTilesGrad .* CosWindowMult;
    clear CosWindowMult;

    % Do tile comparison.
    CorrNum = sum(ImeanTilesGrad .* IampTilesGrad, [2 4 5]);
    CorrDenom = sum(IampTilesGrad .* IampTilesGrad, [2 4 5]);
    CorrVals = squeeze(CorrNum ./ max(0.0001, CorrDenom));

    % For each point in the window, sum up the weighted values.
    for yWin = 1:tileSize
        yCoords2 = (0:qyTiles-2) * halfSize + yWin;
        for xWin = 1:tileSize
            xCoords2 = (0:qxTiles-2) * halfSize + xWin;
            CosWindowVal = CosWindow(yWin, xWin);

            k(yCoords2, xCoords2) = k(yCoords2, xCoords2) + CosWindowVal .* CorrVals;
            kWeights(yCoords2, xCoords2) = kWeights(yCoords2, xCoords2) + CosWindowVal;
        end
    end

    k = max(1.0, k ./ kWeights);
end
