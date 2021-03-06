# function [flux] = LeafFluxes (physcon, atmos, leaf, flux)

LeafFluxes = function(physcon, atmos, leaf, flux){
  


# --- Leaf temperature, energy fluxes, photosynthesis, and stomatal conductance
# leaf.gstyp is always 1
# if (leaf.gstyp <= 1)
  
# Solve for tleaf: Use TleafFunc to iterate leaf temperature, energy fluxes,
# photosynthesis and stomatal conductance. This temperature is refined to an
# accuracy of tol. Do not use the returned value (dummy), and instead use
# the tleaf calculated in the final call to TleafFunc.

t0 = flux$tleaf - 1.0;        # Initial estimate for leaf temperature (K)
t1 = flux$tleaf + 1.0;        # Initial estimate for leaf temperature (K)
tol = 0.1;                    # Accuracy tolerance for tleaf (K)
# func_name = 'TleafFunc';      # The function name

# [flux, dummy] = hybrid_root (func_name, physcon, atmos, leaf, flux, t0, t1, tol);
# hybrid root returns c(flux,root) 
# contained in file hybrid_root.R, adjusted for being called by LeafFluxes.R only

flux = LeafFluxes_hybrid_root(physcon, atmos, leaf, flux, t0, t1, tol);

return(flux)

}
# elseif (leaf.gstyp == 2)

# Iterate leaf temperature, flux calculations, and stomatal conductance
# using stomatal optimization

# [flux] = StomataOptimization (physcon, atmos, leaf, flux);

# end
