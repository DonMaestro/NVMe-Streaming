
G = 4;
fs = 40000;
N = 500;
K = round(N/G);

filen = '/media/StorageL0/temp_dir/dsd.2021-12-02T16_44_54_046.wav';
audioinfo(filen)
[ in fs ] = audioread(filen);

tt = @(t0, tsize, fs) t0/fs:1/fs:(t0+tsize-1)/fs;

t0 = 0;
ifun = @(t) (sin(1394*pi*t) + sin(3266*pi*t)) / 2;

if (!isfloat(in))
	printf('error: this is not float\n');
endif

figure(1);

t0 = 1;
t = tt(t0, N, fs);
%in = [ ifun(t); ifun(t) ].';
%raw = single(in(1:end,1).');
raw = single(in(1:N,1).');
subplot(2,1,1);
plot(in(1:N, 1));
title('input 1');
subplot(2,1,2);
plot(in(1:N, 2));
title('input 2');

bits = (double(dec2bin(typecast(raw, "uint32"))) - 48);
bits = [ zeros(abs(size(bits) - [0 32])) bits ];
exp = bin2dec(char(bits(:,2:9) + 48));
fra = bits(:,10:32) * 2 .^ (-1:-1:-23).';
%f = (-bits(:,1) * 2 + 1) .* 2.^(exp-127) .* ( 1 + fra);

bits(1:8,:)

figure(2)

subplot(2,1,1);
plot(exp);
subplot(2,1,2);
plot(fra);

figure(3)

subplot(2,1,1);
plot(ceil(log2(abs(exp(2:end) - exp(1:end-1)) + 1)));
subplot(2,1,2);
plot(fra(2:end) - fra(1:end-1));


figure(4)

differ = raw(2:end) - raw(1:end-1);
bits = (double(dec2bin(typecast(differ, "uint32"))) - 48);
exp = bin2dec(char(bits(:,2:9) + 48));
fra = bits(:,10:32) * 2 .^ (-1:-1:-23).';
gra = int32(bin2dec(char(bits(:,10:32)+48)));

subplot(3,1,1);
plot(differ);
subplot(3,1,2);
plot(exp);
subplot(3,1,3);
plot(gra);
%i = 0:0.01:1
%f = sin(2*pi*i);
%plot(f)

%gg(1) = raw(1);
%for i = 2:N-1
%	gg(i) = gg(i-1) + differ(i);	
%endfor

