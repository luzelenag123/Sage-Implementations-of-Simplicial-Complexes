def h_vector_from_f(f_vector):
    """
    Given the f-vector [f_0, f_1, ..., f_{d-1}] of a simplicial d-polytope,
    return the h-vector [h_0, ..., h_d].

    Example:
        f_vector = [7, 21, 35, 35, 21]   # f-vector of cyclic polytope C(5,7)
        h_vector_from_f(f_vector)
        # Output: [1, 2, 3, 3, 2, 1]
    """
    R.<t> = PolynomialRing(QQ)
    d = len(f_vector) - 1  # dimension of polytope

    poly = sum(f_vector[i] * (t - 1) ** (d - i) for i in range(d+1))
    h_coeffs = [poly.coefficient(d - i) for i in range(d+1)]

    return h_coeffs

def f_vector_from_h(h_vector):
    """
    Given the h-vector [h_0, ..., h_d] of a simplicial d-polytope,
    return the f-vector [f_{-1}, f_0, f_1, ..., f_{d-1}].

    Example:
        h_vector = [1, 2, 3, 3, 2, 1]   # h-vector of cyclic polytope C(5,7)
        f_vector_from_h(h_vector)
        # Output: [7, 21, 35, 35, 21]
    """
    R.<t> = PolynomialRing(QQ)
    d = len(h_vector) - 1

    # Build H(t) = sum_{i=0}^d h_i t^{d-i}
    poly = sum(h_vector[i] * (t+1)**(d - i) for i in range(d + 1))

    # Solve for the f_i using the identity:
    #   H(t) = sum_i f_i (t - 1)^(d - i)
    f_vector = []
    for i in range(d + 1):
        # Coefficient of (t - 1)^(d - i) in H(t)
        f_i = poly.coefficient(d - i)
        f_vector.append(f_i)

    return f_vector