#!/bin/bash
#SBATCH --job-name=signalp6
#SBATCH --cpus-per-task=32
#SBATCH --mem=500G
#SBATCH --time=7-00:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --account=galta815

~/.local/bin/signalp6 \
	--fastafile /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/transdecoder/trinity_output.Trinity.fasta.transdecoder.pep \
	--format none \
	--organism euk \
	--mode fast \
 	--output_dir /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/signalp6_out
