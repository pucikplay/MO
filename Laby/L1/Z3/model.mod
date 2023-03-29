/*  Gabriel Budziński 254609*/

/* Parameters */

param price;
param efficiency;

/* Variables */ 

var B1_bought >= 0;
var B2_bought >= 0;

var D1_petrol >= 0;
var D1_oil >= 0;
var D1_destillate >= 0;
var D1_leftovers >= 0;

var D2_petrol >= 0;
var D2_oil >= 0;
var D2_destillate >= 0;
var D2_leftovers >= 0;

var K_petrol >= 0;
var K_oil >= 0;
var K_leftovers >= 0;

/* objective function */

minimize Cost: B1_bought*price['B_one'] + B2_bought*price['B_two'];

/* constraints */

s.t. D1_petrol = B1_bought*efficiency['D_one']['Petrol'];
s.t. D1_oil = B1_bought*efficiency['D_one']['Oil'];
s.t. D1_destillate = B1_bought*efficiency['D_one']['Destillate'];
s.t. D1_leftovers = B1_bought*efficiency['D_one']['Leftovers'];

s.t. D2_petrol = B2_bought*efficiency['D_two']['Petrol'];
s.t. D2_oil = B2_bought*efficiency['D_two']['Oil'];
s.t. D2_destillate = B2_bought*efficiency['D_two']['Destillate'];
s.t. D2_leftovers = B2_bought*efficiency['D_two']['Leftovers'];

s.t. K_petrol = ()*efficiency['Krackator']['Petrol'];
s.t. K_oil = B2_bought*efficiency['Krackator']['Oil'];
s.t. K_leftovers = B2_bought*efficiency['Krackator']['Leftovers'];



solve;

display amount;

end;