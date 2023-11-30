/*
Directory Declarative
*/
params.s3root = "s3://nextflow-first-bucket"
params.reads = "$params.s3root/input_files/data/ggal/gut_{1,2}.fq"
params.transcriptome_file = "$params.s3root/input_files/data/ggal/transcriptome.fa"
// params.multiqc = "$projectDir/multiqc"

/*
Container Declarative
*/
params.outdir = "$params.s3root/output"
params.container_salmon = "quay.io/biocontainers/salmon:1.10.2--hecfa306_0"
params.container_multiqc = "quay.io/biocontainers/multiqc:1.18--pyhdfd78af_0"


log.info """\
    R N A S E Q - N F   P I P E L I N E
    ===================================
    transcriptome: ${params.transcriptome_file}
    reads        : ${params.reads}
    outdir       : ${params.outdir}
    """
    .stripIndent()

process INDEX {
    container params.container_salmon
    input:
    path transcriptome

    output:
    path 'salmon_index'

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i salmon_index
    """
}

process QUANTIFICATION {
    container params.container_salmon

    input:
    path salmon_index
    tuple val(sample_id), path(reads)

    output:
    path "$sample_id"

    script:
    """
    salmon quant --threads $task.cpus --libType=U -i $salmon_index -1 ${reads[0]} -2 ${reads[1]} -o $sample_id
    """
}

process FASTQC {
    input:
    tuple val(sample_id), path(reads)

    output:
    path "fastqc_${sample_id}_logs"

    script:
    """
    mkdir fastqc_${sample_id}_logs
    fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads}
    """
}

process MULTIQC {
    publishDir params.outdir, mode:"copy", overwrite: true
    container params.container_multiqc

    input:
    path '*' // MultiQC will recursively search all paths, so using, wildcard, we specify None or mode targeted MultiQC (if needed)

    output:
    path 'multiqc_report.html'

    script:
    """
    multiqc .
    """
}

workflow {
    read_pairs_ch = Channel
        .fromFilePairs(params.reads, checkIfExists: true)
        // .set { read_pairs_ch }

    index_ch = INDEX(params.transcriptome_file)
    index_ch.view()
    quant_ch = QUANTIFICATION(index_ch, read_pairs_ch)
    quant_ch.view()
    MULTIQC(quant_ch)
    // quant_ch.view()
    // fastqc_ch = FASTQC(read_pairs_ch)
    // fastqc_ch.view()
    // MULTIQC(quant_ch.mix(fastqc_ch).collect())
}

workflow.onComplete {
    log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
}
