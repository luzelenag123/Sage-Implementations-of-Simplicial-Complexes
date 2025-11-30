load("lex_ideals.sage")
load("m-vectors.sage")
load("bounds_on_splitting_faces.sage")

def generate_promising_M_vectors(bound_m1 = 6): 
    # h1 can be anything up to the desired bound
    for h1 in range(bound_m1+1): 
        # h2 is not tight on the macaulay bound.
        for h2 in range(macaulay_next(h1-1, 1)):
            # h3 has to satisfy the macaulay bounds.
            for h3 in range(macaulay_next(h2, 2)+1):
                # h3, h4, h5 are weakly decreasing.
                for h4 in range(h3+1):
                    for h5 in range(h4+1):
                        yield [1, h1, h2, h3, h4, h5, 0]

# Computes the g-vector of the boundary of the nth cone.
def g_vector_of_dKn(h_vector, n):
    g_vector = []
    for i in range(0, (len(h_vector)+n)//2):
        g_vector.append(h_vector[i] - h_vector[min(len(h_vector)+n-1-i, len(h_vector)-1)])
    return g_vector

def satisfies_necessary_ball_conditions(h_vector):
    for n in range(len(h_vector) + 1):
        g_vector = g_vector_of_dKn(h_vector, n)
        if not is_m_sequence(g_vector):
            return False
    return True

def satisfies_sufficient_ball_conditions(h): # case where d-1 is odd.
    d = len(h)-1
        
    for i in range(d/2, d-1):
        if h[i] < h[i+1]:
            return False

    v1 = [1]
    for i in range(d/2 - 1):
        v1.append(h[i+1]-h[i])
    v1.append(max(h[d/2] - h[d/2-1], 0))

    v2 = [1]
    for i in range(1, d/2):
        v2.append(h[i] - h[d-i])

    if is_m_sequence(v1) and is_m_sequence(v2):
        return True
    else:
        return False

def satisfies_conjectured_conditions(h):
    max_m = h[1]
    for m in range(max_m):
        if satisfies_sufficient_ball_conditions(h):
            return True
        h = [h[0], h[1]-1] + h[2:]
    return False
