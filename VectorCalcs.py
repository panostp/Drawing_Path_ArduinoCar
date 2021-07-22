import numpy as np

np.random.seed(420)

XPoints = [0]
YPoints = [0]
NormArray = []
for i in range(10):
    XPoints.append(np.random.randint(0, 19))
    YPoints.append(np.random.randint(0, 19))
    Norm = np.round(np.sqrt(np.power(XPoints[i] - XPoints[i - 1], 2) + np.power(YPoints[i] - YPoints[i - 1], 2)), 2)
    NormArray.append(Norm)
print(XPoints)
print(YPoints)

AngleArray = []
for i in range(1, 9):

    #Xreiazetai 3 normes kai paei kapws etsi: OAB -> ABC -> BCD -> CDE -> ...
    if NormArray[i] == 0:
        Angle = 0
    else:
        # Al-Kashi's theorem Law of Cosines.

        Triangle_Completion = np.round(np.sqrt( np.power(XPoints[i+1] - XPoints[i-1], 2) + np.power(YPoints[i+1] - YPoints[i-1], 2)))
        Angle = np.arccos(( np.power(NormArray[i], 2) + np.power(NormArray[i-1], 2) - np.power(Triangle_Completion, 2)) / (2*NormArray[i]*NormArray[i-1]))

    AngleArray.append( np.round((Angle*180)/(np.pi),2)*-1 +180)
print(NormArray)
print(AngleArray)