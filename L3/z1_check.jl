using DelimitedFiles

results_opt = readdlm("results.csv", ';', Int)
results = readdlm("data.csv", ',', Int)

for i in 1:200
    quotient = results[i,2]/results_opt[i,2]
    if quotient > 2 || quotient < 1
        print("WARNING: ")
    end
    println(results_opt[i,1], ',', quotient)
end