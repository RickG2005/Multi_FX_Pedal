function y = applySoftClipping (x, threshold)
    y = threshold * tanh(x / threshold);
end
