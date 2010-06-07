 if plotman,                                         % if view of person selected
    ellipse(-shoulderWidth/2,0,shoulderWidth/2,   ... % body/trunk
      shoulderWidth/6,0,20,[.8 .8 .9]);               %   
    ellipse(-shoulderWidth/2,0,shoulderWidth/8,   ... % head
      shoulderWidth/6,0,20,'k');                      %
    plot(-shoulderWidth/2,shoulderWidth/6,'^');       % nose
    plot(0,0,'o');                                    % shoulder joint
    plot(sum(L)*cos(60/180*pi:.1:120/180*pi),     ... % plot workspace
      sum(L)*sin(60/180*pi:.1:120/180*pi),'g');       % ...
    if C==1,                                          % if first window
      text(0,0,'  estimated shoulder positon',    ... %
        'fontsize',fsz)                               %
      text(0,sum(L)+.01,                          ... %
        '   estimated workspace boundary',        ... %
        'fontsize',fsz)                               %
    end                                               % END if C==1
  end                                                 % END if plotman
  