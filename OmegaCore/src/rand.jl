module Rand

export rvx

tagrand(ω, i = UInt(0)) = 
  tag(ω, (rand = Box(i),))

rv(x) = ω -> x(tagrand(ω))

inc_counter!(ω) = ω.tags.rand.val += 1

o(x, ω) = let x_ = x; inc_counter!(ω); x_

Base.rand(::trait(Rand), ω) = let x_ = StdUnif(counter(ω), ω); inc!(ω); x end
Base.randn(::trait(Rand), ω) = let x_ = StdNormal(counter(ω), ω); inc!(ω); x end
Base.rand(::trait(Rand), ω, ::Distribution) = let x_ = StdNormal(counter(ω), ω); inc!(ω); x end
Base.rand(ω::AbstractΩ, args...) = rabd(traits(ω), ω, args...)