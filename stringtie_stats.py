#!/usr/bin/env python3
# Save as calc_stats.py
import sys
from Bio import SeqIO


def get_stats(fasta_file):
    lengths = []
    total_bases = 0
    gc_bases = 0
    over_3000 = 0

    for rec in SeqIO.parse(fasta_file, "fasta"):
        seq_str = str(rec.seq).upper()
        l = len(seq_str)
        lengths.append(l)
        total_bases += l
        gc_bases += seq_str.count("G") + seq_str.count("C")
        if l > 3000:
            over_3000 += 1

    lengths.sort(reverse=True)
    # Calculate N50
    half_sum = total_bases / 2
    cum_sum = 0
    n50 = 0
    for l in lengths:
        cum_sum += l
        if cum_sum >= half_sum:
            n50 = l
            break

    gc_pct = (gc_bases / total_bases) * 100 if total_bases > 0 else 0
    return {
        "N50": n50,
        "GC%": round(gc_pct, 2),
        "Longest": lengths[0] if lengths else 0,
        ">3000bp": over_3000,
    }


print("--- ALL TRANSCRIPTS ---")
print(get_stats("P_otepoti_curated_transcripts.fa"))

print("\n--- LONGEST ISOFORM PER GENE ---")
print(get_stats("P_otepoti_curated_longest.fa"))
