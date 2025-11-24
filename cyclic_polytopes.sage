from itertools import combinations

def is_gale_even_facet(F, n):
    """
    Check if a subset F of size d satisfies the Gale Evenness Condition.
    F is assumed sorted.
    """
    not_in_F = sorted(set(range(1, n+1)) - set(F))
    for i in range(len(not_in_F)):
        for j in range(i+1, len(not_in_F)):
            a, b = not_in_F[i], not_in_F[j]
            if a > b:
                a, b = b, a
            # Count how many elements of F are strictly between a and b
            num_between = sum(1 for x in F if a < x < b)
            if num_between % 2 == 1:
                return False
    return True

def cyclic_polytope_facets(d, n):
    """
    Return the list of facets of C(d,n) using the Gale Evenness Condition.
    Each facet is represented as a sorted list of d indices from 1 to n.
    """
    facets = []
    for F in combinations(range(1, n+1), d):
        Flist = list(F)
        if is_gale_even_facet(Flist, n):
            facets.append(Flist)
    return facets

#print(cyclic_polytope_facets(6,10))