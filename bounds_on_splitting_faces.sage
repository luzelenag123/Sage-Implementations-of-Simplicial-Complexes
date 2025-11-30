load("lex_ideals.sage")
load("m-vectors.sage")

# Bounds on the number of splitting faces of a ball with h-vector h. 

# Helpers
def count_deg2_divisible_by_xn(L, n):
    """
    Count how many degree 2 generators of L are divisible by x_n.
    L: a monomial ideal of R = k[x_1,...,x_n]
    n: index of the variable (1-based indexing)
    """
    R = L.ring()
    xn = R.gens()[n-1]  # x_n
    return sum(1 for g in L.groebner_basis() if g.degree() == 2 and g % xn == 0)


def weighted_count_deg3(L, n):
    """
    Compute: (n-1) * (# degree 3 generators divisible by x_n)
           + (# degree 3 generators divisible by x_{n-1} but not x_n)
    L: a monomial ideal of R = k[x_1,...,x_n]
    n: index of the variable (1-based indexing)
    """
    R = L.ring()
    xn = R.gens()[n-1]     # x_n
    xn1 = R.gens()[n-2]    # x_{n-1}

    # print(f"x_n = {xn}, x_(n-1) = {xn1}")

    deg3_div_xn = sum(1 for g in L.groebner_basis() if g.degree() == 3 and g % xn == 0)
    deg3_div_xn1_not_xn = sum(1 for g in L.groebner_basis() if g.degree() == 3 and g % xn1 == 0 and g % xn != 0)

    return (n-1) * deg3_div_xn + deg3_div_xn1_not_xn

# Derived from Peeva's cancellation technique.
def lower_bound_on_splitting_faces(h):
    R, L, gens_by_degree = lex_generators_from_h(h)
    n = h[1] + len(h) - 1 
    return count_deg2_divisible_by_xn(L, n) - weighted_count_deg3(L, n)

# Nagel's upper bound.
def upper_bound_on_splitting_faces(h):
    d = len(h) - 1
    g_1 = h[1] - h[d-1]
    g_2 = h[2] - h[d-2]
    return g_1 - macaulay_prev(g_2,2)


# Examples
#h = [1, 5, 7, 10, 5, 3, 0]
#print(lower_bound_on_splitting_faces(h))
#print(upper_bound_on_splitting_faces(h))
