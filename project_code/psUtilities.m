% Author: Jean-Philippe Raymond (raymonjp@iro.umontreal.ca)
% =========================================================


function utilities = psUtilities(paths, nDraws, betas)
   %{
   TODO: Bla bla bla ..

   TODO: Define the distinction that is made between observations and paths
         throughout the whole code, in a README or whatever.

         choiceSets would probably be a better name for paths.
   %}
   
   attributes = myGetPathAttributes(paths, nDraws);
   utilities = attributes * betas';
end
