#=
Gabriel Budziński
254609
=#

using DelimitedFiles
# using PyPlot

results_opt = readdlm("results_opt.csv", ',', Float64)
results = readdlm("results.csv", ',', Float64)
quotients = zeros(Float64, 200)

for i in 1:200
    quotient = results[i,2]/results_opt[i,10]
    if quotient > 2 || quotient < 1
        print("WARNING: ")
    end
    println(results_opt[i,1], ',', quotient, ',', results[i,3], ',', results_opt[i,6])
    # quotients[i] = quotient
end

# plt.plot(1:200, quotients)
# plt.plot(1:200, ones(Int, 200))
# plt.plot(1:200, ones(Int, 200) * 2)
# plt.show()