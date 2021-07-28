A = [0, 0, 1, 10, 4, 4, 5, 6, 6, 6, 6, 6, 9, 9, 1, 1, 5, 3, 2, 2, 1, 1, 1, 3, 5, 5, 4, 3]
B = []
i = 0
B.append(A[i])

# Used with round(x, 2).

while i < A.__len__()-1:
    i += 1
    if A[i] == A[i-1]:
        continue
    B.append(A[i])
print(B)
