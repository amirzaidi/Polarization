function fun_imwritelin(img, file)
    [~, ~] = mkdir('out');
    imwrite(fun_linearrgb_to_srgb(img), strcat('out/', file, '.tif'));
    imwrite(fun_linearrgb_to_srgb(img), strcat('out/comp_', file, '.jpg'), 'quality', 90);
    
    if (size(img, 3) > 1)
        imwrite(fun_linearrgb_to_srgb(img * 2.0), strcat('out/bright_', file, '.jpg'), 'quality', 90);
    end
end
