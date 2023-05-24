# Endfeet2023
**Simulation of potassium diffusion from neurons to capillaries through astrocyte endfeet clefts**

These MATLAB files accompany the manuscript "Analysis of potassium ion diffusion from neurons to capillaries: Effects of astrocyte endfeet geometry" by Sara Djurich and Timothy W. Secomb (under review)

1. The program createSTL.m generates a shape file file according to geometric parameters specified in the program. The resulting stl files may be large and take a while to generate. This program also generates small files endfeet1.m and endfeet2.m containing the geometric parameters.

2. The program Kdiffusion.m solves the time-dependent diffusion problem in the specified geometry, using the MATLAB routine solvepde. The program is run first with a few time points, to generate color contour plots, then again with small time steps to generate the variation of potassium concentration in the extravascular space.

3. For error reporting and suggestions please contact Dr. Timothy W. Secomb, email secomb@u.arizona.edu. We welcome your comments and suggestions.

4. This program is freely available for non-commercial use, provided appropriate acknowledgement is given. Commercial users please contact us before using this program. No assurance is given that it is free of errors and any use is at the user’s risk.
