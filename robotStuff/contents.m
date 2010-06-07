%C:\jim\ResearchProjects\field_design\mfiles as of 2/7/2003 at 16:11:50
%addGoodTrialColumn2targ.m   % add a good trial column to the targ_p?.txd                            
%allSubjEnsemb.m   CI=0;                                                                        
%ANALYSIS.M   % batch file to Analyze data                                                            
%analysis_fromr2d2.m   % batch file to Analyze data                                                         
%BASELINE.M   function baseList=baseline(Dirs,trialsStruct,trialData)             
%CCanalInterp.m   % analyze the fit of the copycat approach to Sys ID                                 
%ccEval4.m   % Evaluate a single copycat basis force field model                                   
%ccFit8.m   % Fit a model of dynamics & control of reaching given a set of CCB fcns.                      
%ccFit9.m   % Fit a model of dynamics & control of reaching given a set of CCB fcns.                                  
%CCobjective.m   % USES NLIN LEAST SQUARES, SO THE OUTPUT IS A VECTOR OF ERRORS                                                 
%compileParams.m   % compile a list of stuff in a big table from paramter files.                         
%CONTROL2.M   % feedback CONTROLLER for a 2 joint arm model:                                  
%copyFigures.m   function copyFigures(prefix,subjNums)                                   
%doEnsembles.m   % Analyze data: ensemble average plots                                                               
%doEnsembles2.m   % Analyze data: ensemble average plots                                                           
%doSim.m   % "Copycat" sys-ID on virtual subject to design a field that causes desired traj  
%do_IFD_ensemb.m   % produce new ensembles plots for subjects                                                    
%ensembleFigureSmall.m   % make an ensemble figure                                                       
%ensembleTrials.m   % load, average adn save an ensemble of robot trials                                 
%ensembleTrials2.m   % load, average adn save an ensemble of robot trials                                   
%ensembleTrials3.m   % load, average adn save an ensemble of robot trials                                                     
%fastLearnCurves.m   % test & compare Figural error, velocity inner product, and                               
%FIELD4.M   % torque calculations based on kinematics -- special field                      
%fieldDesign.m   % design a training field via copycat Sys ID and regional control bases (RCB)       
%field_plot.m   % plot a quiver/vector field plot of the force field                    
%findMonthsPost.m   % read paramters.txt and find months post stroke                           
%forward_kinematics.m   % forcefield calculations based on kinematics                            
%forward_kinematics2.m   % forcefield calculations based on kinematics                                    
%getIdealTrajectory.m   % Setup DESIRED TRAJECTORY based on data loaded from file.                                        
%getTrajectory.m   % Setup DESIRED TRAJECTORY based on data loaded from file.                        
%get_desired_trajcectory.m   % create robot control babis from data using copycat, & save.                         
%get_trajectory.m   % Setup DESIRED TRAJECTORY based on data loaded from file.                        
%groupAnalysis.m   % analyze data: overall group results                                                                                                           
%inverse_dynamics2.m   % Inverse dynamic analysis on chain-o-segments w/known kinetics @ endpoint.            
%inverse_kinematics.m   % Inverse kinematics of two-joint planar arm. (such as the human arm)            
%inverse_kinematics2.m   % determine angles & derivatives endpt positions and their derivatives                                                                                                                                                                                                                                                                 
%inverse_kinematics3.m   % Inverse kinematics of two-joint planar arm. (such as the human arm)            
%JACOBIAN.M   % JACOBIAN.M  [jac] = jacobian(phi,L)                                                    
%kinetic_energy.m   % kinetic energy based on kinematics for planar link-segment chain.               
%learnCurves.m   % analyze data: learning curves                                                               
%loadRobotData.m   % Load data in robot coordinates and convert to subject coords.                                 
%makeTargetList.m   % make trajectories for the robot                                                                          
%makeTargetList4.m   % make trajectories for the robot                                                             
%makeTrialsStruct.m                                                                                         
%make_non_bel_shaped_traj.m   % Patton                                                                    
%multiGroupPlot.m                                                                       
%OptCC.m   %Set up all necessary variables and call the optimization routine.                                                                     
%optoBatch.m   % Nonlinear optimization fits of single copycat (multiple analyses)                      
%passive_torques.m   % calculate the passive impedance torques at the 2 joints                            
%performMeas.m   % analyze data: performance measures and plot individual traject                                  
%performMeas2.m   % analyze data: performance measures and plot individual traject                             
%PLANT.M   % Plant function for the following model is simulated dynamically                    
%plotFieldInfluence.m   %__ plot circle of influnece of the rcb __                              
%plotIFDForces.m   % plots the forces in iterative field design                                         
%plot_trials3.m   % plots the trials for this experiment.                                                
%plot_trials4.m   % plots the trials for this experiment.                                                
%post_anim.m   % animate the results simulated dynamically                               
%post_plot.m   % Plots results of simulation                                             
%PRE_PLOT.M   % Sets and starts Plots for simulation                                       
%probeTrialsStruct2.m   % search for the important trials for each phase of a target list (manipulandum)        
%rcEval3.m   % Evaluate a robot control basis model                                            
%rcFit8.m   % convert a fit of a copycat (cc) model to a robot control (rc) model                         
%ROT2D.M   % counterclockwise rotation of an object (vector or matrix)       
%rrEval.m   % Evaluate a robot control basis model                                            
%saveRCB.m                                                                                         
%setupCopycat3.m   % Sets up parameters for the copycat basis functions for 2-joint link & controller:                  
%setupRCB.m   % Sets up robot radial control bases (RCB):                                     
%SET_ANIM.M   % setup to animate the results simulated dynamically                                  
%set_params.m   % Sets up parameters for the simulation of a 2-joint link:                          
%shape_field.m   % shape a radial function to make desired after-effects                                 
%SIM_ANIM.M   % animate the results simulated dynamically                                            
%startAndLength.m   % find the starting frame based on velocity threshold; adjust length if v is too short 
%STATS.M   % analyze data, subject's stat results & plot                                                   
%stopDetection.m   % send halt signal if slow & within target                 
%testAccel.m   function testAccel()                                                                
%testErrorMeasures.m   % test & compare Figural error, velocity inner product, and                 
%wingDots.m   % analyze data: learning curves in the wing-Dots format sorted by movement direction     
