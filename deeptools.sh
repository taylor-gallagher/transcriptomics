#!/bin/bash
#SBATCH --job-name=bamCoverage
#SBATCH --partition=aoraki
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=01:00:00
#SBATCH --array=1-38%10
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

DEEPTOOLS="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/containers/deeptools_3.5.3.sif"
BAM_DIR="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/Trimgalore_Remapped_VW"
OUT_DIR="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/Trimgalore_Remapped_VW/bigwig"

mkdir -p "$OUT_DIR"

SAMPLE_LIST="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/stringtie/samples.txt"
SAMPLE_NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" "$SAMPLE_LIST")

BAM_FILE="${BAM_DIR}/${SAMPLE_NAME}_Aligned.sortedByCoord.out.bam"

echo "Processing BigWig for: ${SAMPLE_NAME}"

# 1. Check/create CSI index if missing (using -c flag)
if [ ! -f "${BAM_FILE}.csi" ]; then
    echo "Creating CSI index for ${BAM_FILE}..."
    samtools index -c -@ 8 "$BAM_FILE"
fi

# 2. Run bamCoverage (deepTools automatically detects .csi)
singularity exec -B /weka,/projects "$DEEPTOOLS" bamCoverage \
    -b "$BAM_FILE" \
    -o "${OUT_DIR}/${SAMPLE_NAME}.bw" \
    --binSize 10 \
    --normalizeUsing RPKM \
    --numberOfProcessors 8

echo "Completed: ${SAMPLE_NAME}.bw"
