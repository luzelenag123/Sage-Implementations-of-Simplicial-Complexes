def candidates(K):
    """
    Returns the candidates of K.
    Args:
        K: Simplicial Complex
    Return:
        A list of simplices S that satisfy the folowing conditions:
        - dim(S) = n-1
        - K > max(K). S is lexicographically larger than any other facets of K.
        - min(dS) <= R, where R is the minimal unclosed ridge of K.
        - S does not contain any closed faces of K.
    """
    return None

def is_closed(K, F):
    """
    Returns whether or not F is a closed face of K.
    Args:
        K: Simplicial Complex.
        F: A face of K.
    Returns:
        True if and only if any rigde of K.link(F) is in exactly two facets of K.link(F)
    """
    return None

def is_promising(K, new_closed_faces=[]):
    """
    Returns whether or not K is a promising simplicial complex.
    Args:
        K: Simplicial complex.
        new_closed_faces: A list of new closed faces of K. If this is empty, the algorithm will check all closed faces, not just the new ones. 
    Returns:
        True if and only if K is canonical and the link of every new closed k-face has the Z_2-homology of (n-k-2) dimensional sphere.

    """
    return None

def PL_manifolds_homeomorphic_to_sphere(n, m):
    """
    Args:
        n, m: Integers such that n <=5 or m-n <=3.
    Returns:
        The list of canonical (n-1)-dimensional PL-manifolds  homeomorphic to a sphere with at most m vertices (PL-spheres unless  n = 5).
    """
    return None



