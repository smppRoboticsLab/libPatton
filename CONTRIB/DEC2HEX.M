function h = dec2hex(d)
%DEC2HEX DEC2HEX(d) returns the hex number corresponding to the decimal
%        number d.  For example, DEC2HEX(2748) returns 'ABC'.
%        See also HEX2DEC.
%
%       Author: L. Shure

if d==0
   h = setstr('0'); return
end
n = 1 + fix(log(d)/log(16));
s = cumprod([1 16*ones(1,n-1)]);
g = s;
for i=1:n
        g(i) = fix(d/s(n-i+1));
        d = rem(d, s(n-i+1));
        if g(i) > 9
           h(i) = setstr(g(i) + 'A' - 10);
        else
           h(i) = setstr(g(i) + '0');
        end
end
