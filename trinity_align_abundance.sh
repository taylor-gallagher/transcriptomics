#!/bin/bash
#SBATCH --job-name=trinity_align_abundance
#SBATCH --cpus-per-task=32
#SBATCH --mem=200GB
#SBATCH --nodes=1
#SBATCH --time=7-00:00:00
#SBATCH --output=trinity_align_abundance/%x_%j.out
#SBATCH --error=trinity_align_abundance/%x_%j.err
#SBATCH --partition=aoraki

export LANG=C
export LC_ALL=C
export TRINITY_MAX_MEMORY_PER_PARTITION=4G
export TRINITY_MAX_CPU_PER_PARTITION=2

singularity exec -B /weka /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinityrnaseq.v2.15.2.simg \
	/usr/local/bin/util/align_and_estimate_abundance.pl \
	--transcripts /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinity_output.Trinity.fasta \
	--seqType fq \
	--samples_file /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/RNASeq_samples.txt \
	--est_method salmon \
	--trinity_mode \
	--prep_reference \
	--output_dir /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/rna-seq/salmon \
	--thread_count 32
