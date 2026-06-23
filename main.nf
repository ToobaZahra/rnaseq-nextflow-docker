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

process STAR_INDEX {
    container 'quay.io/biocontainers/star:2.7.10a--h9ee0642_0'

    input:
    path genome
    path gtf

    output:
    path "star_index"

    script:
    """
    mkdir star_index
    STAR --runMode genomeGenerate \
         --genomeDir star_index \
         --genomeFastaFiles ${genome} \
         --sjdbGTFfile ${gtf} \
         --genomeSAindexNbases 7
    """
}

process STAR_ALIGN {
    container 'quay.io/biocontainers/star:2.7.10a--h9ee0642_0'

    input:
    path reads
    path index

    output:
    path "*.bam"

    script:
    """
    STAR --runMode alignReads \
         --genomeDir ${index} \
         --readFilesIn ${reads} \
         --readFilesCommand zcat \
         --outSAMtype BAM SortedByCoordinate \
         --outFileNamePrefix aligned_
    """
}

process FEATURECOUNTS {
    container 'quay.io/biocontainers/subread:2.0.3--h7132678_1'

    input:
    path bam
    path gtf

    output:
    path "counts.txt"

    script:
    """
    featureCounts -a ${gtf} -o counts.txt ${bam}
    """
}

process MULTIQC {
    container 'quay.io/biocontainers/multiqc:1.14--pyhdfd78af_0'

    input:
    path reports

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc .
    """
}

workflow {
    reads = Channel.fromPath("data/*.fastq.gz")
    genome = file("genome/genome.fa")
    gtf = file("genome/genes.gtf")

    fastqc_out = FASTQC(reads)
    trimmed = TRIMMOMATIC(reads)
    index = STAR_INDEX(genome, gtf)
    bam = STAR_ALIGN(trimmed, index)
    counts = FEATURECOUNTS(bam, gtf)
    MULTIQC(fastqc_out.mix(counts).collect())
}
