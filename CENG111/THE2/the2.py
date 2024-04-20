a= input("insert coordinates: ")
a= a.replace("(","").replace(")","").replace("[","").replace("]","")
splitted = a.split(",")
x0=float(splitted[0])
y0=abs(float(splitted[1]))
y0org=float(splitted[1])
x1=float(splitted[2])
y1=abs(float(splitted[3]))
y1org=float(splitted[3])
x2=float(splitted[4])
y2=abs(float(splitted[5]))
y2org=float(splitted[5])
x3=float(splitted[6])
y3=abs(float(splitted[7]))
y3org=float(splitted[7])
ListX=[x0,x1,x2,x3]
ListY=[y0,y1,y2,y3]
ListYorg=[y0org, y1org, y2org, y3org]

#x0 ve x2 köşelerde x1 ve x3 arada
if min(ListX)==x0 and max(ListX)==x2:
    if x1==x2:
        if min(ListYorg)>=0:
            YamukArea=abs(x1-x0)*(y1+y0)/2
            QuadArea = abs((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
            print("%.2f" % (YamukArea-QuadArea))
        elif max(ListYorg)<=0:
            YamukArea=abs(x1-x0)*(y1+y0)/2
            print("%.2f" % (YamukArea))
    else:
        QuadArea = ((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
        PentagonArea=((x2*y2)+(x2*y1)+(x1*y0)+(x0*0)+(x0*0)-(x2*0)-(x1*y2)-(x0*y1)-(x0*y0)-(x2*0))/2
        GreenArea=PentagonArea-QuadArea
        if y3>=y1:
            print("%.2f" % (PentagonArea))
        elif y3<=y1:
            if x3<=x1:
                print("%.2f" % (GreenArea))
            elif x3>=x1:
                print("%.2f" % (GreenArea))
elif min(ListX)==x1 and max(ListX)==x3:
    if x2==x3:
        if min(ListYorg)>=0:
            QuadArea = ((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
            YamukArea=abs(x2-x1)*(y1+y2)/2
            print("%.2f" % (YamukArea-QuadArea))
        elif max(ListYorg)<=0:
            YamukArea=abs(x2-x1)*(y1+y2)/2
            print("%.2f" % (YamukArea))
    else:
        QuadArea = ((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
        PentagonArea=((x3*y3)+(x3*y2)+(x2*y1)+(x1*0)+(x1*0)-(x3*0)-(x2*y3)-(x1*y2)-(x1*y1)-(x3*0))/2
        GreenArea=PentagonArea-QuadArea
        if y0>y2:
            print("%.2f" % (PentagonArea))
        elif y0<=y2:
            if x0<=x2:
                print("%.2f" % (GreenArea))
            elif x0>=x2:
                print("%.2f" % (PentagonArea))
elif min(ListX)==x2 and max(ListX)==x0:
    QuadArea = ((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
    PentagonArea=((x0*y0)+(x0*y3)+(x3*y2)+(x2*0)+(x2*0)-(x0*0)-(x3*y0)-(x2*y3)-(x2*y2)-(x0*0))/2
    GreenArea=PentagonArea-QuadArea
    if y1>=y3:
        print("%.2f" % (PentagonArea))
    elif y1<=y3:
            if x3>=x1:
                print("%.2f" % (GreenArea))
            elif x3<=x1:
                print("%.2f" % (GreenArea))             
elif min(ListX)==x3 and max(ListX)==x1:
    if x0==x3:
        YamukArea=abs(x1-x0)*(y1+y0)/2
        print("%.2f" % (YamukArea))
    else:
        QuadArea = abs((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
        PentagonArea=((x1*y1)+(x1*y0)+(x0*y3)+(x3*0)+(x3*0)-(x1*0)-(x0*y1)-(x3*y0)-(x3*y3)-(x1*0))/2
        GreenArea=PentagonArea-QuadArea
        if y2>y0:
            print("%.2f" % (PentagonArea))
        elif y2<=y0:
            if x2<=x0:
                print("%.2f" % (GreenArea))
            elif x2>=x0:
                print("%.2f" % (GreenArea))
#x0 ve x1 köşede x2 x3 arada
elif min(ListX)==x0 and max(ListX)==x1:
    if min(ListYorg)>=0 :
        if max(ListY)==y1 or max(ListY)==y0:
            if x1==x3:
                YamukArea=(x3-x0)*(y3+y0)/2
                print("%.2f" % (YamukArea))
            elif x0==x2:
                YamukArea=(x1-x2)*(y1+y2)/2
                print("%.2f" % (YamukArea))
            else:
                QuadArea = ((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
                YamukArea = abs((x1-x0)*(y1+y0)/2)
                GreenArea=YamukArea-QuadArea
                print("%.2f" % (GreenArea))
    elif max(ListYorg)<=0 :
            YamukArea=(x1-x0)*(y1+y0)/2
            print("%.2f" % (YamukArea))
elif min(ListX)==x1 and max(ListX)==x2:
    if min(ListYorg)>=0 :
        if max(ListY)==y1 or max(ListY)==y2:
            if x0==x2:
                YamukArea=(x0-x1)*(y1+y0)/2
                print("%.2f" % (YamukArea))
            elif x0==x1:
                YamukArea=(x2-x0)*(y0+y2)/2
                print(YamukArea)
            else:
                QuadArea = ((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
                YamukArea = abs((x2-x1)*(y1+y2)/2)
                GreenArea=YamukArea-QuadArea
                print("%.2f" % (GreenArea))
    elif max(ListYorg)<=0 :
            YamukArea=abs(x2-x1)*(y1+y2)/2
            print("%.2f" % (YamukArea))
elif min(ListX)==x2 and max(ListX)==x3:
    if min(ListYorg)>=0 :
        if max(ListY)==y2 or max(ListY)==y3:
            if x1==x3:
                YamukArea=(x1-x2)*(y2+y1)/2
                print("%.2f" % (YamukArea))
            elif x1==x2:
                YamukArea=(x3-x1)*(y3+y1)/2
                print("%.2f" % (YamukArea))
            elif x0==x2:
                YamukArea=abs((x3-x0)*(y3+y0)/2)
                print("%.2f" % (YamukArea))
            else:
                QuadArea = ((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
                YamukArea = abs((x3-x2)*(y3+y2)/2)
                GreenArea=YamukArea-QuadArea
                print("%.2f" % (GreenArea))
    elif max(ListYorg)<=0 :
            YamukArea=(x3-x2)*(y3+y2)/2
            print("%.2f" % (YamukArea))
elif min(ListX)==x3 and max(ListX)==x0:
    if min(ListYorg)>=0 :
        if max(ListY)==y3 or max(ListY)==y0:
            if x0==x2:
                YamukArea=(x2-x3)*(y2+y3)/2
                print("%.2f" % (YamukArea))
            elif x1==x3:
                YamukArea=(x0-x1)*(y0+y1)/2
                print("%.2f" %(YamukArea))
            else:
                QuadArea = ((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
                YamukArea = abs((x0-x3)*(y3+y0)/2)
                GreenArea=YamukArea-QuadArea
                print("%.2f" % (GreenArea))
    elif max(ListYorg)<=0 :
            YamukArea=(x0-x3)*(y3+y0)/2
            print("%.2f" %(YamukArea))
elif min(ListX)==x3 and max(ListX)==x2:
    if min(ListY)==y3 or min(ListY)==y2:
        YamukArea=abs((x2-x3)*(y2+y3))/2
        print("%.2f" %(YamukArea))
    elif min(ListYorg)>=0:
        YamukArea=abs((x2-x3)*(y2+y3))/2
        print("%.2f" %(YamukArea))
    elif max(ListYorg)<=0:
         YamukArea=abs(x2-x3)*(y2+y3)/2
         QuadArea = abs((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
         GreenArea=YamukArea-QuadArea
         print("%.2f" %(GreenArea))
#x0 ve x3 köşede x1 ve x2 arada
elif min(ListX)==x0 and max(ListX)==x3:
        if min(ListYorg)>=0:
            YamukArea=abs((x3-x0)*(y3+y0))/2
            print("%.2f" %(YamukArea))
        elif max(ListYorg)<=0:
            YamukArea=abs(x3-x0)*(y3+y0)/2
            QuadArea = abs((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
            GreenArea=YamukArea-QuadArea
            print("%.2f" %(GreenArea))
elif min(ListX)==x1 and max(ListX)==x0:
    if min(ListYorg)>=0:
        YamukArea=abs(x0-x1)*(y0+y1)/2
        print("%.2f" %(YamukArea))
    elif min(ListYorg)<=0:
        YamukArea=abs(x0-x1)*(y0+y1)/2
        QuadArea = abs((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
        GreenArea=YamukArea-QuadArea
        print("%.2f" %(GreenArea))
elif min(ListX)==x2 and max(ListX)==x1:
    if min(ListYorg)>=0:
        YamukArea=abs((x1-x2)*(y1+y2))/2
        print("%.2f" %(YamukArea))
    elif max(ListYorg)<=0:
        YamukArea=abs(x1-x2)*(y1+y2)/2
        QuadArea = abs((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
        GreenArea=YamukArea-QuadArea
        print("%.2f" %(GreenArea))
elif min(ListX)==x3 and max(ListX)==x2:
    if min(ListYorg)>=0:
        YamukArea=abs((x2-x3)*(y2+y3))/2
        print("%.2f" %(YamukArea))
    elif max(ListYorg)<=0:
         YamukArea=abs(x2-x3)*(y2+y3)/2
         QuadArea = abs((x0*y3)+(x3*y2)+(x2*y1)+(x1*y0)-(y0*x3)-(y3*x2)-(y2*x1)-(y1*x0))/2
         GreenArea=YamukArea-QuadArea
         print("%.2f" %(GreenArea))
