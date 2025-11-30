load("../bistellar_flip.sage")
load("../f_vectors_and_h_vectors.sage")

# Ball with h-vector [1,5,7,9,6,4,0]. d = 5, n = 11.
facets = {(1, 2, 4, 5, 7, 8), (1, 4, 5, 6, 8, 9), (1, 2, 5, 6, 8, 9), 
          (2, 3, 4, 5, 9, 10), (1, 3, 4, 5, 6, 9), (1, 3, 4, 6, 7, 8), 
          (3, 4, 5, 6, 7, 8), (2, 3, 4, 5, 10, 11), (2, 3, 4, 5, 8, 9), 
          (1, 2, 3, 4, 5, 11), (1, 2, 3, 4, 8, 9), (1, 4, 5, 6, 7, 8), 
          (1, 2, 3, 6, 7, 8), (2, 3, 5, 6, 7, 8), (1, 2, 3, 5, 10, 11), 
          (1, 2, 4, 5, 8, 9), (1, 2, 4, 5, 10, 11), (1, 2, 3, 4, 9, 10), 
          (1, 2, 5, 6, 7, 8), (1, 3, 4, 5, 10, 11), (1, 2, 3, 4, 10, 11), 
          (1, 2, 4, 5, 9, 10), (2, 3, 4, 5, 7, 8), (1, 2, 3, 4, 7, 8), 
          (2, 3, 4, 5, 6, 7), (1, 3, 4, 5, 9, 10), (1, 3, 4, 6, 8, 9), 
          (1, 2, 3, 5, 9, 10), (1, 2, 3, 6, 8, 9), (1, 2, 3, 5, 6, 9), 
          (3, 4, 5, 6, 8, 9), (2, 3, 5, 6, 8, 9)}

P = SimplicialComplex(facets)
print(P.minimal_nonfaces()) # has 5 missing 3-faces. Boundary has at most 1 missing 3-face.
#print(find_and_flip(P, 2))
#visited = explore_flip_graph(P, [0,1,4,5])
#print(f"Number of reachable complexes (without 0/d-moves): {len(visited)}")



print(f_vector_from_h([1,5,7,9,6,4,0])) # All faces.
print(f_vector_from_h([0,4,6,9,7,5,1])) # Interior faces.

print(f_vector_from_h([1,5,7,9,5,3,0])) # All faces.
print(f_vector_from_h([0,3,5,9,7,5,1])) # Interior faces.