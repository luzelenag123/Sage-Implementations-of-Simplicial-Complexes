def boundary(C):
    """
    Given a list of facets of a simplicial ball, returns the facets of the boundary.
    
    facets: list of lists or sets
        Example: [[1,2,3], [2,3,4]]
    Returns: list of sets (boundary facets)
    """
    from collections import Counter
    
    # Ensure facets are sets for consistency
    facets = [set(f) for f in C.facets()]
    
    # Collect all (d-1)-faces
    faces = []
    for facet in facets:
        for v in facet:
            face = facet - {v}
            faces.append(frozenset(face))  # frozenset to make hashable
    
    # Count occurrences of each face
    count = Counter(faces)
    
    # Boundary faces are those that appear exactly once
    boundary = [set(face) for face, c in count.items() if c == 1]
    
    return SimplicialComplex(boundary)

def alpha(m, g1, n):
    """
    Given a Sage monomial `m` in variables x1,x2,... (a monomial of degree <= n),
    and integers g1, n, return the set F = Union_{j=1..n} { i_j, i_j+1 }
    where i_j = e_j + 2*j - 1 and e_1 <= ... <= e_n are the indices
    of the Y-variables appearing in the padded degree-n representation of m.
    
    Conventions / notes:
      - We assume x1 corresponds to Y_1, x2 to Y_2, ..., so their indices are 1-based.
      - If deg(m) < n we pad with Y_0's (index 0), as before.
      - g1 is the maximum allowed index for Y (so e_j must be in [0, g1]).
      - Returns a Python set of integers.
    """
    # get exponent vector: returns tuple (e_x1, e_x2, ..., e_xr)
    exp_vec = m.exponents()[0]
    
    # build list of Y-indices from exponents: x1 -> index 1, x2 -> index 2, ...
    exponents = []
    for idx0, multiplicity in enumerate(exp_vec):
        if multiplicity:
            exponents.extend([idx0 + 1] * int(multiplicity))  # +1 for 1-based index

    # pad with zeros (Y_0) if degree < n
    while len(exponents) < int(n):
        exponents.append(0)

    # sort nondecreasing: e1 <= e2 <= ...
    exponents.sort()

    # compute F
    F = set()
    for j, e_j in enumerate(exponents, start=1):
        i_j = int(e_j) + 2*j - 1
        if i_j < 0 or i_j + 1 > 2*(int(n)+int(g1)):  # loose bounds check
            pass
        F.update([i_j, i_j + 1])

    return F

def standard_monomials_from_h(h):
    """
    Given an h-vector h = (h_0, h_1, ..., h_d),
    return the set of standard monomials of the lex segment algebra R/L,
    where L is the lexicographic ideal with Hilbert function h.

    Output: list of monomials (sorted in lex order by degree then lexicographically)
    """
    if h[0] != 1:
        raise ValueError("h[0] must be 1 for a standard graded algebra.")
    
    d = len(h) - 1
    r = h[1]   # number of variables
    
    varnames = [f"x{i+1}" for i in range(r)]
    R = PolynomialRing(QQ, varnames, order='lex')
    
    standard_mons = []
    for deg in range(len(h)):
        mons = sorted(R.monomials_of_degree(deg), reverse=True)
        keep = h[deg]
        standard_mons.extend(mons[:keep])
        if h[deg] == 0:
            break
    return R, standard_mons

def monomial_sequence(R, I, G):
    """
    Construct the sequence (M_0, M_1, ..., M_n) as defined recursively.

    INPUT:
    - R: a polynomial ring, e.g. PolynomialRing(QQ, 'x', 3)
    - I: a set (or list) of monomials in R
    - G: a tuple/list of positive integers (1, G_1, G_2, ..., G_n)

    OUTPUT:
    - A list [M_0, M_1, ..., M_n], where each M_k is a list of monomials in R.
    """
    vars = R.gens()
    v = len(vars)
    n = len(G) - 1
    M = []
    
    # Base case
    M0 = [R(1)]
    M.append(M0)
    
    for k in range(n):
        Mk = M[k]
        Sk = set()
        
        # First part: {x_1 * m : m in M_k}
        for m in Mk:
            Sk.add(vars[0] * m)
        
        # Second part: {∏_{i=1}^{k+1} x_{e_i} : e_i > 1 and ∏ x_{e_i -1} ∈ I}
        from itertools import product
        for exps in product(range(2, v+1), repeat=k+1):
            prod1 = prod(vars[i-1] for i in exps)
            prod2 = prod(vars[i-2] for i in exps) if min(exps) > 1 else None
            if prod2 is not None and prod2 in I:
                Sk.add(prod1)
        
        # Sort in reverse lexicographic order
        Sk_sorted = sorted(Sk, key=lambda m: m.degrees(), reverse=True)
        Mk1 = list(Sk_sorted)[:G[k+1]]
        M.append(Mk1)
        
    return M

def billera_lee_ball(h):
    """
    Returns Billera-Lee ball with h-vector (g_0,g_1,...,g_n, 0,0,...,0)
    """
    d = len(h)-1
    n = d//2
    g = (1,)+tuple(h[i+1] - h[i] for i in range(n))
    print(g)
    R, standard_mons = standard_monomials_from_h(g)
    facets = []
    for m in standard_mons:
        if d % 2 == 1:
            face = [1,2] + [i+2 for i in alpha(m, g[1], n)]
        else:
            face = [1] + [i+1 for i in alpha(m, g[1], n)]
        facets.append(face)
    return SimplicialComplex(facets)
    
# Todo. Make function that recreates Kolins construction.
def Kolins_ball(h):
    """
    Returns Kolins ball with h-vector h. 
    """
    d = len(h)-1
    n = d//2
    g = (1,)+tuple(h[i+1] - h[i] for i in range(n))
    G = [h[i] - h[d-i] for i in range(n)]
    sphere = boundary(billera_lee_ball(h))
    print(sphere.h_vector())
    M = monomial_sequence(R, standard_mons, G)
    print(M)
    facets = []
    for M_i in M:
        for m in M_i:
            if (d-1) % 2  == 1:
                face = {1,2} | set(i+2 for i in alpha(m, g[1], n-1))
            else:
                face = {1} | set(i+1 for i in alpha(m, g[1], n-1))
            facets.append(face)
        print(facets)
    ball_facets = []
    for face in sphere.facets():
        if set(face) not in facets:
            ball_facets.append(face)
    B = SimplicialComplex(ball_facets)
    print(B)
    print(B.facets())
    print(B.h_vector())
    return B

# Refactor. Put helper functions on a different file.
# Remove print calls.
# Add tests and examples.
# Add README file.