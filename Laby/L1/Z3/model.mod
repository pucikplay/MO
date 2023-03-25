/* Enumerated sets */

set Fuel_types;
set Destiller_units;
set Oil_types;

/* Parameters */

param oil_prices{Oil_types} >= 0;
param efficiency{Destiller_units, Fuel_types} >= 0;
param destilling_cost{Destiller_units} >= 0;
param sulphur_content{Oil_types} >= 0;
param demand{Fuel_types} >= 0;

/* Variables */ 

var amount{i in Destiller_units} >= 0; # the array of decision variables

/* objective function */

minimize Cost: sum{i in Destiller_units} amount[i]*destilling_cost[i] + ;

/* constraints */

s.t. _demand{i in Fuel_types}: 
solve;

display amount;

end;