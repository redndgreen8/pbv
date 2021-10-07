import sys


for line in sys.stdin:
    out=[]
    line=line.rstrip()
    ln=line.split("\t")
    out.append(ln[0])
    out.append(ln[1])
    out.append(ln[2])

    rlen = ln[3].split(":")[-1]
    ref_span = int(ln[2]) - int(ln[1])
    out.append( str(rlen))
    out.append( str(ref_span) )
    spann =   int(ln[6])  - int(ln[5])
    out.append( str(spann) )

    if len(ln)==15: 
        max_s = max(int(ln[11]),int(ln[1]))
        min_e = min( int(ln[12]),int(ln[2]) )
    else:
        max_s = 0 
        min_e = 0

    inter = min_e - max_s

    out.append( str(inter))



    sys.stdout.write( "\t".join(out) +"\n" )







