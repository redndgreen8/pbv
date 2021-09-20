import sys


for line in sys.stdin:
    line=line.rstrip() + "\n"
    ln=line.split("\t")
    sys.stdout.write( line.rstrip()  + "\t" + str(max(int(ln[5]),int(ln[1])) ) + "\t" + str( min( int(ln[6]),int(ln[2]) ) )  + "\t" + str(int(ln[6]) - int(ln[5]) ) +  "\t" + str(int(ln[2]) - int(ln[1]) ) + "\n"  )
