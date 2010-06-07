% ***** MATLAB SCD2HCD.M function ******
% batch the processing of a trial (head angle/torque phase)
%
% SYNTAX:	status=scd2hcd(fileroots,delete_or_not,plot_or_not)
% INPUTS		fileroots =	filename root string list (extensions removed)
%					Each line is a file (block) root.
%				trialsperblock = number of trials per block.  default is 10
%				delete_or_not = delete or save intermediate files.  1=delete 0=save
%					default is NOT to save!!!!!!!!!!!!
%				plot_or_not 	='y' of you want to see a plot of the synch
% OUTPUTS 	status		=zero if all went well
%  			& FILES
% EXAMPLE:	scd2hcd(['XXX1';'XXX2';'XXX3';'XXX4';'XXX5';'XXX6']) 
%				will run the steps below on blocks 1-6 with 9 trials per block of subject XXX 
% CALLS:		scd2gha
%				scd2htnet.m
%				scd2htmus.m
%				scd2htgi.m
%				scd2htg.m
% 				scd2htin.m
%				scd2hcom.m
%				scd2hcor.m
%				dif_dio.m
% CALLED BY:	
% REVISIONS: 	8/10/98 initiated by Markworth from scd2hcd1.m
% NOTE:		Code is best viewed in MATLAB EDITOR/DEBUGGER
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function status=scd2hcd(fileroots,delete_or_not,plot_or_not);

%_____ SETUP VARS _____
global DEBUGIT																% NONZERO FOR VERBOSE
prog_name='SCD2HCD.M';
if DEBUGIT, fprintf('\nVerbose'); end; %if						% MESSAGE
fprintf('\n ~ %s ~ \n SCD2HCD.M PROCESSING:',prog_name);    % orient user
fileroots																	% list filerootnames
if ~exist('delete_or_not'), delete_or_not=1; end				% MAKE VAR IF NOT THERE 
if ~exist('plot_or_not'), plot_or_not='n'; end					% MAKE VAR IF NOT THERE 
status=0;																	% START WITH OK STATUS
[r,c]=size(fileroots);													% NUMBER OF FILES IN LIST
numblocks=r
sep='\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n';						% separator string
noverbose=1;

%_____ BEGIN LOOP FOR EACH FILE IN fileroots _____ 
for block=1:numblocks 

	status=scd2hcom(fileroots(block,:));                	   % grav head ang calculation
	status=scd2hcor(fileroots(block,:));                	   % grav head ang calculation
	status=scd2gha(fileroots(block,:));                	   % grav head ang calculation
	status=scd2htnet(fileroots(block,:));							% net head torque calc
	status=scd2htmus(fileroots(block,:));							% muscle head torque calc																		
   status=scd2htgi(fileroots(block,:));                	   % grav/interactive torque calc
   status=scd2htg(fileroots(block,:));								% grav torque calc
	status=scd2htin(fileroots(block,:));							% interactive torque calc	

	scd=[fileroots(block,:),'.scd'];
	
	gha=[fileroots(block,:),'.gha'];		
	hcom=[fileroots(block,:),'.hcom'];							
   hcor=[fileroots(block,:),'.hcor'];								
	htnet=[fileroots(block,:),'.htnet'];							
	htgi=[fileroots(block,:),'.htgi'];							
   htmus=[fileroots(block,:),'.htmus'];							
   htin=[fileroots(block,:),'.htin'];				
   htg=[fileroots(block,:),'.htg'];
     	
   dif_dio(gha,[fileroots(block,:),'.gha_dot'],5010,5011);
   dif_dio(hcom,[fileroots(block,:),'.hcom_dot'],5021,5121);
   
   gha_dot=[fileroots(block,:),'.gha_dot'];
   hcom_dot=[fileroots(block,:),'.hcom_dot'];
   
   filenames=str2mat(gha,gha_dot,hcom,hcom_dot,hcor,htnet,htgi,htmus,htin,htg,scd)   
   
   diomesh(filenames,{[5010],[5011],[5021 5022],[5121],[5031 5032],	...	% gha, hcom x & y, hcor x & y
   					[5040],[5050],[5060],[5070],			...						% htnet, htgi, htmus, htin
                  [5080],[201 1031 1032]},            ...                  % htg, fp, neck x, neck y
               	[fileroots(block,:),'.hcd']);	       	         
                                                                           
end  																								% END for block
                                                                        
%_____ PRINT HCD FILES _____ 
fprintf('\n PLOTTING...');  % MESSAGE
      
RECS={[5010 5011],					'gha, gha dot';      							% cell array of datacodes,
     [1031 1032],						'neck marker x & y'; 							% each cell represents a 
     [201],								'pulling force';     							% plot window, & is a vector
     [5121],							'hcom dot';											% of which datacodes to put on the figure.
     [5040 5050 5060],				'tnet, tgi, tmus'};         

for block=1:numblocks 
   fileroot=deblank(fileroots(block,:));              						% rootname of block
   fprintf(sep);                                      						% display separator string 
   plot_DIO([fileroot '.hcd'],RECS,'y','n');      								% do it
end                                                   						% end print loop

                                                                           
%_____ DELETE INTERMEDIATE FILES _____ 
if delete_or_not == 1
   !del *.gha
   !del *.hcom
   !del *.hcor
   !del *.htnet						
	!del *.htgi						
   !del *.htmus						
   !del *.htin		
   !del *.htg
   !del *.gha_dot
   !del *.hcom_dot
   else
   end      
                                                                           
fprintf('\n ~ END %s @%s ~ \n\n',prog_name,whenis(clock)); 

diary off; 																	% turn off logfile

