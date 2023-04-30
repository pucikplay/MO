#=
Gabriel Budziński
254609
=#

using JuMP
import GLPK

M = 1000

function solve(n, m, p, r)
    model = Model(GLPK.Optimizer)

    @variable(model, c[1:n] >= 0)
    @variable(model, 1 <= c_m[1:n] <= m, Int)
    @variable(model, y[i in 1:n, j in 1:n], Bin)
    @variable(model, C >= 0)
    for i in 1:n, j in 1:n
        if i < j
            if c_m[i] == c_m[j]
                @constraint(model, c[i] <= c[j] - p[j] + M*(1 - y[i,j]))
                @constraint(model, c[j] <= c[i] - p[i] + M*y[i,j])
            end
            @constraint(model, c[i] <= c[j] - p[j] + M*(1 - r[i,j]))
            @constraint(model, c[j] <= c[i] - p[i] + M*r[i,j])
        end
    end
    @constraint(model, [i in 1:n], C >= c[i])
    @objective(model, Min, C)
    optimize!(model)
    for i in 1:n
        println("$(value(c[i])) $(value(c_m[i]))")
    end
end

n = 9
m = 3
p = [1 2 1 2 1 1 3 6 2]
r = [0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0
     0 0 0 0 0 0 0 0 0
     1 1 1 0 0 0 0 0 0
     0 1 1 0 0 0 0 0 0
     0 0 0 1 0 0 0 0 0
     0 0 0 1 1 0 0 0 0
     0 0 0 0 1 0 0 0 0
     0 0 0 0 0 1 1 0 0]

solve(n, m, p, r)