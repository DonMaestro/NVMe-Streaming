% spkg.m
%
% s - The size of the static difference.
%
% Written by: Vitalii Yurchenko
% Email: vitalik16200@gmail.com
% Created: October 2023
%

function [ sf, se ] = spkg(A, B)
	if (!isfloat(A))
		printf('error: this is not float\n');
	endif

	s = ones(size(A));

	Ab = (double(dec2bin(typecast(A, "uint32"),32)) - 48);
	Bb = (double(dec2bin(typecast(B, "uint32"),32)) - 48);

	sf = bin2dec(char(48 + bitxor(Ab(:,10:32), Bb(:,10:32))))
	se = bin2dec(char(48 + bitxor(Ab(:,1:9), Bb(:,1:9))));

	sf = ceil(log2(sf+1));
	se = ceil(log2(se+1));

%	exp = bin2dec(char(bits(:,2:9) + 48));
%	fra = bits(:,10:32) * 2 .^ (-1:-1:-23).';
%	gra = int32(bin2dec(char(bits(:,10:32)+48)));
endfunction

