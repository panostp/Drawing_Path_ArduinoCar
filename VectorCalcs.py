import numpy as np

XPoints = [0]
YPoints = [0]
NormArray = []
np.random.seed(420)
for i in range(19):  # Get "Samples"
    XPoints.append(np.random.randint(0, 19))
    YPoints.append(np.random.randint(0, 19))

print(XPoints)
print(YPoints)

for i in range(1, 20):   # Find the distance between samples
    Norm = np.round(np.sqrt(np.power(XPoints[i] - XPoints[i - 1], 2) + np.power(YPoints[i] - YPoints[i - 1], 2)), 2)
    NormArray.append(Norm)

AngleArray = []
if XPoints[1] != 0:  # 1st Angle
    Angle = np.round(np.arctan(YPoints[1]/XPoints[1]), 2)
    if YPoints[1] > 0:
        AngleArray.append(np.round((Angle*180)/np.pi + np.pi, 2))
    else:
        AngleArray.append(np.round((Angle * 180) / np.pi - np.pi, 2))
else:
    if YPoints[1] > 0:
        AngleArray.append(90)
    elif YPoints[1] < 0:
        AngleArray.append(-90)
    else:
        print("Error!")

for i in range(1, 19):

    if NormArray[i] == 0:
        AngleArray.append(0)
        continue
    # Define Vector (i,i-1) & (i+1,i)

    V1 = [XPoints[i] - XPoints[i-1], YPoints[i] - YPoints[i-1]]
    V2 = [XPoints[i+1] - XPoints[i], YPoints[i+1] - YPoints[i]]
    Angle_V1 = 0
    Angle_V2 = 0

    # Find the arctans of those 2.
    # Check for values that would cause problems.
    if V1[0] == 0:
        if V1[1] > 0:
            Angle_V1 = 1.57
        else:
            Angle_V1 = 4.71
    else:
        Angle_V1 = np.arctan(V1[1] / V1[0])
        if V1[0] < 0:                       # X<0
            if V1[1] < 0:                   # Y<0
                Angle_V1 -= np.pi
            else:                           # Y>0
                Angle_V1 += np.pi

    if V2[0] == 0:
        if V2[1] > 0:
            Angle_V2 = 1.57
        else:
            Angle_V2 = 4.71
    else:
        Angle_V2 = np.arctan(V2[1] / V2[0])
        if V2[0] < 0:
            if V2[0] < 0:
                Angle_V2 -= np.pi
            else:
                Angle_V2 += np.pi

    # Calc the Angle.

    Angle = Angle_V2 - Angle_V1
    if Angle < -3.14:
        Angle += 6.28
    AngleArray.append(np.round((Angle*180)/np.pi, 2))

print(NormArray)
print(AngleArray)
