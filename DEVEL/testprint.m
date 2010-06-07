plot([1 5 6 9 2 2], [3 4 8 2 9 4],'o')

current_directory= cd;

fname=input('enter file name:  ','s');
pname=input('enter pathname:   ','s');

cmd=['fname = ' setstr(39) pname '/' fname setstr(39)]
eval(cmd)

cmd=['print -depsc2 ' fname ]
eval(cmd)

