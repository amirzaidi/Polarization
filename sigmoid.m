function out = sigmoid(in, transfer)
    a = log((1.0 + transfer) / (1.0 - transfer)) / transfer;
    intransformed = 2.0 ./ (1.0 + exp(-a .* in)) - 1.0;
    
    gttransfer = in > transfer;
    out = gttransfer .* intransformed + (1 - gttransfer) .* in;
end

