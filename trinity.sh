#!/bin/bash
#SBATCH --job-name=trinity
#SBATCH --cpus-per-task=6
#SBATCH --mem=500GB
#SBATCH --nodes=1
#SBATCH --time=7-00:00:00
#SBATCH --output=trinity_output/%x_%j.out
#SBATCH --error=trinity_logs/%x_%j.err
#SBATCH --partition=aoraki

export LANG=C
export LC_ALL=C
export TRINITY_MAX_MEMORY_PER_PARTITION=4G
export TRINITY_MAX_CPU_PER_PARTITION=2

singularity exec -B /weka /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinityrnaseq.v2.15.2.simg \
	Trinity \
	--seqType fq \
	--max_memory 50G \
	--samples_file /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/RNASeq_samples.txt \
	--output /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinity_output \
	--min_kmer_cov 2 \
	--no_parallel_norm_stats \
	--normalize_by_read_set \
	--CPU 6
