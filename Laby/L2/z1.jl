#=
Gabriel Budziński
254609
=#

using JuMP
import GLPK

function get_loss(pattern, widths, plank_width)
    sum = 0
    for i in 1:length(widths)
        sum += widths[i]*pattern[i]
    end
    return plank_width - sum
end

function gen_patterns(widths, plank_width)
    patterns = zeros(Int8, length(widths))
    
    losses = [get_loss(patterns, widths, plank_width)]
    while true
        i = 
    end
end

# function solve(plank_width, widths, demand)
#     model = Model(GLPK.Optimizer)

# end

plank_width = 22
widths = [7, 5, 3]
demand = [110, 120, 80]

# function solve(suppliers, capacities, receivers, requirements, cost)
#     model = Model(GLPK.Optimizer)
#     buy = zeros(Int8, receivers, suppliers)
#     @variable(model, buy[1:receivers,1:suppliers] >= 0)
#     for s in 1:suppliers
#         @constraint(model, (sum(buy[1:receivers,s]) <= capacities[s]))
#     end
#     for r in 1:receivers
#         @constraint(model, sum(buy[r,1:suppliers]) == requirements[r])
#     end
#     @objective(model, Min, sum(cost[r,s] * buy[r,s] for r in 1:receivers, s in 1:suppliers))

#     optimize!(model)
#     for i in 1:receivers
#         for j in 1:suppliers
#             print("$(value(buy[i,j])) ")
#         end
#         println()
#     end
#     return
# end

# suppliers = 3
# capacities = [275000,550000,660000]
# receivers = 4
# requirements = [110000,220000,330000,440000]

# cost = [
#     10 7 8
#     10 11 14
#     9 12 4
#     11 13 9
#     ]

# solve(suppliers, capacities, receivers, requirements, cost)