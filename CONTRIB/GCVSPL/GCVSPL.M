%
%
% gcvspl.mexsg
%
% Woltring's B-spline Algorithm in MATLAB
% =======================================
%
%Purpose:
%*******
%
%      Natural B-spline data smoothing subroutine, using the Generali-
%      zed Cross-Validation and Mean-Squared Prediction Error Criteria
%      of Craven & Wahba (1979). Alternatively, the amount of smoothing
%      can be given explicitly, or it can be based on the effective
%      number of degrees of freedom in the smoothing process as defined
%      by Wahba (1980). The model assumes uncorrelated, additive noise
%      and essentially smooth, underlying functions. The noise may be
%      non-stationary, and the independent co-ordinates may be spaced
%      non-equidistantly. Multiple datasets, with common independent
%      variables and weight factors are accomodated.
%
%
%MATLAB Calling convention:
%**************************
%
%     [C, W, IER] = gcvspl( X, Y, NY, WX, WY, M, N, K, MD, VAL, NC);
%
%Meaning of parameters: 
%*********************
%                                                                               Type
%                                                                               ----
%      X(N)    ( I )   Independent variables: strictly increasing knot          1-D array of double
%                      sequence, with X(I-1).lt.X(I), I=2,...,N.
%      Y(NY,K) ( I )   Input data to be smoothed (or interpolated).             2-D array of double
%      NY      ( I )   First dimension of array Y(NY,K), with NY.ge.N.          Integer
%      WX(N)   ( I )   Weight factor array; WX(I) corresponds with              1-D array of double
%                      the relative inverse variance of point Y(I,*).           
%                      If no relative weighting information is
%                      available, the WX(I) should be set to ONE.
%                      All WX(I).gt.ZERO, I=1,...,N.
%      WY(K)   ( I )   Weight factor array; WY(J) corresponds with              1-D array of double
%                      the relative inverse variance of point Y(*,J).
%                      If no relative weighting information is
%                      available, the WY(J) should be set to ONE.
%                      All WY(J).gt.ZERO, J=1,...,K.
%                      NB: The effective weight for point Y(I,J) is
%                      equal to WX(I)*WY(J).
%      M       ( I )   Half order of the required B-splines (spline             Integer
%                      degree 2*M-1), with M.gt.0. The values M =
%                      1,2,3,4 correspond to linear, cubic, quintic,
%                      and heptic splines, respectively.
%      N       ( I )   Number of observations per dataset, with N.ge.2*M.       Integer
%      K       ( I )   Number of datasets, with K.ge.1.
%      MD      ( I )   Optimization mode switch:                                Integer
%                      |MD| = 1: Prior given value for p in VAL
%                                (VAL.ge.ZERO). This is the fastest
%                                use of GCVSPL, since no iteration
%                                is performed in p.
%                      |MD| = 2: Generalized cross validation.
%                      |MD| = 3: True predicted mean-squared error,
%                                with prior given variance in VAL.
%                      |MD| = 4: Prior given number of degrees of
%                                freedom in VAL (ZERO.le.VAL.le.N-M).
%                       MD  < 0: It is assumed that the contents of
%                                X, W, M, N, and WK have not been
%                                modified since the previous invoca-
%                                tion of GCVSPL. If MD < -1, WK(4)
%                                is used as an initial estimate for
%                                the smoothing parameter p.  At the
%                                first call to GCVSPL, MD must be > 0.
%                      Other values for |MD|, and inappropriate values
%                      for VAL will result in an error condition, or
%                      cause a default value for VAL to be selected.
%                      After return from MD.ne.1, the same number of
%                      degrees of freedom can be obtained, for identical
%                      weight factors and knot positions, by selecting
%                      |MD|=1, and by copying the value of p from WK(4)
%                      into VAL. In this way, no iterative optimization
%                      is required when processing other data in Y.
%      VAL     ( I )   Mode value, as described above under MD.                 Double
%      C(NC,K) ( O )   Spline coefficients, to be used in conjunction           2-D array of double
%                      with function SPLDER. NB: the dimensions of C
%                      in GCVSPL and in SPLDER are different! In SPLDER,
%                      only a single column of C(N,K) is needed, and the
%                      proper column C(1,J), with J=1...K should be used
%                      when calling SPLDER.
%      NC      ( I )  First dimension of array C(NC,K), NC.ge.N.                Integer         
%      WK(IWK) (I/W/O) Work vector, with length IWK.ge.6*(N*M+1)+N.             1-D array of double
%                      On normal exit, the first 6 values of WK are
%                      assigned as follows:
%
%                      WK(1) = Generalized Cross Validation value
%                      WK(2) = Mean Squared Residual.
%                      WK(3) = Estimate of the number of degrees of
%                              freedom of the residual sum of squares
%                              per dataset, with 0.lt.WK(3).lt.N-M.
%                      WK(4) = Smoothing parameter p, multiplicative
%                              with the splines' derivative constraint.
%                      WK(5) = Estimate of the true mean squared error
%                              (different formula for |MD| = 3).
%                      WK(6) = Gauss-Markov error variance.
%
%                      If WK(4) -->  0 , WK(3) -->  0 , and an inter-
%                      polating spline is fitted to the data (p --> 0).
%                      A very small value > 0 is used for p, in order
%                      to avoid division by zero in the GCV function.
%
%                      If WK(4) --> inf, WK(3) --> N-M, and a least-
%                      squares polynomial of order M (degree M-1) is
%                      fitted to the data (p --> inf). For numerical
%                      reasons, a very high value is used for p.
%
%                      Upon return, the contents of WK can be used for
%                      covariance propagation in terms of the matrices
%                      B and WE: see the source listings. The variance
%                      estimate for dataset J follows as WK(6)/WY(J).
%
%      IER     ( O )   Error parameter:                                         Integer
%
%                      IER = 0:        Normal exit
%                      IER = 1:        M.le.0 .or. N.lt.2*M
%                      IER = 2:        Knot sequence is not strictly
%                                      increasing, or some weight
%                                      factor is not positive.
%                      IER = 3:        Wrong mode  parameter or value.
%
%Remarks:
%*******
%
%      (1) GCVSPL calculates a natural spline of order 2*M (degree
%      2*M-1) which smoothes or interpolates a given set of data
%      points, using statistical considerations to determine the
%      amount of smoothing required (Craven & Wahba, 1979). If the
%      error variance is a priori known, it should be supplied to
%      the routine in VAL, for |MD|=3. The degree of smoothing is
%      then determined to minimize an unbiased estimate of the true
%      mean squared error. On the other hand, if the error variance
%      is not known, one may select |MD|=2. The routine then deter-
%      mines the degree of smoothing to minimize the generalized
%      cross validation function. This is asymptotically the same
%      as minimizing the true predicted mean squared error (Craven &
%      Wahba, 1979). If the estimates from |MD|=2 or 3 do not appear
%      suitable to the user (as apparent from the smoothness of the
%      M-th derivative or from the effective number of degrees of
%      freedom returned in WK(3) ), the user may select an other
%      value for the noise variance if |MD|=3, or a reasonably large
%      number of degrees of freedom if |MD|=4. If |MD|=1, the proce-
%      dure is non-iterative, and returns a spline for the given
%      value of the smoothing parameter p as entered in VAL.
%
%      (2) The number of arithmetic operations and the amount of
%      storage required are both proportional to N, so very large
%      datasets may be accomodated. The data points do not have
%      to be equidistant in the independant variable X or uniformly
%      weighted in the dependant variable Y. However, the data
%      points in X must be strictly increasing. Multiple dataset
%      processing (K.gt.1) is numerically more efficient dan
%      separate processing of the individual datasets (K.eq.1).
%
%      (3) If |MD|=3 (a priori known noise variance), any value of
%      N.ge.2*M is acceptable. However, it is advisable for N-2*M
%      be rather large (at least 20) if |MD|=2 (GCV).
%
%      (4) For |MD| > 1, GCVSPL tries to iteratively minimize the
%      selected criterion function. This minimum is unique for |MD|
%      = 4, but not necessarily for |MD| = 2 or 3. Consequently,
%      local optima rather that the global optimum might be found,
%      and some actual findings suggest that local optima might
%      yield more meaningful results than the global optimum if N
%      is small. Therefore, the user has some control over the
%      search procedure. If MD > 1, the iterative search starts
%      from a value which yields a number of degrees of freedom
%      which is approximately equal to N/2, until the first (local)
%      minimum is found via a golden section search procedure
%      (Utreras, 1980). If MD < -1, the value for p contained in
%      WK(4) is used instead. Thus, if MD = 2 or 3 yield too noisy
%      an estimate, the user might try |MD| = 1 or 4, for suitably
%      selected values for p or for the number of degrees of
%      freedom, and then run GCVSPL with MD = -2 or -3. The con-
%      tents of N, M, K, X, WX, WY, and WK are assumed unchanged
%      since the last call to GCVSPL if MD < 0.
%
%      (5) GCVSPL calculates the spline coefficient array C(N,K);
%      this array can be used to calculate the spline function
%      value and any of its derivatives up to the degree 2*M-1
%      at any argument T within the knot range, using subrou-
%      tines SPLDER and SEARCH, and the knot array X(N). Since
%      the splines are constrained at their Mth derivative, only
%      the lower spline derivatives will tend to be reliable
%      estimates of the underlying, true signal derivatives.
%
%      (6) GCVSPL combines elements of subroutine CRVO5 by Utre-
%      ras (1980), subroutine SMOOTH by Lyche et al. (1983), and
%      subroutine CUBGCV by Hutchinson (1985). The trace of the
%      influence matrix is assessed in a similar way as described
%      by Hutchinson & de Hoog (1985). The major difference is
%      that the present approach utilizes non-symmetrical B-spline
%      design matrices as described by Lyche et al. (1983); there-
%      fore, the original algorithm by Erisman & Tinney (1975) has
%      been used, rather than the symmetrical version adopted by
%      Hutchinson & de Hoog.
%
%       (7) Our lab uses the following equation to calculate VAL:
%               VAL = (EMG_sampling_frequency/1000.0) / pow(2*PI*EMG_CUTOFF_FREQUENCY/1000.0/
%                       pow( (sqrt(2.0) - 1), 0.5/M ), 2.0*M )
%               where PI is 3.1415... and the EMG_CUTOFF_FREQUENCY is generally 10 Hz for the
%               arm data that we use (probably 5-6 Hz for normal gait).
%               (equation courtesy of Dan Moran)
%
%References:
%****************************************************************************
%
%      P. Craven & G. Wahba (1979), Smoothing noisy data with
%      spline functions. Numerische Mathematik 31, 377-403.
%
%      A.M. Erisman & W.F. Tinney (1975), On computing certain
%      elements of the inverse of a sparse matrix. Communications
%      of the ACM 18(3), 177-179.
%
%      M.F. Hutchinson & F.R. de Hoog (1985), Smoothing noisy data
%      with spline functions. Numerische Mathematik 47(1), 99-106.
%
%      M.F. Hutchinson (1985), Subroutine CUBGCV. CSIRO Division of
%      Mathematics and Statistics, P.O. Box 1965, Canberra, ACT 2601,
%      Australia.
%
%      T. Lyche, L.L. Schumaker, & K. Sepehrnoori (1983), Fortran
%      subroutines for computing smoothing and interpolating natural
%      splines. Advances in Engineering Software 5(1), 2-5.
%
%      F. Utreras (1980), Un paquete de programas para ajustar curvas
%      mediante funciones spline. Informe Tecnico MA-80-B-209, Depar-
%      tamento de Matematicas, Faculdad de Ciencias Fisicas y Matema-
%      ticas, Universidad de Chile, Santiago.
%
%      Wahba, G. (1980). Numerical and statistical methods for mildly,
%      moderately and severely ill-posed problems with noisy data.
%      Technical report nr. 595 (February 1980). Department of Statis-
%      tics, University of Madison (WI), U.S.A.
%
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% FORTRAN program converted to C by Dwight Meglan using f2c converter.
% MATLAB 4.x mex file conversion by ChunXiang Tian (7/4/96 - was he really working on July 4?)
% MATLAB 4.x mex update by David Carta (3/7/97)
% MATLAB 5.1 mex file conversion by Tony Reina 
%
% Tony Reina                            Created: 4/2/1998
% The Neurosciences Institute, San Diego, CA
% Motor Systems Research Lab
