
SD = os.path.dirname(workflow.snakefile)



rule all:
    input:
        bam="asmTOref.bam",
        vcf1="asmTOref.vcf",
        fasta="reads.INS.fa",
        bam2="insTOref.bam",
        bed="insTOref.bed",
        rep="insTOref.rep.bed",

rule align:
    input:
        asm=config['asm'],
        ref=config['ref'],
    output:
        bam="asmTOref.bam",
        #bai="asmTOref.bam.bai",
    params:
        thr=config['t'],
        map_p=config['mp'],
        temp=config['temp'],
    shell:"""
 
 lra align -CONTIG -p s {input.ref} {input.asm} -t {params.thr} | \
    samtools sort -T {params.temp}/asm.$$ -m2G -o {output}

"""



rule index:
    input:
        bam="asmTOref.bam",
    output:
        bai="asmTOref.bam.bai",
    shell:"""
        samtools index {input}

"""




rule pileUP:
    input:
        bam="asmTOref.bam",
        bai="asmTOref.bam.bai",
    output:
        vcf1="asmTOref.vcf",
    params:
        asm=config['asm'],
        ref=config['ref'],
    shell:"""
htsbox pileup -f {params.ref}  -q 10 -S 10000 -T 20 {input.bam} -c > {output.vcf1}

"""

rule extractLargeSVasm:
    input:
        vcf1="asmTOref.vcf",
    output:
        fasta="reads.INS.fa",
        vcf="asmTOref.INS.vcf",
        vcf2="asmTOref.DEL.vcf",
    params:
        minl=config['minL'],
        sd=SD,
    shell:"""
awk '{{if ($1~/^#/) {{print$0;}} else if (length($5) > length($4)+ {params.minl}  ) {{print $1"_"$2"\t"$5;}} }}'  {input} | grep -v "#" | python {params.sd}/extractFa.py > {output.fasta}

awk '{{if ($1~/^#/) {{print$0;}} else if (length($5) > length($4)+ {params.minl}  ) {{print ;}} }}'  {input} > {output.vcf}

awk '{{if ($1~/^#/) {{print$0;}} else if ( length($4) > length($5) + {params.minl} ) {{print ;}} }}'  {input} > {output.vcf2}

"""



rule maptoRef:
    input:
        fasta="reads.INS.fa",
    output:
        bam2="insTOref.bam",
        bam2I="insTOref.bam.bai",
    params:
        ref=config['ref'],
        thr=config['t'],
        temp=config['temp'],
    shell:"""

minimap2 -a {params.ref} {input.fasta} -t {params.thr} | \
   samtools sort -T {params.temp}/asm.$$ -m2G -o {output.bam2}
samtools index {output.bam2}

"""



rule samtoBed:
    input:
        bam2="insTOref.bam",
    output:
        bed="insTOref.bed",
    params:
        sd=SD,
    shell:"""

samtools view -q 10 -F 2304 -@ 3 {input.bam2} | {params.sd}/samToBed /dev/stdin/ --useH --flag   > {output.bed}
"""

rule repContent:
    input:
        bed="insTOref.bed",
    output:
        rep="insTOref.rep.bed",
    params:
        sd=SD,
        repF=config[repf],
    shell:"""
rm -f {output}

intersectBed -loj -a {input} -b $sum/annotation/repeatMask.bed |sort -k1,1 -k2,2n | python {params.sd}/repeatMask.py | groupBy -g 1,2,3,4,5,6 -c 7 |awk 'BEGIN{{OFS="\t"}} {{$8=$5/$4;$9=$6/$4;$10=$7/$4;print;}}' | awk '$10 < {params.repF} ' > {output}


"""

#1       .       .       GT:AD   1/1:0,1








