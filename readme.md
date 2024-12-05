Brief documentation:
--------------------

This code reproduces the computational modeling results of Beerendonk, Mejias et al., A disinhibitory circuit mechanism explains a general principle of peak performance during mid-level arousal, *PNAS* 2024.

All code, unless specified otherwise, developed by Jorge Mejias. 

The code is for personal use only, and it is aimed at providing help in reproducing the results of Beerendonk, Mejias et al. 2024. If something in it is unclear, please go to the original publication and supplementary material, or contact the author at j.f.mejias@uva.nl. 

Any questions may be sent to Jorge Mejias: j.f.mejias@uva.nl.


Usage Instructions:
-------------------

To generate the panels of the computational model (Figure 3 in the paper), simply initialize Matlab and run the corresponding code. For example, running `fig3CD.m` will produce panels C and D of Figure 3. Other pieces of code (such as `bringparam.m`, `parameters.m`, or `trial.m`) are used to run the core simulations.

It should be possible to replicate all panels in a moderately powerful laptop, although some results (especially panels E and F) might require a bit of computer time (for my particular case, a few hours). If you are using a slower computer, feel free to reduce the number of trials (`Ntrials` in the code) to produce approximate results faster.