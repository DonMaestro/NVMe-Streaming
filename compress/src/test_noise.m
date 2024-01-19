
G = 4;
fs = 40000;
N = 2048;
K = round(N/G);

M=6;

raw = zeros(1,N);

raw = awgn(raw,8);

b = fir1(512, [19480/fs*2, 19500/fs*2]);

figure(1);
freqz(b);

figure(2);

fraw = filter(b,1,raw);

subplot(1,2,1);
Y = fft(fraw);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs/N*(0:(N/2));
plot(f,P1);

subplot(1,2,2);
plot(fraw);

