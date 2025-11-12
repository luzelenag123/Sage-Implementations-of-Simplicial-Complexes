attach("bistellar_flip.sage")

if __name__ == "__main__":

    # Facet list of the cyclic polytope with d=5 and n=9.
    facets = [[1, 2, 3, 4, 5], [1, 2, 3, 4, 9], [1, 2, 3, 5, 6],
            [1, 2, 3, 6, 7], [1, 2, 3, 7, 8], [1, 2, 3, 8, 9],
            [1, 2, 4, 5, 9], [1, 2, 5, 6, 9], [1, 2, 6, 7, 9], 
            [1, 2, 7, 8, 9], [1, 3, 4, 5, 6], [1, 3, 4, 6, 7], 
            [1, 3, 4, 7, 8], [1, 3, 4, 8, 9], [1, 4, 5, 6, 7], 
            [1, 4, 5, 7, 8], [1, 4, 5, 8, 9], [1, 5, 6, 7, 8], 
            [1, 5, 6, 8, 9], [1, 6, 7, 8, 9], [2, 3, 4, 5, 9], 
            [2, 3, 5, 6, 9], [2, 3, 6, 7, 9], [2, 3, 7, 8, 9], 
            [3, 4, 5, 6, 9], [3, 4, 6, 7, 9], [3, 4, 7, 8, 9], 
            [4, 5, 6, 7, 9], [4, 5, 7, 8, 9], [5, 6, 7, 8, 9]]
    P = SimplicialComplex(facets)
    d4_n9_all = explore_flip_graph(P, [0,4])
    print(f"Number of reachable complexes (without 0/d-moves): {len(result)}")
    # This should return 337 PL-spheres of dimension 4 with 9 vertices.

    # Write result in txt files.
    with open("d4_n9_all.txt", "w") as f:
        for index, item in enumerate(d4_n9_all):
            f.write(f"sphere_{index+1}={item.facets()}\n")

    finbow_neighborly_polytopal = [SimplicialComplex(facets) for facets in extract_lists_from_file('finbow_neighborly_polytopal.txt')] 
    print(f"Length of Finbow's database = {len(finbow_neighborly_polytopal)}")

    d4_n9_neighborly = []
    d4_n9_neighborly_polytopal = []
    d4_n9_neighborly_nonpolytopal = []
    for index, sphere in enumerate(d4_n9_all):
        if sphere.f_vector() == [1,9,36,74,75,30]:
            d4_n9_neighborly.append((index,sphere))
            polytopal = False
            for polytopal_sphere in finbow_neighborly_polytopal:
                if sphere.is_isomorphic(polytopal_sphere):
                    polytopal = True
                    d4_n9_neighborly_polytopal.append((index,sphere))
                    break
            if not polytopal:
                d4_n9_neighborly_nonpolytopal.append((index,sphere))

    print(f"Neighborly = {len(d4_n9_neighborly)}")
    print(f"Neighborly polytopal = {len(d4_n9_neighborly_polytopal)}")
    print(f"Neighborly non-polytopal = {len(d4_n9_neighborly_nonpolytopal)}")

    with open("d4_n9_neighborly.txt", "w") as f:
        for index, item in d4_n9_neighborly:
            f.write(f"sphere_{index+1}={item.facets()}\n")

    with open("d4_n9_neighborly_polytopal.txt", "w") as f:
        for index, item in d4_n9_neighborly_polytopal:
            f.write(f"sphere_{index+1}={item.facets()}\n")

    with open("d4_n9_neighborly_nonpolytopal.txt", "w") as f:
        for index, item in d4_n9_neighborly_nonpolytopal:
            f.write(f"sphere_{index+1}={item.facets()}\n")