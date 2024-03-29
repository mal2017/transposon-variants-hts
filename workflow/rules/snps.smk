rule get_pileups:
    input:
        bam = "results/merged/{sample}.bam",
        bai = "results/merged/{sample}.bam.bai",
        fasta = config.get("TRANSPOSON_FASTA")
    output:
        csv = "results/pileups/{sample}.pileups.csv.gz"
    params:
        bq = config.get('MIN_SNP_BQ')
    resources:
        time=20,
        mem=10000,
        cpus=2
    conda:
        "../envs/bioc-general.yaml"
    script:
        '../scripts/pileups.R'


rule get_male_snps:
    input:
        pileups = expand("results/pileups/{s}.pileups.csv.gz",s=SAMPLES),
        fasta = config.get("TRANSPOSON_FASTA")
    output:
        bed = "results/snps/snps.bed",
        csv = "results/snps/snps.csv.gz",
        vcf = expand("results/snps/snps.vcf"),
    params:
        min_snp_depth =  config.get('MIN_SNP_SUPPORT'),
        sample_2_fingerprint =config.get('SAMPLE_OF_INTEREST','w1118_male')
    resources:
        time=20,
        mem=10000,
        cpus=2
    conda:
        "../envs/bioc-general.yaml"
    script:
        '../scripts/snps.R'

#
# rule get_total_depths_snps:
#     input:
#         bam = "results/merged/{s}.bam".format(s=config.get('SAMPLE_OF_INTEREST','w1118_male')),
#         vcf = rules.get_male_snps.output.vcf
#     output:
#         csv = "results/snps/depth-at-snps.csv.gz",
#     params:
#         sample_2_fingerprint =config.get('SAMPLE_OF_INTEREST','w1118_male'),
#     resources:
#         time=20,
#         mem=10000,
#         cpus=2
#     conda:
#         "../envs/bioc-general.yaml"
#     script:
#         '../scripts/depth-at-snps.R'
