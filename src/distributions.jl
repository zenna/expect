Id = Int

normal(μ, σ, ωid::Id, ω::Omega) = quantile(Normal(μ, σ), ω[ωid])
normal(μ::T, σ::T, ωid::Int=ωnew()) where T = RandVar{T}(normal, (μ, σ, ωid))
normal(μ::AbstractRandVar{T}, σ::T, ωid::Int=ωnew()) where T = RandVar{T, true}(normal, (μ, σ, ωid))
normal(μ::T, σ::AbstractRandVar{T}, ωid::Int=ωnew()) where T = RandVar{T, true}(normal, (μ, σ, ωid))

"Gamma distribution"
gammarv(α, θ, ωi, ω::Omega) = quantile(Gamma(α, θ), ω[ωi])
gammarv(α::T, θ::T, ωid::Id = ωnew()) where T <: Real =
  RandVar{T, true}(gammarv, (α, θ, ωid))
Γ = gammarv

"Dirichlet distribution"
function dirichlet(α)
  gammas = [gammarv(αi, 1.0) for αi in α]
  Σ = sum(gammas)
  [gamma/Σ for gamma in gammas]
end

# ## Problem here is that
# "Dirichlet distribution"
# function dirichlet(α, ω)
#   gammas = [gammarv(αi, 1.0, ω) for αi in α]
#   Σ = sum(gammas)
#   [gamma/Σ for gamma in gammas]
# end

"Inverse Gamma"
inversegamma(α, θ, ωi) = quantile(InverseGamma(α, θ), ωi)
inversegamma(α, θ, ωid::Id = ωnew()) =
  RandVar{Real}(ω -> inversegamma(apl(α, ω), apl(θ, ω), ω[ωid]), ωid)

"Beta"
beta(α, β, ωid::Id, ω::Omega) = quantile(Beta(α, β), ω[ωid])
beta(α::T, β::T, ωid::Id=ωnew()) where T = RandVar{T, true}(Mu.beta, (α, β, ωid))

"Bernoulli"
bernoulli(p, ωid::Id, ω::Omega) = quantile(Bernoulli(p), ω[ωid])
bernoulli(p::T, ωid::Id = ωnew()) where T <: Real = RandVar{T, true}(bernoulli, (p, ωid))
bernoulli(p::RandVar{T}, ωid::Id = ωnew()) where T = RandVar{T, true}(bernoulli, (p, ωid))

"Categorical"
categorical(p, ωid::Id, ω::Omega) = quantile(Categorical(p), ω[ωid])
categorical(p::Array{T, 1}, ωid::Id = ωnew()) where T <: Real = RandVar{Int, true}(categorical, (p, ωid))
categorical(p::RandVar{Array{T, 1}, true}, ωid::Id = ωnew()) where T =
                                        RandVar{Int, true}(categorical, (p, ωid))

"`uniform(a, b)`"
uniform(a::T, b::T, ωid::Id, ω::Omega) where T = ω[ωid] * (b - a) + a
uniform(a::T, b::T, ωid::Id=ωnew()) where T = RandVar{T, true}(uniform, (a, b, ωid))
uniform(a::AbstractRandVar{T}, b::T, ωid::Id=ωnew()) where T = RandVar{T, true}(uniform, (a, b, ωid))
uniform(a::T, b::AbstractRandVar{T}, ωid::Id=ωnew()) where T = RandVar{T, true}(uniform, (a, b, ωid))
uniform(a::AbstractRandVar{T}, b::AbstractRandVar{T}, ωid::Id=ωnew()) where T = RandVar{T, true}(uniform, (a, b, ωid))
