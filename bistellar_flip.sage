from collections import deque
import ast

def bistellar_flip(K, F):
    """
    Let K be an (n-1)-dimensional simplicial complex on m vertices, and F a face of K. 
    Performs a bistellar flip on K at F, if possible.

    Args:
        K: Simplicial Complex.
        F: A face of K (list, tuple, or set of vertices).

    Returns:
        The simplicial complex resulting from applying this bistellar flip. 
        Raises RuntimeError if the flip is not possible.
    
    Note:
        A bistellar flip replaces a configuration of facets (F * ∂G) with (∂F * G),
        where link(K, F) = ∂G and G is a simplex not in K.
    """
    F_set = set(F)
    K_dim = K.dimension()
    F_dim = len(F_set) - 1
    G_dim = K_dim - F_dim
    
    # Verify F is a face of K
    if not any(F_set.issubset(set(facet)) for facet in K.facets()):
        raise RuntimeError(f"Face {F} is not a face of the complex K.")
        
    # Compute link(K, F) and check if it's the boundary of a simplex
    link_F = K.link(F)
    
    # link(K, F) should be the boundary of a (G_dim)-dimensional simplex    
    if link_F.dimension() != G_dim - 1:
        raise RuntimeError(f"link(K, F) has dimension {link_F.dimension()}, expected {G_dim - 1}.")

    if len(link_F.vertices()) != G_dim + 1:
        raise RuntimeError(f"link(K, F) has {len(link_F.vertices())}, expected {G_dim + 1} vertices.")
    
    # Extract G: the vertices in link(K, F) form the simplex G
    G_set = set(link_F.vertices())
    
    # Verify G is not a face of K
    if any(G_set.issubset(set(facet)) for facet in K.facets()):
        raise RuntimeError(f"Simplex G = {G_set} is already a face of K. Flip not allowed.")
    
    # Perform the flip: (K \ (F * ∂G)) ∪ (∂F * G)
    
    # Build F * ∂G (star of F with boundary of G)
    boundary_G_faces = [G_set - {v} for v in G_set]  
    F_star_dG = set(frozenset(F_set | bg) for bg in boundary_G_faces)

    # Build ∂F * G (boundary of F with simplex G)
    boundary_F_faces = [F_set - {v} for v in F_set]
    dF_star_G = [bf | G_set for bf in boundary_F_faces]
    
    # Keep all facets not in F * ∂G
    new_facets = []
    for facet in K.facets():
        if frozenset(facet) not in F_star_dG:
            new_facets.append(tuple(facet))
    
    # Add all faces in ∂F * G
    for face in dF_star_G:
        new_facets.append(tuple(face))
    
    return SimplicialComplex(new_facets)


def find_and_flip(K, a):
    """
    Finds a face F with dim(F) = a, such that a bistellar flip on K at F can be done. 
    If none are found, raises exception.
    
    Args:
        K: Simplicial complex. 
        a: Integer representing the desired dimension of F.
    
    Returns:
        A tuple (F, new_complex), where F is the found face, and new_complex 
        is the resulting complex after the flip.
    
    Raises:
        RuntimeError if no valid flip can be found.
    """
    # Iterate through all faces of dimension a
    for face in K.face_iterator():
        if len(face) - 1 == a:  # dimension is size - 1
            try:
                new_complex = bistellar_flip(K, set(face))
                return (set(face), new_complex)
            except RuntimeError:
                # This face doesn't admit a valid flip, try next one
                continue
    
    raise RuntimeError(f"No valid bistellar flip found for dimension {a} in complex K.")

def explore_flip_graph(K, excluded_types=[]):
    """
    Explore all simplicial complexes reachable from K via bistellar flips of types 
    other than the excluded types (by dimension).
    
    Args:
        K: Simplicial Complex
        excluded_types: List of integers representing the face dimensions to exclude from flipping.
    
    Returns:
        A list of simplicial complexes (up to combinatorial equivalence) that are reachable.
    
    Note:
        Uses BFS to explore the flip graph. Two complexes are considered equivalent
        if they have the same f-vector or h-vector.
    """

    queue = deque([K])
    visited = [K]

    while queue:

        current = queue.popleft()

        for face in current.face_iterator():
            if face.dimension() in excluded_types:
                continue 
            
            try:
                new_complex = bistellar_flip(current, face)
            except RuntimeError:
                # No valid flip at this face for this complex
                continue
            else:
                if not any(new_complex.is_isomorphic(V) for V in visited):
                    queue.append(new_complex)
                    visited.append(new_complex)
                    print(f"Visited {len(visited)} PL-spheres so far")
            
    return visited

def extract_lists_from_file(filepath):
    """
    Reads a text file where each line contains a variable assignment 
    like "P_1 = [[1,2,3,4],...]" and extracts the list part.

    Args:
        filepath (str): The path to the input text file.

    Returns:
        list: A list containing the extracted lists from each line.
    """
    extracted_data = []
    with open(filepath, 'r') as file:
        for line in file:
            # Remove leading/trailing whitespace and split by '='
            parts = line.strip().split('=', 1) 
            if len(parts) == 2:
                # The second part contains the string representation of the list
                list_str = parts[1].strip()
                try:
                    # Safely evaluate the string to a Python list object
                    extracted_list = ast.literal_eval(list_str)
                    if isinstance(extracted_list, (list, set, tuple)):
                        extracted_data.append(extracted_list)
                except (ValueError, SyntaxError) as e:
                    print(f"Error parsing line: '{line.strip()}' - {e}")
    return extracted_data

# Examples
if __name__ == "__main__":
    '''
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
    result = explore_flip_graph(P, [0,4])
    print(f"Number of reachable complexes (without 0/d-moves): {len(result)}")
    # This should return 337 PL-spheres of dimension 4 with 9 vertices.

    # Write result in txt files.
    with open("d4_n9_all.txt", "w") as f:
        for index, item in enumerate(result):
            f.write(f"sphere_{index+1}={item.facets()}\n")
    '''

    d4_n9_all = [SimplicialComplex(facets) for facets in extract_lists_from_file('d4_n9_all.txt')]
    print(f"all = {len(d4_n9_all)}")

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

    '''
    # Extract list of 126 neighbourly simplicial 5-polytopes with 9 vertices.
    file_path = 'd4_n9_neighborly_polytopal.txt'
    neighborly_polytopal_facet_lists = extract_lists_from_file(file_path)
    print(f"There are {len(neighborly_polytopal_facet_lists)} polytopal neighbourly simplicial 5-polytopes with 9 vertices. Expected 126.")

    # Extract neighbourly PL-spheres.
    neighborly = []
    with open("d4_n9_neighborly.txt", "w") as f:
        for index, item in enumerate(result):
            if item.f_vector() == [1,9,36,74,75,30]:
                neighborly.append(item)
                f.write(f"sphere_{index+1}={item.facets()}\n") 

    print(f"There are {len(neighborly)} neighborly 4 dimensional PL-spheres with 9 vertices. Expected 139.")

    # Remove neighbourly polytopal spheres.
    neighborly_non_polytopal = neighborly.copy()

    for facet_list in neighborly_polytopal_facet_lists:
        P = SimplicialComplex(facet_list)
        for sphere in neighborly:
            if P.is_isomorphic(sphere):
                neighborly_non_polytopal.remove(sphere)
            break
    print(f"There are {len(neighborly_non_polytopal)} neighbourly non-polytopal 4 dimensional PL-spheres with 9 vertices. Expected 13.")
    '''
    
