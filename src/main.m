clc;
clc;
clear;

[x, fs] = audioread("C:\Users\rick2\Documents\Multi_FX\Matlab\data\test.wav");

%% BUILD FX CHAIN

effects = {};
disp("Build FX Chain")

% Gain
gain_on = input("Gain required? ", "s");
    if strcmpi(gain_on, 'y')
        disp("Gain enable");
        gainVal = input("Enter gain value: ");
        gainVal = max(min(gainVal, 5),0); % Clamped from 0-5

        effects{end+1}.name = "Gain";
        effects{end}.process = @(x) applyGain(x, gainVal);
    end 

% Hard Clipping
hc_on = input("Hard Clipping required? ", "s");
    if strcmpi(hc_on, 'y')
        disp("Hard clipping enabled");
        threshold = input("Enter threshold value(0-1): ");
        threshold = max(min(threshold, 1),0); % Clamped from 0-1
        
        effects{end+1}.name = "Hard Clipping";
        effects{end}.process = @(x) applyHardClipping(x, threshold);
    end

% Soft Clipping
sc_on = input("Soft Clipping required? ", "s");
    if strcmpi(sc_on, 'y')
        disp("Soft clipping enabled");      
        threshold = input("Enter threshold value(0-1): ");
        threshold = max(min(threshold, 1),0); % Clamped from 0-1
        
        effects{end+1}.name = "Soft Clipping";
        effects{end}.process = @(x) applySoftClipping(x, threshold);
    end

% First Order LPF
lpf_on = input("LPF required? ", "s");
    if strcmpi(lpf_on, 'y')
        disp("LPF enabled");      
        fc = input("Enter cutoff freq (20-20,000): ");
        fc = max(min(fc, 20000),20); % Clamped to audible range
        
        effects{end+1}.name = "LPF";
        effects{end}.process = @(x) applyLPF(x, fs, fc);

        plotLPF(fs, fc);
    end

% First Order HPF
hpf_on = input("HPF required? ", "s");
    if strcmpi(hpf_on, 'y')
        disp("HPF enabled");      
        fc = input("Enter cutoff freq (20-20,000): ");
        fc = max(min(fc, 20000),20); % Clamped to audible range
        
        effects{end+1}.name = "HPF";
        effects{end}.process = @(x) applyHPF(x, fs, fc);

        plotHPF(fs, fc);
    end

% Delay
delay_on = input("Delay required? ", "s");
    if strcmpi(delay_on, 'y')
        disp("Delay enabled");      

        delayTime = input("Enter delay time in seconds: ");
        delayTime = max(delayTime, 0); % Ensure non-negative delay time

        feedback = input("Enter feedback value (0-0.99): ");
        feedback = max(min(feedback, 0.99),0); % Clamped from 0-0.99

        mix = input("Enter mix value (0-1) [Dry-Wet]: ");
        mix = max(min(mix, 1),0); % Clamped from 0-1
        
        effects{end+1}.name = 'Delay';
        effects{end}.process = @(x) applyDelay(x, fs, delayTime, feedback, mix);
    end
    
% Current Order
disp("Current FX chain:");
for k = 1:length(effects)
    fprintf("%d: %s\n", k, effects{k}.name);
end

% User Reorder
if length(effects) > 1
    order = input("Enter new order (example: [2 1 3]) or press Enter: ");

    if ~isempty(order)
        if numel(order) == length(effects) && all(sort(order) == 1:length(effects))
            effects = effects(order);
        else
            disp("Invalid order. Keeping original.");
        end
    end
end

% Final Order
disp(" ");
disp("Final FX chain:");
for k = 1:length(effects)
    fprintf("%d: %s\n", k, effects{k}.name);
end
    
%% EXECUTION

% Apply Processing
y = x;
for k = 1:length(effects)
    y = effects{k}.process(y);
end

% Normalisation 
y_out = y;    
peak = max(abs(y_out));
if peak > 1
    y_out = y_out / peak;
end

audiowrite("output.wav", y_out, fs);

%% VISUALISATION

% Waveform Display
N = min(length(x), fs * 0.02);

t = (0:N-1) / fs;

figure;
plot(t, x(1:N), 'b', t, y(1:N), 'r');
legend('Input','Output (Gain + Clip)');
xlabel('Time (s)'); ylabel('Amplitude');
title('Waveform Comparison');
grid on;

% Frequency Response of filters


% Metering
fprintf("Input peak:  %.3f\n", max(abs(x)));
fprintf("Output peak (pre-normalisation): %.3f\n", max(abs(y)));
fprintf("Output peak (post-normalisation): %.3f\n", max(abs(y_out)));
disp("Done");


