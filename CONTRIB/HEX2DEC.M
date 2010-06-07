function d = hex2dec(h)
%HEX2DEC  HEX2DEC('X') returns the decimal number corresponding to the
%        hex number in quotes.  For example, HEX2DEC('12B') and
%        HEX2DEC('12b') both return 299.

%      Author: J.N. Little

[m,n]=size(h);
p = cumprod([1 16*ones(1,n-1)]);
for i=1:n
       if (h(i) > 96)
            h(i) = h(i) - 87;
       elseif (h(i) > 64)
            h(i) = h(i) - 55;
       else
            h(i) = h(i) - 48;
       end
end
d = h*p(n:-1:1)';

