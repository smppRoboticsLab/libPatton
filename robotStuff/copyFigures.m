
function copyFigures(prefix,subjNums)

prefix

for i=subjNums, 
  dir=[prefix num2str(i)];  cd(dir); cd
  %pause(1.5); 
  if exist('results.pdf'),
    cmd=['!copy results.pdf ..\results\' prefix num2str(i) '_r.pdf'];
  elseif exist('ensembles.pdf'),
    cmd=['!copy ensembles.pdf ..\results\' prefix  num2str(i) '_e.pdf'];
  elseif exist('ensembles.ps'),
    cmd=(['!copy ensembles.ps ..\results\' prefix  num2str(i) '_e.ps']);
  end
  disp(cmd); 
  eval(cmd)
  cd ..
end


cd results

cmd=['!pkzip results.zip ' prefix '*.*']; 
disp(cmd); 
eval(cmd)

cd ..
cd 

playwav('done.wav')
