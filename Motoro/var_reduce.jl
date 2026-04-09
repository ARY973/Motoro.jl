using Motoro
using StatsPlots
using Plots
using Statistics
using Printf

call = EuropeanCall(40.0, 1.0)
model_naive = MonteCarlo(1, 5000, Naive)
model_anti = MonteCarlo(1, 5000, Antithetic)
model_strat = MonteCarlo(1, 5000, Stratified)
model_antistrat = MonteCarlo(1, 5000, AntiStrat)

data = MarketData(41.0, 0.08, 0.3, 0.0)

M = 500
prices_naive = zeros(M)
prices_anti = zeros(M)
prices_strat = zeros(M)
prices_antistrat = zeros(M)

for j in 1:M
    prices_naive[j] = price(call, model_naive, data)
    prices_anti[j] = price(call, model_anti, data)
    prices_strat[j] = price(call, model_strat, data)
    prices_antistrat[j] = price(call, model_antistrat, data)
end

bs_price = price(call, BlackScholes(), data)

println("Method        | Mean     | Std Dev")
println("--------------|----------|--------")
@printf("Naive         | %.4f   | %.4f\n", mean(prices_naive), std(prices_naive))
@printf("Antithetic    | %.4f   | %.4f\n", mean(prices_anti),  std(prices_anti))
@printf("Stratified    | %.4f   | %.4f\n", mean(prices_strat), std(prices_strat))
@printf("Anti-Strat    | %.4f   | %.4f\n", mean(prices_antistrat), std(prices_antistrat))
@printf("Black-Scholes | %.4f   | N/A\n",  bs_price)

histogram(prices_naive, alpha=0.5, label="Naive")
histogram!(prices_anti, alpha=0.5, label="Antithetic")
histogram!(prices_strat, alpha=0.5, label="Stratified")
histogram!(prices_antistrat, alpha=0.5, label="Anti-Strat")
vline!([bs_price], label="Black-Scholes", linewidth=2, color=:black)







