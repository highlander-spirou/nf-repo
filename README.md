# Nextflow project

This project aim to learn and develop a nextflow workflow that intergrated on the cloud, with high industrial standard.

The skeleton of this nextflow project is based on the nextflow training repo: https://training.nextflow.io/basic_training/rnaseq_pipeline/

This repo contains the first part: **Create a development state, where nextflow script is execute locally**

The script contains:
```
├── main.nf → The main script to execute the rna-seq workflow
├── log_filter.py → A script to filter out the LOG.INFO in the nextflow log
├── nextflow.config → A dependency declarative file, with docker environment for each process
└── README.md
```
