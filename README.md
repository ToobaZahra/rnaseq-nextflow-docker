# RNA-seq Nextflow + Docker Pipeline

Hi, I'm Tooba Zahra — a Bioinformatics MS student at COMSATS University Islamabad (graduating Feb 2027). I built this pipeline as part of my journey into reproducible bioinformatics workflows.

## Why Nextflow + Docker?

In this pipeline, each step (FastQC, Trimmomatic, STAR, etc.) runs inside its own Docker container. This means every tool has its own isolated environment — so if STAR needs Python 3.3 and FastQC needs Python 3.2, they won't conflict with each other. No dependency issues, no "it works on my machine" problems. The pipeline runs the same way everywhere.

## What this pipeline does

1. **FastQC** — checks raw read quality
2. **Trimmomatic** — trims adapters and low quality bases
3. **STAR** — indexes the genome and aligns reads
4. **featureCounts** — counts reads per gene
5. **MultiQC** — combines all QC reports into one HTML file

## Requirements

- Nextflow
- Docker

## How to run

Clone the repo and run:

```bash
nextflow run main.nf
```

Nextflow pulls the Docker images automatically — no manual installation needed.

## Output

- `*_fastqc.html` — QC reports per sample
- `trimmed_*.fastq.gz` — trimmed reads
- `*.bam` — aligned reads
- `counts.txt` — gene counts matrix
- `multiqc_report.html` — combined QC report

## Tools used

| Tool | Version | Purpose |
|------|---------|---------|
| FastQC | 0.11.9 | QC |
| Trimmomatic | 0.39 | Trimming |
| STAR | 2.7.10a | Alignment |
| featureCounts | 2.0.3 | Quantification |
| MultiQC | 1.14 | Reporting |
