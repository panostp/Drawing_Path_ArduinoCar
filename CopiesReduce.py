import numpy as np
A = [0, 0, 1, 10, 4, 4, 5, 6, 6, 6, 6, 6, 9, 9, 1, 1, 5, 3, 2, 2, 1, 1, 1, 3, 5, 5, 4, 3]   # X values
C = [0, 0, 1, 10, 4, 4, 5, 6, 6, 7, 7, 7, 9, 9, 1, 0, 3, 3, 4, 5, 6, 1, 1, 3, 2, 1, 1, 0]   # Y values
B = []  # New X values
D = []  # New Y Values
NormArray = []  # Norms
NewNorm = []    # New Norms must be A.__len__()-1
i = 0

# Used with round(x, 2).
plt.scatter(A, C)
plt.plot(A, C, '-.')
plt.show()

for i in range(1, A.__len__()):   # Find the distance between samples
    Norm = np.round(np.sqrt(np.power(A[i] - A[i - 1], 2) + np.power(C[i] - C[i - 1], 2)), 2)
    NormArray.append(Norm)

B.append(A[0])
D.append(C[0])

for i in range(1, A.__len__()-1):
    if (NormArray[i] <= 1) | (A[i] == A[i-1] & C[i] == C[i-1]):     # Isn't 100% true, angles have to be taken into consideration. Not so difficult..
        continue                                                    # Angles matter more than Norms, here.
    # Really small angles are the ones that should be filtered out.
    # Also, Norms that are like <0.1 and have angles close to 0 should be filtered out too.
    B.append(A[i])
    D.append(C[i])
    NewNorm.append(NormArray[i])

plt.scatter(B, D)
plt.plot(B, D, 'r-.')
plt.show()

print(NewNorm)
print(B)
print(D)
