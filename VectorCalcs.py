import numpy as np

np.random.seed(420)

XPoints = [0]
YPoints = [0]

NormArray = []
AngleArray = []

#Random points, perlin noise would more realistic but I 'm focusing on the algorithm that finds the angles.
for i in range(10):
    XPoints.append(np.random.randint(0, 19))
    YPoints.append(np.random.randint(0, 19))
print(XPoints)
print(YPoints)

#1st angle starts from 0(0,0) to a random point
if XPoints[1]!=0 :
    Angle = np.round( np.arctan(YPoints[1]/XPoints[1]),2)
    if YPoints[1]>0:
        AngleArray.append(np.round((Angle*180)/np.pi +np.pi, 2))
    else:
        AngleArray.append(np.round((Angle * 180) / np.pi - np.pi, 2))
else:
    if YPoints[1]>0:
        AngleArray.append(90)
    elif YPoints[1]<0:
        AngleArray.append(-90)
    else:
        print("Error!")


for i in range(1, 10):
    Norm = np.round(np.sqrt(np.power(XPoints[i] - XPoints[i - 1], 2) + np.power(YPoints[i] - YPoints[i - 1], 2)), 2)
    NormArray.append(Norm)

for i in range(1, 9):

    #Needs 3 norms to form a triangle: OAB -> ABC -> BCD -> CDE -> ...
    ## To avoid Big Numbers as args in arccosine
    if Growth_Ratio >= 1000:
        Angle = 90
        continue
    elif Growth_Ratio <= -1000:
        Angle = -90
        continue
    else:
        # Al-Kashi's theorem Law of Cosines.

        Triangle_Completion = np.round(np.sqrt( np.power((XPoints[i+1] - XPoints[i-1]), 2) + np.power(YPoints[i+1] - YPoints[i-1], 2)), 2)        
        Arcosine_Arg = round((np.power(NormArray[i], 2) + np.power(NormArray[i-1], 2) - np.power(Triangle_Completion, 2)) /(2*NormArray[i]*NormArray[i-1]),2)
        Angle = np.arccos(Arcosine_Arg)

    AngleArray.append( np.round((Angle*180)/(np.pi),2)*-1 +180)
print(NormArray)
print(AngleArray)
