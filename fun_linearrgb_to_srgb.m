% From MATLAB source code. Extracted for GPU parallelization.
function y = fun_linearrgb_to_srgb(x)
    % Curve parameters
    gamma = cast(1/2.4,'like',x);
    a     = cast(1.055,'like',x);
    b     = cast(-0.055,'like',x);
    c     = cast(12.92,'like',x);
    d     = cast(0.0031308,'like',x);

    y = zeros(size(x),'like',x);

    in_sign = -2 * (x < 0) + 1;
    x = abs(x);

    lin_range = (x < d);
    gamma_range = ~lin_range;

    y(gamma_range) = a * exp(gamma .* log(x(gamma_range))) + b;
    y(lin_range) = c * x(lin_range);

    y = y .* in_sign;
end
