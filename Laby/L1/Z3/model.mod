/*  Gabriel Budziński 254609*/

/* Sets */

set Fuels;
set Units;

/* Parameters */

param price_B1;
param price_B2;

param sulphur_content_B1;
param sulphur_content_B2;
param sulphur_content_B1_K;
param sulphur_content_B2_K;

param efficiency{Units, Fuels};

param destilling_cost_D1;
param destilling_cost_D2;
param destilling_cost_K;

param demand_petrol;
param demand_oil_home;
param demand_oil_heavy;

/* Variables */ 

var B1_bought >= 0;
var B2_bought >= 0;

var D1_petrol >= 0;
var D1_oil >= 0;
var D1_destillate >= 0;
var D1_leftovers >= 0;
var D1_destillate_to_K >= 0;
var D1_destillate_out >= 0;
var D1_oil_home >= 0;
var D1_oil_heavy >= 0;

var D2_petrol >= 0;
var D2_oil >= 0;
var D2_destillate >= 0;
var D2_leftovers >= 0;
var D2_destillate_to_K >= 0;
var D2_destillate_out >= 0;
var D2_oil_home >= 0;
var D2_oil_heavy >= 0;

var K_petrol >= 0;
var K_oil >= 0;
var K_leftovers >= 0;

/* objective function */

minimize Cost: B1_bought*(price_B1 + destilling_cost_D1) + 
               B2_bought*(price_B2 + destilling_cost_D2) + 
               (D1_destillate_to_K + D2_destillate_to_K)*destilling_cost_K;

/* constraints */

s.t. efficiency_D1_petrol:          D1_petrol = B1_bought*efficiency['D_one','Petrol'];
s.t. efficiency_D1_oil:             D1_oil = B1_bought*efficiency['D_one','Oil'];
s.t. efficiency_D1_destillate:      D1_destillate = B1_bought*efficiency['D_one','Destillate'];
s.t. efficiency_D1_leftovers:       D1_leftovers = B1_bought*efficiency['D_one','Leftovers'];
s.t. destillate_conservation_D1:    D1_destillate = D1_destillate_to_K + D1_destillate_out;
s.t. oil_conservation_D1:           D1_oil = D1_oil_home + D1_oil_heavy;

s.t. efficiency_D2_petrol:          D2_petrol = B2_bought*efficiency['D_two','Petrol'];
s.t. efficiency_D2_oil:             D2_oil = B2_bought*efficiency['D_two','Oil'];
s.t. efficiency_D2_destillate:      D2_destillate = B2_bought*efficiency['D_two','Destillate'];
s.t. efficiency_D2_leftovers:       D2_leftovers = B2_bought*efficiency['D_two','Leftovers'];
s.t. destillate_conservation_D2:    D2_destillate = D2_destillate_to_K + D2_destillate_out;
s.t. oil_conservation_D2:           D2_oil = D2_oil_home + D2_oil_heavy;

s.t. efficiency_K_petrol:       K_petrol = (D1_destillate_to_K + D2_destillate_to_K)*efficiency['Krackator','Petrol'];
s.t. efficiency_K_oil:          K_oil = (D1_destillate_to_K + D2_destillate_to_K)*efficiency['Krackator','Oil'];
s.t. efficiency_K_leftovers:    K_leftovers = (D1_destillate_to_K + D2_destillate_to_K)*efficiency['Krackator','Leftovers'];

s.t. demand_petrol_:     D1_petrol + D2_petrol >= demand_petrol;
s.t. demand_oil_home_:   D1_oil_home + D2_oil_home + K_oil >= demand_oil_home;
s.t. demand_oil_heavy_:  D1_oil_heavy + D1_destillate_out + D1_leftovers + 
                        D2_oil_heavy + D2_destillate_out + D2_leftovers + 
                        K_leftovers >= demand_oil_heavy;

s.t. sulphur_content_oil_home:  D1_oil_home*sulphur_content_B1 +
                                D2_oil_home*sulphur_content_B2 +
                                (D1_destillate_to_K*sulphur_content_B1_K + 
                                 D2_destillate_to_K*sulphur_content_B2_K)*efficiency['Krackator','Oil'] <= 0.5;

solve;

display B1_bought;
display B2_bought;

end;