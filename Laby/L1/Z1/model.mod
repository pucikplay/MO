/* Gabriel Budziński 254609 */
/* Parameters */

param N;
param A{i in {1..N}, j in {1..N}} := 1/(i + j - 1);
param B{i in {1..N}} := sum{j in {1..N}} 1/(i + j - 1);
param C{i in {1..N}} := B[i];

/* Variables */ 

var X {i in {1..N}} >= 0; # the array of decision variables plus trivial bounds

/* objective function */

minimize CostFun: sum{i in {1..N}} X[i]*C[i];

/* constraints */

s.t. matrix_contraints{i in {1..N}}: sum{j in {1..N}} A[i,j] * X[j] = B[i];

solve;

/* output to file */

printf N & "," & sum{i in {1..N}} (1 - X[i])^2 / N & "\n" >> "out.csv";

end;