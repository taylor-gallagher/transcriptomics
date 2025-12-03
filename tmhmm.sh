#!/bin/bash
#SBATCH --job-name=tmhmm
#SBATCH --cpus-per-task=64
#SBATCH --mem=500G
#SBATCH --time=7-00:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --account=galta815

/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/tmhmm-2.0c/bin/tmhmm --short /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/transdecoder/trinity_output.Trinity.fasta.transdecoder.pep \
	> tmhmm.v2.out
