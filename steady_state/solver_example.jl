# Example for use of DifferentialEquations.jl
# CHEME5440/7770 - Spring 2021
# To install the package, use the following commands inside the Julia REPL:
using Pkg
Pkg.add("DifferentialEquations")
# For this example, you will also need Plots; To add:
Pkg.add("Plots")
# ------------------------------------------------------------ #
# Lorenz system example
# dX/dt = σ(Y-X)
# dY/dt = X(ρ - Z) - Y
# dZ/dt = XY - βZ
# Based on DifferentialEquations.jl tutorial
using DifferentialEquations     # Include DifferentialEquations.jl
using Plots                     # Include Plots.jl for plotting
gr(show = true)                 # Use the gr backend for plotting and show plots
# Model parameters
#σ = 5.5
#ρ = 22.0   #.0 indicates to the compiler that ρ is a floating-point number (i.e. not an integer)
#β = 7/3

l=1

kbp = 1.0
kb = 0.0
VRmax = 294.282
a1p = 1/(1+l)
a1m = l/(1+l)
abp = 0.1
dbp = 0.01
ab = 1.0
db = 1.0
B1 = (2.5*l)/(1+l)
k1pxA = 10.0
k1m = 1.0



# -------------------------- Lorenz Model -------------------------------------
# du: Diffrerential equations, [dX/dt, dY/dt, dZ/dt]
# u: Time-dependent variables, [X, Y, Z]; u[1] = xX; u[2] = Y; u[3] = Z
# p: Additional model parameters (none in this example)
# t: time 
# Note "!" point after function name is a Julia convention that indicates 
# that the function will modify values in one or more of the function arguments.  In this case,
# lorenz! will modify values in the input vector, du
#function lorenz!(du,u,p,t)
 du[1] = σ*(u[2]-u[1])                  #dX/dt = σ(Y-X)
 du[2] = u[1]*(ρ-u[3]) - u[2]           #dY/dt = X(ρ - Z) - Y
 du[3] = u[1]*u[2] - β*u[3]             #dZ/dt = XY - βZ


function adapt!(du,u,p,t)
 du[1] = (kbp*u[7])+(kb*u[6])-(VRmax)
 du[2] = (VRmax)+(a1p*u[3])-(a1m*u[2])-(abp*u[2]*u[5])+(dbp*u[7])-(ab*u[2]*u[4])+(db*u[6])
 du[3] = (a1m*u[2])-(a1p*u[3])+(B1*u[7])+(B1*u[6])
 du[4] = (kb*u[6])-(ab*u[2]*u[4])+(db*u[6])+(B1*u[6])-(k1pxA*u[4])+(k1m*u[5])
 du[5] = (kbp*u[7])-(abp*u[2]*u[5])+(dbp*u[7])+(B1*u[7])+(k1pxA*u[4])-(k1m*u[5])
 du[6] = (ab*u[2]*u[4])-(db*u[6])-(kb*u[6])-(B1*u[6])
 du[7] = (abp*u[7])-(dbp*u[7])-(kbp*u[7])-(B1*u[7])
end
# ------------- SOLVE THE MODEL WITH DIFFERENTIALEQUATIONS.jl -------------------
E0_ss = 1709.65                       # initial(ss) value of E0
E1s_ss = 11.3987                      # initial(ss) value of E1s
E1_ss = 6440.81                       # initial(ss) value of E1
B_ss = 181.818                        # initial(ss) value of B
Bp_ss = 1818.18                       # initial(ss) value of Bp
E1sB_ss = 921.107                     # initial(ss) value of E1sB
E1sBp_ss = 917.032                    # initial(ss) value of E1sBp

u0 = [E0_ss; E1s_ss; E1_ss; B_ss; Bp_ss; E1sB_ss; E1sBp_ss]       # initial(ss) state vector
tspan = (0.0,100.0)                     #time interval (start time, end time)
prob = ODEProblem(adapt!,u0,tspan)      #Create an ODE problem for the Lorenz fxn
sol = solve(prob)                       #Solve the system
# ------------- MAKE SOME PLOTS OF THE RESULTS WITH PLOTS.jl ---------------------
#Plot the results; X, Y, and Z vs time
#plt1 = plot(sol, xaxis="time", yaxis = "X, Y, or Z", label=["X" "Y" "Z"])
#display(plt1)
#Plot the results; the vars=(0,3) argument specifies to plot Z (column 3 of sol)
#vs t
#plt2 = plot(sol,vars=(0,3), xaxis="time", yaxis = "Z", legend = false)
#display(plt2)
#Plot the results; the vars=(1,2,3) argument specifies to plot X vs Y vs Z
#plt3 = plot(sol,vars=(1,2,3), xaxis="X", yaxis="Y", zaxis="Z", legend = false)
#display(plt3)
#Save the three plots as PNG files
#savefig(plt1, "./plot1.png")    
#savefig(plt2, "./plot2.png")  
#savefig(plt3, "./plot3.png")    