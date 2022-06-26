function fun_imwritelin(img, file)
    imwrite(fun_linearrgb_to_srgb(img), file);
end
