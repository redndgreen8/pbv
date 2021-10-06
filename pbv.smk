
SD = os.path.dirname(workflow.snakefile)



rule all:
    input:
        bam="asmTOref.bam",
        vcf1="asmTOref.INS.vcf",
        fasta="reads.INS.fa",
        bam2="insTOref.bam",
        bed="insTOref.bed",

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




rule findIns:
    input:
        bam="asmTOref.bam",
        bai="asmTOref.bam.bai",
    output:
        vcf1="asmTOref.INS.vcf",
    params:
        asm=config['asm'],
        ref=config['ref'],
    shell:"""
htsbox pileup -f {params.ref}  -q 10 -S 10000 -T 20 {input.bam} -c > {output.vcf1}

"""

rule extractLargeSVasm:
    input:
        vcf1="asmTOref.INS.vcf",
    output:
        fasta="reads.INS.fa",
    params:
        minl=config['minL'],
        sd=SD,
    shell:"""
awk '{{if ($1~/^#/) {{print$0;}} else if (length($5) > length($4)+ {params.minl} || length($4) > length($5) + {params.minl} ) {{print $1"_"$2"\t"$5;}} }}'  {input} | grep -v "#" | python {params.sd}/extractFa.py > {output}


"""



rule maptoRef:
    input:
        fasta="reads.INS.fa",
    output:
        bam2="insTOref.bam",
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
    shell:"""

samtools view -q 10 -F 2304 -@ 3 {input.bam2} | samToBed /dev/stdin/ --useH --flag   > {output.bed}
"""











    #intersectBed -wa -wb -a  -b $sum/annotation/repeatMask.bed |sort -k1,1 -k2,2n | python repeatMask.py | groupBy -g 1,2,3,10 -c 9| awk 'BEGIN{{OFS="\t"}} $6=$5/$4' > {output.inter}

   # intersectBed -v -a -b $sum/annotation/repeatMask.bed |awk 'BEGIN{{OFS="\t"}}{{print$1,$2,$3,$3-$2,0,0}}'>>{output.inter}




