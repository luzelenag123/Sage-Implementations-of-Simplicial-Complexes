load("conditions_on_h_vectors_of_balls.sage")

potential_h_vectors = []
h_vectors_of_balls = set()
gen = generate_promising_M_vectors(bound_m1=5)
for vector in gen:
    if satisfies_necessary_ball_conditions(vector):
        if lower_bound_on_splitting_faces(vector) <= upper_bound_on_splitting_faces(vector):
            if not satisfies_conjectured_conditions(vector):
                potential_h_vectors.append(vector)
            elif vector[1] == 5:
                h_vectors_of_balls.add(tuple(vector))


#with open("potential_h_vectors.txt", "w") as f:
#        for index, vector in enumerate(potential_h_vectors):
#           f.write(f"vector_{index+1}={vector}\n")

print(h_vectors_of_balls)
print(len(h_vectors_of_balls))