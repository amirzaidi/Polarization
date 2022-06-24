% From MATLAB source code. Extracted for GPU parallelization.
function y = fun_srgb_to_linearrgb(x)
    % Curve parameters
    gamma = cast(2.4,'like',x);
    a     = cast(1/1.055,'like',x);
    b     = cast(0.055/1.055,'like',x);
    c     = cast(1/12.92,'like',x);
    d     = cast(0.04045,'like',x);

    in_sign = -2 * (x < 0) + 1;
    x = abs(x);

    lin_range = (x < d);
    gamma_range = ~lin_range;

    y = zeros(size(x),'like',x);

    y(gamma_range) = exp(gamma .* log(a * x(gamma_range) + b));
    y(lin_range) = c * x(lin_range);

    y = y .* in_sign;
end
