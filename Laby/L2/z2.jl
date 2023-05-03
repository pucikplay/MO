#=
Gabriel Budziński
254609
=#

using JuMP
import GLPK

M = 1000

function solve(n, p, w, r)
    model = Model(GLPK.Optimizer)
    # task finish times
    @variable(model, c[1:n] >= 0)
    # precedence
    @variable(model, y[1:n,1:n], Bin)
    # task must be started after specified time
    @constraint(model, [i in 1:n], c[i] - p[i] >= r[i])
    # task i before j or j before i
    @constraint(model, [i in 1:n, j in 1:n; i < j], c[i] <= c[j] - p[j] + M*(1 - y[i,j]))
    @constraint(model, [i in 1:n, j in 1:n; i < j], c[j] <= c[i] - p[i] + M*y[i,j])
    @objective(model, Min, sum(c[i]*w[i] for i in 1:n))
    optimize!(model)
    for i in 1:n
        print("$(value(c[i])) ")
    end
end


solve(3, [2,3,2], [1,1,5], [2,3,5])