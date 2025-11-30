from collections import Counter

load("../cyclic_polytopes.sage")
load("../bistellar_flip.sage")

"""
possible_values = set()
for sphere in reachable:
        m = 0
        for missing_face in sphere.minimal_nonfaces():
            if missing_face.dimension() == 4:
                m4+=1
        possible_values.add(m4)
print(possible_values)
"""

def explore_and_flip(K, excluded_types=[]):
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
    n = len(K.vertices())
    queue = deque([K])
    visited = [K]
    h_vectors = set()  # Delete later.
    done = False # Delete later.
    visited_m5 = set()
    #possible_m5 = set(binomial(n-6-i,3) for i in range(n-8))
    #print(f"Possible_m5: {possible_m5}")

    while queue and (not done):

        current = queue.popleft()
        m5 = sum(missing_face.dimension() == 5 for missing_face in current.minimal_nonfaces())
        visited_m5.add(m5) # Delete later.
        h_vectors.add(tuple(current.h_vector())) # Delete later.

        for face in current.face_iterator():
            if face.dimension() in excluded_types:
                continue 
            
            try:
                new_complex = bistellar_flip(current, face)
                
            except RuntimeError:
                # No valid flip at this face for this complex
                continue
            else:
                new_m5 = sum(missing_face.dimension() == 5 for missing_face in new_complex.minimal_nonfaces())
                if new_m5 <= m5:
                    if not any(new_complex.is_isomorphic(V) for V in visited):
                        queue.append(new_complex)
                        visited.append(new_complex)
                        print(f"Visited {len(visited)} PL-spheres so far")
                        if len(visited) == 500:  # Delete later.
                            done = True
                            break
    print(h_vectors)
    print(visited_m5)
    return visited

def explore_flip_graph_DFS(K, excluded_types=[]):

    def dfs(current):

        m4 = sum(missing_face.dimension() == 4 for missing_face in current.minimal_nonfaces())

        output = []

        # Explore all possible flips from `current`
        for face in current.face_iterator():
            if face.dimension() in excluded_types:
                continue
            try:
                new_complex = bistellar_flip(current, face)
            except RuntimeError:
                continue
            new_m4 = sum(missing_face.dimension() == 4 for missing_face in new_complex.minimal_nonfaces())
            if new_m4 < m4:
                print(new_m4)
                for path, faces in dfs(new_complex):
                    output.append(([current] + path, [face] + faces))

        if output == []:
            return [([current], [])]

        # --- BACKTRACKING OCCURS HERE ---
        print("Ending DFS call")
        return output

    output = dfs(K)
    return output

facets = cyclic_polytope_facets(9, 13)
P = SimplicialComplex(facets)
d8_n13_neighborly = explore_and_flip(P, [0,1,2,3,5,6,7,8])
print(f"Number of reachable complexes (without 0/d-moves): {len(d8_n13_neighborly)}")

for sphere in d8_n13_neighborly:
    m_5 = sum(missing_face.dimension() == 5 for missing_face in sphere.minimal_nonfaces())
    if m_5 == 0:
        print(sphere.facets())
        break

'''
S1 = SimplicialComplex(cyclic_polytope_facets(5, 11))
#print(S1.h_vector())
paths = explore_flip_graph_DFS(S1, [0,6])
for path, faces in paths:
    list_m4 = []
    for sphere in path:
        m4 = sum(missing_face.dimension() == 4 for missing_face in sphere.minimal_nonfaces())
        list_m4.append(m4)
    if list_m4 == [10, 7, 5, 2, 1]:
        print(faces)
'''
'''
S1 = SimplicialComplex(cyclic_polytope_facets(7, 12))
print(sum(missing_face.dimension() == 4 for missing_face in S1.minimal_nonfaces()))
S2 = bistellar_flip(S1, [1,3,5,12])
print(sum(missing_face.dimension() == 4 for missing_face in S2.minimal_nonfaces()))
S3 = bistellar_flip(S2, [1,3,6,12])
print(sum(missing_face.dimension() == 4 for missing_face in S3.minimal_nonfaces()))
S4 = bistellar_flip(S3, [1,4,6,12])
print(sum(missing_face.dimension() == 4 for missing_face in S4.minimal_nonfaces()))
S5 = bistellar_flip(S4, [1,3,7,12])
print(sum(missing_face.dimension() == 4 for missing_face in S5.minimal_nonfaces()))
S6 = bistellar_flip(S5, [1,8,10,12])
print(sum(missing_face.dimension() == 4 for missing_face in S5.minimal_nonfaces()))
S7 = bistellar_flip(S6, [1,7,10,12])
print(sum(missing_face.dimension() == 4 for missing_face in S6.minimal_nonfaces()))
S8 = bistellar_flip(S7, [1,7,9,12])
print(sum(missing_face.dimension() == 4 for missing_face in S7.minimal_nonfaces()))
S9 = bistellar_flip(S8, [1,6,10,12])
print(sum(missing_face.dimension() == 4 for missing_face in S7.minimal_nonfaces()))
'''