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
    greedy_schedule = greedySchedule(times)
    println(greedy_schedule)
end


times = [3 6 10;
         34 2 3;
         3 12 6;
         5 4 2]

calcMakespan(times)