#=
Gabriel Budziński
254609
=#

using JuMP
import Cbc

M = 1000

function replace(x)
    if x == 1
        return '#'
    else
        return '-'
    end
end

function solve(n, p, t, r, u, T)
    model = Model(Cbc.Optimizer)
    @variable(model, x[1:n,1:T], Bin)
    @variable(model, C >= 0) # C_max
    for i in 1:n, w in 1:T
        W = max(1,w-t[i]+1)
        @constraint(model, sum(x[i,W]*r[i]) <= 30)
    end
    @constraint(model, [i in 1:n, j in 1:n; i < j && u[i,j] == 1], sum((w-1+t[i])*x[i,w] for w in 1:(T-t[i]+1)) <= sum((w-1)*x[j,w] for w in 1:(T-t[j]+1)))
    @constraint(model, [i in 1:n], sum(x[i,:]) == 1)
    for i in 1:n
        @constraint(model, [w in t[i]:(T+t[i]-1)], x[i,(w-t[i]+1)]*w <= C)
    end
    @objective(model, Min, C)
    optimize!(model)
    for i in 1:n
        for w in 1:225
            print("$(replace(value(x[i,w])))")
        end
        print("\n")
    end
    println("$(value(C))")
end

n = 8
p = 1
t = [50 47 55 46 32 57 15 62]
r = [9 17 11 4 13 7 7 17]
u = [0 1 1 1 0 0 0 0
     0 0 0 0 1 0 0 0
     0 0 0 0 0 1 0 0
     0 0 0 0 0 1 1 0
     0 0 0 0 0 0 0 1
     0 0 0 0 0 0 0 1
     0 0 0 0 0 0 0 1
     0 0 0 0 0 0 0 0]

solve(n,p,t,r,u,sum(t))