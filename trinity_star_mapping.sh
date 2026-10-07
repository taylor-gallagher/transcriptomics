#!/bin/bash
#SBATCH --job-name=star_remapping_vw
#SBATCH --cpus-per-task=16
#SBATCH --mem=200G
#SBATCH --time=1-00:00:00
#SBATCH --output=remapping_logs/%x_%A_%a.out
#SBATCH --error=remapping_logs/%x_%A_%a.err
#SBATCH --array=1-38
#SBATCH --partition=aoraki

STAR_SIF="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/rna-seq/star/star_2.7.10a_alpha_220506.sif"
GENOME_DIR="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/rna-seq/star/star_output"
OUTPUT_DIR="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/Trimgalore_Remapped_VW"
READS_DIR="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/rna-seq/trimmed_reads"
BRAKER_GTF="/weka/users/guhjo98p/velvetworm/source_invest/braker_busco_rerun_2026-05-21_existingbam_v3/braker_clean_etp/braker.gtf"
mkdir -p "$OUTPUT_DIR"

FILES=(${READS_DIR}/*_R1_val_1.fq.gz)

INDEX=$(($SLURM_ARRAY_TASK_ID - 1))
R1="${FILES[$INDEX]}"

if [[ -z "$R1" ]]; then
    echo "ERROR: No file found for Array Task ID $SLURM_ARRAY_TASK_ID"
    exit 1
fi

R2="${R1/_R1_val_1.fq.gz/_R2_val_2.fq.gz}"
SAMPLE_NAME=$(basename "$R1" _R1_val_1.fq.gz)

echo "Processing Sample: $SAMPLE_NAME"
echo "R1: $R1"
echo "R2: $R2"

singularity exec -B /weka,/projects "$STAR_SIF" \
    STAR \
    --runThreadN 16 \
    --genomeDir "$GENOME_DIR" \
    --readFilesIn "$R1" "$R2" \
    --readFilesCommand gunzip -c \
    --outFileNamePrefix "${OUTPUT_DIR}/${SAMPLE_NAME}_" \
    --outSAMtype BAM Unsorted \
    --outSAMunmapped None \
    --outReadsUnmapped Fastx
