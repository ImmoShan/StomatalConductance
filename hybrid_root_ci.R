# function [flux, root] = hybrid_root (func, physcon, atmos, leaf, flux, xa, xb, tol)
# set func = CiFunc


#testing_values
#ci0 = 0.7 * atmos$co2air;
#ci1 = ci0 * 0.99;

#xa = ci0
#xb = ci1
#tol = 0.1;     

# function hybrid_root specifically for CiFunc

hybrid_root_ci = function(physcon, atmos, leaf, flux, xa, xb, tol){
  
  # Solve for the root of a function using the secant and Brent's methods given
  # initial estimates xa and xb. The root is updated until its accuracy is tol. 
  # func is the name of the function to solve. The variable root is returned as
  # the root of the function. The function being evaluated has the definition statement: 
  #
  # function [flux, fx] = func (physcon, atmos, leaf, flux, x)
  #
  # The function func is exaluated at x and the returned value is fx. It uses variables
  # in the physcon, atmos, leaf, and flux structures. These are passed in as
  # input arguments. It also calculates values for variables in the flux structure
  # so this must be returned in the function call as an output argument. The matlab
  # function feval evaluates func.
  
  # source("CiFunc.R")
  source("brent_root_ci.R")  
  source("CiFunc.R")
  
  
  
  # --- Evaluate func at xa and see if this is the root
  # xa = t0
  
  x0 = xa;
  flux_f0 = CiFunc(physcon, atmos, leaf, flux, x0);
  flux = flux_f0[[1]]
  f0 = flux_f0[[2]]
  if (f0 == 0) {
    root = x0;
    hybrid_root_ci_output = list(flux,root)
    return(hybrid_root_ci_output) #what about this return?
  }
  
  
  
  # --- Evaluate func at xb and see if this is the root
  # xb = t1
  
  x1 = xb;
  flux_f1 = CiFunc(physcon, atmos, leaf, flux, x1);
  flux = flux_f1[[1]]
  f1 = flux_f1[[2]]
  if (f1 == 0) {
    root = x1;
    hybrid_root_ci_output = list(flux,root)
    return(hybrid_root_ci_output) #same as above
  }
  
  # --- Order initial root estimates correctly
  
  if (f1 < f0) {
    minx = x1;
    minf = f1;
  }
  else {
    minx = x0;
    minf = f0;
  }
  
  # --- Iterative root calculation. Use the secant method, with Brent's method as a backup
  
  itmax = 40;
  for (iter in 1:itmax){
    dx = -f1 * (x1 - x0) / (f1 - f0);
    x = x1 + dx;
    
    # Check if x is the root. If so, exit the iteration
    
    if (abs(dx) < tol){
      x0 = x;
      break
    }
    
    # Evaluate the function at x
    
    x0 = x1;
    f0 = f1;
    x1 = x;
    flux_f1 = CiFunc (physcon, atmos, leaf, flux, x1);
    flux = flux_f1[[1]]
    f1 = flux_f1[[2]]
    if (f1 < minf){
      minx = x1;
      minf = f1;
    }
    
    # If a root zone is found, use Brent's method for a robust backup strategy
    # and exit the iteration
    
    if (f1 * f0 < 0){
      flux_x = brent_root_ci (physcon, atmos, leaf, flux, x0, x1, tol);
      flux = flux_x[[1]]
      x = flux_x[[2]]
      x0 = x;
      break
    }
    
    # In case of failing to converge within itmax iterations stop at the minimum function
    
    if (iter == itmax) {
      flux_f1 = CiFunc (physcon, atmos, leaf, flux, minx);
      flux = flux_f1[[1]]
      f1 = flux_f1[[2]]
      x0 = minx;
    }
    
  }
  
  root = x0;
  
  hybrid_root_ci_output = list(flux,root)
  
  return(hybrid_root_ci_output)
  
}