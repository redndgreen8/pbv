import sys



sys.stdout.write("""##fileformat=VCFv4.2
##FILTER=<ID=PASS,Description="All filters passed">
##source=htsbox-pileup-r345
##reference=/project/mchaisso_100/projects/HPRC/pbv_run/hg38.no_alts.fasta
##contig=<ID=chr1,length=248956422>
##contig=<ID=chr10,length=133797422>
##contig=<ID=chr11,length=135086622>
##contig=<ID=chr12,length=133275309>
##contig=<ID=chr13,length=114364328>
##contig=<ID=chr14,length=107043718>
##contig=<ID=chr15,length=101991189>
##contig=<ID=chr16,length=90338345>
##contig=<ID=chr17,length=83257441>
##contig=<ID=chr18,length=80373285>
##contig=<ID=chr19,length=58617616>
##contig=<ID=chr2,length=242193529>
##contig=<ID=chr20,length=64444167>
##contig=<ID=chr21,length=46709983>
##contig=<ID=chr22,length=50818468>
##contig=<ID=chr3,length=198295559>
##contig=<ID=chr4,length=190214555>
##contig=<ID=chr5,length=181538259>
##contig=<ID=chr6,length=170805979>
##contig=<ID=chr7,length=159345973>
##contig=<ID=chr8,length=145138636>
##contig=<ID=chr9,length=138394717>
##contig=<ID=chrM,length=16569>
##contig=<ID=chrX,length=156040895>
##contig=<ID=chrY,length=57227415>
##ALT=<ID=*,Description="Represents allele(s) other than observed.">

##INFO=<ID=INDEL,Number=0,Type=Flag,Description="Indicates that the variant is an INDEL.">
##INFO=<ID=IDV,Number=1,Type=Integer,Description="Maximum number of reads supporting an indel">
##INFO=<ID=IMF,Number=1,Type=Float,Description="Maximum fraction of reads supporting an indel">
##INFO=<ID=DP,Number=1,Type=Integer,Description="Raw read depth">
##INFO=<ID=VDB,Number=1,Type=Float,Description="Variant Distance Bias for filtering splice-site artefacts in RNA-seq data (bigger is better)",Version="3">
##INFO=<ID=RPB,Number=1,Type=Float,Description="Mann-Whitney U test of Read Position Bias (bigger is better)">
##INFO=<ID=MQB,Number=1,Type=Float,Description="Mann-Whitney U test of Mapping Quality Bias (bigger is better)">
##INFO=<ID=BQB,Number=1,Type=Float,Description="Mann-Whitney U test of Base Quality Bias (bigger is better)">
##INFO=<ID=MQSB,Number=1,Type=Float,Description="Mann-Whitney U test of Mapping Quality vs Strand Bias (bigger is better)">
##INFO=<ID=SGB,Number=1,Type=Float,Description="Segregation based metric.">
##INFO=<ID=MQ0F,Number=1,Type=Float,Description="Fraction of MQ0 reads (smaller is better)">
##INFO=<ID=I16,Number=16,Type=Float,Description="Auxiliary tag used for calling, see description of bcf_callret1_t in bam2bcf.h">
##INFO=<ID=QS,Number=R,Type=Float,Description="Auxiliary tag used for calling">

##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=AD,Number=R,Type=Integer,Description="Allelic depths for the ref and alt alleles in the order listed">

##FORMAT=<ID=PL,Number=G,Type=Integer,Description="List of Phred-scaled genotype likelihoods">

#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT\n""")



for line in sys.stdin:
    out=[]
    line=line.rstrip()
    ln=line.split("\t")
    
    ## chr  start   end
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

    if len(ln)>10: 
        #print(ln[11:13])
        max_s = int(ln[11]) #max(int(ln[11]),int(ln[1]))
        min_e = int(ln[12]) #min( int(ln[12]),int(ln[2]) )
    else:
        max_s = 0 
        min_e = 0

    inter = min_e - max_s

    out.append( str(inter))



    sys.stdout.write( "\t".join(out) +"\n" )







## chr  start   end     rlen    ref_span    mapped_span            