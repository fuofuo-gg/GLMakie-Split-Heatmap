using GLMakie

# Créer une figure et des axes
fig = GLMakie.Figure()
fig = GLMakie.Figure(size=(2400, 1600), fontsize=26)
ax2 = GLMakie.Axis(fig[1, 1])

# Définir les limites des axes
GLMakie.xlims!(ax2, 1, 10)  # Limites de l'axe x de 1 à 10
GLMakie.ylims!(ax2, 1, 10)  # Limites de l'axe y de 1 à 10

# Définir les données
x = 1:10
y = 1:10
z1 = rand(10, 10)  # Données pour les triangles inférieurs
z2 = rand(10, 10)  # Données pour les triangles supérieurs

# Normaliser les données
z1_normalized = (z1 .- minimum(z1)) ./ (maximum(z1) - minimum(z1))
z2_normalized = (z2 .- minimum(z2)) ./ (maximum(z2) - minimum(z2))

function color_map(z,cmap)
    return   cmap[Int(round(z, digits=3)*1000)+1]
end

cmap = get(colorschemes[:Spectral_11], range(0, 1, 1001))
# Tracer les triangles inférieurs
for i in 1:length(x)-1
    for j in 1:length(y)-1
        # Coordonnées des sommets des triangles inférieurs
        xs = [x[i], x[i+1], x[i+1], x[i]]
        ys = [y[j], y[j], y[j+1], y[j+1]]
        zs = [z1[i,j], z1[i+1,j], z1[i+1,j+1], z1[i,j+1]]  # Utiliser les valeurs de z1 pour les sommets

        # Appliquer la couleur basée sur les valeurs de z1
        color_vals = color_map(z1[i,j],cmap)
        GLMakie.mesh!(ax2, xs, ys, zs, color=color_vals, shading=false)
    end
end

cmap = get(colorschemes[:Spectral_11], range(0, 1, 1001))
# Tracer les triangles supérieurs
for i in 1:length(x)-1
    for j in 1:length(y)-1
        # Coordonnées des sommets des triangles supérieurs
        xs = [x[i+1], x[i], x[i], x[i+1]]
        ys = [y[j+1], y[j+1], y[j], y[j]]
        zs = [z2[i+1,j+1], z2[i,j+1], z2[i,j], z2[i+1,j]]  # Utiliser les valeurs de z2 pour les sommets

        # Appliquer la couleur basée sur les valeurs de z2
        color_vals = color_map(z2[i,j], cmap)
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
# Afficher le graphique
display(fig)
#save("split_heatmap.png", fig)
