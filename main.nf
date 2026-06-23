nextflow.enable.dsl=2

process FASTQC {
    container 'biocontainers/fastqc:v0.11.9_cv8'

    input:
    path reads

    output:
    path "*_fastqc*"

    script:
    """
    fastqc ${reads}
    """
}

process TRIMMOMATIC {
    container 'quay.io/biocontainers/trimmomatic:0.39--hdfd78af_2'

    input:
    path reads

    output:
    path "trimmed_*.fastq.gz"

    script:
    """
    trimmomatic SE ${reads} trimmed_${reads} TRAILING:10 MINLEN:36
    """
}

workflow {
    reads = Channel.fromPath("data/*.fastq.gz")
    FASTQC(reads)
    TRIMMOMATIC(reads)
}
