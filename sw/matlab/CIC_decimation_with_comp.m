%% Initialize filter parameters
B = 16;
R = 125;                          % Decimation factor
N = 2;                            % Order
M = 1;                            % Diff delay
NFFT = 2 ^ 16;
ff = 0:1/NFFT:1-1/NFFT;

Fs = 2e6;                      % Set sampling rate
ts = 1/Fs;   
Fc = 8000;
Fo = Fc * R / Fs ;                % Normalized cutoff

p = 2e3;                          % Granularity
s = 0.25/p;                       % Step size
fp = [0:s:Fo];                    % Pass band frequency samples
fs = (Fo+s):s:0.5;                % Stop band frequency samples
f = [fp fs] * 2;

%% Ñalculate CIC filter
HCIC = abs(sin(pi * M * ff) ./ sin(pi * ff ./ R)) .^ N;   % Ñalculate CIC frequecy response
HCIC(1) = HCIC(2);                                    
HCICdb = 20 * log10(abs(HCIC));

%% Calculate compensation filter and its idead frequency response
L = 100; 
Mp = ones(1, length(fp));             % Pass band response; Mp(1)=1
Mp(2:end) = abs(M * R * sin(pi * fp(2:end) / R)./ sin(pi * M * fp(2:end))) .^ N; 
Mf = [Mp zeros(1, length(fs))];
f(end) = 1;
h = fir2(L, f, Mf);                   % Filter length L+1
h = h / max(h);                       % Floating point coefficients
hz = round(h * power(2, B - 1) - 1);  % Fixed point coefficients

%% Calculate FIR filter real frequency response
hFFT_db = 20 * log10(abs(fft(hz, length(HCIC))));
hFFT_db = hFFT_db - max(hFFT_db);
result_response = hFFT_db + HCICdb;

%% Parameters for HDL Simulink model
CLK_DECIMATION_FACTOR = 50; % 100 MHz / 50 = 2 MHz










%% Plot filter response                      
figure("name", "CIC filter response with FIR compensation", 'Numbertitle', 'off');
plot(ff, HCICdb - max(HCICdb), '--', 'LineWidth', 3, 'Color',[0 0 1]); 
hold on;
plot(ff, result_response - max(result_response), '-', 'LineWidth', 3, 'Color',[1 0 0]); 
hold on;
plot(ff, hFFT_db, '--', 'LineWidth', 3, 'Color',[1 1 0]); 
title([{'CIC, Comp. FIR and Result'};{sprintf('Filter Order = %i, Coef. width = %i', L, B)}]);
xlabel ('Freq (\pi x rad / samples)');
ylabel ('Magnitude (dB)');  
legend('CIC filter','Sum Response', 'Comp. FIR','location','northeast');
axis([0 1 -100 5]); 






