#!/usr/bin/env python3

#################
## 	CONTAINERS ###
#################

diamond_container = 'docker://nanozoo/diamond:2.1.12--cc14f58'
trinotate = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_4.0.2.sif'

###########
## RULES ###
###########

rule target:
    input:
        '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/uniprot_sprot.dmnd',
        '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/transdecoder.blastp.outfmt6',
        '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/transdecoder.blastx.outfmt6',
        '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/pfam.domtblout',
        '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/Rfam.tblout',
        '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/signalp6.txt',
        '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/eggnog/eggnog.emapper.hits',
        '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/eggnog/eggnog.emapper.annotations',
        '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/eggnog/eggnog.emapper.seed_orthologs'

rule Diamond_BLASTP_mkdb:
    input:
        reference = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/uniprot_sprot.fasta'
    output:
        diamond_db = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/uniprot_sprot.dmnd'
    log:
        diamond_db_log = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/dmnd.log'
    singularity:
        diamond_container
    shell:
        'diamond makedb --in {input.reference} -d {output.diamond_db} > {log.diamond_db_log} 2>&1'
       
rule Diamond_BLASTP:
    input:
        blastp_query = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/transdecoder/trinity_output.Trinity.fasta.transdecoder.pep',
        diamond_db = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/uniprot_sprot.dmnd'
    output:
        diamond_blastp_out = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/transdecoder.blastp.outfmt6'
    log:
        blastp_log = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/blastp.log'
    singularity:
        diamond_container
    threads:
        32
    shell:
        'diamond blastp --query {input.blastp_query} --db {input.diamond_db} --out {output.diamond_blastp_out} --outfmt 6 --evalue 1e-5 --max-target-seqs 1 --threads {threads} > {log.blastp_log}'

rule Diamond_BLASTX:
    input:
        blastx_query = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinity_output.Trinity.fasta',
        diamond_db = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/uniprot_sprot.dmnd'
    output:
        diamond_blastx_out = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/transdecoder.blastx.outfmt6'
    log:
        blastx_log = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/blastx.log'
    singularity:
        diamond_container
    threads:
        32
    shell:
        'diamond blastx --query {input.blastx_query} --db {input.diamond_db} --out {output.diamond_blastx_out} --outfmt 6 --evalue 1e-5 --max-target-seqs 1 --threads {threads} > {log.blastx_log}'

rule hmmscan:
    input:
        hmmscan_query = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/transdecoder/trinity_output.Trinity.fasta.transdecoder.pep',
        pfam_db = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/Pfam-A.hmm'
    output:
        domtblout = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/pfam.domtblout'
    log:
        pfam_log = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/pfam.log'
    resources:
        mem_mb = 500000,
        time_min = 10080
    threads:
        64
    shell:
        '~/.conda/envs/trinotate/bin/hmmscan --cpu {threads} --domtblout {output.domtblout} {input.pfam_db} {input.hmmscan_query} > {log.pfam_log}'

rule cmscan:
    input:
        transcriptome = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinity/trinity_output.Trinity.fasta',
        rfam_db = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/Rfam.cm'
    output:
        tblout = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/Rfam.tblout'
    log:
        rfam_log = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/Rfam.log'
    resources:
        mem_mb = 500000,
        time_min = 10080
    threads:
        32
    shell:
        '~/.conda/envs/trinotate/bin/cmscan --cpu {threads} --tblout {output.tblout} {input.rfam_db} {input.transcriptome} > {log.rfam_log}'

rule signalp6:
    input:
        signalp6_query = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/transdecoder/trinity_output.Trinity.fasta.transdecoder.pep'
    output:
        signalp6_table = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/signalp6.txt'
    log:
        signalp6_log = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/signalp6.log'
    threads:
        32
    resources:
        mem_mb = 100000,
        time_min = 10080
    shell:
        """
        source ~/miniforge3/bin/activate &&
        conda activate trinotate &&
        ~/.local/bin/signalp6 --fasta {input.signalp6_query} --format txt --organism euk --output_dir /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped > {output.signalp6_table} 2> {log.signalp6_log}
        """

rule eggnogmapper:
    input:
        pep="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/transdecoder/trinity_output.Trinity.fasta.transdecoder.pep"
    output:
        hits="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/eggnog/eggnog.emapper.hits",
        annotations="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/eggnog/eggnog.emapper.annotations",
        seeds="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/eggnog/eggnog.emapper.seed_orthologs"
    log:
        "/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/eggnog.log"
    threads:
        32
    shell:
        """
        ~/.conda/envs/trinotate/bin/emapper.py \
            -i {input.pep} \
            --output /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/eggnog/eggnog \
            --override \
            --cpu {threads} \
            --data_dir /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped \
            --scratch_dir /projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/tmp \
            > {log} 2>&1
        """

        
rule trinotate:
    input:
        diamond_blastp_out = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/transdecoder.blastp.outfmt6',
        diamond_blastx_out = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/transdecoder.blastx.outfmt6',
        domtblout = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/pfam.domtblout',
        tblout = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/Rfam.tblout',
        signalp6_table = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/signalp6.short',
        eggnog_annotation = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/eggnog',
        sqlite = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/velvetworm_transcriptome.sqlite'
    output:
        report = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/trinotate_annotation_report.xlsx'
    log:
        trinotate_load_log = '/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/trinotate_unwrapped/trinotate_load.log'
    threads:
        32
    singularity:
        trinotate
    shell:
        """
        Trinotate {input.sqlite} init &&
        Trinotate {input.sqlite} LOAD_swissprot_blastp {input.diamond_blastp_out} &&
        Trinotate {input.sqlite} LOAD_swissprot_blastx {input.diamond_blastx_out} &&
        Trinotate {input.sqlite} LOAD_pfam {input.domtblout} &&
        Trinotate {input.sqlite} LOAD_rfam {input.tblout} &&
        Trinotate {input.sqlite} LOAD_signalp {input.signalp6_table} &&
        Trinotate {input.sqlite} LOAD_eggnog {input.eggnog_annotation} &&
        Trinotate {input.sqlite} report > {output.report} 2> {log.trinotate_load_log}
        """

