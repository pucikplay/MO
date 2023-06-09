using JuMP

import Cbc
import HiGHS

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

    model = Model(HiGHS.Optimizer)
    @variable(model, x[1:n,1:m] >= 0)
    @constraint(model, [j in 1:n], sum(x[j,i] for i in S_j[j]) == 1)
    @constraint(model, [i in 1:m], sum(x[j,i] * times[j,i] for j in S_i[i]) <= T)
    @objective(model, Min, 0)
    set_silent(model)
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
    while l <= r
        mid = (l+r) ÷ 2
        feasible, result = checkFeasibility(times, mid)
        # println(l, ',', mid, ',', r, ':', feasible)
        if feasible
            r = mid - 1
        else
            l = mid + 1
        end
    end
    feasible, result = checkFeasibility(times, l)
    return l, result
end

function findMatching(result, times)
    n = length(result[:,1])
    m = length(result[1,:])
    counts = [count(x -> 1 > x > 0, result[:,i]) for i in 1:m]

    iterator = 0
    while sum(counts) > 0
        # println(counts)
        if count(x -> x == 1, counts) == 0
            mach = findfirst(x -> x > 0, counts)
            job = findfirst(x -> 1 > x > 0, result[:,mach])
            for machine in 1:m
                result[job, machine] = 0
            end
            result[job, mach] = 1
        end

        if counts[iterator + 1] == 1
            job = findfirst(x -> 1 > x > 0, result[:,iterator + 1])
            for machine in 1:m
                result[job, machine] = 0
            end
            result[job, iterator + 1] = 1
        end
        counts = [count(x -> 1 > x > 0, result[:,i]) for i in 1:m]
        iterator = (iterator + 1) % m 
    end

    makespan = maximum([sum(result[j,i] * times[j,i] for j in 1:n) for i in 1:m])

    return result, makespan
end

function getMakespan(filename)
    times = readTimes(filename)

    alpha = calcMakespan(times)
    # println(alpha)
    T_min, result = binsearch(alpha, times)
    # println(T_min)
    # display(result)
    # println()
    result_altered, makespan = findMatching(result, times)
    # display(result_altered)
    # println()
    return makespan
end

instances = readdir("instances", join = true)

for instance in instances
    name = split(split(instance,'/')[2],'.')[1]
    # println(name)
    makespan = getMakespan(instance)
    println(name, ',', Int(makespan))
end