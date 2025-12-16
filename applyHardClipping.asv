function y = applyHardClipping (x, threshold)
    y = x;
    for i = 1:length(x)
        if y(i) > threshold
            y(i) = threshold;
        elseif y(i) < -threshold
            y(i) = -threshold;
        end
    end
end
