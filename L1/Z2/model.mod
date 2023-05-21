/* Gabriel Budziński 254609 */
/* Enumerated sets */

set Cities;
set Types;

/* Parameters */

param multiplier{Types};
param surplus{Cities, Types} >= 0;
param deficit{Cities, Types} >= 0;
param distance{Cities, Cities} >= 0;

/* Variables */ 

# liczba dźwigów typu k transportowanych z miasta i do j
var transport{i in Cities, j in Cities, k in Types} >= 0;

/* objective function */

# koszt rozwiązania to suma kosztów transportu wszystkich dźwigów
minimize Cost: sum{i in Cities, j in Cities, k in Types} transport[i,j,k]*distance[i,j]*multiplier[k];

/* constraints */

# z miasta nie może wyjechać więcej dźwigów niż jest nadmiaru
s.t. out{i in Cities, k in Types}: sum{j in Cities} transport[i,j,k] <= surplus[i,k];

# do miasta musi przyjechać co najmniej tyle dźwigow typu II ile jest niedomiaru
s.t. in_II{i in Cities}: sum{j in Cities} transport[j,i,'Typ_II'] >= deficit[i,'Typ_II'];

# do miasta musi przyjechać co najmniej tyle dźwigów obu typów aby zaspokoić niedomiar
s.t. in_total{i in Cities}: sum{j in Cities, k in Types} transport[j,i,k] = sum{k in Types} deficit[i,k];

solve;

/* output to file */

for {i in Cities} {
    printf{j in Cities}: transport[i,j,'Typ_I'] & " & " >> "out_I.txt";
    printf "\\\\\\hline\n" >> "out_I.txt";
}
for {i in Cities} {
    printf{j in Cities}: transport[i,j,'Typ_II'] & " & " >> "out_II.txt";
    printf "\\\\\\hline\n" >> "out_II.txt";
}
end;