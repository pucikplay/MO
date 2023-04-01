/* Gabriel Budziński 254609 */

/* Sets */

set Subjects;
set Groups;
set Time := 16..39;
set Days;

/* Parameters */

param Start{Groups, Subjects};
param End{Groups, Subjects};
param Day{Groups, Subjects};
param Preference{Groups, Subjects};

/* Variables */

var register{Groups, Subjects} binary;
var hours{Time, Days} binary;
var training_1 binary;
var training_2 binary;
var training_3 binary;

/* objective function */

maximize Satisfaction: sum{g in Groups, s in Subjects} register[g,s]*Preference[g,s];

/* constraints */

s.t. no_collisions{g1 in Groups, s1 in Subjects, g2 in Groups, s2 in Subjects:  
                    Day[g1,s1] == Day[g2,s2] && 
                    (s1 != s2 || g1 != g2) && 
                    (Start[g1,s1] <= End[g2,s2] &&
                     Start[g2,s2] <= End[g1,s1])}: 
                        register[g1,s1] + register[g2,s2] <= 1;
                        
s.t. max_hours{d in Days}: sum{t in Time} hours[t,d] <= 4*2;
s.t. empty_hour{d in Days}: sum{t in {24,25,26,27}} hours[t,d] <= 2*1;
s.t. one_group_per_subject{s in Subjects}: (sum{g in Groups} register[g,s]) = 1;
s.t. restrict_hours{g in Groups, s in Subjects, t in Time: t >= Start[g,s] && t < End[g,s]}: hours[t,Day[g,s]] >= register[g,s];
/* training_i = 0 iff all the slots are empty */
s.t. training_1_{t in {26,27,28,29}}: training_1 >= hours[t,1];
s.t. training_2_{t in {22,23,24,25}}: training_2 >= hours[t,3];
s.t. training_3_{t in {26,27,28,29}}: training_3 >= hours[t,3];
/* training_1 and training_2 and training_3 = 0 */
s.t. training_i: training_1 >= 0;
s.t. training_ii: training_2 >= 0;
s.t. training_iii: training_3 >= 0;
s.t. training: training_1 + training_2 + training_3 <= 2;
/* additional constraints */
s.t. three_days{g in Groups, s in Subjects: Day[g,s] == 3 || Day[g,s] == 5}: register[g,s] = 0;
s.t. preference_limit{g in Groups, s in Subjects : Preference[g,s] <= 4 } : register[g,s] = 0;

solve;

display register;
display Satisfaction;

end;