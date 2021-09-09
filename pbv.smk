
SD = os.path.dirname(workflow.snakefile)



rule all:
    input:
        bam="asmTOref.bam",
        vcf1="asmTOref.INS.vcf",
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
        vcf1="asmTOref.INS.vcf",
    params:
        asm=config['asm'],
        ref=config['ref'],
    shell:"""
htsbox pileup -f {params.ref}  -q 5 -S 10000 -T 20 {input.bam} -c > {output.vcf1}

"""

rule extractLargeSVasm:
    input:
        vcf1="asmTOref.INS.vcf",
    output:
        fasta="asmTOref.fa",
    params:
        minl=config['minL'],
        sd=SD,
    shell:"""
awk '{{if ($1~/^#/) {{print$0;}} else if (length($5) > length($4)+ {params.minl} || length($4) > length($5) + {params.minl} ) {{print $1"_"$2"\t"$5;}} }}'  {input} | grep -v "#" | python {params.sd}/extractFa.py > {output}


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