function fun_imwritelin(img, file)
    [~, ~] = mkdir('out');
    imwrite(fun_linearrgb_to_srgb(img), strcat('out/', file, '.tif'));
    
    [~, ~, dim] = size(img);
    if (dim > 1)
        imwrite(fun_linearrgb_to_srgb(img * 2.0), strcat('out/comp_', file, '.jpg'), 'quality', 90);
    end
end
