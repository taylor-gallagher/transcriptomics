#!/bin/bash
#SBATCH --job-name=rnaquast
#SBATCH --cpus-per-task=36
#SBATCH --mem=300GB
#SBATCH --nodes=1
#SBATCH --time=7-00:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --partition=aoraki

singularity exec -B /weka /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/rnaquast/rnaquast_2.2.2.sif \
	rnaQUAST.py \
	-c /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinity_output.Trinity.fasta \
	--gtf /projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/PacBio_Annotation/galba_predictions/pacbio_native.asm.bp.p_ctg/galba.gtf \
	--reference /projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/References/pacbio_native.asm.bp.p_ctg.fasta \
	--threads 36 \
	-o rnaquast_output
