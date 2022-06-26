function out = fun_tonemap_curve(base, detail, basepow, detailpow)
    baselog = reallog(1 + (exp(1) - 1) .* base);
    baselog = baselog .^ basepow;
    base = (exp(baselog) - 1) ./ (exp(1) - 1);
    
    out = base .* (detail .^ detailpow);
end
