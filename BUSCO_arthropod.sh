#!/bin/bash
#SBATCH --job-name=arthropod_BUSCO      # Job name
#SBATCH --nodes=1                       # Use one node
#SBATCH --ntasks-per-node=1             # Number of tasks
#SBATCH --cpus-per-task=8               # Number of CPU cores
#SBATCH --mem=200G                        # Memory allocation
#SBATCH --time=4:00:00                  # Time limit (HH:MM:SS)
#SBATCH --output=busco_athropod_hic.out        # Standard output
#SBATCH --error=busco_arthropod_hic.err         # Standard error
#SBATCH --partition=aoraki

singularity exec -B /weka busco_v5.8.2_cv1.sif  \
	busco \
	-i /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinity_output.Trinity.fasta \
	-l arthropoda_odb10 \
	-o transcriptome_output \
	-m tran \
	-c 8 \
	-f 
