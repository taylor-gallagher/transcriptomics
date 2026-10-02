#!/bin/bash
#SBATCH --job-name=gffread
#SBATCH --cpus-per-task=8
#SBATCH --mem=50G
#SBATCH --time=1:00:00
#SBATCH --output=gffread.out
#SBATCH --error=gffread.err
#SBATCH --partition=aoraki

singularity exec -B /weka,/projects /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/containers/gffread_0.12.7.sif \
	gffread \
	-w /projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/stringtie/P_otepoti_curated_transcripts.fa \
	-g /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/hi-c/final_assembly.fasta \
	/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/stringtie/P_otepoti_master_curated.gtf
