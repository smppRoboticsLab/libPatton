%
%
%       splder.mexsg
%
%       Herman Woltring's SPLDER subroutine in MATLAB
%
%
% Purpose:
% *******
%
%       To produce the value of the function (IDER.eq.0) or of the
%       IDERth derivative (IDER.gt.0) of a 2M-th order B-spline at
%       the point T. The spline is described in terms of the half
%       order M, the knot sequence X(N), N.ge.2*M, and the spline
%       coefficients C(N).
%
% Calling convention:
% ******************
%
%       [SVIDER] = SPLDER ( IDER, M, N, T, X, C, L, Q )
%
% Meaning of parameters:                                                Type    
% *********************                                                 ****    
%                                                                       
%       SVIDER  ( O )   Function or derivative value.                   Double
%       IDER    ( I )   Derivative order required, with 0.le.IDER       Int             
%                       and IDER.le.2*M. If IDER.eq.0, the function
%                       value is returned; otherwise, the IDER-th
%                       derivative of the spline is returned.
%       M       ( I )   Half order of the spline, with M.gt.0.          Int
%       N       ( I )   Number of knots and spline coefficients,        Int
%                       with N.ge.2*M.
%       T       ( I )   Argument at which the spline or its deri-       Double
%                       vative is to be evaluated, with X(1).le.T
%                       and T.le.X(N).
%       X(N)    ( I )   Strictly increasing knot sequence array,        Double[N]
%                       X(I-1).lt.X(I), I=2,...,N.
%       C(N)    ( I )   Spline coefficients, as evaluated by            Double[N]
%                       subroutine GVCSPL.
%       L       (I/O)   L contains an integer such that:                Double
%                       X(L).le.T and T.lt.X(L+1) if T is within
%                       the range X(1).le.T and T.lt.X(N). If
%                       T.lt.X(1), L is set to 0, and if T.ge.X(N),
%                       L is set to N. The search for L is facili-
%                       tated if L has approximately the right
%                       value on entry.
%       Q(2*M)  ( W )   Internal work array.                            Double[2*M]
%
% Remark:
% ******
%
%       This subroutine is an adaptation of subroutine SPLDER of
%       the paper by Lyche et al. (1983). No checking is performed
%       on the validity of the input parameters.----|
%                                                   \/
%       Update (4/7/98): Parameter T is now checked with the first and last values of
%       array X[N]. If T (the timepoint) is outside of the array of time values
%       an error message will result and the mex subroutine will return without
%       executing SPLDER.   -Tony Reina
%
% Reference:
% *********
%
%       T. Lyche, L.L. Schumaker, C. K. Sepehrnoori, Fortran subroutines
%       for computing smoothing and interpolating natural splines.
%       Advances in Engineering Software 5(1983)1, pp. 2-5.
%
% ***********************************************************************
% FORTRAN program converted to C by Dwight Meglan using f2c converter.
% MATLAB 4.x mex file conversion by ChunXiang Tian (7/4/96 - was he really working on July 4?)
% MATLAB 4.x mex update by David Carta (3/7/97)
% MATLAB 5.1 mex file conversion by Tony Reina 
% Update to error check the time value T,  4/7/98  by GAR
%
% Tony Reina                            Created: 4/7/1998
% The Neurosciences Institute, San Diego, CA
% Motor Systems Research Lab
