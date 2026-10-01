#!/bin/bash
#SBATCH --job-name=stringtie
#SBATCH --partition=aoraki
#SBATCH --cpus-per-task=16
#SBATCH --mem=50G
#SBATCH --time=01:30:00
#SBATCH --array=1-38%8
#SBATCH --output=logs/stringtie_%A_%a.out
#SBATCH --error=logs/stringtie_%A_%a.err

# 1. Map Slurm array task ID to sample name
SAMPLE_LIST="samples.txt"
SAMPLE_NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")

echo "Starting StringTie for sample: ${SAMPLE_NAME} on $(hostname)"

# 2. Set input and reference paths
BRAKER_GTF="/weka/users/guhjo98p/velvetworm/source_invest/braker_busco_rerun_2026-05-21_existingbam_v3/braker_clean_etp/braker.gtf"
OUTPUT_DIR="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/Trimgalore_Remapped_VW"
STRINGTIE_DIR="${OUTPUT_DIR}/stringtie_per_sample"

mkdir -p "$STRINGTIE_DIR"

# 3. Activate conda environment properly in a non-interactive shell
conda activate stringtie

# 4. Run StringTie (clean line continuations, no trailing spaces)
stringtie "${OUTPUT_DIR}/${SAMPLE_NAME}_Aligned.sortedByCoord.out.bam" \
    -G "$BRAKER_GTF" \
    -o "${STRINGTIE_DIR}/${SAMPLE_NAME}.gtf" \
    -p 16 \
    -m 200 \
    -c 2.5 \
    -j 3 \
    -f 0.15

echo "StringTie completed for sample: ${SAMPLE_NAME}"
