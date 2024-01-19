
G = 4;
fs = 40000;
N = 2048;
K = round(N/G);

M=6;

tt = @(t0, tsize, fs) t0/fs:1/fs:(t0+tsize-1)/fs;

t0 = 0;
ifun = @(t) (sin(1394*2*pi*t) + sin(10000*2*pi*t) + cos(19266*2*pi*t)) / 3;

figure(1);

t0 = 1;
t = tt(t0, N, fs);
in = [ ifun(t); ifun(t) ].';
%raw = single(in(1:end,1).');
raw = single(in(1:N,1).');
subplot(2,1,1);
plot(in(1:N, 1));
title('input 1');
subplot(2,1,2);
plot(in(1:N, 2));
title('input 2');

figure(2);

subplot(1,2,1);
Y = fft(raw);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs/N*(0:(N/2));
plot(f,P1);

subplot(1,2,2);
%raw = raw + 0.1*randn(1,N);
raw = awgn(raw,80);
Y = fft(raw);
P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs/N*(0:(N/2));
plot(f,P1);

figure(3);

function h = findh(raw)
	M = floor((length(raw) - 1) / 2);

	A = flip(raw(1:M));
	for i = 2:M
		A = [ A; flip(raw(i:M+i-1)) ];
	endfor

	x = raw(M+1:2*M).';
	h = linsolve(A,x);

endfunction

b = fir1(20, 0.02);  % low pass filter
%Ufiltered = filtfilt(b, 1, raw);
Ufiltered = raw;
x = [];
for i = 100:N-1
	gg = Ufiltered(i-2*M-1:i);
	h = findh(gg(1:end-1));
	
	r = flip(gg(M+3:end));
	
	%raw(i+1);
	x = [x h'*r'];
endfor

subplot(2,1,1);
plot([gg raw(i+1)]);
subplot(2,1,2);
plot([gg x(end)]);

[ sf se ] = spkg(raw(101:N), x);

figure(4)

subplot(2,1,1);
hist(sf, max(sf));
subplot(2,1,2);
hist(se, max(se));

