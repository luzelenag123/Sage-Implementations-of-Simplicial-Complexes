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

    d4_n9_all = [SimplicialComplex(facets) for facets in extract_lists_from_file('d4_n9_all.txt')]
    print(f"all 4-dimensional PL-spheres with 9 vertices = {len(d4_n9_all)}")

    d4_n9_neighborly = [SimplicialComplex(facets) for facets in extract_lists_from_file('d4_n9_neighborly.txt')]
    print(f"neighborly 4-dimensional PL-spheres with 9 vertices = {len(d4_n9_neighborly)}")

    d4_n9_neighborly_polytopal = [SimplicialComplex(facets) for facets in extract_lists_from_file('d4_n9_neighborly_polytopal.txt')]
    print(f"neighborly polytopal 4-dimensional PL-spheres with 9 vertices = {len(d4_n9_neighborly_polytopal)}")

    d4_n9_neighborly_nonpolytopal = [SimplicialComplex(facets) for facets in extract_lists_from_file('d4_n9_neighborly_nonpolytopal.txt')]
    print(f"neighborly non-polytopal 4-dimensional PL-sphere with 9 vertices = {len(d4_n9_neighborly_nonpolytopal)}")


    
    
