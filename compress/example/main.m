addpath('l1magic-1.11/l1magic/Optimization');

PM=5

G = 4;
fs = 40000;
N = 500;
K = round(N/G);

t = 1;
t0 = 0;
ifun = @(t) sin(1394*pi*t) + sin(3266*pi*t);

t = t0:1/fs:t0+(N-1)/fs;
raw = ifun(t);

%plot(x(1:N/4));


%mask = repmat([1,zeros(1,G-1)],1,N/G);

%x = raw .* mask;
x = raw;
x(randperm(N, N-K)) = 0;
x = x';
subplot(PM,1,1); plot(x(1:N));

A = randn(K, N);
A = orth(A')';
%D = dct(eye(N,N));
%A = D(K,:)
%A = fspecial('gaussian',16);

y = A*raw';

x0 = A'*y;
subplot(PM,1,2); plot(x0(1:N));
xp = l1eq_pd(x, A, [], y, 1e-4);
subplot(PM,1,3); plot(xp(1:N));


Y = fft(raw);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
F = fs*(0:(N/2))/N;
subplot(PM,1,4); plot(F,P1);
Y = fft(xp);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
F = fs*(0:(N/2))/N;
subplot(PM,1,5); plot(F,P1);

