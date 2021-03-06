% this incorporates the rc coefficients into B & consolidates 4 linear components of B

i=0; j=0; saving_matrix=[];                 % init
for i=1:length(RCB)
  saving_vector=[i                      ... % set up for file strorage
       RCB(i).rc*RCB(i).B(1:4)          ... 
       RCB(i).K(1:4)                    ...
      -RCB(i).C(1)-Xshoulder2motor      ...
      -RCB(i).C(2)+Yshoulder2motor];       
  saving_matrix=[saving_matrix;
                 saving_vector];
end
saving_matrix(21,:)=[21 zeros(1,10)];

headr=str2mat(                          ...
 'Condensed robot control bases (RCB)', ...
 ['rendered ' whenis(clock)],           ...
 ['Directory: ' cd] ,                   ...
 'NOTE: in robot coordinates!',' ',     ...
 '___ BEGIN DATA: ___',                 ...
 [      'number' setstr(9)              ...
        'B11' setstr(9)                 ...
        'B21' setstr(9)                 ...
        'B12' setstr(9)                 ...
        'B22' setstr(9)                 ...
        'K11' setstr(9)                 ...
        'K21' setstr(9)                 ...
        'K12' setstr(9)                 ...
        'K22' setstr(9)                 ...
        'C1' setstr(9)                  ...
        'C2' setstr(9)                  ...
 ]    );

mat2txt('RCB.txd',headr,saving_matrix);