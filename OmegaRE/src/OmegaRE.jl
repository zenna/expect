module OmegaRE

using Base.Threads: @spwan
export re, Replica, ReplicaAlg

"Replica Exchange (Parallel Tempering)"
struct ReplicaAlg end
const Replica = ReplicaAlg()

"swap `v[i]` and `v[j]`"
function swap!(v, i, j)
  temp = v[i] 
  v[i] = v[j]
  v[j] = temp
end

"Logarithmically spaced temperatures"
logtemps(n, k = 10) = exp.(k * range(-2.0, stop = 1.0, length = n))

struct PreSwap end
struct PostSwap end

"Swap adjacent chains"
function swap_contexts!(rng, ctxs, logdensity, ωs)
  for i in length(ωs):-1:2
    j = i - 1
    E_i_x = ctxapl(ctxs[i], logdensity, ωs[i])
    E_j_x = ctxapl(ctxs[j], logdensity, ωs[i])
    E_i_y = ctxapl(ctxs[i], logdensity, ωs[j])
    E_j_y = ctxapl(ctxs[j], logdensity, ωs[j])

    k = (E_i_y + E_j_x) - (E_i_x + E_j_y)
    
    doswap = log(rand(rng)) < k
    if doswap
      swap!(ωs, i, j)
    end
  end
end

"""
`re(rng, logdensity, n, ctxs, algs)`

Replica Exchange Markov Chain Monte Carlo

Replica exhange:
- runs `nreplicas = length(algs)` MCMC chains in parallel
- Each alg is run in a different context.
  - The most common form of a context is a temperature
- We assume there is a ground context which is the true model we wish to sample from
- 

# Arguments
- `rng`: AbstractRng used to sample proposals in MH loop
- `logdensity`: density to sample from
- `n`: number of samples
- `algs`: Sampling algorithms, each should support
  - each alg should support `alg(ω, ctx)`
- `ctxs`: List of contexts where:
  - a context is an object that implements:
    1. `under(f, context)`
    2. I need to be able to compute in some context (e.g. temp), the logdensity of another point
  evalincontext(context, logdensity, ω)
# Returns
- `n` samples
"""
function re(rng,
            logdensity,
            n,
            ctxs,
            inits,
            samples = Array{typeof(inits[1])}(undef, n),
            algs;
            keep = keepall,
            swap_every)
  # @pre length(ctxs) == length(algs)
  nreplicas = length(algs)

  groundid = 1
  i = 0
  while i < n
  for j = 1:div(n, swapevery)
    for i = 1:nreplicas
      if i == groundid
        groundsamples, groundenergy = something
        @inbounds samples[i:j] .+ groundsamples
      else
        energy = something
      end

      # In context i take n/swapevery samples
      # Do we want to apply ctx
      apl = @spawn under(ctxs[i], inits[i], algs[i])
      swap_contexts!(rng)
    end
  end
end

# Questions:
# Can there be more than one ground context?
# Is it true that from the ground context we need many samples and from
# everythinge else we need 1 sample?
# -- No, we only need samples from the ground context, we need scores
# From the others
# We need to be able to compute:
  # In some context i, density of some other point

# How should burn in / thinning work?
end # module
