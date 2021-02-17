using Omega
using Flux
import Tracker

function testsum(;kwargs...)
  x = logistic(1.0, 1.0, (10,))
  y = sum(x)
  ΩT = Omega.SimpleΩ{Vector{Int}, Tracker.TrackedArray{Float64, 1, Array{Float64,1}}}
  samples = rand(y, y ==ₛ -1.0; alg = HMCFAST, ΩT = ΩT, kwargs...)
end

testsum()