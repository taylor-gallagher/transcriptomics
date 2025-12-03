#!/bin/bash
#SBATCH --job-name=trinitystats
#SBATCH --cpus-per-task=4
#SBATCH --mem=50GB
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --partition=aoraki

singularity exec -B /weka /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinityrnaseq.v2.15.2.simg \
	/usr/local/bin/util/TrinityStats.pl trinity_output.Trinity.fasta > trinity_stats.txt
