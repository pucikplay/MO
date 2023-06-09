import matplotlib.pyplot as plt
import csv

quotients = []
times_opt = []
times = []

if __name__ == "__main__":
    with open('L3/data.csv') as csvfile:
            reader = csv.reader(csvfile, delimiter=',')
            for row in reader:
                quotients.append(float(row[1]))
                times.append(float(row[2]))
                times_opt.append(float(row[3]))

    plt.plot(range(200), quotients)
    plt.plot(range(200), [1] * 200)
    plt.plot(range(200), [2] * 200)
    plt.xlabel("# of instance")
    plt.ylabel("makespan/opt_makespan")
    plt.savefig("L3/quotients.png", dpi=300)
    plt.close()

    plt.plot(range(200), times, label='Approx')
    plt.plot(range(200), times_opt, label='Cplex')
    plt.xlabel("# of instance")
    plt.ylabel("Time of execution")
    plt.legend()
    plt.savefig("L3/times.png", dpi=300)
    plt.ylim((-.5,10))
    plt.savefig("L3/times_lim.png", dpi=300)
    plt.close()
