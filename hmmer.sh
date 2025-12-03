#!/bin/bash
#SBATCH --job-name=hmmer
#SBATCH --cpus-per-task=64
#SBATCH --mem=500G
#SBATCH --time=7-00:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --account=galta815

~/.conda/envs/trinotate/bin/hmmscan --cpu 64 --domtblout /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/pfam.domtblout \
	/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/Pfam-A.hmm \
	/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/transdecoder/trinity_output.Trinity.fasta.transdecoder.pep \
	> /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/pfam.log
