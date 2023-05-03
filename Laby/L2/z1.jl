#=
Gabriel Budziński
254609
=#

using JuMP
import GLPK

# get loss of pattern
function get_loss(pattern, widths, plank_width)
    sum = 0
    for i in 1:length(widths)
        sum += widths[i]*pattern[i]
    end
    return plank_width - sum
end

# generate all feasible patterns
function gen_patterns(widths, plank_width)
    widths_no = length(widths)
    fit = map((x) -> plank_width ÷ x, widths)
    patterns = zeros(Int8, widths_no)
    counts = zeros(Int8, widths_no)
    while counts[1] <= fit[1]
        loss = get_loss(counts, widths, plank_width)
        if loss < widths[widths_no] && loss >= 0
            patterns = cat(dims=2, patterns, counts)
        end
        i = widths_no
        counts[i] += 1
        while counts[i] > fit[i]
            counts[i] = 0
            i -= 1
            if i == 0
                counts[1] = fit[1] + 1
                break
            end
            counts[i] += 1
        end
    end
    return patterns[:,2:end]
end

function solve(plank_width, widths, demand, patterns)
    model = Model(GLPK.Optimizer)
    widths_no = length(widths)
    patterns_no = length(patterns) ÷ widths_no
    # number of planks cut in each pattern
    @variable(model, x[1:patterns_no] >= 0, Int)
    # satisfy demand
    @constraint(model, [i = 1:widths_no], sum(x.*patterns[i,:]) >= demand[i])
    @objective(model, Min, sum(x[:]))
    optimize!(model)
    for i in 1:patterns_no
        println("$(value(x[i])) $(patterns[:,i])")
    end
end

plank_width = 22
widths = [7 5 3]
demand = [110 120 80]

solve(plank_width, widths, demand, gen_patterns(widths, plank_width))