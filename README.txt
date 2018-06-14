Matlab code is modified from:

Noronha, A.L., K.R. Johnson, J.R. Southon, C. Hu, J. Ruan, and S. McCabe-Glynn (2015), Radiocarbon Evidence for Decomposition of Aged Organic Matter in the Vadose Zone as the Main Source of Speleothem Carbon, Quaternary Science Reviews. (http://www.sciencedirect.com/science/article/pii/S0277379115002267)


Primary updates include:
--Does not require pre-1955 a14C measurements
--Calculates DCP using the entire record, including post-1955 measurements
--Arbitrary number of carbon pools (User-defined)
--Turnover age of carbon pools is fixed (User-defined)
--Includes forward modeling code as well as inverse modeling
--Calculates MRCA, RMSE for all successful models and for best-fit model.
--Can model multiple speleothems in series





Main files are Bomber.m, BombHandler.m, or BombGenerator.m
--All other functions are called by these three files.

Use Bomber.m to run a fast, single inverse model of a speleothem.
--The default speleothem is WC-3 (See RECORDREFS.txt for a list of references for the stalagmite records included.)

Use BombHandler.m to run Bomber.m multiple times.
--This allows you to:
----Model multiple speleothems in series
----Model the same speleothem from different intial conditions to get a range of possible answers

Use BombGenerator to create a forward model of a synthetic speleothem.
--You can then test the performance of Bomber.m and BombHandler.m by attempting to reconstruct the known input to BombGenerator.m


When generating a new stalagmite file, use the following format:
3 columns, tab-delimited:
Age(Years BP; youngest to oldest)	a14C(FMC)	a14Cerror(1sigma)



The code currently does not take a14Cerror into account.	



Post-bomb a14C regional atmospheric records retrieved from:
 [CALIBomb](http://calib.qub.ac.uk/CALIBomb/)


and described in detail in:


Hua, Q., M. Barbetti, and A. Rakowski (2013), [Atmospheric Radiocarbon for the Period 1950–2010], Radiocarbon, 55(4), 2059–2072. https://journals.uair.arizona.edu/index.php/radiocarbon/article/view/16177)




Pre-bomb atmospheric a14C records separated into a Nothern Hemisphere and a Southern Hemisphere record based on [IntCal13](http://www.radiocarbon.org/IntCal13.htm):



Reimer, P.J., E. Bard, A. Bayliss, J.W. Beck, P. G. Blackwell, C. B. Ramsey, C. E. Buck, H. Cheng, R. L. Edwards, M. Friedrich, P. M. Grootes, T.P. Guilderson, H. Haflidason, I. Hajdas, C. Hatte, T.J. Heaton, D.L. Hoffmann, A.G. Hogg, K.A. Hughen, K.F. Kaiser, B. Kromer, S.W. Manning, M. Niu, R. W. Reimer, D.A. Richards, E.M. Scott, J. R. Southon, R. Staff, C.S.M. Turney, and J. van der Plicht (2013), [IntCal13 and Marine13 Radiocarbon Age Calibration Curves 0-50,000 Years Cal BP], Radiocarbon, 55(4), 1869–1887. (https://journals.uair.arizona.edu/index.php/radiocarbon/article/view/16947)



Hogg, A.G., Q. Hua, P.G. Blackwell, M. Niu, C.E. Buck, T.P. Guilderson, T.J. Heaton, J.G. Palmer, P.J. Reimer, R.W. Reimer, C.S. M. Turney, and S.R.H. Zimmerman (2013), [SHCal13 Southern Hemisphere Calibration, 0–50,000 Years Cal BP], Radiocarbon, 55(4), 1889–1903. (https://journals.uair.arizona.edu/index.php/radiocarbon/article/view/16783)