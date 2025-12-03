#!/bin/bash
#SBATCH --job-name=infernal_optimised_1
#SBATCH --cpus-per-task=64
#SBATCH --mem=500G
#SBATCH --time=7-00:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --account=galta815

~/.conda/envs/trinotate/bin/cmscan \
	--cpu 64 \
	--rfam \
	--tblout /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/Rfam.tblout \
	/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/Rfam.cm \
	/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinity_output.Trinity.fasta \
	> /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/Optimised_1_Rfam.log
