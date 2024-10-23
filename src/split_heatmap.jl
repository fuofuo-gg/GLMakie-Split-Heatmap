using GLMakie

screen_resolution = (1920, 1080)
# Create a figure with the screen size
fig = GLMakie.Figure(resolution=screen_resolution, fontsize=26)

ax2 = GLMakie.Axis(fig[1, 1])

# Set axis limits
GLMakie.xlims!(ax2, 1, 10)  # Set x-axis limits from 1 to 10
GLMakie.ylims!(ax2, 1, 10)  # Set y-axis limits from 1 to 10

# Define the data
x = 1:10
y = 1:10
z1 = rand(10, 10)  # Data for the lower triangles
z2 = rand(10, 10)  # Data for the upper triangles

# Normalize the data
z1_normalized = (z1 .- minimum(z1)) ./ (maximum(z1) - minimum(z1))
z2_normalized = (z2 .- minimum(z2)) ./ (maximum(z2) - minimum(z2))

function color_map(z, cmap)
    return cmap[Int(round(z, digits=3) * 1000) + 1]
end

cmap = get(colorschemes[:Spectral_11], range(0, 1, 1001))
# Plot the lower triangles
for i in 1:length(x)-1
    for j in 1:length(y)-1
        # Coordinates of the lower triangle vertices
        xs = [x[i], x[i+1], x[i+1], x[i]]
        ys = [y[j], y[j], y[j+1], y[j+1]]
        zs = [z1[i, j], z1[i+1, j], z1[i+1, j+1], z1[i, j+1]]  # Use z1 values for the vertices

        # Apply color based on z1 values
        color_vals = color_map(z1[i, j], cmap)
        GLMakie.mesh!(ax2, xs, ys, zs, color=color_vals, shading=false)
    end
end

cmap = get(colorschemes[:Spectral_11], range(0, 1, 1001))
# Plot the upper triangles
for i in 1:length(x)-1
    for j in 1:length(y)-1
        # Coordinates of the upper triangle vertices
        xs = [x[i+1], x[i], x[i], x[i+1]]
        ys = [y[j+1], y[j+1], y[j], y[j]]
        zs = [z2[i+1, j+1], z2[i, j+1], z2[i, j], z2[i+1, j]]  # Use z2 values for the vertices

        # Apply color based on z2 values
        color_vals = color_map(z2[i, j], cmap)
        GLMakie.mesh!(ax2, xs, ys, zs, color=color_vals, shading=false)
    end
end

for i in 1:length(x)-1
    for j in 1:length(y)-1
        GLMakie.text!(ax2, string(round(z1[i, j], digits=3)),
        position = (x[i]+0.75, y[j]+0.25),
        align = (:center, :center),
        color = :black,
        fontsize = 14, 
        overdraw= true)

        GLMakie.text!(ax2, string(round(z2[i, j], digits=3)),
        position = (x[i]+0.25, y[j]+0.75),
        align = (:center, :center),
        color = :black,
        fontsize = 14, 
        overdraw= true)
    end
end

# Display the plot
display(fig)
# save("split_heatmap.png", fig)
