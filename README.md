# Nextflow project

This project aim to learn and develop a nextflow workflow that intergrated on the cloud, with high industrial standard.

The skeleton of this nextflow project is based on the nextflow training repo: https://training.nextflow.io/basic_training/rnaseq_pipeline/

This repo contains the second part: **Migrate local file to AWS S3 bucket**

The script contains:

```
├── main.nf → The main script to execute the rna-seq workflow
├── log_filter.py → A script to filter out the LOG.INFO in the nextflow log
├── nextflow.config → A dependency declarative file, with docker environment for each process
└── README.md
```

In this repo, I also include the Container into the main.nf file. This helps easier to reuse duplicated containers.
In the next branch, I will seperate the core logic from the declarative 

### Steps:

1. Reconfig nextflow.config (check configuration guides https://www.nextflow.io/docs/latest/amazons3.html#aws-access-and-secret-keys)
```
docker {
    enabled = true
}

aws {
    accessKey = '<ACCESS ID>'
    secretKey = 'ACCESS Secret'
    region = 'ap-southeast-2'
}
```
2. Change the declarative of inputs (and publishDir)
```
Inputs

params.s3root = "s3://nextflow-first-bucket"
params.reads = "$params.s3root/input_files/data/ggal/gut_{1,2}.fq"
params.transcriptome_file = "$params.s3root/input_files/data/ggal/transcriptome.fa"
```

```
Output
 
process MULTIQC{
    publishDir params.outdir, mode:"copy", overwrite: true

    ...
}
```