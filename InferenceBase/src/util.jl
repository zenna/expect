export ignorefirstn, this, keepall

# FIXME: Move these to MH common

"`burnin(n)` keep function that ignores first `n` samples"
ignorefirstn(n) = i -> i > n

"`thin(n)` keep function that accept only every `n` samples"
thin(n) = i -> i % n == 0

@inline keepall(i) = true

"`a &ₚ b` Pointwise logical `x->a(x) & b(x)`"
a &ₚ b = (x...)->a(x...) &ₚ b(x...)