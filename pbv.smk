



rule all:
    input:
        bam="asmTOref.bam",
        bed="asmTOref.INS.bed",
        fasta="asmTOref.fa",
        bam2="insTOref.bam",
        vcf="DUPs.vcf",

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
 
 lra align -CONTIG -p s {input.ref} {input.asm} -t {params.thr} {params.map_p} | \
    samtools sort -T {params.temp}/asm.$$ -m2G -o {output}
samtools index {output}

"""

rule findIns:
    input:
        bam="asmTOref.bam",
    output:
        bed="asmTOref.INS.bed",
        fasta="asmTOref.fa",
    params:
        asm=config['asm']
    shell:"""

htsbox {input.bam} > {output.bed}

bedtools getfasta -fi {params.asm} -bed {output.bed} > {output.fasta}
"""


rule maptoRef:
    input:
        fasta="asmTOref.fa",
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



rule callDUP:
    input:
        bam2="insTOref.bam",
    output:
        vcf="DUPs.vcf",
    params:
    shell:"""

hmcnc {input.bam2} > {output.vcf}

"""