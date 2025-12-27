function plotLPF(fs, fc)
    T = 1/fs;
    d_fc = 2*pi*fc/fs;
    a_fc = (2/T) * tan(d_fc/2);
    alpha = a_fc * T / 2;

    % Filter coefficients
    a1 = (alpha - 1) / (1 + alpha);
    b0 = alpha / (1 + alpha);
    b1 = b0;

    [H, f] = freqz([b0 b1], [1 a1], 4096, fs);
    
    % Plot
    figure;
    plot(f, abs(H), 'LineWidth', 1.5);
    hold on;
    yline(1, '--k', 'Unity Gain');
    xline(fc, '--r', 'Cutoff Frequency');
    hold off;

    xlabel('Frequency (Hz)');
    ylabel('Gain');
    title(sprintf('1st Order LPF Frequency Response (fc = %d Hz)', fc));
    grid on;
    ylim([0 1.1]);

end
