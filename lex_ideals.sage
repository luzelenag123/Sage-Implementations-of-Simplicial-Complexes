from itertools import combinations_with_replacement
from sage.all import QQ, PolynomialRing
from sage.interfaces.macaulay2 import macaulay2


def monomials_of_degree(R, deg):
    """Return all monomials of given degree in R in lex order (largest first)."""
    if deg == 0:
        return [R(1)]
    vars_list = R.gens()
    nvars = len(vars_list)
    exps = []
    for comb in combinations_with_replacement(range(nvars), deg):
        exp = [0] * nvars
        for i in comb:
            exp[i] += 1
        exps.append(R.monomial(*exp))
    # sort in lex order, highest first
    return sorted(exps, reverse=True)

def lex_generators_from_h(h):
    """
    Given an h-vector, compute the minimal generators of the lexicographic ideal L
    such that R/L has Hilbert function h.
    """
    d = len(h) - 1
    nvars = h[1] + d  # from h_1 = nvars - d
    
    varnames = [f"x{i+1}" for i in range(nvars)]
    R = PolynomialRing(QQ, varnames, order='lex')
    
    L = R.ideal(0)
    for deg in range(len(h)):
        mons = monomials_of_degree(R, deg)
        #print(mons)
        allowed = h[deg]
        L += R.ideal(mons[:-allowed])
        # We don't really care about higher degrees.
        if deg == 3:
            break
    
    gens_by_degree = {}
    for g in L.groebner_basis():
        deg = g.total_degree()
        gens_by_degree.setdefault(deg, []).append(g)
    
    return R, L, gens_by_degree

def get_betti_table(h):
    R, I, _ = lex_generators_from_h(h)
    m2 = macaulay2
    
    m2_R = m2(R)
    m2_I = m2(I)

    # Get raw Betti table text
    bt = m2(f'betti res {m2_I.name()}')
    lines = str(bt).splitlines()

    # Skip first two lines: column header + "total:" row
    data_lines = lines[2:]

    rows = []
    for line in data_lines:
        line = line.strip()
        if not line:
            continue

        # expected format: "k: a b c ..."
        if ":" not in line:
            continue

        label, entries = line.split(":", 1)
        entries = entries.split()

        row = []
        for p in entries:
            if p == '.':
                row.append(0)
            else:
                row.append(int(p))
        rows.append(row)

    return rows

def beta(betti_table, i,j):
    row = j-i 
    column = i 
    try:
        value = betti_table[row][column]
    except (IndexError):
        value = 0
    return value
    

# Example
#print(get_betti_table([1, 5, 7, 10, 5, 3, 0]))