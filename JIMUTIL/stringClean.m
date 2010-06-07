%%  function to clean strings out of unwanted characters
function s1=stringClean(s,char2clean)

i=0;
while i<length(s)
  i=i+1;
  if s(i)==char2clean,
    s(i)=[];
  end
end
s1=s;

return
