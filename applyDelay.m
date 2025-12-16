function y = applyDelay(x, fs, delayTime, feedback, mix)
    delaySamples = round(delayTime*fs);
    N = length(x);

    y = zeros(size(x));
    buffer = zeros(delaySamples, 1);

    for n = 1:N
        idx = mod(n - 1, delaySamples) + 1; % Calculate circular buffer index
        delayed = buffer(idx); 
        y(n) = (1 - mix) * x(n) + mix * delayed; % Append output for sample
        buffer(idx) = x(n) + feedback * delayed; % Update buffer w/ feedback
    end
end
