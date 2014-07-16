/****************************************************************/
/*       PIKA - Phase field snow micro-structure model          */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#!/usr/bin/python
'''
***************************************
* Calculator for Phase Field Modeling *
* of Dry Snow Metamorphosis           *
* (Kaempfer 2009)                     *
*                                     *
* Execute:                            *
* ./KaempferPlapp2009.py              *
*                                     *
***************************************

NOMENCLATURE:

R_da = gas constant for dry air [J/(kg K)]
R_v = gas constant for water vapor [J/(kg K)]

P_a = atmospheric pressure [Pa]
P_vs = saturated vapor pressure over ice [Pa]

K_fit = fitting coefficients
T = Temperature [K]
X_s = humidity ratio [kg/kg]

'''

# Load SymPy and enable latex printing
from sympy import *
init_printing()

# Define symbolic variables
T = symbols('T')

# Define constants
R_da = 286.9
R_v = 461.5
P_a = 1.01325e5
rho_a = 1.341
rho_i = 918.9
K_fit = [-0.58653696e4, 0.2224103300e2, 0.13749042e-1, -0.34031775e-4, 0.26967687e-7, 0.6918651]

# Eq. (2)
P_vs = exp(K_fit[0]*T**(-1) + K_fit[1]*T**0 + K_fit[2]*T**1 + K_fit[3]*T**2 + K_fit[4]*T**3 + K_fit[5]*log(T))

# Eq. (1)
x_s = (R_da / R_v) * P_vs / (P_a - P_vs)

# Eq. (3)
rho_vs = rho_a * x_s

# Concentration equilibrium
u_eq = (rho_vs - rho_vs.subs(T, 263.15)) / rho_i


print "T = 263.15"
print "P_vs = ", P_vs.evalf(subs={T: 263.15})
print "x_s = ", x_s.evalf(subs={T: 263.15})
print "rho_vs(263.15) = ", rho_vs.evalf(subs={T: 263.15})
print "rho_vs(268.15) = ", rho_vs.evalf(subs={T: 263.15})

print ""
print "u_eq(263.15) = ", u_eq.evalf(subs={T: 264.8})
print "u_eq(268.15) = ", u_eq.evalf(subs={T: 267.515})
