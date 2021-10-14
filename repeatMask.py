import sys



for line in sys.stdin:
    out=[]
    line=line.rstrip()
    ln=line.split("\t")
    
    out.append(ln[0])
    out.append(ln[1])
    out.append(ln[2])

    #rlen    ref_span    mapped_span  
    rlen = ln[3].split(":")[-1]
    ref_span = int(ln[2]) - int(ln[1])
    out.append( str(rlen))
    out.append( str(ref_span) )
    spann =   int(ln[6])  - int(ln[5])
    out.append( str(spann) )

    if ln[15] != "-1": 
        #print(ln[11:13])
        max_s = int(ln[15]) #max(int(ln[11]),int(ln[1]))
        min_e = int(ln[16]) #min( int(ln[12]),int(ln[2]) )
    else:
        max_s = 0 
        min_e = 0

    inter = min_e - max_s

    out.append( str(inter))

    sys.stdout.write( "\t".join(out) +"\n" )

## chr  start   end     rlen    ref_span    mapped_span            