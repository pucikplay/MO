#=
Gabriel Budziński
254609
=#

using JuMP
import Cbc

M = 1000

function solve(n, p, w, r)
    model = Model(Cbc.Optimizer)
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
        println("$(value(c[i] - p[i]))")
    end
end

p = [3,2,4,5,1]
r = [2,1,3,1,0]
w = [1,1,1,1,1]

solve(5, p, w, r)