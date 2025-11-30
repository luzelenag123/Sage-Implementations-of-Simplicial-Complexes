from functools import lru_cache
from sage.all import binomial

@lru_cache(maxsize=None)
def macaulay_decomposition(a, d):
    """
    Return the Macaulay decomposition of a in degree d:
    a = C(k_d, d) + C(k_{d-1}, d-1) + ...
    Output: list of (n, d_i) pairs.
    """
    k = []
    while a > 0 and d > 0:
        n = d
        while binomial(n, d) <= a:
            n += 1
        n -= 1
        k.append((n, d))
        a -= binomial(n, d)
        d -= 1
    return k

@lru_cache(maxsize=None)
def macaulay_next(a, d):
    """
    Compute the Macaulay bound of a in degree d:
    sum of binomial(k_i + 1, d_i + 1) for the decomposition.
    """
    k = macaulay_decomposition(a, d)
    bound = 0
    for n, d in k:
        bound += binomial(n + 1, d + 1)
    return bound

@lru_cache(maxsize=None)
def macaulay_prev(a, d):
    """
    Compute the Macaulay bound of a in degree d:
    sum of binomial(k_i + 1, d_i + 1) for the decomposition.
    """
    k = macaulay_decomposition(a, d)
    bound = 0
    for n, d in k:
        bound += binomial(n - 1, d - 1)
    return bound

def is_m_sequence(seq):
    for i in range(1, len(seq)):
        if seq[i] < 0:
            return False
    for i in range(1, len(seq)-1):
        if seq[i+1] > macaulay_next(seq[i], i):
            #print(f"a = {seq[i]}, d = {i}")
            #print(f"{seq[i+1]} > {macaulay_bound(seq[i], i)}")
            return False
    return True

def generate_M_vectors(length, bound=5, i=1):
    """
    Generates all the M-vectors of length 'length' where m_1 is less than or equal to 'bound'.
    """
    if i==1:
        start = [1]
    else:
        start = []

    if i == length:
        yield start
        return
        
    for a in range(bound+1):
        next_bound = macaulay_next(a, i)
        tails = generate_M_vectors(length=length, bound=next_bound, i=i+1)
        for tail in tails:
            yield start + [a] + tail

# TODO Add support for lexicographic ideals.
# TODO Add an examples/tests file.