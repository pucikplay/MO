using JuMP
import Cbc
import GLPK

function readTimes(filename)
    times = Array{Int64, 2}
    lines = open(filename) do file
        readlines(file)
    end
    sizes = parse.(Int,split(replace(lines[1], r"[^0-9.]"=>" ")))
    n, m = sizes[1], sizes[2]
    times = zeros(Int, n, m)
    for (i,line) in enumerate(lines[3:end])
        parsed = parse.(Int,split(replace(line, r"[^0-9.]"=>" ")))
        times[i,:] = parsed[2:2:end]
    end
    return times
end

function greedySchedule(times)
    n = length(times[:,1])
    m = length(times[1,:])
    makespans = zeros(Int64, m)

    for j in 1:n
        minimum, machine = findmin(times[j,:])
        makespans[machine] += minimum
    end

    return maximum(makespans)
end

function calcMakespan(times)
    n = length(times[:,1])
    m = length(times[1,:])
    alpha = greedySchedule(times)
    return alpha
end

function checkFeasibility(times, T)
    n = length(times[:,1])
    m = length(times[1,:])
    S_j = [[] for j in 1:n]
    S_i = [[] for i in 1:m]
    for j in 1:n
        for i in 1:m
            if times[j,i] <= T
                S_j[j] = append!(S_j[j], i)
                S_i[i] = append!(S_i[i], j)
            end
        end
    end

    model = Model(GLPK.Optimizer)
    @variable(model, x[1:n,1:m] >= 0)
    @constraint(model, [j in 1:n], sum(x[j,i] for i in S_j[j]) == 1)
    @constraint(model, [i in 1:m], sum(x[j,i] * times[j,i] for j in S_i[i]) <= T)
    @objective(model, Min, 0)
    optimize!(model)
    if termination_status(model) == OPTIMAL::TerminationStatusCode
        return true,value.(x)
    end
    return false,nothing
end

function binsearch(alpha, times)
    n = length(times[:,1])
    m = length(times[1,:])
    l = alpha ÷ m
    r = alpha
    mid = 0
    result = nothing
    while l < r
        mid = (l+r) ÷ 2
        feasible, result = checkFeasibility(times, mid)
        if feasible
            r = mid - 1
        else
            l = mid + 1
        end
    end
    return mid + 1, result
end

times = readTimes("111.txt")

alpha = calcMakespan(times)
println(alpha)
T_min, result = binsearch(alpha, times)
println(T_min)
display(result)

# println(checkFeasibility(times, 10))