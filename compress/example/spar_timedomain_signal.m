addpath('l1magic-1.11/l1magic/Optimization');
% Initialize constants and variables
rng(0);                 % set RNG seed
N = 256;                % length of signal
P = 5;                  % number of non-zero peaks
K = 64;                 % number of measurements to take (N < L)
x = zeros(N,1);         % original signal (P-sparse)

% Generate signal with P randomly spread values
peaks = randperm(N);
peaks = peaks(1:P);
x(peaks) = randn(1, P);
amp = 1.2*max(abs(x));
figure; subplot(3,1,1); plot(x); title('Original signal'); xlim([1 N]); ylim([-amp amp]);

% Obtain K measurements
A = randn(K, N);
y = A*x;
subplot(3,1,2); plot(y); title('K measured values'); xlim([1 K]);

% Perform Compressed Sensing recovery
x0 = A.'*y;
xp = l1eq_pd(x0, A, [], y);
subplot(3,1,3); plot(real(xp)); title('Recovered signal'); xlim([1 N]); ylim([-amp amp]);

