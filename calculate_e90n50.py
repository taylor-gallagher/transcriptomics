#!/usr/bin/env python3
import glob
import os
import sys
from collections import defaultdict

QUANT_DIR = "/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/trinity/exn50_calculation/salmon_quant"
FASTA_ALL = "/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/Transcriptome_Assembly/trinity_vw_genome/Trinity-GG.fasta"
FASTA_LONGEST = "/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/Trinity-GG-longest-isoforms.fasta"


def read_fasta_lengths(fasta_path):
    """Read FASTA and return a dictionary of {transcript_id: length}."""
    if not os.path.exists(fasta_path):
        print(f"Error: {fasta_path} not found!")
        sys.exit(1)
    lengths = {}
    with open(fasta_path) as f:
        current_id = None
        current_len = 0
        for line in f:
            line = line.strip()
            if line.startswith(">"):
                if current_id:
                    lengths[current_id] = current_len
                current_id = line[1:].split()[0]
                current_len = 0
            else:
                current_len += len(line)
        if current_id:
            lengths[current_id] = current_len
    return lengths


def compute_ex90n50(lengths_dict, tpm_dict):
    """Calculate Ex90N50 for a given dictionary of transcript lengths."""
    subset_tpm = {
        tid: tpm_dict[tid] for tid in lengths_dict if tid in tpm_dict
    }

    sorted_transcripts = sorted(
        subset_tpm.keys(), key=lambda x: subset_tpm[x], reverse=True
    )

    total_expression = sum(subset_tpm.values())
    target_90 = 0.90 * total_expression

    cum_tpm = 0.0
    e90_lengths = []
    for tid in sorted_transcripts:
        cum_tpm += subset_tpm[tid]
        e90_lengths.append(lengths_dict[tid])
        if cum_tpm >= target_90:
            break

    e90_lengths.sort(reverse=True)
    half_total_len = sum(e90_lengths) / 2.0

    cum_len = 0
    ex90_n50 = 0
    for l in e90_lengths:
        cum_len += l
        if cum_len >= half_total_len:
            ex90_n50 = l
            break

    return ex90_n50, len(e90_lengths), len(subset_tpm)


print("Loading Salmon quantification files...")
quant_files = glob.glob(f"{QUANT_DIR}/*/quant.sf")
print(f"Found {len(quant_files)} quant.sf files.")

if len(quant_files) == 0:
    print(f"Error: No quant.sf files found in {QUANT_DIR}/*/quant.sf")
    sys.exit(1)

total_tpm = defaultdict(float)
for qf in quant_files:
    with open(qf) as f:
        header = f.readline()
        for line in f:
            parts = line.strip().split("\t")
            tid = parts[0]
            tpm = float(parts[3])
            total_tpm[tid] += tpm

print("\n--- 1. Contig Ex90N50 (all) ---")
lengths_all = read_fasta_lengths(FASTA_ALL)
ex90_all, count_e90_all, total_all = compute_ex90n50(lengths_all, total_tpm)
print(f"Contig Ex90N50 (all): {ex90_all} bp")
print(f"  -> Represented by top {count_e90_all} of {total_all} transcripts")

print("\n--- 2. Contig Ex90N50 (longest isoform per gene) ---")
lengths_longest = read_fasta_lengths(FASTA_LONGEST)
ex90_long, count_e90_long, total_long = compute_ex90n50(
    lengths_longest, total_tpm
)
print(f"Contig Ex90N50 (longest isoform per gene): {ex90_long} bp")
print(f"  -> Represented by top {count_e90_long} of {total_long} transcripts")
