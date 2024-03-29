function fun_edge_extend(MultipleOf)
    global Imean;
    global Iamp;
    global YY;
    global XX;
    
    [Y, X, ~] = size(Imean);

    YAdd = MultipleOf - mod(Y - 1, MultipleOf) - 1;
    XAdd = MultipleOf - mod(X - 1, MultipleOf) - 1;
    
    MirrSize = [YAdd XAdd] / 2;
    
    Imean = padarray(Imean, MirrSize, 'symmetric', 'both');
    Iamp = padarray(Iamp, MirrSize, 'symmetric', 'both');
    YY = (YAdd / 2) + (1 : Y);
    XX = (XAdd / 2) + (1 : X);
end
