# Generating a phase diagram for Notch-Delta signaling

using Makie
using AbstractPlotting
using AbstractPlotting.MakieLayout
AbstractPlotting.inline!(true)


# Model Notch Delta system
# D1: active delta in cell 1
# D2: active delta in cell 2
function precise_adapt(D1, D2)
    
    u = 1/(1+10(D2^2/(0.1+D2^2))^2) - D1    #dD1/dt
    v = 1/(1+10(D1^2/(0.1+D1^2))^2) - D2    #dD2/dt
    
    return Point(u,v)
end

# Construct the streamplot
plt1 = Scene(resolution =(400,400))
streamplot!(plt1, precise_adapt, 0..1, 0..1, colormap = :plasma, 
    gridsize= (32,32), arrow_size = 0.01)

# Display the plot
display(plt1)

# Save the plot
save("odeField.png", plt1)
