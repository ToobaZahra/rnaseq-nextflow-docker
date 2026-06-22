nextflow.enable.dsl=2

process FASTQC {
	container 'biocontainers/fastqc:v0.11.9_cv8'
	input:
	path fastq
	
	output:
	path "fastqc_*"

	script:
	"""
	fastqc $fastq
	"""
}

workflow{
	reads= Channel.fromPath("data/*.fastq.gz")
	FASTQC(reads)
}

