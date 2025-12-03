#!/bin/bash
#SBATCH --job-name=trinotate_run
#SBATCH --cpus-per-task=1
#SBATCH --mem=400G
#SBATCH --time=30-00:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --partition=aoraki_long

source ~/miniforge3/bin/activate
conda activate trinotate

# External tools
EXTERNAL_PATHS="$CONDA_PREFIX/bin:/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/tmhmm-2.0c/bin:/home/galta815/.local/bin"

singularity exec -B /weka/ /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_4.0.2.sif \
	env PATH="$EXTERNAL_PATHS:$PATH" \
        /usr/local/src/Trinotate/Trinotate \
	--db velvetworm_transcriptome.sqlite --CPU 1 \
	--transcript_fasta /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinity_output.Trinity.fasta \
	--transdecoder_pep /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/transdecoder/trinity_output.Trinity.fasta.transdecoder.pep \
	--trinotate_data_dir /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/data_directory \
	--run "swissprot_blastp swissprot_blastx pfam signalp6 tmhmmv2 infernal EggnogMapper" 




