#=
Gabriel Budziński
254609
=#

using JuMP
import GLPK

M = 1000

function solve(n, m, p, r)
    model = Model(GLPK.Optimizer)
    # start times
    @variable(model, s[1:n] >= 0)
    # machine number
    @variable(model, 1 <= c[1:n] <= m, Int)
    # precedence on same machine
    @variable(model, y[1:n,1:n], Bin)
    # if same machine
    @variable(model, x[1:n,1:n,1:3], Bin)
    # C_max
    @variable(model, C)
    # if same machine x[i,j,2] == 1
    @constraint(model, [i in 1:n, j in 1:n; i < j], c[i] - c[j] <= -0.1*x[i,j,1] + m*x[i,j,3])
    @constraint(model, [i in 1:n, j in 1:n; i < j], -m*x[i,j,1] + 0.1*x[i,j,3] <= c[i] - c[j])
    @constraint(model, [i in 1:n, j in 1:n], sum(x[i,j,:]) == 1)
    # if same machine i before j or j before i
    @constraint(model, [i in 1:n, j in 1:n; i < j], s[i] + M*(y[i,j] + (1-x[i,j,2])) >= s[j] + p[j])
    @constraint(model, [i in 1:n, j in 1:n; i < j], s[j] + M*(1 - y[i,j] + (1-x[i,j,2])) >= s[i] + p[i])
    # precedence from task data
    @constraint(model, [i in 1:n, j in 1:n; i < j && r[i,j] == 1], s[i] + p[i] <= s[j])
    # C_max is the max
    @constraint(model, [i in 1:n], C >= s[i] + p[i])
    @objective(model, Min, C)
    optimize!(model)
    for i in 1:n
        println("$i $(value(s[i])) $(value(c[i]))")
    end
end

n = 9
m = 3
p = [1 2 1 2 1 1 3 6 2]
r = [0 0 0 1 0 0 0 0 0
     0 0 0 1 1 0 0 0 0
     0 0 0 1 1 0 0 0 0
     0 0 0 0 0 1 1 0 0
     0 0 0 0 0 0 1 1 0
     0 0 0 0 0 0 0 0 1
     0 0 0 0 0 0 0 0 1
     0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0]

solve(n, m, p, r)