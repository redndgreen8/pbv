import sys
import argparse
ap=argparse.ArgumentParser()
ap.add_argument("--minl", help="min insertion len.", default=5000,type=int)

args=ap.parse_args()

reads=[]


for line in sys.stdin:
    line=line.rstrip()
    line=line.split()
    contig=line[0]+"_"
    #print(contig)
    seqs=line[1].split(",")
    ct=len(seqs)
    #print(str(ct))
    for r in range(ct):
        rlen=len(seqs[r])
        if rlen > args.minl:
            reads.append(">" + contig + str(r)+ "_" + str(ct) + ":" + str(rlen) + "\n" + seqs[r])
sys.stdout.write("\n".join(reads))