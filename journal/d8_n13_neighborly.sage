load("../bistellar_flip.sage")
load("../cyclic_polytopes.sage")

if __name__ == "__main__":

    # Facet list of the cyclic polytope with d=6 and n=10.
    facets = cyclic_polytope_facets(9, 13)
    P = SimplicialComplex(facets)
    d8_n13_neighborly = explore_flip_graph(P, [0,1,2,3,5,6,7,8])
    print(f"Number of reachable complexes (without 0/d-moves): {len(d8_n13_neighborly)}")

    for sphere in d8_n13_neighborly:
        m_5 = sum(missing_face.dimension() == 5 for missing_face in sphere.minimal_nonfaces())
        if m_5 == 0:
            print(sphere.facets())
            break