function Id2 = fun_adjust_textures(Id, InColorCoords, InThreshold, InBounds, OutColor)
    % Textures
    AlbedoLightMap = max(0.001, fun_euclidean_length(Id, 3));
    Albedo = Id ./ AlbedoLightMap;

    cIn = Albedo(InColorCoords(1), InColorCoords(2), :);
    
    CompareVec = zeros([1 1 3]);
    CompareVec(1, 1, :) = cIn;
    BinaryMap = fun_euclidean_length(Albedo - CompareVec, 3) < InThreshold;

    BinaryMap = imopen(BinaryMap, strel('disk', 1));
    BinaryMap = imclose(BinaryMap, strel('disk', 6));

    % Top Left Bottom Right
    BinaryMap(1:InBounds(1), :, :) = 0;
    BinaryMap(:, 1:InBounds(2), :) = 0;
    BinaryMap(InBounds(3):end, :, :) = 0;
    BinaryMap(:, InBounds(4):end, :) = 0;

    Motif = zeros([1 1 3]);
    Motif(1, 1, :) = OutColor;
    
    Albedo2 = BinaryMap .* Motif + (1 - BinaryMap) .* Albedo;
    Id2 = Albedo2 .* AlbedoLightMap;
end
