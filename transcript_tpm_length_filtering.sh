#!/bin/bash
#SBATCH --job-name=transcript_tpm_length_filtering
#SBATCH --cpus-per-task=32
#SBATCH --mem=200GB
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --output=transcript_tpm_length_filtering/%x_%j.out
#SBATCH --error=transcript_tpm_length_filtering/%x_%j.err
#SBATCH --partition=aoraki

find . -name "quant.sf" -exec awk 'NR>1 && $4 >= 1 && $2 >= 200 {print $1}' {} + | sort | uniq > high_confidence_ids.txt
