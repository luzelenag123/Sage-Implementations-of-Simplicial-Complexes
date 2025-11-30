load("../bistellar_flip.sage")
load("../cyclic_polytopes.sage")

if __name__ == "__main__":

    # Facet list of the cyclic polytope with d=6 and n=10.
    facets = cyclic_polytope_facets(6, 10)
    P = SimplicialComplex(facets)
    d5_n10_all = explore_flip_graph(P, [0,5])
    print(f"Number of reachable complexes (without 0/d-moves): {len(d5_n10_all)}")