# Total Curated Transcripts:
awk '$3 == "transcript"' P_otepoti_master_transcriptome.gtf | wc -l

# Total Curated Gene Loci:
awk '$3 == "transcript"' P_otepoti_master_transcriptome.gtf | sed -n 's/.*gene_id "\([^"]*\)".*/\1/p' | sort -u | wc -l
