#!/bin/bash
#SBATCH --job-name=trinity_filtering
#SBATCH --cpus-per-task=32
#SBATCH --mem=200GB
#SBATCH --nodes=1
#SBATCH --time=2-00:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --partition=aoraki

export LANG=C
export LC_ALL=C
export TRINITY_MAX_MEMORY_PER_PARTITION=4G
export TRINITY_MAX_CPU_PER_PARTITION=2

singularity exec -B /weka /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinityrnaseq.v2.15.2.simg \
	/usr/local/bin/util/retrieve_sequences_from_fasta.pl \
	> /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/transcriptome_tpm_length_filtered.fasta



transcriptome_tpm_length_filtered.fasta
