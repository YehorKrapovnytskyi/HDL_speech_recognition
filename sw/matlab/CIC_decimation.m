%% Initialize filter parameters
B = 16;
R = 80;                           % Decimation Ratio
N = 2;                            % Order
M = 1;                            % Diff delay
NFFT = 2 ^ 16;
ff = 0:1/NFFT:1-1/NFFT;

Fs = 1.28e6;                      % Set sampling rate
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
NFFT = 2 ^ 16;
hFFT = abs(fft(h, length(HCIC)));
hFFT = hFFT(1 : length(hFFT) / 2);
resp = ones(1, NFFT);
resp(1:NFFT/2) = hFFT;
result = 20 * log10(resp .* HCIC);
plot(ff, result);


%% Plot filter response                      
%figure("name", "CIC filter response with FIR compensation", 'Numbertitle', 'off');
%plot(f, HCICdb, '-.', 'LineWidth', 2, 'Color',[0 0 1]); % Plot frequecy response in db
%hold on;







