PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

INSERT INTO core_publication
  (publication_type, pmid, authors, title, journal, publication_date, url,
   contains_promoter_data, contains_expression_data, submission_notes, curation_complete,
   reported_TF, reported_species)
SELECT
  'ARTICLE',
  '42148648',
  'Valdez F, Velazquez-Salinas L, Fish I, Smoliga GR, Gajewski KP, Davis C, Rodriguez LL, Mire CE, Arzt J',
  'Genome sequence of a historical vesicular stomatitis New Jersey virus isolate collected in 1965 from a naturally infected cow in El Salvador.',
  'Microbiology resource announcements',
  '2026 May 18',
  'https://doi.org/10.1128/mra.00041-26',
  0,
  1,
  NULL,
  1,
  'UmuDAb',
  'Campylobacter jejuni subsp. jejuni NCTC 11168 = ATCC 700819'
WHERE NOT EXISTS (
  SELECT 1 FROM core_publication WHERE pmid='42148648'
);

UPDATE core_publication
SET
  authors = CASE WHEN authors IS NULL OR authors='' THEN 'Valdez F, Velazquez-Salinas L, Fish I, Smoliga GR, Gajewski KP, Davis C, Rodriguez LL, Mire CE, Arzt J' ELSE authors END,
  title = CASE WHEN title IS NULL OR title='' THEN 'Genome sequence of a historical vesicular stomatitis New Jersey virus isolate collected in 1965 from a naturally infected cow in El Salvador.' ELSE title END,
  journal = CASE WHEN journal IS NULL OR journal='' THEN 'Microbiology resource announcements' ELSE journal END,
  publication_date = CASE WHEN publication_date IS NULL OR publication_date='' THEN '2026 May 18' ELSE publication_date END,
  url = CASE WHEN url IS NULL OR url='' THEN 'https://doi.org/10.1128/mra.00041-26' ELSE url END,
  reported_TF = CASE WHEN reported_TF IS NULL OR reported_TF='' THEN 'UmuDAb' ELSE reported_TF END,
  reported_species = CASE WHEN reported_species IS NULL OR reported_species='' THEN 'Campylobacter jejuni subsp. jejuni NCTC 11168 = ATCC 700819' ELSE reported_species END,
  contains_promoter_data = 0,
  contains_expression_data = 1,
  curation_complete = 1,
  submission_notes = CASE
    WHEN submission_notes IS NULL OR submission_notes='' THEN submission_notes
    ELSE submission_notes
  END
WHERE pmid='42148648';

INSERT INTO core_tf (name, family_id, description)
SELECT 'UmuDAb', 41, 'The UmuDAb protein has been described in Acinetobacter baumannii as a variation of the standard UmuD protein, which associates with UmuC as the translesion synthesis polymerase V. Most likely through a non-conserved N-term DNA-binding motif, UmuDAb has been shown to bind palindromic sites in the promoters of the genes it regulates, and to operate also as a translesion synthesis polymerase in this organism [PMID::24123815][PMID::24342640].'
WHERE NOT EXISTS (
  SELECT 1 FROM core_tf WHERE lower(name)=lower('UmuDAb')
);

UPDATE core_tf
SET
  family_id = COALESCE(family_id, 41),
  description = CASE WHEN description IS NULL THEN 'The UmuDAb protein has been described in Acinetobacter baumannii as a variation of the standard UmuD protein, which associates with UmuC as the translesion synthesis polymerase V. Most likely through a non-conserved N-term DNA-binding motif, UmuDAb has been shown to bind palindromic sites in the promoters of the genes it regulates, and to operate also as a translesion synthesis polymerase in this organism [PMID::24123815][PMID::24342640].' ELSE description END
WHERE lower(name)=lower('UmuDAb');

INSERT INTO core_tfinstance (refseq_accession, uniprot_accession, description, TF_id, notes)
SELECT
  'WP_012052586',
  'V9UYV3',
  'regulatory protein, IclR [Pseudomonas putida DOT-T1E].',
  (SELECT TF_id FROM core_tf WHERE lower(name)=lower('UmuDAb') LIMIT 1),
  ''
WHERE NOT EXISTS (
  SELECT 1 FROM core_tfinstance WHERE uniprot_accession='V9UYV3'
);

UPDATE core_tfinstance
SET
  TF_id = COALESCE(TF_id, (SELECT TF_id FROM core_tf WHERE lower(name)=lower('UmuDAb') LIMIT 1)),
  refseq_accession = COALESCE(NULLIF(refseq_accession,''), 'WP_012052586'),
  description = COALESCE(NULLIF(description,''), 'regulatory protein, IclR [Pseudomonas putida DOT-T1E].'),
  notes = COALESCE(notes, '')
WHERE uniprot_accession='V9UYV3';

INSERT INTO core_curation
  (TF_species, site_species, experimental_process, forms_complex,
   complex_notes, notes, last_modified, curator_id, publication_id, created, validated_by_id)
VALUES
  ('Campylobacter jejuni subsp. jejuni NCTC 11168 = ATCC 700819', 'Campylobacter jejuni subsp. jejuni NCTC 11168 = ATCC 700819', NULL,
   0, NULL, '',
   datetime('now'), (SELECT curator_id FROM core_curator ORDER BY curator_id LIMIT 1), (SELECT publication_id FROM core_publication WHERE pmid='42148648' LIMIT 1), datetime('now'), NULL);

INSERT INTO core_curation_TF_instances (curation_id, tfinstance_id)
SELECT (SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42148648' LIMIT 1) ORDER BY curation_id DESC LIMIT 1), (SELECT TF_instance_id FROM core_tfinstance WHERE uniprot_accession='V9UYV3' LIMIT 1)
WHERE NOT EXISTS (
  SELECT 1 FROM core_curation_TF_instances
  WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42148648' LIMIT 1) ORDER BY curation_id DESC LIMIT 1) AND tfinstance_id=(SELECT TF_instance_id FROM core_tfinstance WHERE uniprot_accession='V9UYV3' LIMIT 1)
);

INSERT INTO core_genome (genome_accession, organism)
SELECT 'NC_002163.1', 'Campylobacter jejuni subsp. jejuni NCTC 11168 = ATCC 700819'
WHERE NOT EXISTS (
  SELECT 1 FROM core_genome WHERE genome_accession='NC_002163.1'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dnaA',
  'chromosomal replication initiation protein',
  1,
  1323,
  1,
  'Cj0001',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0001'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dnaN',
  'DNA polymerase III subunit beta',
  1483,
  2550,
  1,
  'Cj0002',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0002'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gyrB',
  'DNA gyrase subunit B',
  2579,
  4888,
  1,
  'Cj0003',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0003'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343476.1',
  'monoheme cytochrome C',
  4916,
  5257,
  -1,
  'Cj0004c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0004c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343477.1',
  'molydopterin containing oxidoreductase',
  5260,
  6498,
  -1,
  'Cj0005c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0005c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343478.1',
  'Na+/H+ antiporter family protein',
  6703,
  8010,
  1,
  'Cj0006',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0006'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gltB',
  'glutamate synthase large subunit',
  8144,
  12634,
  1,
  'Cj0007',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0007'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343480.1',
  'hypothetical protein',
  12644,
  14395,
  1,
  'Cj0008',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0008'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gltD',
  'glutamate synthase subunit beta',
  14398,
  15843,
  1,
  'Cj0009',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0009'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rnhB',
  'ribonuclease HII',
  15844,
  16419,
  -1,
  'Cj0010c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0010c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343483.1',
  'non-specific DNA binding protein',
  16452,
  16691,
  -1,
  'Cj0011c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0011c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rrc',
  'non-heme iron protein',
  16756,
  17403,
  -1,
  'Cj0012c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0012c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ilvD',
  'dihydroxy-acid dehydratase',
  17563,
  19239,
  1,
  'Cj0013',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0013'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343486.1',
  'integral membrane protein',
  19251,
  19775,
  -1,
  'Cj0014c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0014c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343487.1',
  'hypothetical protein',
  19867,
  21093,
  -1,
  'Cj0015c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0015c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343488.1',
  '7-cyano-7-deazaguanine synthase',
  21159,
  21833,
  1,
  'Cj0016',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0016'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dsbI',
  'disulfide bond formation protein',
  21854,
  23380,
  -1,
  'Cj0017c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0017c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dba',
  'disulfide bond formation protein',
  23392,
  23559,
  -1,
  'Cj0018c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0018c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343491.1',
  'MCP-domain signal transduction protein',
  23665,
  25443,
  -1,
  'Cj0019c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0019c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343492.1',
  'cytochrome C551 peroxidase',
  25433,
  26347,
  -1,
  'Cj0020c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0020c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343493.1',
  'fumarylacetoacetate (FAA) hydrolase familyprotein',
  26411,
  27289,
  -1,
  'Cj0021c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0021c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343494.1',
  'pseudouridine synthase',
  27402,
  28304,
  -1,
  'Cj0022c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0022c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purB',
  'adenylosuccinate lyase',
  28382,
  29710,
  1,
  'Cj0023',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0023'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nrdA',
  'ribonucleotide-diphosphate reductase subunitalpha',
  29726,
  32095,
  1,
  'Cj0024',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0024'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343497.1',
  'sodium:dicarboxylate family transmembranesymporter',
  32134,
  33519,
  -1,
  'Cj0025c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0025c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thyX',
  'thymidylate synthase',
  33639,
  34262,
  -1,
  'Cj0026c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0026c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pyrG',
  'CTP synthetase',
  34382,
  36013,
  1,
  'Cj0027',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0027'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'recJ',
  'single-stranded-DNA-specific exonuclease',
  36000,
  37571,
  1,
  'Cj0028',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0028'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ansA',
  'L-asparaginase',
  37667,
  38662,
  1,
  'Cj0029',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0029'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  39249,
  40761,
  1,
  'Cjr01',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjr01'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAAla',
  '—',
  40866,
  40941,
  1,
  'Cjp01',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp01'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAIle',
  '—',
  40950,
  41026,
  1,
  'Cjp02',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp02'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  41568,
  44457,
  1,
  'Cjr02',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjr02'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  44741,
  44860,
  1,
  'Cjr03',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjr03'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343502.1',
  'hypothetical protein',
  44966,
  46363,
  1,
  'Cj0030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343503.1',
  'type IIS restriction/modification enzyme',
  46424,
  50156,
  1,
  'Cj0031',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0031'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343504.1',
  'integral membrane protein',
  50156,
  51937,
  1,
  'Cj0033',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0033'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343505.1',
  'periplasmic protein',
  51967,
  52668,
  -1,
  'Cj0034c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0034c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343506.1',
  'efflux protein',
  52665,
  53867,
  -1,
  'Cj0035c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0035c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343507.1',
  'hypothetical protein',
  53970,
  55319,
  1,
  'Cj0036',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0036'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343508.1',
  'cytochrome C',
  55343,
  56386,
  -1,
  'Cj0037c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0037c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343509.1',
  'poly(A) polymerase family protein',
  56564,
  57211,
  -1,
  'Cj0038c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0038c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'typA',
  'GTP-binding protein TypA',
  57211,
  59019,
  -1,
  'Cj0039c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0039c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343511.1',
  'hypothetical protein',
  59154,
  59477,
  1,
  'Cj0040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliK',
  'flagellar hook-length control protein',
  59493,
  61289,
  1,
  'Cj0041',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0041'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgD',
  'flagellar hook assembly protein',
  61343,
  62227,
  1,
  'Cj0042',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0042'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgE',
  'flagellar hook protein',
  62231,
  63868,
  1,
  'Cj0043',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0043'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343515.1',
  'hypothetical protein',
  63872,
  65743,
  -1,
  'Cj0044c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0044c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343516.1',
  'iron-binding protein',
  65744,
  66466,
  -1,
  'Cj0045c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0045c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  66646,
  66744,
  1,
  'Cjs03',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjs03'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  66985,
  68504,
  1,
  'Cj0046',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0046'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mnmA',
  'tRNA-specific 2-thiouridylase MnmA',
  68532,
  69548,
  -1,
  'Cj0053c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0053c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343518.1',
  'lysine decarboxylase family protein',
  69548,
  70153,
  -1,
  'Cj0054c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0054c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343519.1',
  'hypothetical protein',
  70274,
  71098,
  -1,
  'Cj0055c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0055c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343521.1',
  'periplasmic protein',
  72005,
  72859,
  1,
  'Cj0057',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0057'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343522.1',
  'peptidase C39 family protein',
  72844,
  73443,
  1,
  'Cj0058',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0058'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliY',
  'flagellar motor switch protein FliY',
  73492,
  74334,
  -1,
  'Cj0059c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0059c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliM',
  'flagellar motor switch protein FliM',
  74331,
  75410,
  -1,
  'Cj0060c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0060c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliA',
  'flagellar biosynthesis RNA polymerase sigmafactor',
  75410,
  76126,
  -1,
  'Cj0061c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0061c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343526.1',
  'integral membrane protein',
  76083,
  76439,
  -1,
  'Cj0062c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0062c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343527.1',
  'ATP-binding protein',
  76458,
  77324,
  -1,
  'Cj0063c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0063c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flhF',
  'flagellar biosynthesis regulator FlhF',
  77317,
  78771,
  -1,
  'Cj0064c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0064c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'folK',
  '2-amino-4-hydroxy-6-hydroxymethyldihydropteridine pyrophosphokinase',
  78781,
  79254,
  -1,
  'Cj0065c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0065c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'aroQ',
  '3-dehydroquinate dehydratase',
  79257,
  79736,
  -1,
  'Cj0066c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0066c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343531.1',
  'amidohydrolase family protein',
  79827,
  81056,
  1,
  'Cj0067',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0067'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pspA',
  'protease',
  81044,
  81940,
  1,
  'Cj0068',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0068'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343533.1',
  'hypothetical protein',
  82019,
  83050,
  1,
  'Cj0069',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0069'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  83292,
  83893,
  -1,
  'Cj0072c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0072c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343535.1',
  'hypothetical protein',
  84087,
  84743,
  -1,
  'Cj0073c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0073c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343536.1',
  'iron-sulfur protein',
  84736,
  86175,
  -1,
  'Cj0074c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0074c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343537.1',
  'oxidoreductase iron-sulfur subunit',
  86172,
  86912,
  -1,
  'Cj0075c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0075c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lctP',
  'L-lactate permease',
  87036,
  88718,
  -1,
  'Cj0076c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0076c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cdtC',
  'cytolethal distending toxin C',
  88890,
  89459,
  -1,
  'Cj0077c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0077c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cdtB',
  'cytolethal distending toxin B',
  89470,
  90267,
  -1,
  'Cj0078c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0078c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cdtA',
  'cytolethal distending toxin A',
  90264,
  91070,
  -1,
  'Cj0079c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0079c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343542.1',
  'membrane protein',
  91147,
  91416,
  1,
  'Cj0080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cydA',
  'cytochrome bd oxidase subunit I',
  91417,
  92979,
  1,
  'Cj0081',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0081'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cydB',
  'cytochrome bd oxidase subunit II',
  92979,
  94103,
  1,
  'Cj0082',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0082'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343545.1',
  'amino acid recemase',
  94297,
  94992,
  -1,
  'Cj0085c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0085c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ung',
  'uracil-DNA glycosylase',
  95108,
  95803,
  -1,
  'Cj0086c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0086c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'aspA',
  'aspartate ammonia-lyase',
  96074,
  97480,
  1,
  'Cj0087',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0087'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dcuA',
  'anaerobic C4-dicarboxylate transporter',
  97496,
  98833,
  1,
  'Cj0088',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0088'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343549.1',
  'lipoprotein',
  98941,
  100302,
  1,
  'Cj0089',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0089'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343550.1',
  'lipoprotein',
  100312,
  100680,
  1,
  'Cj0090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343551.1',
  'lipoprotein',
  100704,
  101327,
  1,
  'Cj0091',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0091'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343552.1',
  'periplasmic protein',
  101410,
  102747,
  1,
  'Cj0092',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0092'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343553.1',
  'periplasmic protein',
  102757,
  103959,
  1,
  'Cj0093',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0093'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplU',
  '50S ribosomal protein L21',
  104118,
  104426,
  1,
  'Cj0094',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0094'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpmA',
  '50S ribosomal protein L27',
  104437,
  104691,
  1,
  'Cj0095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'obgE',
  'GTPase ObgE',
  104798,
  105850,
  1,
  'Cj0096',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0096'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'proB',
  'glutamate 5-kinase',
  105955,
  106710,
  1,
  'Cj0097',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0097'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fmt',
  'methionyl-tRNA formyltransferase',
  106784,
  107701,
  1,
  'Cj0098',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0098'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'birA',
  'biotin--[acetyl-CoA-carboxylase] synthetase',
  107664,
  108317,
  1,
  'Cj0099',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0099'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343560.1',
  'ParA family protein',
  108314,
  109099,
  1,
  'Cj0100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343561.1',
  'chromosome-partitioning protein ParB',
  109105,
  109941,
  1,
  'Cj0101',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0101'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'atpF''',
  'ATP synthase subunit B''',
  110002,
  110427,
  1,
  'Cj0102',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0102'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'atpF',
  'ATP synthase subunit B',
  110438,
  110950,
  1,
  'Cj0103',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0103'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'atpH',
  'ATP synthase subunit delta',
  110953,
  111474,
  1,
  'Cj0104',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0104'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'atpA',
  'ATP synthase subunit alpha',
  111488,
  112993,
  1,
  'Cj0105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'atpG',
  'ATP synthase subunit gamma',
  113002,
  113886,
  1,
  'Cj0106',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0106'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'atpD',
  'ATP synthase subunit beta',
  113912,
  115309,
  1,
  'Cj0107',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0107'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'atpC',
  'ATP synthase subunit epsilon',
  115313,
  115702,
  1,
  'Cj0108',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0108'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'exbB3',
  'MotA/TolQ/ExbB proton channel family protein',
  115702,
  116256,
  1,
  'Cj0109',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0109'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'exbD3',
  'ExbD/TolR family transport protein',
  116265,
  116654,
  1,
  'Cj0110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343571.1',
  'periplasmic protein',
  116657,
  117436,
  1,
  'Cj0111',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0111'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tolB',
  'translocation protein TolB',
  117446,
  118654,
  1,
  'Cj0112',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0112'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pal',
  'peptidoglycan associated lipoprotein',
  118731,
  119228,
  1,
  'Cj0113',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0113'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343574.1',
  'periplasmic protein',
  119232,
  120179,
  1,
  'Cj0114',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0114'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'slyD',
  'FKBP-type peptidyl-prolyl cis-trans isomerase',
  120194,
  120763,
  1,
  'Cj0115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fabD',
  'malonyl CoA-acyl carrier protein transacylase',
  120763,
  121683,
  1,
  'Cj0116',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0116'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pfs',
  'aminodeoxyfutalosine nucleosidase',
  121680,
  122369,
  1,
  'Cj0117',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0117'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343578.1',
  'hypothetical protein',
  122366,
  123121,
  1,
  'Cj0118',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0118'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343579.1',
  'hydrolase',
  123126,
  123647,
  1,
  'Cj0119',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0119'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343580.1',
  'recombination protein RecO',
  123647,
  124261,
  1,
  'Cj0120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343581.1',
  'metalloprotease',
  124258,
  124665,
  1,
  'Cj0121',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0121'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343582.1',
  'hypothetical protein',
  124789,
  125478,
  1,
  'Cj0122',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0122'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343583.1',
  'tRNA-dihydrouridine synthase',
  125503,
  126429,
  -1,
  'Cj0123c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0123c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343584.1',
  'membrane protein',
  126426,
  127412,
  -1,
  'Cj0124c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0124c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343585.1',
  'hypothetical protein',
  127402,
  127764,
  -1,
  'Cj0125c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0125c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343586.1',
  'hypothetical protein',
  127776,
  128237,
  -1,
  'Cj0126c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0126c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'accD',
  'acetyl-CoA carboxylase carboxyl transferasesubunit beta',
  128227,
  129069,
  -1,
  'Cj0127c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0127c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343588.1',
  'inositol monophosphatase family protein',
  129078,
  129800,
  -1,
  'Cj0128c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0128c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343589.1',
  'outer membrane protein assembly factor',
  129800,
  132019,
  -1,
  'Cj0129c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0129c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tyrA',
  'prephenate dehydrogenase',
  132096,
  132923,
  1,
  'Cj0130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343591.1',
  'peptidase M23 family protein',
  133003,
  134376,
  1,
  'Cj0131',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0131'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lpxC',
  'UDP-3-O-[3-hydroxymyristoyl] N-acetylglucosaminedeacetylase',
  134376,
  135260,
  1,
  'Cj0132',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0132'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343593.1',
  'glycoprotease family protein',
  135299,
  135700,
  1,
  'Cj0133',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0133'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thrB',
  'homoserine kinase',
  135709,
  136587,
  1,
  'Cj0134',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0134'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343595.1',
  'hypothetical protein',
  136612,
  136869,
  1,
  'Cj0135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'infB',
  'translation initiation factor IF-2',
  136856,
  139471,
  1,
  'Cj0136',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0136'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rbfA',
  'ribosome-binding factor A',
  139468,
  139830,
  1,
  'Cj0137',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0137'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343598.1',
  'hypothetical protein',
  139820,
  140242,
  1,
  'Cj0138',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0138'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343599.1',
  'endonuclease',
  140289,
  142640,
  1,
  'Cj0139',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0139'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343600.1',
  'hypothetical protein',
  142633,
  143964,
  1,
  'Cj0140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343601.1',
  'ABC transporter permease',
  143953,
  144756,
  -1,
  'Cj0141c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0141c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343602.1',
  'ABC transporter ATP-binding protein',
  144749,
  145603,
  -1,
  'Cj0142c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0142c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343603.1',
  'ABC transporter substrate-binding protein',
  145616,
  146506,
  -1,
  'Cj0143c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0143c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343604.1',
  'methyl-accepting chemotaxis signal transductionprotein',
  146705,
  148684,
  1,
  'Cj0144',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0144'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343605.1',
  'TAT pathway signal sequence domain-containingprotein',
  148819,
  150600,
  1,
  'Cj0145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trxB',
  'thioredoxin reductase',
  150638,
  151576,
  -1,
  'Cj0146c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0146c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trxA',
  'thioredoxin',
  151710,
  152024,
  -1,
  'Cj0147c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0147c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343608.1',
  'hypothetical protein',
  152081,
  152419,
  -1,
  'Cj0148c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0148c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hom',
  'homoserine dehydrogenase',
  152419,
  153666,
  -1,
  'Cj0149c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0149c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343610.1',
  'aminotransferase',
  153670,
  154872,
  -1,
  'Cj0150c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0150c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343611.1',
  'periplasmic protein',
  154884,
  155690,
  -1,
  'Cj0151c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0151c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343612.1',
  'membrane protein',
  155684,
  156622,
  -1,
  'Cj0152c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0152c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343613.1',
  '23S rRNA(guanosine(2251)-2''-O)-methyltransferase RlmB',
  156615,
  157298,
  -1,
  'Cj0153c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0153c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343614.1',
  'rRNA small subunit methyltransferase I',
  157312,
  158136,
  -1,
  'Cj0154c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0154c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpmE',
  '50S ribosomal protein L31',
  158139,
  158339,
  -1,
  'Cj0155c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0155c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343616.1',
  '16S rRNA (uracil(1498)-N(3))-methyltransferase',
  158418,
  159074,
  -1,
  'Cj0156c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0156c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343617.1',
  'integral membrane protein',
  159076,
  159483,
  -1,
  'Cj0157c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0157c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343618.1',
  'heme-binding lipoprotein',
  159483,
  159908,
  -1,
  'Cj0158c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0158c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343619.1',
  '6-pyruvoyl-tetrahydropterin synthase',
  159908,
  160489,
  -1,
  'Cj0159c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0159c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343620.1',
  '7-carboxy-7-deazaguanine synthase',
  160486,
  161229,
  -1,
  'Cj0160c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0160c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'moaA',
  'cyclic pyranopterin monophosphate synthase',
  161232,
  162194,
  -1,
  'Cj0161c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0161c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343622.1',
  'periplasmic protein',
  162207,
  162722,
  -1,
  'Cj0162c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0162c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343623.1',
  'hypothetical protein',
  162719,
  163216,
  -1,
  'Cj0163c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0163c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ubiA',
  '4-hydroxybenzoate octaprenyltransferase',
  163207,
  164091,
  -1,
  'Cj0164c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0164c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'miaA',
  'tRNA dimethylallyltransferase',
  164162,
  165031,
  1,
  'Cj0166',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0166'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343626.1',
  'integral membrane protein',
  165017,
  165580,
  -1,
  'Cj0167c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0167c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAGlu',
  '—',
  165728,
  165802,
  1,
  'Cjp03',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp03'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343627.1',
  'periplasmic protein',
  165938,
  166105,
  -1,
  'Cj0168c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0168c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'sodB',
  'superoxide dismutase',
  166373,
  167035,
  1,
  'Cj0169',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0169'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343629.1',
  'hypothetical protein',
  167050,
  167794,
  1,
  'Cj0170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343630.1',
  'saccharopine dehydrogenase',
  167807,
  169012,
  -1,
  'Cj0172c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0172c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cfbpC',
  'iron-uptake ABC transporter ATP-binding protein',
  169054,
  169962,
  -1,
  'Cj0173c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0173c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cfbpB',
  'iron-uptake ABC transporter permease',
  169946,
  171562,
  -1,
  'Cj0174c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0174c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cfbpA',
  'iron-uptake ABC transporter substrate-bindingprotein',
  171562,
  172566,
  -1,
  'Cj0175c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0175c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343634.1',
  'lipoprotein',
  172563,
  172694,
  -1,
  'Cj0176c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0176c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343635.1',
  'iron transport protein',
  172916,
  173767,
  1,
  'Cj0177',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0177'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343636.1',
  'TonB-denpendent outer membrane receptor',
  173764,
  176031,
  1,
  'Cj0178',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0178'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'exbB1',
  'biopolymer transport protein',
  176043,
  176804,
  1,
  'Cj0179',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0179'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'exbD1',
  'biopolymer transport protein',
  176791,
  177201,
  1,
  'Cj0180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tonB1',
  'TonB transport protein',
  177203,
  177949,
  1,
  'Cj0181',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0181'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343640.1',
  'transmembrane transport protein',
  177995,
  179200,
  1,
  'Cj0182',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0182'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343641.1',
  'integral membrane protein',
  179299,
  180657,
  1,
  'Cj0183',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0183'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343642.1',
  'serine/threonine protein phosphatase',
  180702,
  181856,
  -1,
  'Cj0184c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0184c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343644.1',
  'TerC family integral membrane protein',
  182068,
  182787,
  -1,
  'Cj0186c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0186c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purN',
  'phosphoribosylglycinamide formyltransferase',
  182859,
  183425,
  -1,
  'Cj0187c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0187c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343646.1',
  'kinase',
  183416,
  184786,
  -1,
  'Cj0188c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0188c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343647.1',
  'hypothetical protein',
  184770,
  185468,
  -1,
  'Cj0189c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0189c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343648.1',
  'hypothetical protein',
  185470,
  186975,
  -1,
  'Cj0190c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0190c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'def',
  'peptide deformylase',
  186972,
  187499,
  -1,
  'Cj0191c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0191c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'clpP',
  'ATP-dependent Clp protease proteolytic subunit',
  187535,
  188119,
  -1,
  'Cj0192c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0192c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tig',
  'trigger factor',
  188119,
  189453,
  -1,
  'Cj0193c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0193c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'folE',
  'GTP cyclohydrolase I',
  189596,
  190168,
  1,
  'Cj0194',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0194'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliI',
  'flagellum-specific ATP synthase',
  190168,
  191553,
  1,
  'Cj0195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purF',
  'amidophosphoribosyltransferase',
  191556,
  192893,
  -1,
  'Cj0196c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0196c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dapB',
  '4-hydroxy-tetrahydrodipicolinate reductase',
  192895,
  193623,
  -1,
  'Cj0197c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0197c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343656.1',
  'recombination factor protein RarA',
  193686,
  194867,
  -1,
  'Cj0198c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0198c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343657.1',
  'periplasmic protein',
  194867,
  195988,
  -1,
  'Cj0199c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0199c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343658.1',
  'periplasmic protein',
  196123,
  196470,
  -1,
  'Cj0200c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0200c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343659.1',
  'integral membrane protein',
  196534,
  197139,
  -1,
  'Cj0201c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0201c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343661.1',
  'citrate transporter',
  197707,
  199053,
  1,
  'Cj0203',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0203'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343662.1',
  'oligopeptide transporter',
  199236,
  201233,
  1,
  'Cj0204',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0204'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'uppP',
  'undecaprenyl-diphosphatase',
  201307,
  202110,
  1,
  'Cj0205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thrS',
  'threonine--tRNA ligase',
  202241,
  204049,
  1,
  'Cj0206',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0206'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'infC',
  'translation initiation factor IF-3',
  204046,
  204564,
  1,
  'Cj0207',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0207'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343666.1',
  'DNA modification methylase',
  204603,
  205694,
  1,
  'Cj0208',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0208'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  206063,
  209195,
  1,
  'Cj0223',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0223'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'argC',
  'N-acetyl-gamma-glutamyl-phosphate reductase',
  209279,
  210307,
  1,
  'Cj0224',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0224'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343668.1',
  'acetyltransferase',
  210317,
  210763,
  1,
  'Cj0225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'argB',
  'acetylglutamate kinase',
  210767,
  211612,
  1,
  'Cj0226',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0226'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'argD',
  'acetylornithine aminotransferase',
  211616,
  212803,
  1,
  'Cj0227',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0227'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pcm',
  'protein-L-isoaspartate O-methyltransferase',
  212822,
  213451,
  -1,
  'Cj0228c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0228c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343672.1',
  'acetyltransferase',
  213540,
  214088,
  1,
  'Cj0229',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0229'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343673.1',
  'nicotinate phosphoribosyltransferase',
  214057,
  215430,
  -1,
  'Cj0230c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0230c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nrdF',
  'ribonucleotide-diphosphate reductase subunitbeta',
  215417,
  216439,
  -1,
  'Cj0231c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0231c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343675.1',
  'integral membrane protein',
  216453,
  216863,
  -1,
  'Cj0232c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0232c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pyrE',
  'orotate phosphoribosyltransferase',
  216864,
  217472,
  -1,
  'Cj0233c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0233c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'frr',
  'ribosome recycling factor',
  217475,
  218038,
  -1,
  'Cj0234c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0234c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'secG',
  'protein translocase subunit SecG',
  218048,
  218419,
  -1,
  'Cj0235c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0235c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343679.1',
  'integral membrane protein',
  218523,
  219218,
  -1,
  'Cj0236c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0236c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cynT',
  'carbonic anhydrase',
  219378,
  220013,
  1,
  'Cj0237',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0237'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343681.1',
  'mechanosensitive ion channel family protein',
  220010,
  221893,
  1,
  'Cj0238',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0238'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343682.1',
  'nitrogen fixation protein NifU',
  221916,
  222887,
  -1,
  'Cj0239c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0239c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'iscS',
  'cysteine desulfurase',
  222897,
  224078,
  -1,
  'Cj0240c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0240c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343684.1',
  'bacteriohemerythrin',
  224256,
  224657,
  -1,
  'Cj0241c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0241c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343685.1',
  'hypothetical protein',
  224794,
  225960,
  -1,
  'Cj0243c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0243c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpmI',
  '50S ribosomal protein L35',
  226116,
  226307,
  1,
  'Cj0244',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0244'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplT',
  '50S ribosomal protein L20',
  226401,
  226754,
  1,
  'Cj0245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343690.1',
  'hypothetical protein',
  228946,
  229803,
  1,
  'Cj0248',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0248'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343691.1',
  'hypothetical protein',
  229831,
  230310,
  1,
  'Cj0249',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0249'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343692.1',
  'MFS transport protein',
  230279,
  231589,
  -1,
  'Cj0250c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0250c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343693.1',
  'highly acidic protein',
  231592,
  231747,
  -1,
  'Cj0251c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0251c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'moaC',
  'cyclic pyranopterin monophosphate synthaseaccessory protein',
  231840,
  232313,
  1,
  'Cj0252',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0252'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343695.1',
  'hypothetical protein',
  232291,
  232554,
  1,
  'Cj0253',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0253'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343696.1',
  'hypothetical protein',
  232544,
  233704,
  1,
  'Cj0254',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0254'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'exoA',
  'exodeoxyribonuclease',
  233723,
  234481,
  -1,
  'Cj0255c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0255c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343698.1',
  'sulfatase family protein',
  234599,
  236137,
  1,
  'Cj0256',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0256'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dgkA',
  'diacylglycerol kinase',
  236134,
  236490,
  1,
  'Cj0257',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0257'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343700.1',
  'ArsR family transcriptional regulator',
  236487,
  236732,
  1,
  'Cj0258',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0258'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pyrC',
  'dihydroorotase',
  236722,
  237729,
  1,
  'Cj0259',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0259'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343702.1',
  'hypothetical protein',
  237761,
  237976,
  -1,
  'Cj0260c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0260c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343703.1',
  'SAM-dependent methyltransferase',
  238032,
  238751,
  -1,
  'Cj0261c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0261c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343704.1',
  'methyl-accepting chemotaxis signal transductionprotein',
  238832,
  240829,
  -1,
  'Cj0262c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0262c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343705.1',
  'zinc transporter ZupT',
  241022,
  241897,
  1,
  'Cj0263',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0263'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343706.1',
  'molybdopterin containing oxidoreductase',
  241921,
  244437,
  -1,
  'Cj0264c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0264c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343707.1',
  'cytochrome C-type heme-binding protein',
  244448,
  245023,
  -1,
  'Cj0265c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0265c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343708.1',
  'integral membrane protein',
  245504,
  246013,
  -1,
  'Cj0266c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0266c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343709.1',
  'integral membrane protein',
  246013,
  246543,
  -1,
  'Cj0267c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0267c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343710.1',
  'transmembrane protein',
  246555,
  247643,
  -1,
  'Cj0268c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0268c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ilvE',
  'branched-chain amino acid aminotransferase',
  247656,
  248570,
  -1,
  'Cj0269c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0269c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343712.1',
  'tautomerase family protein',
  248747,
  248953,
  1,
  'Cj0270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343713.1',
  'bacterioferritin comigratory protein',
  248950,
  249405,
  1,
  'Cj0271',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0271'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343714.1',
  'hypothetical protein',
  249405,
  250496,
  1,
  'Cj0272',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0272'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fabZ',
  '3-hydroxyacyl-ACP dehydratase',
  250590,
  251030,
  1,
  'Cj0273',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0273'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lpxA',
  'acyl-[acyl-carrier-protein]--UDP-N-acetylglucosamine O-acyltransferase',
  251030,
  251821,
  1,
  'Cj0274',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0274'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'clpX',
  'ATP-dependent protease ATP-binding subunit ClpX',
  251784,
  253037,
  1,
  'Cj0275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mreB',
  'rod shape-determining protein MreB',
  253049,
  254089,
  1,
  'Cj0276',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0276'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mreC',
  'rod shape-determining protein MreC',
  254079,
  254828,
  1,
  'Cj0277',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0277'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'carB',
  'carbamoyl phosphate synthase large subunit',
  255089,
  258358,
  1,
  'Cj0279',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0279'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343721.1',
  'hypothetical protein',
  258355,
  258777,
  1,
  'Cj0280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tal',
  'transaldolase',
  258778,
  259755,
  -1,
  'Cj0281c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0281c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'serB',
  'phosphoserine phosphatase',
  259755,
  260378,
  -1,
  'Cj0282c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0282c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cheW',
  'chemotaxis protein',
  260378,
  260899,
  -1,
  'Cj0283c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0283c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cheA',
  'chemotaxis histidine kinase',
  260904,
  263213,
  -1,
  'Cj0284c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0284c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cheV',
  'chemotaxis protein',
  263217,
  264173,
  -1,
  'Cj0285c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0285c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343727.1',
  'hypothetical protein',
  264166,
  264783,
  -1,
  'Cj0286c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0286c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'greA',
  'transcription elongation factor GreA',
  264934,
  265419,
  -1,
  'Cj0287c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0287c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lpxB',
  'ipid-A-disaccharide synthase',
  265431,
  266525,
  -1,
  'Cj0288c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0288c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'peb3',
  'major antigenic peptide PEB3',
  266622,
  267374,
  -1,
  'Cj0289c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0289c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glpT',
  '—',
  267516,
  268809,
  -1,
  'Cj0292c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0292c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'surE',
  '5''-nucleotidase SurE',
  269064,
  269840,
  1,
  'Cj0293',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0293'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343732.1',
  'MoeB/ThiF family protein',
  269830,
  270489,
  1,
  'Cj0294',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0294'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343733.1',
  'acetyltransferase',
  270473,
  270931,
  1,
  'Cj0295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'panD',
  'aspartate 1-decarboxylase',
  271041,
  271421,
  -1,
  'Cj0296c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0296c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'panC',
  'pantothenate synthetase',
  271418,
  272266,
  -1,
  'Cj0297c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0297c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'panB',
  '3-methyl-2-oxobutanoatehydroxymethyltransferase',
  272277,
  273101,
  -1,
  'Cj0298c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0298c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343737.1',
  'beta-lactamase',
  273321,
  274094,
  1,
  'Cj0299',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0299'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'modC',
  'molybdenum ABC transporter ATP-binding protein',
  274179,
  275063,
  -1,
  'Cj0300c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0300c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'modB',
  'molybdenum ABC transporter permease',
  275060,
  275734,
  -1,
  'Cj0301c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0301c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343740.1',
  'molybdenum-pterin-binding protein',
  275727,
  276128,
  -1,
  'Cj0302c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0302c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'modA',
  'molybdenum ABC transporter substrate-bindinglipoprotein',
  276125,
  276874,
  -1,
  'Cj0303c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0303c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'bioC',
  'biotin synthesis protein',
  276925,
  277611,
  -1,
  'Cj0304c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0304c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343743.1',
  'hypothetical protein',
  277608,
  278219,
  -1,
  'Cj0305c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0305c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'bioF',
  '8-amino-7-oxononanoate synthase',
  278216,
  279358,
  -1,
  'Cj0306c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0306c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'bioA',
  'adenosylmethionine--8-amino-7-oxononanoateaminotransferase BioA',
  279426,
  280709,
  1,
  'Cj0307',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0307'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'bioD',
  'dethiobiotin synthetase',
  280696,
  281301,
  -1,
  'Cj0308c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0308c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343747.1',
  'efflux protein',
  281311,
  281625,
  -1,
  'Cj0309c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0309c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343748.1',
  'efflux protein',
  281629,
  281967,
  -1,
  'Cj0310c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0310c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343749.1',
  '50S ribosomal protein L25/general stress proteinCtc',
  282101,
  282637,
  1,
  'Cj0311',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0311'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pth',
  'peptidyl-tRNA hydrolase',
  282634,
  283179,
  1,
  'Cj0312',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0312'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343751.1',
  'integral membrane protein',
  283181,
  284239,
  1,
  'Cj0313',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0313'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lysA',
  'diaminopimelate decarboxylase',
  284283,
  285491,
  1,
  'Cj0314',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0314'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343753.1',
  'HAD-superfamily hydrolase',
  285493,
  286260,
  1,
  'Cj0315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pheA',
  'bifunctional chorismate mutase/prephenatedehydratase',
  286248,
  287321,
  1,
  'Cj0316',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0316'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisC',
  'histidinol-phosphate aminotransferase',
  287311,
  288405,
  1,
  'Cj0317',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0317'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliF',
  'flagellar MS-ring protein',
  288457,
  290139,
  1,
  'Cj0318',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0318'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliG',
  'flagellar motor switch protein',
  290139,
  291167,
  1,
  'Cj0319',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0319'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliH',
  'flagellar assembly protein FliH',
  291175,
  292005,
  1,
  'Cj0320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dxs',
  '1-deoxy-D-xylulose-5-phosphate synthase',
  291998,
  293845,
  1,
  'Cj0321',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0321'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'perR',
  'peroxide stress regulator',
  293931,
  294341,
  1,
  'Cj0322',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0322'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343761.1',
  'hypothetical protein',
  294387,
  295583,
  1,
  'Cj0323',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0323'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ubiE',
  'ubiquinone/menaquinone biosynthesismethyltransferase',
  295586,
  296293,
  1,
  'Cj0324',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0324'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'xseA',
  'exodeoxyribonuclease VII large subunit',
  296290,
  297453,
  1,
  'Cj0325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'serC',
  '3-phosphoserine/phosphohydroxythreonineaminotransferase',
  297463,
  298539,
  1,
  'Cj0326',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0326'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343765.1',
  'endoribonuclease L-PSP family protein',
  298536,
  298886,
  1,
  'Cj0327',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0327'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fabH',
  '3-oxoacyl-ACP synthase III',
  298883,
  299857,
  -1,
  'Cj0328c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0328c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'plsX',
  'phosphate acyltransferase',
  299850,
  300836,
  -1,
  'Cj0329c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0329c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpmF',
  '50S ribosomal protein L32',
  300842,
  300988,
  -1,
  'Cj0330c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0330c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343769.1',
  'hypothetical protein',
  301012,
  301365,
  -1,
  'Cj0331c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0331c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ndk',
  'nucleoside diphosphate kinase',
  301366,
  301779,
  -1,
  'Cj0332c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0332c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fdxA',
  'ferredoxin',
  301892,
  302176,
  -1,
  'Cj0333c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0333c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ahpC',
  'alkyl hydroperoxide reductase',
  302383,
  302979,
  1,
  'Cj0334',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0334'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flhB',
  'flagellar biosynthesis protein FlhB',
  303098,
  304186,
  1,
  'Cj0335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'motB',
  'flagellar motor protein MotB',
  304192,
  304935,
  -1,
  'Cj0336c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0336c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'motA',
  'flagellar motor protein MotA',
  304938,
  305714,
  -1,
  'Cj0337c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0337c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'polA',
  'DNA polymerase I',
  305730,
  308369,
  -1,
  'Cj0338c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0338c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343777.1',
  'MFS transport protein',
  308533,
  309894,
  1,
  'Cj0339',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0339'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343778.1',
  'nucleoside hydrolase',
  309891,
  310898,
  1,
  'Cj0340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343779.1',
  'integral membrane protein',
  310854,
  311297,
  -1,
  'Cj0341c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0341c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'uvrA',
  'excinuclease ABC subunit A',
  311302,
  314127,
  -1,
  'Cj0342c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0342c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343781.1',
  'integral membrane protein',
  314200,
  314985,
  -1,
  'Cj0343c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0343c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343782.1',
  'hypothetical protein',
  315108,
  315233,
  1,
  'Cj0344',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0344'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trpE',
  'anthranilate synthase subunit I',
  315398,
  316648,
  1,
  'Cj0345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trpD',
  'anthranilate synthase subunit II',
  316645,
  318246,
  1,
  'Cj0346',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0346'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trpF',
  'N-(5''-phosphoribosyl)anthranilate isomerase',
  318233,
  318832,
  1,
  'Cj0347',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0347'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trpB',
  'tryptophan synthase subunit beta',
  318829,
  320007,
  1,
  'Cj0348',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0348'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trpA',
  'tryptophan synthase subunit alpha',
  320000,
  320749,
  1,
  'Cj0349',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0349'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343788.1',
  'hypothetical protein',
  320820,
  321242,
  1,
  'Cj0350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliN',
  'flagellar motor switch protein',
  321242,
  321550,
  1,
  'Cj0351',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0351'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343790.1',
  'transmembrane protein',
  321551,
  322348,
  1,
  'Cj0352',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0352'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343791.1',
  'phosphatase',
  322345,
  323805,
  -1,
  'Cj0353c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0353c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fdxB',
  'ferredoxin',
  323805,
  324050,
  -1,
  'Cj0354c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0354c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343793.1',
  'two-component regulator',
  324163,
  324834,
  -1,
  'Cj0355c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0355c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'folB',
  'dihydroneopterin aldolase',
  324913,
  325230,
  -1,
  'Cj0356c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0356c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343795.1',
  'glycerol-3-phosphate acyltransferase PlsY',
  325215,
  325823,
  -1,
  'Cj0357c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0357c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343796.1',
  'cytochrome C551 peroxidase',
  326024,
  327049,
  1,
  'Cj0358',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0358'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glmM',
  'phosphoglucosamine mutase',
  327143,
  328480,
  1,
  'Cj0360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lspA',
  'lipoprotein signal peptidase',
  328473,
  328943,
  1,
  'Cj0361',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0361'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343799.1',
  'integral membrane protein',
  328927,
  329379,
  1,
  'Cj0362',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0362'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343800.1',
  'coproporphyrinogen III oxidase',
  329376,
  330722,
  -1,
  'Cj0363c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0363c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343801.1',
  'hypothetical protein',
  330851,
  331102,
  1,
  'Cj0364',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0364'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cmeC',
  'multidrug efflux pump protein CmeC',
  331125,
  332603,
  -1,
  'Cj0365c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0365c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cmeB',
  'multidrug efflux pump protein CmeB',
  332596,
  335718,
  -1,
  'Cj0366c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0366c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cmeA',
  'multidrug efflux pump protein CmeA',
  335718,
  336821,
  -1,
  'Cj0367c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0367c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cmeR',
  'transcriptional regulator CmeR',
  336916,
  337548,
  -1,
  'Cj0368c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0368c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343806.1',
  'ferredoxin domain-containing integral membraneprotein',
  337535,
  338911,
  -1,
  'Cj0369c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0369c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsU',
  '30S ribosomal protein S21',
  339071,
  339283,
  1,
  'Cj0370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343808.1',
  'hypothetical protein',
  339403,
  340008,
  1,
  'Cj0371',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0371'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343809.1',
  'glutathionylspermidine synthase',
  340018,
  341187,
  1,
  'Cj0372',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0372'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343810.1',
  '2-hydroxyacid dehydrogenase',
  341190,
  342125,
  1,
  'Cj0373',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0373'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343811.1',
  'nucleotide-binding protein',
  342115,
  342606,
  1,
  'Cj0374',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0374'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343812.1',
  'lipoprotein',
  342615,
  343091,
  1,
  'Cj0375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343813.1',
  'periplasmic protein',
  343102,
  343926,
  1,
  'Cj0376',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0376'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343814.1',
  'AAA ATPase',
  343926,
  345638,
  1,
  'Cj0377',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0377'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343815.1',
  'ferric reductase-like transmembrane protein',
  345635,
  346174,
  -1,
  'Cj0378c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0378c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343816.1',
  'sulfoxide reductase catalytic subunit',
  346174,
  347067,
  -1,
  'Cj0379c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0379c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343817.1',
  'hypothetical protein',
  347123,
  347908,
  -1,
  'Cj0380c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0380c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pyrF',
  'orotidine 5''-phosphate decarboxylase',
  347905,
  348744,
  -1,
  'Cj0381c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0381c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nusB',
  'transcription antitermination protein NusB',
  348741,
  349139,
  -1,
  'Cj0382c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0382c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ribH',
  '6,7-dimethyl-8-ribityllumazine synthase',
  349139,
  349603,
  -1,
  'Cj0383c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0383c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kdsA',
  '2-dehydro-3-deoxyphosphooctonate aldolase',
  349600,
  350415,
  -1,
  'Cj0384c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0384c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343822.1',
  'integral membrane protein',
  350412,
  351344,
  -1,
  'Cj0385c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0385c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'engA',
  'GTPase Der',
  351446,
  352828,
  1,
  'Cj0386',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0386'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'aroK',
  'shikimate kinase',
  352815,
  353312,
  1,
  'Cj0387',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0387'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trpS',
  'tryptophan--tRNA ligase',
  353309,
  354268,
  1,
  'Cj0388',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0388'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'serS',
  'serine--tRNA ligase',
  354279,
  355514,
  1,
  'Cj0389',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0389'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343827.1',
  'transmembrane protein',
  355524,
  357986,
  1,
  'Cj0390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343828.1',
  'hypothetical protein',
  358017,
  358652,
  -1,
  'Cj0391c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0391c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pyk',
  'pyruvate kinase',
  358750,
  360192,
  -1,
  'Cj0392c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0392c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mqo',
  'malate:quinone oxidoreductase',
  360241,
  361587,
  -1,
  'Cj0393c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0393c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343831.1',
  'pantothenate kinase',
  361706,
  362335,
  -1,
  'Cj0394c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0394c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343832.1',
  'hypothetical protein',
  362322,
  362612,
  -1,
  'Cj0395c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0395c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343833.1',
  'lipoprotein',
  362609,
  363607,
  -1,
  'Cj0396c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0396c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343834.1',
  'hypothetical protein',
  363604,
  364182,
  -1,
  'Cj0397c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0397c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gatC',
  'glutamyl-tRNA(Gln) amidotransferase subunit C',
  364326,
  364610,
  1,
  'Cj0398',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0398'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343836.1',
  'colicin V production protein',
  364678,
  365241,
  1,
  'Cj0399',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0399'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fur',
  'ferric uptake regulator',
  365243,
  365716,
  1,
  'Cj0400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lysS',
  'lysine--tRNA ligase',
  365717,
  367222,
  1,
  'Cj0401',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0401'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glyA',
  'serine hydroxymethyltransferase',
  367219,
  368463,
  1,
  'Cj0402',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0402'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343840.1',
  'hypothetical protein',
  368460,
  369005,
  1,
  'Cj0403',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0403'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343841.1',
  'transmembrane protein',
  369019,
  369855,
  1,
  'Cj0404',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0404'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'aroE',
  'shikimate 5-dehydrogenase',
  369852,
  370640,
  1,
  'Cj0405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343843.1',
  'lipoprotein',
  370715,
  371614,
  -1,
  'Cj0406c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0406c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lgt',
  'prolipoprotein diacylglyceryl transferase',
  371704,
  372519,
  1,
  'Cj0407',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0407'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'frdC',
  'fumarate reductase cytochrome B subunit',
  372589,
  373371,
  1,
  'Cj0408',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0408'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'frdA',
  'fumarate reductase flavoprotein subunit',
  373355,
  375346,
  1,
  'Cj0409',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0409'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'frdB',
  'fumarate reductase iron-sulfur subunit',
  375339,
  376064,
  1,
  'Cj0410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343848.1',
  'ATP/GTP binding protein',
  376092,
  378278,
  1,
  'Cj0411',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0411'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343849.1',
  'ATP/GTP binding protein',
  378268,
  380097,
  1,
  'Cj0412',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0412'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343850.1',
  'periplasmic protein',
  380097,
  380801,
  1,
  'Cj0413',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0413'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343851.1',
  'oxidoreductase subunit',
  380937,
  381665,
  1,
  'Cj0414',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0414'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343852.1',
  'GMC oxidoreductase subunit',
  381667,
  383388,
  1,
  'Cj0415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343853.1',
  'hypothetical protein',
  383559,
  383657,
  1,
  'Cj0416',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0416'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343854.1',
  'hypothetical protein',
  383677,
  383823,
  1,
  'Cj0417',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0417'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343855.1',
  'hypothetical protein',
  383947,
  384651,
  -1,
  'Cj0418c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0418c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343856.1',
  'histidine triad (HIT) family protein',
  384759,
  385121,
  1,
  'Cj0419',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0419'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343857.1',
  'periplasmic protein',
  385195,
  385767,
  1,
  'Cj0420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343858.1',
  'integral membrane protein',
  385772,
  386728,
  -1,
  'Cj0421c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0421c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343859.1',
  'H-T-H containing protein',
  386790,
  386999,
  -1,
  'Cj0422c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0422c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343860.1',
  'integral membrane protein',
  387168,
  387395,
  1,
  'Cj0423',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0423'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343861.1',
  'acidic periplasmic protein',
  387404,
  388036,
  1,
  'Cj0424',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0424'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343862.1',
  'periplasmic protein',
  388049,
  388465,
  1,
  'Cj0425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343863.1',
  'ABC transporter ATP-binding protein',
  388595,
  390172,
  1,
  'Cj0426',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0426'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343864.1',
  'hypothetical protein',
  390162,
  390497,
  1,
  'Cj0427',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0427'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343865.1',
  'hypothetical protein',
  390572,
  390955,
  1,
  'Cj0428',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0428'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343866.1',
  'hypothetical protein',
  390999,
  391583,
  -1,
  'Cj0429c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0429c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343867.1',
  'integral membrane protein',
  391711,
  392937,
  1,
  'Cj0430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343868.1',
  'ATP/GTP-binding protein',
  392930,
  393544,
  1,
  'Cj0431',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0431'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  394130,
  395642,
  1,
  'Cjr04',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjr04'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAAla',
  '—',
  395747,
  395822,
  1,
  'Cjp04',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp04'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAIle',
  '—',
  395831,
  395907,
  1,
  'Cjp05',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp05'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  396449,
  399360,
  1,
  'Cjr05',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjr05'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  399644,
  399763,
  1,
  'Cjr06',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjr06'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'murD',
  'UDP-N-acetylmuramoylalanine--D-glutamate ligase',
  399936,
  401144,
  -1,
  'Cj0432c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0432c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mraY',
  'phospho-N-acetylmuramoyl-pentapeptide-transferase',
  401144,
  402205,
  -1,
  'Cj0433c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0433c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pgm',
  '2,3-bisphosphoglycerate-independentphosphoglycerate mutase',
  402285,
  403763,
  1,
  'Cj0434',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0434'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fabG',
  '3-oxoacyl-ACP reductase',
  403835,
  404578,
  1,
  'Cj0435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343873.1',
  'pyridoxamine 5''-phosphate oxidase',
  404585,
  404995,
  1,
  'Cj0436',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0436'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'sdhA',
  'succinate dehydrogenase flavoprotein subunit',
  405333,
  407168,
  1,
  'Cj0437',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0437'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'sdhB',
  'succinate dehydrogenase iron-sulfur protein',
  407165,
  408130,
  1,
  'Cj0438',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0438'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'sdhC',
  'succinate dehydrogenase subunit C',
  408134,
  408991,
  1,
  'Cj0439',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0439'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343877.1',
  'transcriptional regulator',
  409015,
  409683,
  -1,
  'Cj0440c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0440c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'acpP',
  'acyl carrier protein',
  409793,
  410026,
  1,
  'Cj0441',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0441'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fabF',
  '3-oxoacyl-ACP synthase',
  410053,
  411267,
  1,
  'Cj0442',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0442'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'accA',
  'acetyl-CoA carboxylase carboxyl transferasesubunit alpha',
  411269,
  412207,
  1,
  'Cj0443',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0443'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  412359,
  414430,
  1,
  'Cj0444',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0444'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343881.1',
  'NUDIX hydrolase family protein',
  414516,
  415112,
  1,
  'Cj0447',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0447'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343882.1',
  'MCP-type signal transduction protein',
  415144,
  416241,
  -1,
  'Cj0448c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0448c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343883.1',
  'hypothetical protein',
  416251,
  416466,
  -1,
  'Cj0449c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0449c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpmB',
  '50S ribosomal protein L28',
  416651,
  416845,
  -1,
  'Cj0450c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0450c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rep',
  'ribulose-phosphate 3-epimerase',
  416985,
  417632,
  1,
  'Cj0451',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0451'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dnaQ',
  'DNA polymerase III subunit epsilon',
  417629,
  418390,
  1,
  'Cj0452',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0452'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  418412,
  418516,
  1,
  'Cjs02',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjs02'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thiC',
  'phosphomethylpyrimidine synthase',
  418573,
  419865,
  1,
  'Cj0453',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0453'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343888.1',
  'membrane protein',
  419857,
  420426,
  -1,
  'Cj0454c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0454c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  420365,
  420892,
  -1,
  'Cj0455c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0455c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343890.1',
  'hypothetical protein',
  420889,
  421848,
  -1,
  'Cj0456c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0456c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343891.1',
  'lipoprotein',
  421850,
  422479,
  -1,
  'Cj0457c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0457c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'miaB',
  'tRNA-2-methylthio-N(6)-dimethylallyladenosinesynthase',
  422463,
  423764,
  -1,
  'Cj0458c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0458c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343893.1',
  'hypothetical protein',
  423761,
  424027,
  -1,
  'Cj0459c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0459c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nusA',
  'transcription elongation factor NusA',
  424131,
  425219,
  1,
  'Cj0460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343895.1',
  'MFS transport protein',
  425235,
  426422,
  -1,
  'Cj0461c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0461c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343896.1',
  'hypothetical protein',
  426496,
  427542,
  1,
  'Cj0462',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0462'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343897.1',
  'zinc protease-like protein',
  427542,
  428762,
  1,
  'Cj0463',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0463'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'recG',
  'ATP-dependent DNA helicase RecG',
  428752,
  430575,
  1,
  'Cj0464',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0464'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ctb',
  'group 3 truncated hemoglobin',
  430572,
  430955,
  -1,
  'Cj0465c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0465c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nssR',
  'transcriptional regulator',
  431050,
  431646,
  1,
  'Cj0466',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0466'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343901.1',
  'amino acid ABC transporter permease',
  431662,
  432363,
  1,
  'Cj0467',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0467'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343902.1',
  'amino acid ABC transporter permease',
  432356,
  433012,
  1,
  'Cj0468',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0468'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343903.1',
  'amino acid ABC transporter ATP-binding protein',
  433014,
  433775,
  1,
  'Cj0469',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0469'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAThr',
  '—',
  433867,
  433942,
  1,
  'Cjp06',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp06'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNATyr',
  '—',
  433992,
  434077,
  1,
  'Cjp07',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp07'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAGly',
  '—',
  434084,
  434160,
  1,
  'Cjp08',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp08'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAThr',
  '—',
  434265,
  434339,
  1,
  'Cjt1',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjt1'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tuf',
  'elongation factor Tu',
  434408,
  435607,
  1,
  'Cj0470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpmG',
  '50S ribosomal protein L33',
  435660,
  435818,
  1,
  'Cj0471',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0471'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNATrp',
  '—',
  435831,
  435906,
  1,
  'Cjp09',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp09'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'secE',
  'protein translocase subunit SecE',
  435925,
  436104,
  1,
  'Cj0472',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0472'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nusG',
  'transcription termination/antiterminationprotein NusG',
  436114,
  436647,
  1,
  'Cj0473',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0473'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplK',
  '50S ribosomal protein L11',
  436673,
  437098,
  1,
  'Cj0474',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0474'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplA',
  '50S ribosomal protein L1',
  437153,
  437854,
  1,
  'Cj0475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplJ',
  '50S ribosomal protein L10',
  438006,
  438485,
  1,
  'Cj0476',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0476'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplL',
  '50S ribosomal protein L7/L12',
  438506,
  438883,
  1,
  'Cj0477',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0477'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpoB',
  'DNA-directed RNA polymerase subunit beta',
  438992,
  443128,
  1,
  'Cj0478',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0478'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpoC',
  'DNA-directed RNA polymerase subunit beta''',
  443121,
  447674,
  1,
  'Cj0479',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0479'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343914.1',
  'transcriptional regulator',
  447705,
  448466,
  -1,
  'Cj0480c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0480c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dapA',
  'dihydrodipicolinate synthase',
  448697,
  449605,
  1,
  'Cj0481',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0481'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'uxaA''',
  '—',
  449602,
  451034,
  1,
  'Cj0483',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0483'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  451046,
  452278,
  1,
  'Cj0484',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0484'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343919.1',
  'short chain dehydrogenase',
  452320,
  453108,
  1,
  'Cj0485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343920.1',
  'sugar transporter',
  453119,
  454375,
  1,
  'Cj0486',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0486'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343921.1',
  'amidohydrolase',
  454359,
  455129,
  1,
  'Cj0487',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0487'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343922.1',
  'hypothetical protein',
  455130,
  455447,
  1,
  'Cj0488',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0488'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  455461,
  456899,
  1,
  'Cj0489',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0489'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsL',
  '30S ribosomal protein S12',
  457227,
  457613,
  1,
  'Cj0491',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0491'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsG',
  '30S ribosomal protein S7',
  457683,
  458153,
  1,
  'Cj0492',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0492'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fusA',
  'elongation factor G',
  458166,
  460241,
  1,
  'Cj0493',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0493'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAArg',
  '—',
  460270,
  460346,
  1,
  'Cjp10',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp10'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343928.1',
  'exporting protein',
  460364,
  460513,
  1,
  'Cj0494',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0494'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343929.1',
  'methyltransferase domain-containing protein',
  460519,
  461220,
  1,
  'Cj0495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343930.1',
  'hypothetical protein',
  461210,
  461584,
  1,
  'Cj0496',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0496'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343931.1',
  'lipoprotein',
  461557,
  462834,
  1,
  'Cj0497',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0497'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trpC',
  'Indole-3-glycerol phosphate synthase',
  462831,
  463607,
  1,
  'Cj0498',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0498'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343933.1',
  'histidine triad (HIT) family protein',
  463617,
  464102,
  1,
  'Cj0499',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0499'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343934.1',
  'rhodanese-like domain-containing protein',
  464092,
  465090,
  1,
  'Cj0500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  465376,
  466598,
  1,
  'Cj0501',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0501'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hemH',
  'ferrochelatase',
  466660,
  467571,
  -1,
  'Cj0503c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0503c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343936.1',
  'oxidoreductase',
  467568,
  468434,
  -1,
  'Cj0504c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0504c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343937.1',
  'DegT family aminotransferase',
  468439,
  469512,
  -1,
  'Cj0505c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0505c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'alaS',
  'alanine--tRNA ligase',
  469627,
  472155,
  1,
  'Cj0506',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0506'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'maf',
  'Maf-like protein',
  472155,
  472706,
  1,
  'Cj0507',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0507'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pbpA',
  'penicillin-binding protein',
  472703,
  474634,
  1,
  'Cj0508',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0508'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'clpB',
  'chaperone protein ClpB',
  474662,
  477235,
  -1,
  'Cj0509c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0509c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343942.1',
  'hypothetical protein',
  477347,
  477637,
  -1,
  'Cj0510c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0510c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343943.1',
  'protease',
  477755,
  479089,
  1,
  'Cj0511',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0511'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purC',
  'phosphoribosylaminoimidazolesuccinocarboxamidesynthase',
  479091,
  479801,
  1,
  'Cj0512',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0512'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purS',
  'phosphoribosylformylglycinamidine synthase',
  479810,
  480055,
  1,
  'Cj0513',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0513'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purQ',
  'phosphoribosylformylglycinamidine synthase I',
  480057,
  480728,
  1,
  'Cj0514',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0514'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343947.1',
  'periplasmic protein',
  480700,
  481896,
  1,
  'Cj0515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'plsC',
  '1-acyl-SN-glycerol-3-phosphate acyltransferase',
  481877,
  482569,
  1,
  'Cj0516',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0516'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'crcB',
  'fluoride ion transporter CrcB',
  482563,
  482931,
  1,
  'Cj0517',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0517'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'htpG',
  'chaperone protein HtpG',
  483003,
  484829,
  1,
  'Cj0518',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0518'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343951.1',
  'rhodanese-like domain-containing protein',
  484826,
  485143,
  1,
  'Cj0519',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0519'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343952.1',
  'membrane protein',
  485143,
  485577,
  1,
  'Cj0520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  485698,
  487343,
  1,
  'Cj0522',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0522'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pbpB',
  'penicillin-binding protein',
  487340,
  489148,
  -1,
  'Cj0525c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0525c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliE',
  'flagellar hook-basal body protein FliE',
  489155,
  489451,
  -1,
  'Cj0526c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0526c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgC',
  'flagellar basal body rod protein FlgC',
  489458,
  489952,
  -1,
  'Cj0527c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0527c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgB',
  'flagellar basal body rod protein FlgB',
  489962,
  490393,
  -1,
  'Cj0528c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0528c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343960.1',
  'aminodeoxychorismate lyase family protein',
  490474,
  491475,
  -1,
  'Cj0529c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0529c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343961.1',
  'periplasmic protein',
  491390,
  493960,
  1,
  'Cj0530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'icd',
  'isocitrate dehydrogenase',
  494077,
  496281,
  1,
  'Cj0531',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0531'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mdh',
  'malate dehydrogenase',
  496278,
  497180,
  1,
  'Cj0532',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0532'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'sucC',
  'succinyl-CoA ligase subunit beta',
  497181,
  498344,
  1,
  'Cj0533',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0533'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'sucD',
  'succinyl-CoA synthetase subunit alpha',
  498354,
  499223,
  1,
  'Cj0534',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0534'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'oorD',
  '2-oxoglutarate-acceptor oxidoreductase subunitOorD',
  499238,
  499549,
  1,
  'Cj0535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'oorA',
  '2-oxoglutarate-acceptor oxidoreductase subunitOorA',
  499558,
  500682,
  1,
  'Cj0536',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0536'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'oorB',
  '2-oxoglutarate-acceptor oxidoreductase subunitOorB',
  500683,
  501528,
  1,
  'Cj0537',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0537'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'oorC',
  '2-oxoglutarate-acceptor oxidoreductase subunitOorC',
  501525,
  502082,
  1,
  'Cj0538',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0538'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343970.1',
  'hypothetical protein',
  502221,
  502484,
  1,
  'Cj0539',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0539'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343971.1',
  'exporting protein',
  502487,
  503023,
  1,
  'Cj0540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343972.1',
  'polyprenyl synthetase',
  503037,
  503930,
  1,
  'Cj0541',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0541'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hemA',
  'glutamyl-tRNA reductase',
  503930,
  505228,
  1,
  'Cj0542',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0542'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'proS',
  'proline--tRNA ligase',
  505212,
  506921,
  1,
  'Cj0543',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0543'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343975.1',
  'integral membrane protein',
  506918,
  507307,
  1,
  'Cj0544',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0544'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hemC',
  'porphobilinogen deaminase',
  507304,
  508227,
  1,
  'Cj0545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ubiD',
  '3-octaprenyl-4-hydroxybenzoate carboxy-lyase',
  508224,
  510026,
  1,
  'Cj0546',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0546'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flaG',
  'flagellar protein FlaG',
  510184,
  510549,
  1,
  'Cj0547',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0547'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliD',
  'flagellar hook-associated protein 2',
  510552,
  512480,
  1,
  'Cj0548',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0548'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliS',
  'flagellar protein FliS',
  512492,
  512878,
  1,
  'Cj0549',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0549'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343981.1',
  'hypothetical protein',
  512859,
  513134,
  1,
  'Cj0550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rnpB',
  '—',
  513138,
  513451,
  -1,
  'Cjp11',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp11'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'efp',
  'elongation factor P',
  513566,
  514135,
  1,
  'Cj0551',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0551'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343983.1',
  'membrane protein',
  514295,
  514987,
  1,
  'Cj0552',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0552'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343984.1',
  'integral membrane protein',
  514974,
  515927,
  1,
  'Cj0553',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0553'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343985.1',
  'hypothetical protein',
  515937,
  516941,
  1,
  'Cj0554',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0554'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343986.1',
  'dicarboxylate carrier protein MatC',
  517060,
  518352,
  1,
  'Cj0555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343987.1',
  'amidohydrolase family protein',
  518363,
  519160,
  1,
  'Cj0556',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0556'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343988.1',
  'integral membrane protein',
  519157,
  520242,
  -1,
  'Cj0557c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0557c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'proA',
  'gamma-glutamyl phosphate reductase',
  520239,
  521471,
  -1,
  'Cj0558c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0558c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343990.1',
  'pyridine nucleotide-disulfide oxidoreductase',
  521542,
  522477,
  1,
  'Cj0559',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0559'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343991.1',
  'MATE family transport protein',
  522658,
  523986,
  1,
  'Cj0560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343992.1',
  'periplasmic protein',
  524034,
  524963,
  -1,
  'Cj0561c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0561c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dnaB',
  'replicative DNA helicase',
  525117,
  526493,
  1,
  'Cj0562',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0562'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343994.1',
  'hypothetical protein',
  526556,
  527158,
  1,
  'Cj0563',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0563'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343995.1',
  'integral membrane protein',
  527149,
  527355,
  1,
  'Cj0564',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0564'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  527436,
  528163,
  1,
  'Cj0565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343996.1',
  'hypothetical protein',
  528182,
  529648,
  1,
  'Cj0566',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0566'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002343997.1',
  'hypothetical protein',
  529659,
  529772,
  1,
  'Cj0567',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0567'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  529974,
  531130,
  1,
  'Cj0568',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0568'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344000.1',
  'ATP/GTP binding protein',
  531139,
  532206,
  1,
  'Cj0570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344001.1',
  'transcriptional regulator',
  532203,
  533075,
  1,
  'Cj0571',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0571'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAMet',
  '—',
  533097,
  533172,
  -1,
  'Cjp12',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp12'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAGln',
  '—',
  533206,
  533280,
  -1,
  'Cjp13',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp13'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ribA',
  '3,4-dihydroxy-2-butanone-4-phosphate synthase',
  533373,
  534392,
  1,
  'Cj0572',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0572'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344003.1',
  'GatB/Yqey family protein',
  534404,
  534847,
  1,
  'Cj0573',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0573'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ilvI',
  'acetolactate synthase 3 catalytic subunit',
  534865,
  536565,
  1,
  'Cj0574',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0574'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ilvH',
  'acetolactate synthase small subunit',
  536562,
  537026,
  1,
  'Cj0575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lpxD',
  'UDP-3-O-acylglucosamine N-acyltransferase',
  537023,
  537988,
  1,
  'Cj0576',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0576'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'queA',
  'S-adenosylmethionine--tRNAribosyltransferase-isomerase',
  537977,
  539005,
  -1,
  'Cj0577c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0577c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tatC',
  'Sec-independent protein translocase TatC',
  538998,
  539735,
  -1,
  'Cj0578c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0578c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tatB',
  'Sec-independent translocase TatB',
  539728,
  540144,
  -1,
  'Cj0579c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0579c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344010.1',
  'coproporphyrinogen III oxidase',
  540202,
  541269,
  -1,
  'Cj0580c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0580c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344011.1',
  'RNA pyrophosphohydrolase',
  541371,
  541841,
  1,
  'Cj0581',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0581'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lysC',
  'aspartatokinase',
  541843,
  543045,
  1,
  'Cj0582',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0582'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344013.1',
  'hypothetical protein',
  543046,
  543582,
  1,
  'Cj0583',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0583'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344014.1',
  'DNA polymerase III subunit delta''',
  543588,
  544187,
  1,
  'Cj0584',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0584'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'folP',
  'dihydropteroate synthase',
  544189,
  545331,
  1,
  'Cj0585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ligA',
  'DNA ligase',
  545332,
  547275,
  1,
  'Cj0586',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0586'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344017.1',
  'integral membrane protein',
  547256,
  548260,
  1,
  'Cj0587',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0587'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tlyA',
  'hemolysin',
  548257,
  549018,
  1,
  'Cj0588',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0588'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ribF',
  'bifunctional riboflavin kinase/FMNadenylyltransferase',
  548984,
  549838,
  1,
  'Cj0589',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0589'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344020.1',
  'tRNA (cmo5U34)-methyltransferase',
  549825,
  550535,
  1,
  'Cj0590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344021.1',
  'lipoprotein',
  550525,
  550746,
  -1,
  'Cj0591c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0591c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344022.1',
  'periplasmic protein',
  550743,
  551177,
  -1,
  'Cj0592c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0592c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344023.1',
  'integral membrane protein',
  551235,
  551867,
  -1,
  'Cj0593c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0593c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344024.1',
  'DNA/RNA non-specific endonuclease',
  551878,
  552528,
  -1,
  'Cj0594c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0594c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nth',
  'endonuclease III',
  552525,
  553151,
  -1,
  'Cj0595c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0595c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'peb4cbf2',
  'peptidyl-prolyl cis-trans isomerase',
  553232,
  554053,
  1,
  'Cj0596',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0596'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fba',
  'fructose-bisphosphate aldolase',
  554053,
  555117,
  1,
  'Cj0597',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0597'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344028.1',
  'membrane protein',
  555212,
  556654,
  1,
  'Cj0598',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0598'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344029.1',
  'OmpA family membrane protein',
  556651,
  557604,
  1,
  'Cj0599',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0599'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344030.1',
  'hypothetical protein',
  557591,
  558466,
  1,
  'Cj0600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344031.1',
  'sodium-dependent transmembrane transportprotein',
  558458,
  559801,
  -1,
  'Cj0601c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0601c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344032.1',
  'MOSC-domain-containing protein',
  559852,
  560520,
  -1,
  'Cj0602c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0602c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dsbD',
  'thiol:disulfide interchange protein',
  560517,
  562220,
  -1,
  'Cj0603c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0603c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344034.1',
  'polyphosphate kinase',
  562315,
  563196,
  1,
  'Cj0604',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0604'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344035.1',
  'amidohydrolase',
  563205,
  564395,
  1,
  'Cj0605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344036.1',
  'secretion protein HlyD',
  564474,
  565646,
  1,
  'Cj0606',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0606'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344037.1',
  'macrolide export ATP-binding protein/permease',
  565646,
  567571,
  1,
  'Cj0607',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0607'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344038.1',
  'outer membrane efflux protein',
  567573,
  568943,
  1,
  'Cj0608',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0608'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344039.1',
  'hypothetical protein',
  568946,
  570124,
  -1,
  'Cj0609c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0609c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344040.1',
  'periplasmic protein',
  570111,
  571121,
  -1,
  'Cj0610c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0610c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344041.1',
  'acyltransferase family protein',
  571122,
  572498,
  -1,
  'Cj0611c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0611c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cft',
  'ferritin',
  572541,
  573044,
  -1,
  'Cj0612c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0612c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pstS',
  'phosphate ABC transporter substrate-bindingprotein',
  573224,
  574219,
  1,
  'Cj0613',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0613'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pstC',
  'phosphate ABC transporter permease',
  574229,
  575143,
  1,
  'Cj0614',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0614'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pstA',
  'phosphate ABC transporter permease',
  575140,
  576228,
  1,
  'Cj0615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pstB',
  'phosphate ABC transporter ATP-binding protein',
  576225,
  576965,
  1,
  'Cj0616',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0616'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  577027,
  578255,
  1,
  'Cj0617',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0617'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344049.1',
  'MATE family transport protein',
  578345,
  579661,
  1,
  'Cj0619',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0619'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344050.1',
  'hypothetical protein',
  579637,
  580284,
  1,
  'Cj0620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344051.1',
  'hypothetical protein',
  580326,
  581846,
  1,
  'Cj0621',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0621'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hypF',
  'carbamoyltransferase',
  581827,
  584016,
  1,
  'Cj0622',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0622'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hypB',
  'hydrogenase isoenzymes formation protein',
  584094,
  584837,
  1,
  'Cj0623',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0623'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hypC',
  'hydrogenase isoenzymes formation protein',
  584837,
  585118,
  1,
  'Cj0624',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0624'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hypD',
  'hydrogenase isoenzymes formation protein',
  585102,
  586193,
  1,
  'Cj0625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hypE',
  'hydrogenase isoenzymes formation protein',
  586190,
  587164,
  1,
  'Cj0626',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0626'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hypA',
  'hydrogenase nickel incorporation protein HypA',
  587164,
  587508,
  1,
  'Cj0627',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0627'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344058.1',
  'lipoprotein',
  587868,
  591303,
  1,
  'Cj0628',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0628'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344059.1',
  'DNA polymerase III subunit delta',
  591537,
  592502,
  -1,
  'Cj0630c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0630c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344060.1',
  'ribonuclease',
  592495,
  594429,
  -1,
  'Cj0631c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0631c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ilvC',
  'ketol-acid reductoisomerase',
  594548,
  595570,
  1,
  'Cj0632',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0632'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344062.1',
  'periplasmic protein',
  595574,
  596656,
  1,
  'Cj0633',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0633'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dprA',
  'DNA processing protein A',
  596646,
  597419,
  1,
  'Cj0634',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0634'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344064.1',
  'Holliday junction resolvase-like protein',
  597416,
  597799,
  1,
  'Cj0635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344065.1',
  'NOL1/NOP2/sun family protein',
  597828,
  598667,
  1,
  'Cj0636',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0636'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mrsA',
  'methionine sulfoxide reductase A',
  598843,
  599340,
  -1,
  'Cj0637c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0637c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ppa',
  'inorganic pyrophosphatase',
  599381,
  599899,
  -1,
  'Cj0638c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0638c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'adk',
  'adenylate kinase',
  599909,
  600487,
  -1,
  'Cj0639c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0639c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'aspS',
  'aspartate--tRNA ligase',
  600484,
  602235,
  -1,
  'Cj0640c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0640c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pnk',
  'NAD kinase',
  602326,
  603186,
  1,
  'Cj0641',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0641'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'recN',
  'DNA repair protein',
  603186,
  604709,
  1,
  'Cj0642',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0642'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cbrR',
  'two-component response regulator',
  604815,
  606059,
  1,
  'Cj0643',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0643'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344073.1',
  'TatD-related deoxyribonuclease',
  606050,
  606865,
  1,
  'Cj0644',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0644'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344074.1',
  'transglycosylase',
  606865,
  607983,
  1,
  'Cj0645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344075.1',
  'lipoprotein',
  607943,
  608770,
  1,
  'Cj0646',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0646'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344076.1',
  'HAD-superfamily hydrolase',
  608776,
  609264,
  1,
  'Cj0647',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0647'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344077.1',
  'membrane protein',
  609255,
  609770,
  1,
  'Cj0648',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0648'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344078.1',
  'OstA family protein',
  609752,
  610213,
  1,
  'Cj0649',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0649'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'engB',
  'GTP-binding protein EngB',
  610210,
  610806,
  1,
  'Cj0650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344080.1',
  'integral membrane protein',
  610803,
  611297,
  1,
  'Cj0651',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0651'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pbpC',
  'penicillin-binding protein',
  611298,
  613103,
  1,
  'Cj0652',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0652'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344082.1',
  'aminopeptidase',
  613224,
  615014,
  -1,
  'Cj0653c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0653c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  615014,
  616485,
  -1,
  'Cj0654c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0654c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344083.1',
  'periplasmic protein',
  616572,
  617120,
  -1,
  'Cj0659c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0659c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344084.1',
  'transmembrane protein',
  617113,
  618219,
  -1,
  'Cj0660c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0660c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'era',
  'GTPase Era',
  618206,
  619081,
  -1,
  'Cj0661c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0661c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hslU',
  'ATP-dependent protease ATP-binding subunit HslU',
  619078,
  620397,
  -1,
  'Cj0662c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0662c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hslV',
  'ATP-dependent protease peptidase subunit',
  620394,
  620936,
  -1,
  'Cj0663c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0663c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplI',
  '50S ribosomal protein L9',
  620936,
  621379,
  -1,
  'Cj0664c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0664c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'argG',
  'argininosuccinate synthase',
  621392,
  622612,
  -1,
  'Cj0665c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0665c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344090.1',
  'S4 domain-containing protein',
  622768,
  623013,
  1,
  'Cj0667',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0667'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344091.1',
  'ATP/GTP-binding protein',
  623010,
  623417,
  1,
  'Cj0668',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0668'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344092.1',
  'ABC transporter ATP-binding protein',
  623410,
  624138,
  1,
  'Cj0669',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0669'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpoN',
  'RNA polymerase factor sigma-54',
  624138,
  625388,
  1,
  'Cj0670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dcuB',
  'anaerobic C4-dicarboxylate transporter',
  625552,
  626976,
  1,
  'Cj0671',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0671'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344095.1',
  'periplasmic protein',
  627118,
  627306,
  1,
  'Cj0672',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0672'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kdpA',
  '—',
  627316,
  628972,
  1,
  'Cj0676',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0676'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kdpB',
  'potassium-transporting ATPase subunit B',
  629020,
  631065,
  1,
  'Cj0677',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0677'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kdpC',
  '—',
  631067,
  631661,
  1,
  'Cj0678',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0678'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kdpD',
  '—',
  631667,
  633487,
  1,
  'Cj0679',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0679'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'uvrB',
  'excinuclease ABC subunit B',
  633589,
  635562,
  -1,
  'Cj0680c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0680c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344099.1',
  'hypothetical protein',
  635716,
  635946,
  1,
  'Cj0681',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0681'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344100.1',
  'hypothetical protein',
  635936,
  636178,
  1,
  'Cj0682',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0682'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344101.1',
  'hypothetical protein',
  636175,
  636612,
  1,
  'Cj0683',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0683'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'priA',
  'primosome assembly protein PriA',
  636594,
  638447,
  1,
  'Cj0684',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0684'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cipA',
  'invasion protein CipA',
  638540,
  639892,
  -1,
  'Cj0685c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0685c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ispG',
  '4-hydroxy-3-methylbut-2-en-1-yl diphosphatesynthase (flavodoxin)',
  639998,
  641071,
  1,
  'Cj0686',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0686'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgH',
  'flagellar basal body L-ring protein',
  641102,
  641800,
  -1,
  'Cj0687c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0687c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pta',
  'phosphate acetyltransferase',
  641890,
  643395,
  1,
  'Cj0688',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0688'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ackA',
  'acetate kinase',
  643409,
  644599,
  1,
  'Cj0689',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0689'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344108.1',
  'restriction/modification enzyme',
  644627,
  648379,
  -1,
  'Cj0690c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0690c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344109.1',
  'membrane protein',
  648529,
  649020,
  1,
  'Cj0691',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0691'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344110.1',
  'membrane protein',
  649008,
  649946,
  -1,
  'Cj0692c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0692c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344111.1',
  'rRNA small subunit methyltransferase H',
  649946,
  650884,
  -1,
  'Cj0693c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0693c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344112.1',
  'periplasmic protein',
  651043,
  652533,
  1,
  'Cj0694',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0694'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ftsA',
  'cell division protein FtsA',
  652530,
  653918,
  1,
  'Cj0695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ftsZ',
  'cell division protein FtsZ',
  653934,
  655046,
  1,
  'Cj0696',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0696'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgG2',
  'flagellar basal-body rod protein',
  655202,
  656014,
  1,
  'Cj0697',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0697'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgG',
  'flagellar basal body rod protein',
  656043,
  656834,
  1,
  'Cj0698',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0698'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glnA',
  'glutamine synthetase',
  656901,
  658331,
  -1,
  'Cj0699c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0699c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344118.1',
  'hypothetical protein',
  658534,
  659229,
  1,
  'Cj0700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344119.1',
  'protease',
  659226,
  660479,
  1,
  'Cj0701',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0701'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purE',
  '5-(carboxyamino)imidazole ribonucleotide mutase',
  660480,
  660974,
  1,
  'Cj0702',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0702'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344121.1',
  'hypothetical protein',
  660984,
  661520,
  1,
  'Cj0703',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0703'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glyQ',
  'glycine--tRNA ligase alpha subunit',
  661532,
  662395,
  1,
  'Cj0704',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0704'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344123.1',
  'hypothetical protein',
  662382,
  663107,
  1,
  'Cj0705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344124.1',
  'hypothetical protein',
  663117,
  663833,
  1,
  'Cj0706',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0706'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kdtA',
  '3-deoxy-D-manno-octulosonic acid transferase',
  663830,
  664987,
  1,
  'Cj0707',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0707'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344126.1',
  'pseudouridine synthase',
  664968,
  665720,
  1,
  'Cj0708',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0708'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ffh',
  'signal recognition particle protein',
  665788,
  667125,
  1,
  'Cj0709',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0709'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsP',
  '30S ribosomal protein S16',
  667190,
  667417,
  1,
  'Cj0710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344129.1',
  'hypothetical protein',
  667420,
  667662,
  1,
  'Cj0711',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0711'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rimM',
  'ribosome maturation factor RimM',
  667655,
  668194,
  1,
  'Cj0712',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0712'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trmD',
  'tRNA (guanine-N(1)-)-methyltransferase',
  668191,
  668895,
  1,
  'Cj0713',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0713'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplS',
  '50S ribosomal protein L19',
  668906,
  669262,
  1,
  'Cj0714',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0714'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344133.1',
  '5-hydroxyisourate hydrolase',
  669395,
  669808,
  1,
  'Cj0715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344134.1',
  'phospho-2-dehydro-3-deoxyheptonate aldolase',
  669832,
  671172,
  1,
  'Cj0716',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0716'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344135.1',
  'ArsC family protein',
  671169,
  671498,
  1,
  'Cj0717',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0717'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dnaE',
  'DNA polymerase III subunit alpha',
  671946,
  675548,
  1,
  'Cj0718',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0718'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344137.1',
  'hypothetical protein',
  675560,
  676192,
  -1,
  'Cj0719c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0719c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flaC',
  'flagellin C',
  676227,
  676976,
  -1,
  'Cj0720c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0720c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344139.1',
  'integral membrane protein',
  677015,
  677485,
  -1,
  'Cj0721c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0721c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344140.1',
  'DNA methylase',
  677498,
  678313,
  -1,
  'Cj0722c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0722c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344141.1',
  'integral membrane zinc-metalloprotease',
  678310,
  679497,
  -1,
  'Cj0723c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0723c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344142.1',
  'hypothetical protein',
  679624,
  679809,
  1,
  'Cj0724',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0724'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mogA',
  'molybdenum cofactor biosynthesis protein MogA',
  679806,
  680348,
  -1,
  'Cj0725c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0725c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'corA',
  'magnesium and cobalt transport protein',
  680369,
  681352,
  -1,
  'Cj0726c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0726c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344145.1',
  'substrate-binding protein',
  681469,
  682515,
  1,
  'Cj0727',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0727'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344146.1',
  'periplasmic protein',
  682526,
  683851,
  1,
  'Cj0728',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0728'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344147.1',
  'type I phosphodiesterase/nucleotidepyrophosphatase',
  683848,
  684657,
  1,
  'Cj0729',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0729'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344148.1',
  'ABC transporter permease',
  684654,
  685493,
  1,
  'Cj0730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344149.1',
  'ABC transporter permease',
  685494,
  686273,
  1,
  'Cj0731',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0731'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344150.1',
  'ABC transporter ATP-binding protein',
  686277,
  687266,
  1,
  'Cj0732',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0732'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344151.1',
  'HAD-superfamily hydrolase',
  687263,
  687901,
  1,
  'Cj0733',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0733'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisJ',
  'histidine-binding protein',
  687925,
  688680,
  -1,
  'Cj0734c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0734c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344153.1',
  'periplasmic protein',
  689007,
  689726,
  1,
  'Cj0735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344154.1',
  'hypothetical protein',
  689656,
  691584,
  1,
  'Cj0736',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0736'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  693017,
  694064,
  1,
  'Cj0740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  694230,
  695922,
  1,
  'Cj0742',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0742'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  696424,
  697936,
  1,
  'Cjr07',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjr07'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAAla',
  '—',
  698041,
  698116,
  1,
  'Cjp14',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp14'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAIle',
  '—',
  698125,
  698201,
  1,
  'Cjp15',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp15'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  698743,
  701654,
  1,
  'Cjr08',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjr08'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  701939,
  702058,
  1,
  'Cjr09',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjr09'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344160.1',
  'hypothetical protein',
  702810,
  702917,
  1,
  'Cj0747',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0747'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344161.1',
  'hypothetical protein',
  703027,
  703119,
  1,
  'Cj0748',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0748'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  703132,
  704369,
  1,
  'Cj0752',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0752'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tonB3',
  'TonB transport protein',
  704442,
  705125,
  -1,
  'Cj0753c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0753c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cfrA',
  'ferric enterobactin uptake receptor',
  705450,
  707540,
  1,
  'Cj0755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hrcA',
  'heat-inducible transcription repressor',
  707840,
  708634,
  1,
  'Cj0757',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0757'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'grpE',
  'heat shock protein GrpE',
  708631,
  709161,
  1,
  'Cj0758',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0758'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dnaK',
  'chaperone DnaK',
  709183,
  711054,
  1,
  'Cj0759',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0759'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344167.1',
  'hypothetical protein',
  711314,
  712336,
  1,
  'Cj0760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344168.1',
  'hypothetical protein',
  712406,
  712747,
  1,
  'Cj0761',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0761'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'aspB',
  'aspartate aminotransferase',
  712797,
  713966,
  -1,
  'Cj0762c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0762c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cysE',
  'serine acetyltransferase',
  714138,
  714776,
  -1,
  'Cj0763c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0763c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'speA',
  'arginine decarboxylase',
  714777,
  716612,
  -1,
  'Cj0764c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0764c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisS',
  'histidine--tRNA ligase',
  716609,
  717835,
  -1,
  'Cj0765c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0765c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tmk',
  'thymidylate kinase',
  717832,
  718410,
  -1,
  'Cj0766c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0766c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'coaD',
  'phosphopantetheine adenylyltransferase',
  718401,
  718877,
  -1,
  'Cj0767c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0767c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344175.1',
  '3-polyprenyl-4-hydroxybenzoate decarboxylase',
  718917,
  719480,
  -1,
  'Cj0768c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0768c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgA',
  'flagellar basal body P-ring biosynthesis proteinFlgA',
  719477,
  720139,
  -1,
  'Cj0769c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0769c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344177.1',
  'NLPA family lipoprotein',
  720223,
  720999,
  -1,
  'Cj0770c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0770c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344178.1',
  'NLPA family lipoprotein',
  721009,
  721779,
  -1,
  'Cj0771c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0771c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344179.1',
  'NLPA family lipoprotein',
  721828,
  722601,
  -1,
  'Cj0772c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0772c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344180.1',
  'binding-protein dependent transport systempermease',
  722791,
  723702,
  -1,
  'Cj0773c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0773c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344181.1',
  'methionine ABC transporter ATP-binding protei',
  723699,
  724709,
  -1,
  'Cj0774c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0774c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'valS',
  'valine--tRNA ligase',
  724714,
  727326,
  -1,
  'Cj0775c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0775c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344183.1',
  'periplasmic protein',
  727349,
  728371,
  -1,
  'Cj0776c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0776c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344184.1',
  'ATP-dependent DNA helicase',
  728500,
  730530,
  1,
  'Cj0777',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0777'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'peb2',
  'major antigenic peptide PEB2',
  730569,
  731306,
  1,
  'Cj0778',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0778'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tpx',
  '2-Cys peroxiredoxin',
  731405,
  731932,
  1,
  'Cj0779',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0779'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'napA',
  'nitrate reductase catalytic subunit',
  732179,
  734953,
  1,
  'Cj0780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'napG',
  'quinol dehydrogenase periplasmic subunit',
  734971,
  735711,
  1,
  'Cj0781',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0781'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'napH',
  'quinol dehydrogenase membrane subunit',
  735708,
  736490,
  1,
  'Cj0782',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0782'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'napB',
  'nitrate reductase small subunit',
  736487,
  737011,
  1,
  'Cj0783',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0783'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'napL',
  'periplasmic protein',
  737016,
  737930,
  1,
  'Cj0784',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0784'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'napD',
  'nitrate reductase assembly protein NapD',
  737923,
  738261,
  1,
  'Cj0785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344193.1',
  'hypothetical protein',
  738274,
  738447,
  1,
  'Cj0786',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0786'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344194.1',
  'hypothetical protein',
  738526,
  738774,
  1,
  'Cj0787',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0787'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344195.1',
  'hypothetical protein',
  738771,
  739262,
  1,
  'Cj0788',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0788'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cca',
  'poly(A) polymerase family protein',
  739231,
  740349,
  1,
  'Cj0789',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0789'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purU',
  'formyltetrahydrofolate deformylase',
  740346,
  741170,
  1,
  'Cj0790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344198.1',
  'aminotransferase',
  741167,
  742441,
  -1,
  'Cj0791c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0791c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344199.1',
  'hypothetical protein',
  742477,
  743355,
  1,
  'Cj0792',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0792'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgS',
  'signal transduction histidine kinase',
  743359,
  744378,
  1,
  'Cj0793',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0793'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344201.1',
  'hypothetical protein',
  744495,
  745775,
  1,
  'Cj0794',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0794'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'murF',
  'UDP-N-acetylmuramoyl-tripeptideD-alanyl-D-alanine ligase',
  745833,
  747260,
  -1,
  'Cj0795c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0795c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344203.1',
  'hydrolase',
  747261,
  747980,
  -1,
  'Cj0796c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0796c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344204.1',
  'hypothetical protein',
  747982,
  748197,
  -1,
  'Cj0797c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0797c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ddl',
  'D-alanine--D-alanine ligase',
  748257,
  749297,
  -1,
  'Cj0798c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0798c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ruvA',
  'Holliday junction DNA helicase RuvA',
  749307,
  749858,
  -1,
  'Cj0799c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0799c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344207.1',
  'ATPase',
  749834,
  751693,
  -1,
  'Cj0800c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0800c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344208.1',
  'integral membrane protein',
  751797,
  753248,
  1,
  'Cj0801',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0801'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cysS',
  'cysteine--tRNA ligase',
  753248,
  754636,
  1,
  'Cj0802',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0802'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'msbA',
  'lipid ABC transporter ATP-bindingprotein/permease',
  754629,
  756371,
  1,
  'Cj0803',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0803'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pyrD',
  'dihydroorotate dehydrogenase 2',
  756403,
  757461,
  1,
  'Cj0804',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0804'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344212.1',
  'zinc protease',
  757458,
  758708,
  1,
  'Cj0805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dapA',
  '4-hydroxy-tetrahydrodipicolinate synthase',
  758701,
  759597,
  1,
  'Cj0806',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0806'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344214.1',
  'oxidoreductase',
  759597,
  760376,
  1,
  'Cj0807',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0807'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344215.1',
  'hypothetical protein',
  760417,
  760722,
  -1,
  'Cj0808c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0808c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344216.1',
  'hydrolase',
  760734,
  761330,
  -1,
  'Cj0809c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0809c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nadE',
  'NH(3)-dependent NAD(+) synthetase',
  761404,
  762144,
  1,
  'Cj0810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lpxK',
  'tetraacyldisaccharide 4''-kinase',
  762148,
  763074,
  1,
  'Cj0811',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0811'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thrC',
  'threonine synthase',
  763071,
  764483,
  1,
  'Cj0812',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0812'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kdsB',
  '3-deoxy-manno-octulosonate cytidylyltransferase',
  764480,
  765199,
  1,
  'Cj0813',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0813'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  765285,
  766597,
  1,
  'Cj0814',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0814'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glnH',
  'glutamine-binding protein',
  766692,
  767462,
  1,
  'Cj0817',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0817'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344225.1',
  'lipoprotein',
  767555,
  767782,
  1,
  'Cj0818',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0818'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344226.1',
  'hypothetical protein',
  767808,
  768032,
  1,
  'Cj0819',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0819'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliP',
  'flagellar biosynthesis protein FliP',
  768029,
  768763,
  -1,
  'Cj0820c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0820c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glmU',
  'bifunctional N-acetylglucosamine-1-phosphateuridyltransferase/glucosamine-1-phosphateacetyltransferase',
  768906,
  770195,
  1,
  'Cj0821',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0821'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dfp',
  'bifunctional phosphopantothenoylcysteinedecarboxylase/phosphopantothenate synthase',
  770192,
  771346,
  1,
  'Cj0822',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0822'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344230.1',
  'hypothetical protein',
  771343,
  771960,
  1,
  'Cj0823',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0823'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'uppS',
  'UDP diphosphate synthase',
  771964,
  772632,
  1,
  'Cj0824',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0824'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344232.1',
  'processing peptidase',
  772629,
  773405,
  1,
  'Cj0825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344233.1',
  'integral membrane protein',
  773405,
  774430,
  1,
  'Cj0826',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0826'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'truA',
  'tRNA pseudouridine synthase A',
  774427,
  775152,
  1,
  'Cj0827',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0827'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ilvA',
  'threonine dehydratase',
  775149,
  776360,
  -1,
  'Cj0828c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0828c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344236.1',
  'CoA-binding domain-containing protein',
  776360,
  776773,
  -1,
  'Cj0829c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0829c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344237.1',
  'integral membrane protein',
  776892,
  777308,
  1,
  'Cj0830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trmA',
  'tRNA/tmRNA (uracil-C(5))-methyltransferase',
  777295,
  778368,
  -1,
  'Cj0831c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0831c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344239.1',
  'Na+/H+ antiporter family protein',
  778365,
  780098,
  -1,
  'Cj0832c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0832c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344240.1',
  'oxidoreductase',
  780095,
  780844,
  -1,
  'Cj0833c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0833c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344241.1',
  'ankyrin repeat-containing protein',
  780841,
  782079,
  -1,
  'Cj0834c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0834c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'acnB',
  'aconitate hydratase B',
  782129,
  784675,
  -1,
  'Cj0835c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0835c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ogt',
  'methylated-DNA--protein-cysteinemethyltransferase',
  784730,
  785182,
  1,
  'Cj0836',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0836'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344244.1',
  'hypothetical protein',
  785174,
  786115,
  -1,
  'Cj0837c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0837c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'metG',
  'methionine--tRNA ligase',
  786119,
  788005,
  -1,
  'Cj0838c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0838c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344246.1',
  'hypothetical protein',
  788015,
  788212,
  -1,
  'Cj0839c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0839c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fbp',
  'fructose-1,6-bisphosphatase',
  788205,
  789047,
  -1,
  'Cj0840c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0840c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mobB',
  'molybdopterin-guanine dinucleotide biosynthesisprotein',
  789049,
  789540,
  -1,
  'Cj0841c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0841c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344249.1',
  'lipoprotein',
  789636,
  790121,
  1,
  'Cj0842',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0842'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344250.1',
  'transglycosylase',
  790018,
  791643,
  -1,
  'Cj0843c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0843c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344251.1',
  'integral membrane protein',
  791640,
  791921,
  -1,
  'Cj0844c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0844c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gltX',
  'glutamate--tRNA ligase',
  791924,
  793219,
  -1,
  'Cj0845c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0845c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344253.1',
  'metallophosphoesterase',
  793305,
  794429,
  1,
  'Cj0846',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0846'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'psd',
  'phosphatidylserine decarboxylase',
  794426,
  795226,
  1,
  'Cj0847',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0847'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344255.1',
  'hypothetical protein',
  795223,
  795504,
  -1,
  'Cj0848c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0848c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344256.1',
  'hypothetical protein',
  795501,
  797660,
  -1,
  'Cj0849c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0849c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344257.1',
  'MFS transport protein',
  797653,
  798840,
  -1,
  'Cj0850c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0850c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344258.1',
  'integral membrane protein',
  798818,
  799321,
  -1,
  'Cj0851c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0851c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344259.1',
  'integral membrane protein',
  799321,
  799650,
  -1,
  'Cj0852c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0852c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hemL',
  'glutamate-1-semialdehyde aminotransferase',
  799647,
  800921,
  -1,
  'Cj0853c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0853c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344261.1',
  'periplasmic protein',
  800918,
  801265,
  -1,
  'Cj0854c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0854c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'folD',
  'bifunctional 5,10-methylene-tetrahydrofolatedehydrogenase/ 5,10-methylene-tetrahydrofolatecyclohydrolase',
  801345,
  802193,
  1,
  'Cj0855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lepP',
  'signal peptidase I',
  802203,
  803051,
  1,
  'Cj0856',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0856'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'moeA',
  'molybdopterin biosynthesis protein',
  803073,
  804233,
  -1,
  'Cj0857c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0857c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'murA',
  'UDP-N-acetylglucosamine1-carboxyvinyltransferase',
  804230,
  805486,
  -1,
  'Cj0858c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0858c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344266.1',
  'hypothetical protein',
  805552,
  805980,
  -1,
  'Cj0859c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0859c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344267.1',
  'integral membrane protein',
  806075,
  806947,
  1,
  'Cj0860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pabA',
  'para-aminobenzoate synthase glutamineamidotransferase subunit II',
  806934,
  807500,
  -1,
  'Cj0861c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0861c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pabB',
  'para-aminobenzoate synthase subunit I',
  807497,
  809281,
  -1,
  'Cj0862c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0862c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'xerD',
  'DNA recombinase',
  809271,
  810335,
  -1,
  'Cj0863c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0863c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344271.1',
  'periplasmic protein',
  810963,
  811322,
  1,
  'Cj0864',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0864'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dsbB',
  'protein-disulfide oxidoreductase',
  811319,
  812119,
  1,
  'Cj0865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  812155,
  813591,
  1,
  'Cj0866',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0866'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dsbA',
  'hypothetical protein',
  813675,
  814316,
  1,
  'Cj0872',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0872'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  814351,
  815337,
  -1,
  'Cj0873c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0873c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344277.1',
  'hypothetical protein',
  815432,
  815524,
  -1,
  'Cj0877c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0877c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344278.1',
  'hypothetical protein',
  815545,
  815691,
  1,
  'Cj0878',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0878'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344279.1',
  'periplasmic protein',
  815669,
  816301,
  -1,
  'Cj0879c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0879c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344280.1',
  'hypothetical protein',
  816298,
  816540,
  -1,
  'Cj0880c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0880c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344281.1',
  'hypothetical protein',
  816524,
  817570,
  -1,
  'Cj0881c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0881c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flhA',
  'flagellar biosynthesis protein FlhA',
  817579,
  819753,
  -1,
  'Cj0882c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0882c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344283.1',
  'transcriptional regulator',
  819740,
  820150,
  -1,
  'Cj0883c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0883c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsO',
  '30S ribosomal protein S15',
  820325,
  820597,
  1,
  'Cj0884',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0884'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ftsK',
  'DNA translocase FtsK',
  820683,
  823523,
  -1,
  'Cj0886c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0886c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344286.1',
  'flagellin',
  823633,
  825885,
  -1,
  'Cj0887c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0887c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNALeu',
  '—',
  826066,
  826152,
  1,
  'Cjp16',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp16'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAGly',
  '—',
  826163,
  826237,
  1,
  'Cjp17',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp17'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344287.1',
  'ABC transporter ATP-binding protein',
  826268,
  828199,
  -1,
  'Cj0888c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0888c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344288.1',
  'sensory trasnduction histidine kinase',
  828203,
  829492,
  -1,
  'Cj0889c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0889c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344289.1',
  'sensory transduction transcriptional regulator',
  829486,
  830148,
  -1,
  'Cj0890c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0890c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'serA',
  'D-3-phosphoglycerate dehydrogenase',
  830135,
  831718,
  -1,
  'Cj0891c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0891c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344291.1',
  'periplasmic protein',
  831715,
  832203,
  -1,
  'Cj0892c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0892c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsA',
  '30S ribosomal protein S1',
  832203,
  833873,
  -1,
  'Cj0893c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0893c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ispH',
  '4-hydroxy-3-methylbut-2-enyl diphosphatereductase',
  834005,
  834838,
  -1,
  'Cj0894c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0894c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'aroA',
  '3-phosphoshikimate 1-carboxyvinyltransferase',
  834828,
  836114,
  -1,
  'Cj0895c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0895c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pheT',
  'phenylalanine--tRNA ligase subunit beta',
  836111,
  838432,
  -1,
  'Cj0896c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0896c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pheS',
  'phenylalanine--tRNA ligase subunit alpha',
  838429,
  839421,
  -1,
  'Cj0897c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0897c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344297.1',
  'histidine triad (HIT) family protein',
  839544,
  839909,
  1,
  'Cj0898',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0898'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thiJ',
  '4-methyl-5(beta-hydroxyethyl)-thiazolemonophosphate synthesis protein',
  839939,
  840508,
  -1,
  'Cj0899c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0899c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344299.1',
  'hypothetical protein',
  840501,
  840680,
  -1,
  'Cj0900c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0900c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344300.1',
  'amino acid ABC transporter permease',
  840763,
  841506,
  1,
  'Cj0901',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0901'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glnQ',
  'glutamine transporter ATP-binding protein',
  841499,
  842227,
  1,
  'Cj0902',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0902'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344302.1',
  'amino acid transport protein',
  842255,
  843721,
  -1,
  'Cj0903c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0903c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344303.1',
  'tRNA (cytidine(34)-2''-O)-methyltransferase',
  843825,
  844292,
  -1,
  'Cj0904c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0904c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'alr',
  'alanine racemase',
  844295,
  845281,
  -1,
  'Cj0905c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0905c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344305.1',
  'periplasmic protein',
  845282,
  846259,
  -1,
  'Cj0906c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0906c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344306.1',
  'periplasmic protein',
  846415,
  846885,
  1,
  'Cj0908',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0908'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344307.1',
  'periplasmic protein',
  846971,
  847390,
  1,
  'Cj0909',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0909'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344308.1',
  'periplasmic protein',
  847394,
  847846,
  1,
  'Cj0910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344309.1',
  'periplasmic protein',
  847843,
  848403,
  1,
  'Cj0911',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0911'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cysM',
  'cysteine synthase',
  848410,
  849309,
  -1,
  'Cj0912c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0912c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hupB',
  'DNA-binding protein HU',
  849436,
  849732,
  -1,
  'Cj0913c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0913c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ciaB',
  'invasion antigen CiaB',
  849834,
  851666,
  -1,
  'Cj0914c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0914c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344313.1',
  'acyl-CoA thioesterase',
  851728,
  852141,
  1,
  'Cj0915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344314.1',
  'hypothetical protein',
  852181,
  852378,
  -1,
  'Cj0916c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0916c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cstA',
  'integral membrane protein',
  852359,
  854470,
  -1,
  'Cj0917c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0917c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'prsA',
  'ribose-phosphate pyrophosphokinase',
  854637,
  855566,
  -1,
  'Cj0918c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0918c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344317.1',
  'amino acid ABC transporter permease',
  855674,
  856333,
  -1,
  'Cj0919c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0919c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344318.1',
  'amino acid ABC transporter permease',
  856344,
  857096,
  -1,
  'Cj0920c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0920c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'peb1A',
  'bifunctional adhesin/ABC transporteraspartate/glutamate-binding protein',
  857098,
  857877,
  -1,
  'Cj0921c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0921c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pebC',
  'amino acid ABC transporter ATP-binding protein',
  857899,
  858627,
  -1,
  'Cj0922c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0922c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cheR',
  'MCP protein methyltransferase',
  858763,
  859551,
  -1,
  'Cj0923c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0923c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cheB''',
  'MCP protein-glutamate methylesterase',
  859567,
  860121,
  -1,
  'Cj0924c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0924c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpiB',
  'ribose 5-phosphate isomerase',
  860287,
  860724,
  1,
  'Cj0925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344324.1',
  'membrane protein',
  860724,
  861056,
  1,
  'Cj0926',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0926'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'apt',
  'adenine phosphoribosyltransferase',
  861053,
  861601,
  1,
  'Cj0927',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0927'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344326.1',
  'integral membrane protein',
  861620,
  862216,
  1,
  'Cj0928',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0928'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pepA',
  'cytosol aminopeptidase',
  862213,
  863664,
  1,
  'Cj0929',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0929'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344328.1',
  'ribosome-binding ATPase',
  863661,
  864764,
  1,
  'Cj0930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'argH',
  'argininosuccinate lyase',
  864786,
  866168,
  -1,
  'Cj0931c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0931c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pckA',
  'phosphoenolpyruvate carboxykinase',
  866178,
  867752,
  -1,
  'Cj0932c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0932c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pycB',
  'pyruvate carboxylase B subunit',
  867765,
  869564,
  -1,
  'Cj0933c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0933c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344332.1',
  'sodium:amino-acid symporter family protein',
  869596,
  870936,
  -1,
  'Cj0934c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0934c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344333.1',
  'sodium:amino-acid symporter family protein',
  870949,
  872283,
  -1,
  'Cj0935c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0935c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'atpE',
  'ATP synthase subunit C',
  872516,
  872854,
  1,
  'Cj0936',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0936'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNALeu',
  '—',
  872889,
  872974,
  1,
  'Cjt01',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjt01'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344335.1',
  'integral membrane protein',
  873171,
  874082,
  1,
  'Cj0937',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0937'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'aas',
  '2-acylglycerophosphoethanolamineacyltransferase',
  874090,
  877602,
  -1,
  'Cj0938c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0938c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344337.1',
  'hypothetical protein',
  877647,
  878027,
  -1,
  'Cj0939c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0939c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAAsp',
  '—',
  878095,
  878171,
  -1,
  'Cjt02',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjt02'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAVal',
  '—',
  878223,
  878298,
  -1,
  'Cjp19',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp19'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNALys',
  '—',
  878400,
  878475,
  -1,
  'Cjp20',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp20'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAAsp',
  '—',
  878480,
  878556,
  -1,
  'Cjt2',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjt2'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAVal',
  '—',
  878608,
  878683,
  -1,
  'Cjt03',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjt03'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNALys',
  '—',
  878691,
  878766,
  -1,
  'Cjt04',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjt04'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glnP',
  'glutamine transporter permease',
  878828,
  879613,
  -1,
  'Cj0940c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0940c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344339.1',
  'permease',
  879636,
  880841,
  -1,
  'Cj0941c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0941c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'secA',
  'protein translocase subunit SecA',
  880838,
  883426,
  -1,
  'Cj0942c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0942c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lolA',
  'outer-membrane lipoprotein carrier protein',
  883526,
  884035,
  1,
  'Cj0943',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0943'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344342.1',
  'periplasmic protein',
  884032,
  884766,
  -1,
  'Cj0944c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0944c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344343.1',
  'ATP-dependent DNA helicase',
  884776,
  886119,
  -1,
  'Cj0945c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0945c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344344.1',
  'lipoprotein',
  886168,
  887514,
  1,
  'Cj0946',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0946'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344345.1',
  'carbon-nitrogen hydrolase',
  887526,
  888398,
  -1,
  'Cj0947c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0947c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344346.1',
  'cation efflux family protein',
  888395,
  889282,
  -1,
  'Cj0948c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0948c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344347.1',
  'peptidyl-arginine deiminase family protein',
  889279,
  890256,
  -1,
  'Cj0949c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0949c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344348.1',
  'lipoprotein',
  890355,
  890789,
  -1,
  'Cj0950c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0950c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  890799,
  892379,
  -1,
  'Cj0951c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0951c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purH',
  'bifunctionalphosphoribosylaminoimidazolecarboxamideformyltransferase/IMP cyclohydrolase',
  892478,
  894010,
  -1,
  'Cj0953c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0953c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344352.1',
  'DnaJ-like protein',
  894013,
  894783,
  -1,
  'Cj0954c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0954c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purL',
  'phosphoribosylformylglycinamidine synthase II',
  894780,
  896966,
  -1,
  'Cj0955c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0955c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trmE',
  'tRNA modification GTPase',
  896977,
  898305,
  -1,
  'Cj0956c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0956c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344355.1',
  'hypothetical protein',
  898298,
  899116,
  -1,
  'Cj0957c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0957c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344356.1',
  'membrane protein insertase YidC',
  899120,
  900706,
  -1,
  'Cj0958c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0958c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344357.1',
  'membrane protein insertion efficiency factor',
  900703,
  901044,
  -1,
  'Cj0959c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0959c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rnpA',
  'ribonuclease P protein component',
  901041,
  901367,
  -1,
  'Cj0960c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0960c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpmH',
  '50S ribosomal protein L34',
  901364,
  901498,
  -1,
  'Cj0961c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0961c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344360.1',
  'acetyltransferase',
  901629,
  902108,
  1,
  'Cj0962',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0962'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344361.1',
  'hypothetical protein',
  902105,
  902713,
  1,
  'Cj0963',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0963'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344362.1',
  'periplasmic protein',
  902710,
  903900,
  1,
  'Cj0964',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0964'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344363.1',
  'acyl-CoA thioester hydrolase',
  903892,
  904266,
  -1,
  'Cj0965c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0965c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344364.1',
  'periplasmic protein',
  904409,
  906697,
  1,
  'Cj0967',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0967'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  907117,
  907396,
  1,
  'Cj0969',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0969'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344365.1',
  'hypothetical protein',
  907408,
  907710,
  1,
  'Cj0970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344366.1',
  'hypothetical protein',
  907713,
  908105,
  1,
  'Cj0971',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0971'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344367.1',
  'hypothetical protein',
  908107,
  908430,
  1,
  'Cj0972',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0972'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  908554,
  908705,
  1,
  'Cj0973',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0973'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344369.1',
  'hypothetical protein',
  908693,
  908833,
  1,
  'Cj0974',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0974'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344370.1',
  'outer-membrane protein',
  908891,
  910615,
  1,
  'Cj0975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344371.1',
  'tRNA (mo5U34)-methyltransferase',
  910711,
  911601,
  1,
  'Cj0976',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0976'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344372.1',
  'hypothetical protein',
  911674,
  912252,
  1,
  'Cj0977',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0977'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344373.1',
  'lipoprotein',
  912253,
  912426,
  -1,
  'Cj0978c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0978c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344374.1',
  'nuclease',
  912435,
  912962,
  -1,
  'Cj0979c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0979c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344375.1',
  'peptidase',
  913030,
  914298,
  1,
  'Cj0980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cjaB',
  'MFS transport protein',
  914281,
  915528,
  -1,
  'Cj0981c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0981c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cjaA',
  'amino acid transporter substrate-bindingprotein',
  915568,
  916407,
  -1,
  'Cj0982c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0982c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344378.1',
  'lipoprotein',
  916626,
  917744,
  1,
  'Cj0983',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0983'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344379.1',
  'hypothetical protein',
  917836,
  918576,
  1,
  'Cj0984',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0984'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hipO',
  'hippurate hydrolase',
  918580,
  919731,
  -1,
  'Cj0985c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0985c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  919733,
  920953,
  -1,
  'Cj0986c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0986c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344383.1',
  'hypothetical protein',
  920967,
  921203,
  -1,
  'Cj0988c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0988c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344384.1',
  'membrane protein',
  921188,
  921394,
  1,
  'Cj0989',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0989'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344385.1',
  'hypothetical protein',
  921397,
  922158,
  -1,
  'Cj0990c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0990c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344386.1',
  'oxidoreductase ferredoxin-type electrontransport protein',
  922155,
  923420,
  -1,
  'Cj0991c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0991c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hemN',
  'coproporphyrinogen III oxidase',
  923422,
  924777,
  -1,
  'Cj0992c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0992c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344388.1',
  'hypothetical protein',
  924764,
  925255,
  -1,
  'Cj0993c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0993c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'argF',
  'ornithine carbamoyltransferase',
  925252,
  926172,
  -1,
  'Cj0994c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0994c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hemB',
  'delta-aminolevulinic acid dehydratase',
  926169,
  927152,
  -1,
  'Cj0995c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0995c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ribA',
  'GTP cyclohydrolase II',
  927210,
  927770,
  1,
  'Cj0996',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0996'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344392.1',
  'rRNA small subunit methyltransferase G',
  927771,
  928337,
  1,
  'Cj0997',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0997'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344393.1',
  'periplasmic protein',
  928353,
  928925,
  -1,
  'Cj0998c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0998c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344394.1',
  'membrane protein',
  929020,
  930117,
  -1,
  'Cj0999c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj0999c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344395.1',
  'transcriptional regulator',
  930230,
  931111,
  1,
  'Cj1000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpoD',
  'RNA polymerase sigma factor RpoD',
  931191,
  933059,
  1,
  'Cj1001',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1001'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344397.1',
  'phosphoglycerate/bisphosphoglycerate mutase',
  933075,
  933587,
  -1,
  'Cj1002c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1002c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344398.1',
  'integral membrane protein',
  933584,
  934102,
  -1,
  'Cj1003c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1003c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344399.1',
  'periplasmic protein',
  934201,
  934617,
  1,
  'Cj1004',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1004'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344400.1',
  'membrane bound ATPase',
  934626,
  936242,
  -1,
  'Cj1005c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1005c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344401.1',
  'MiaB-like tRNA modifying enzyme',
  936246,
  937496,
  -1,
  'Cj1006c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1006c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344402.1',
  'mechanosensitive ion channel family protein',
  937493,
  939064,
  -1,
  'Cj1007c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1007c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'aroB',
  '3-dehydroquinate synthase',
  939061,
  940116,
  -1,
  'Cj1008c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1008c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344404.1',
  'hypothetical protein',
  940162,
  941562,
  -1,
  'Cj1009c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1009c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tgt',
  'queuine tRNA-ribosyltransferase',
  941592,
  942713,
  1,
  'Cj1010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344406.1',
  'CorA-like Mg2+ transporter protein',
  942715,
  943482,
  1,
  'Cj1011',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1011'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAArg',
  '—',
  943535,
  943611,
  1,
  'Cjp21',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp21'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344407.1',
  'membrane protein',
  943614,
  944063,
  -1,
  'Cj1012c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1012c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344408.1',
  'cytochrome C biogenesis protein',
  944080,
  947325,
  -1,
  'Cj1013c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1013c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'livF',
  'ABC transporter ATP-binding protein',
  947343,
  948038,
  -1,
  'Cj1014c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1014c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'livG',
  'ABC transporter ATP-binding protein',
  948025,
  948795,
  -1,
  'Cj1015c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1015c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'livM',
  'branched-chain amino acid ABC transporterpermease',
  948792,
  949844,
  -1,
  'Cj1016c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1016c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'livH',
  'branched-chain amino acid ABC transporterpermease',
  949844,
  950740,
  -1,
  'Cj1017c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1017c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'livK',
  'branched-chain amino acid ABC transportersubstrate-binding protein',
  950759,
  951868,
  -1,
  'Cj1018c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1018c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'livJ',
  'branched-chain amino acid ABC transportersubstrate-binding protein',
  951890,
  953005,
  -1,
  'Cj1019c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1019c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344415.1',
  'cytochrome C',
  953036,
  953470,
  -1,
  'Cj1020c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1020c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344416.1',
  'periplasmic protein',
  953479,
  953670,
  -1,
  'Cj1021c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1021c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344417.1',
  'integral membrane protein',
  953723,
  954229,
  -1,
  'Cj1022c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1022c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'asd',
  'aspartate-semialdehyde dehydrogenase',
  954238,
  955269,
  -1,
  'Cj1023c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1023c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgR',
  'sigma-54 associated transcriptional activator',
  955269,
  956570,
  -1,
  'Cj1024c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1024c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344420.1',
  'hypothetical protein',
  956627,
  957076,
  -1,
  'Cj1025c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1025c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344421.1',
  'lipoprotein',
  957052,
  957567,
  -1,
  'Cj1026c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1026c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gyrA',
  'DNA gyrase subunit A',
  957631,
  960222,
  -1,
  'Cj1027c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1027c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344423.1',
  'purine/pyrimidine phosphoribosyltransferase',
  960263,
  960838,
  -1,
  'Cj1028c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1028c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mapA',
  'outer membrane lipoprotein MapA',
  960835,
  961479,
  -1,
  'Cj1029c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1029c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lepA',
  'elongation factor EF-4',
  961556,
  963352,
  -1,
  'Cj1030c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1030c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cmeD',
  'multidrug efflux system outer membrane protein',
  963479,
  964753,
  1,
  'Cj1031',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1031'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cmeE',
  'mutlidrug efflux system membrane fusion protein',
  964750,
  965490,
  1,
  'Cj1032',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1032'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cmeF',
  'multidrug efflux system membrane protein',
  965493,
  968510,
  1,
  'Cj1033',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1033'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344429.1',
  'adenylosuccinate lyase',
  968534,
  969340,
  -1,
  'Cj1034c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1034c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344430.1',
  'arginyl-tRNA--protein transferase',
  969341,
  970060,
  -1,
  'Cj1035c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1035c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344431.1',
  'hypothetical protein',
  970060,
  970311,
  -1,
  'Cj1036c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1036c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pycA',
  'acetyl-CoA carboxylase subunit A',
  970315,
  971760,
  -1,
  'Cj1037c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1037c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344433.1',
  'cell division/peptidoglycan biosynthesisprotein',
  971900,
  973063,
  1,
  'Cj1038',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1038'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'murG',
  'UDP-N-acetylglucosamine--N-acetylmuramyl-(pentapeptide) pyrophosphoryl-undecaprenolN-acetylglucosamine transferase',
  973060,
  974088,
  1,
  'Cj1039',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1039'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344435.1',
  'MFS transport protein',
  974059,
  975222,
  -1,
  'Cj1040c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1040c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344436.1',
  'ATP/GTP-binding protein',
  975230,
  976081,
  -1,
  'Cj1041c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1041c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344437.1',
  'transcriptional regulator',
  976144,
  977034,
  -1,
  'Cj1042c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1042c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344438.1',
  'thiamine-phosphate pyrophosphorylase',
  977031,
  977636,
  -1,
  'Cj1043c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1043c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thiH',
  'thiamine biosynthesis protein ThiH',
  977626,
  978771,
  -1,
  'Cj1044c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1044c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thiG',
  'thiazole synthase',
  978774,
  979550,
  -1,
  'Cj1045c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1045c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'moeB',
  'thiamine biosynthesis protein ThiF',
  979553,
  980356,
  -1,
  'Cj1046c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1046c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thiS',
  'thiamine biosynthesis protein',
  980353,
  980544,
  -1,
  'Cj1047c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1047c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dapE',
  'succinyl-diaminopimelate desuccinylase',
  980554,
  981651,
  -1,
  'Cj1048c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1048c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344444.1',
  'LysE family transporter protein',
  981655,
  982254,
  -1,
  'Cj1049c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1049c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'npdA',
  'NAD-dependent protein deacetylase',
  982247,
  982948,
  -1,
  'Cj1050c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1050c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cjeI',
  'restriction modification enzyme',
  982991,
  987010,
  -1,
  'Cj1051c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1051c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mutS',
  'endonuclease MutS2',
  987019,
  989229,
  -1,
  'Cj1052c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1052c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344448.1',
  'integral membrane protein',
  989219,
  989569,
  -1,
  'Cj1053c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1053c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'murC',
  'UDP-N-acetylmuramate--L-alanine ligase',
  989562,
  990860,
  -1,
  'Cj1054c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1054c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344450.1',
  'sulfatase family protein',
  990924,
  992897,
  -1,
  'Cj1055c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1055c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344451.1',
  'carbon-nitrogen hydrolase family protein',
  992909,
  993685,
  -1,
  'Cj1056c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1056c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344452.1',
  'hypothetical protein',
  993678,
  993851,
  -1,
  'Cj1057c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1057c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'guaB',
  'inosine 5''-monophosphate dehydrogenase',
  993848,
  995305,
  -1,
  'Cj1058c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1058c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gatA',
  'aspartyl/glutamyl-tRNA amidotransferase subunitA',
  995315,
  996676,
  -1,
  'Cj1059c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1059c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344455.1',
  'membrane protein',
  996673,
  996783,
  -1,
  'Cj1060c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1060c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ileS',
  'isoleucine--tRNA ligase',
  996777,
  999530,
  -1,
  'Cj1061c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1061c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344457.1',
  'CinA-like protein',
  999629,
  1000717,
  1,
  'Cj1062',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1062'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344458.1',
  'acetyltransferase',
  1000729,
  1001154,
  1,
  'Cj1063',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1063'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1001218,
  1001837,
  1,
  'Cj1064',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1064'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rdxA',
  'nitroreductase',
  1001837,
  1002442,
  1,
  'Cj1066',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1066'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pgsA',
  'CDP-diacylglycerol--glycerol-3-phosphate3-phosphatidyltransferase',
  1002567,
  1003103,
  1,
  'Cj1067',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1067'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344461.1',
  'zinc metalloprotease',
  1003100,
  1004206,
  1,
  'Cj1068',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1068'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344462.1',
  'hypothetical protein',
  1004199,
  1005065,
  1,
  'Cj1069',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1069'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsF',
  '30S ribosomal protein S6',
  1005152,
  1005529,
  1,
  'Cj1070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ssb',
  'single-stranded DNA-binding protein',
  1005538,
  1006089,
  1,
  'Cj1071',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1071'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsR',
  '30S ribosomal protein S18',
  1006100,
  1006360,
  1,
  'Cj1072',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1072'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'lon',
  'ATP-dependent protease La',
  1006421,
  1008796,
  -1,
  'Cj1073c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1073c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344467.1',
  'lipoprotein',
  1008813,
  1009460,
  -1,
  'Cj1074c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1074c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344468.1',
  'flagellar assembly protein FliW',
  1009621,
  1010010,
  1,
  'Cj1075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'proC',
  'pyrroline-5-carboxylate reductase',
  1010010,
  1010741,
  1,
  'Cj1076',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1076'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ctsT',
  'periplasmic protein',
  1010738,
  1011040,
  1,
  'Cj1077',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1077'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344471.1',
  'periplasmic protein',
  1011037,
  1011699,
  1,
  'Cj1078',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1078'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344472.1',
  'periplasmic protein',
  1011696,
  1012148,
  1,
  'Cj1079',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1079'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hemD',
  'uroporphyrinogen-III synthase',
  1012145,
  1012774,
  -1,
  'Cj1080c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1080c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thiE',
  'thiamin-phosphate pyrophosphorylase',
  1012752,
  1013384,
  -1,
  'Cj1081c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1081c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thiD',
  'phosphomethylpyrimidine kinase',
  1013374,
  1014186,
  -1,
  'Cj1082c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1082c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344476.1',
  'endonuclease III',
  1014183,
  1014869,
  -1,
  'Cj1083c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1083c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344477.1',
  'ATP/GTP-binding protein',
  1014866,
  1015627,
  -1,
  'Cj1084c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1084c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mfd',
  'transcription-repair coupling factor',
  1015629,
  1018565,
  -1,
  'Cj1085c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1085c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344479.1',
  'hypothetical protein',
  1018565,
  1018960,
  -1,
  'Cj1086c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1086c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344480.1',
  'peptidase',
  1018897,
  1019799,
  -1,
  'Cj1087c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1087c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'folC',
  'bifunctional folylpolyglutamatesynthase/dihydrofolate synthase',
  1019786,
  1020970,
  -1,
  'Cj1088c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1088c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344482.1',
  'hypothetical protein',
  1020936,
  1022333,
  -1,
  'Cj1089c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1089c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344483.1',
  'lipoprotein',
  1022317,
  1022829,
  -1,
  'Cj1090c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1090c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'leuS',
  'leucine--tRNA ligase',
  1022826,
  1025255,
  -1,
  'Cj1091c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1091c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'secF',
  'protein translocase subunit SecF',
  1025265,
  1026236,
  -1,
  'Cj1092c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1092c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'secD',
  'protein translocase subunit SecD',
  1026236,
  1027816,
  -1,
  'Cj1093c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1093c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'yajC',
  'protein translocase subunit YajC',
  1027809,
  1028081,
  -1,
  'Cj1094c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1094c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344488.1',
  'apolipoprotein N-acyltransferase',
  1028054,
  1029379,
  1,
  'Cj1095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'metK',
  'S-adenosylmethionine synthetase',
  1029616,
  1030812,
  -1,
  'Cj1096c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1096c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344490.1',
  'serine/threonine transporter SstT',
  1030953,
  1032176,
  1,
  'Cj1097',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1097'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pyrB',
  'aspartate carbamoyltransferase',
  1032186,
  1033073,
  1,
  'Cj1098',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1098'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344492.1',
  'peptidase',
  1033077,
  1034798,
  1,
  'Cj1099',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1099'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344493.1',
  'hypothetical protein',
  1034792,
  1035229,
  1,
  'Cj1100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344494.1',
  'ATP-dependent DNA helicase',
  1035226,
  1037301,
  1,
  'Cj1101',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1101'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'truB',
  'tRNA pseudouridine synthase B',
  1037298,
  1038116,
  1,
  'Cj1102',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1102'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'csrA',
  'carbon storage regulator',
  1038110,
  1038337,
  1,
  'Cj1103',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1103'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344497.1',
  '4-diphosphocytidyl-2C-methyl-D-erythritolkinase',
  1038334,
  1039101,
  1,
  'Cj1104',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1104'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'smpB',
  'SsrA-binding protein',
  1039098,
  1039550,
  1,
  'Cj1105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344499.1',
  'thioredoxin',
  1039561,
  1040163,
  1,
  'Cj1106',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1106'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'clpS',
  'ATP-dependent Clp protease adaptor protein',
  1040163,
  1040453,
  1,
  'Cj1107',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1107'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'clpA',
  'ATP-dependent Clp protease ATP-binding subunit',
  1040450,
  1042579,
  1,
  'Cj1108',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1108'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'aat',
  'leucyl/phenylalanyl-tRNA--protein transferase',
  1042554,
  1043201,
  1,
  'Cj1109',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1109'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344503.1',
  'MCP-type signal transduction protein',
  1043223,
  1044512,
  -1,
  'Cj1110c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1110c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344504.1',
  'MarC family integral membrane protein',
  1044593,
  1045219,
  -1,
  'Cj1111c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1111c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344505.1',
  'methionine sulfoxide reductase B',
  1045234,
  1045593,
  -1,
  'Cj1112c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1112c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344506.1',
  'hypothetical protein',
  1045683,
  1046480,
  1,
  'Cj1113',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1113'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pssA',
  'CDP-diacylglycerol--serineO-phosphatidyltransferase',
  1046471,
  1047199,
  -1,
  'Cj1114c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1114c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344508.1',
  'phosphatidylserine decarboxylase-like protein',
  1047209,
  1047826,
  -1,
  'Cj1115c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1115c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ftsH',
  'ATP-dependent zinc metalloprotease FtsH',
  1047823,
  1049760,
  -1,
  'Cj1116c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1116c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'prmA',
  '50S ribosomal protein L11 methyltransferase',
  1049764,
  1050609,
  -1,
  'Cj1117c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1117c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cheY',
  'chemotaxis protein CheY',
  1050632,
  1051024,
  -1,
  'Cj1118c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1118c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pglG',
  'integral membrane protein',
  1051137,
  1052030,
  -1,
  'Cj1119c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1119c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pglF',
  'UDP-N-acetyl-alpha-D-glucosamine C6 dehydratase',
  1052030,
  1053802,
  -1,
  'Cj1120c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1120c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pglE',
  'UDP-N-acetylbacillosamine transaminase',
  1053804,
  1054964,
  -1,
  'Cj1121c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1121c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344515.1',
  'integral membrane protein',
  1055060,
  1055713,
  -1,
  'Cj1122c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1122c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pglD',
  'UDP-N-acetylbacillosamine N-acetyltransferase',
  1055670,
  1056257,
  -1,
  'Cj1123c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1123c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pglC',
  'undecaprenyl phosphateN,N''-diacetylbacillosamine 1-phosphate transferase',
  1056244,
  1056846,
  -1,
  'Cj1124c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1124c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pglA',
  'N,N''-diacetylbacillosaminyl-diphospho-undecaprenolalpha-1,3-N-acetylgalactosaminyltransferase',
  1056839,
  1057969,
  -1,
  'Cj1125c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1125c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pglB',
  'undecaprenyl-diphosphooligosaccharide--proteinglycotransferase',
  1057979,
  1060120,
  -1,
  'Cj1126c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1126c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pglJ',
  'N-acetylgalactosamine-N,N''-diacetylbacillosaminyl-diphospho-undecaprenol4-alpha-N-acetylgalactosaminyltransferase',
  1060124,
  1061221,
  -1,
  'Cj1127c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1127c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pglI',
  'GalNAc(5)-diNAcBac-PP-undecaprenolbeta-1,3-glucosyltransferase',
  1061209,
  1062138,
  -1,
  'Cj1128c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1128c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pglH',
  'GalNAc-alpha-(1->4)-GalNAc-alpha-(1->3)-diNAcBac-PP-undecaprenolalpha-1,4-N-acetyl-D-galactosaminyltransferase',
  1062131,
  1063210,
  -1,
  'Cj1129c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1129c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pglK',
  'protein glycosylation K',
  1063207,
  1064901,
  -1,
  'Cj1130c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1130c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gne',
  'UDP-GlcNAc/Glc 4-epimerase',
  1064895,
  1065881,
  -1,
  'Cj1131c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1131c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344525.1',
  'hypothetical protein',
  1065939,
  1066733,
  -1,
  'Cj1132c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1132c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'waaC',
  'heptosyltransferase I',
  1066799,
  1067827,
  1,
  'Cj1133',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1133'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'htrB',
  'lipid A biosynthesis lauroyl acyltransferase',
  1067817,
  1068704,
  1,
  'Cj1134',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1134'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344528.1',
  'glucosyltransferase',
  1068701,
  1070248,
  1,
  'Cj1135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344529.1',
  'glycosyltransferase',
  1070252,
  1071424,
  1,
  'Cj1136',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1136'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344530.1',
  'glycosyltransferase',
  1071408,
  1072403,
  -1,
  'Cj1137c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1137c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344531.1',
  'glycosyltransferase',
  1072461,
  1073630,
  1,
  'Cj1138',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1138'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'wlaN',
  'beta-1,3 galactosyltransferase',
  1073619,
  1074530,
  -1,
  'Cj1139c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1139c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cstIII',
  'alpha-2,3 sialyltransferase',
  1074585,
  1075469,
  1,
  'Cj1140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'neuB1',
  'sialic acid synthase',
  1075450,
  1076481,
  1,
  'Cj1141',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1141'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'neuC1',
  'UDP-N-acetylglucosamine 2-epimerase',
  1076478,
  1077593,
  1,
  'Cj1142',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1142'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'neuA1',
  'bifunctionalbeta-1,4-N-acetylgalactosaminyltransferase/CMP-Neu5Acsynthase',
  1077590,
  1079200,
  1,
  'Cj1143',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1143'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344537.1',
  'hypothetical protein',
  1079195,
  1080041,
  -1,
  'Cj1145c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1145c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'waaV',
  'glucosyltransferase',
  1080025,
  1080849,
  -1,
  'Cj1146c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1146c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'waaF',
  'heptosyltransferase II',
  1080908,
  1081867,
  1,
  'Cj1148',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1148'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gmhA',
  'phosphoheptose isomerase',
  1081848,
  1082408,
  -1,
  'Cj1149c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1149c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hldE',
  'bifunctional D-beta-D-heptose 7-phosphatekinase/D-beta-D-heptose 1-phosphate adenylyltransferase',
  1082405,
  1083790,
  -1,
  'Cj1150c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1150c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hldD',
  'ADP-glyceromanno-heptose 6-epimerase',
  1083783,
  1084736,
  -1,
  'Cj1151c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1151c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gmhB',
  'D-glycero-alpha-D-manno-heptose-1,7-bisphosphate7-phosphatase',
  1084737,
  1085297,
  -1,
  'Cj1152c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1152c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344544.1',
  'cytochrome C',
  1085379,
  1085681,
  1,
  'Cj1153',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1153'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344545.1',
  'cbb3-type cytochrome oxidase maturation protein',
  1085704,
  1085910,
  -1,
  'Cj1154c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1154c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344546.1',
  'cation-transporting ATPase',
  1085907,
  1088264,
  -1,
  'Cj1155c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1155c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rho',
  'transcription termination factor Rho',
  1088373,
  1089671,
  1,
  'Cj1156',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1156'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dnaX',
  'DNA polymerase III subunits gamma and tau',
  1089675,
  1091204,
  1,
  'Cj1157',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1157'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344549.1',
  'hypothetical protein',
  1091201,
  1091428,
  -1,
  'Cj1158c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1158c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344550.1',
  'hypothetical protein',
  1091407,
  1091529,
  -1,
  'Cj1159c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1159c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344551.1',
  'membrane protein',
  1091544,
  1091723,
  -1,
  'Cj1160c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1160c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344552.1',
  'cation-transporting ATPase',
  1091795,
  1093894,
  -1,
  'Cj1161c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1161c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344553.1',
  'heavy-metal-associated domain-containingprotein',
  1093894,
  1094088,
  -1,
  'Cj1162c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1162c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344554.1',
  'cation transport protein',
  1094078,
  1095028,
  -1,
  'Cj1163c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1163c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344555.1',
  'hypothetical protein',
  1095104,
  1095367,
  -1,
  'Cj1164c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1164c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344556.1',
  'integral membrane protein',
  1095437,
  1095931,
  -1,
  'Cj1165c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1165c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344557.1',
  'integral membrane protein',
  1095928,
  1096704,
  -1,
  'Cj1166c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1166c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ldh',
  'L-lactate dehydrogenase',
  1096771,
  1097697,
  1,
  'Cj1167',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1167'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344559.1',
  'integral membrane protein',
  1097694,
  1098296,
  -1,
  'Cj1168c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1168c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344560.1',
  'periplasmic protein',
  1098377,
  1098604,
  -1,
  'Cj1169c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1169c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'omp50',
  'outer membrane protein',
  1098615,
  1100036,
  -1,
  'Cj1170c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1170c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ppi',
  'peptidyl-prolyl cis-trans isomerase',
  1100192,
  1100674,
  -1,
  'Cj1171c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1171c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344563.1',
  'transcriptional regulator',
  1100684,
  1101391,
  -1,
  'Cj1172c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1172c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344564.1',
  'multidrug resistance protein',
  1101500,
  1101841,
  1,
  'Cj1173',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1173'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344565.1',
  'multidrug resistance protein',
  1101841,
  1102149,
  1,
  'Cj1174',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1174'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'argS',
  'arginine--tRNA ligase',
  1102167,
  1103759,
  -1,
  'Cj1175c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1175c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tatA',
  'Sec-independent protein translocase',
  1103771,
  1104010,
  -1,
  'Cj1176c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1176c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gmk',
  'guanylate kinase',
  1104012,
  1104635,
  -1,
  'Cj1177c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1177c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344569.1',
  'highly acidic protein',
  1104632,
  1106260,
  -1,
  'Cj1178c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1178c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliR',
  'flagellar biosynthesis protein FliR',
  1106317,
  1107084,
  -1,
  'Cj1179c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1179c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344571.1',
  'ABC transporter ATP-binding protein',
  1107071,
  1107706,
  -1,
  'Cj1180c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1180c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tsf',
  'elongation factor Ts',
  1107719,
  1108792,
  -1,
  'Cj1181c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1181c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsB',
  '30S ribosomal protein S2',
  1108792,
  1109583,
  -1,
  'Cj1182c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1182c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cfa',
  'cyclopropane-fatty-acyl-phospholipid synthase',
  1109699,
  1110862,
  -1,
  'Cj1183c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1183c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'petC',
  'ubiquinol-cytochrome C reductase cytochrome Csubunit',
  1110990,
  1112114,
  -1,
  'Cj1184c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1184c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'petB',
  'ubiquinol-cytochrome C reductase cytochrome Bsubunit',
  1112111,
  1113361,
  -1,
  'Cj1185c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1185c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'petA',
  'ubiquinol-cytochrome C reductase iron-sulfursubunit',
  1113363,
  1113866,
  -1,
  'Cj1186c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1186c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'arsB',
  'arsenical pump membrane protein',
  1113956,
  1115242,
  -1,
  'Cj1187c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1187c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gidA',
  'tRNA uridine 5-carboxymethylaminomethylmodification protein GidA',
  1115243,
  1117102,
  -1,
  'Cj1188c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1188c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cetB',
  'bipartate energy taxis response protein CetB',
  1117190,
  1117687,
  -1,
  'Cj1189c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1189c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cetA',
  'bipartate energy taxis response protein CetA',
  1117705,
  1119084,
  -1,
  'Cj1190c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1190c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344582.1',
  'PAS domain-containing signal-transduction sensorprotein',
  1119205,
  1119699,
  -1,
  'Cj1191c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1191c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dctA',
  'C4-dicarboxylate transport protein',
  1119968,
  1121344,
  1,
  'Cj1192',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1192'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344584.1',
  'periplasmic protein',
  1121341,
  1122147,
  -1,
  'Cj1193c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1193c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344585.1',
  'phosphate permease',
  1122289,
  1123815,
  1,
  'Cj1194',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1194'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pyrC2',
  'dihydroorotase',
  1123823,
  1125001,
  -1,
  'Cj1195c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1195c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gpsA',
  'glycerol-3-phosphate dehydrogenase',
  1125011,
  1125907,
  -1,
  'Cj1196c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1196c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gatB',
  'aspartyl/glutamyl-tRNA amidotransferase subunitB',
  1125904,
  1127322,
  -1,
  'Cj1197c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1197c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344589.1',
  'S-ribosylhomocysteine lyase',
  1127437,
  1127931,
  1,
  'Cj1198',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1198'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344590.1',
  'oxidoreductase',
  1128243,
  1129235,
  1,
  'Cj1199',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1199'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344591.1',
  'NLPA family lipoprotein',
  1129228,
  1130016,
  1,
  'Cj1200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'metE',
  '5-methyltetrahydropteroyltriglutamate--homocysteine methyltransferase',
  1130028,
  1132292,
  1,
  'Cj1201',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1201'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'metF',
  'methylenetetrahydrofolate reductase',
  1132302,
  1133150,
  1,
  'Cj1202',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1202'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344594.1',
  'integral membrane protein',
  1133172,
  1133363,
  -1,
  'Cj1203c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1203c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'atpB',
  'ATP synthase subunit A',
  1133360,
  1134040,
  -1,
  'Cj1204c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1204c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'radA',
  'DNA repair protein RadA',
  1134109,
  1135449,
  -1,
  'Cj1205c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1205c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ftsY',
  'signal recognition particle protein',
  1135449,
  1136315,
  -1,
  'Cj1206c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1206c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344598.1',
  'lipoprotein thiredoxin',
  1136315,
  1136872,
  -1,
  'Cj1207c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1207c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344599.1',
  '5-formyltetrahydrofolate cyclo-ligase',
  1136955,
  1137581,
  1,
  'Cj1208',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1208'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344600.1',
  'ribonuclease Y',
  1137502,
  1139055,
  1,
  'Cj1209',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1209'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344601.1',
  'integral membrane protein',
  1139064,
  1139621,
  1,
  'Cj1210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344602.1',
  'competence family protein',
  1139621,
  1140880,
  1,
  'Cj1211',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1211'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rbn',
  'ribonuclease BN',
  1140824,
  1141630,
  -1,
  'Cj1212c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1212c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glcD',
  'glycolate oxidase subunit D',
  1141634,
  1143016,
  -1,
  'Cj1213c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1213c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344605.1',
  'exporting protein',
  1143019,
  1143744,
  -1,
  'Cj1214c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1214c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344606.1',
  'peptidase M23 family protein',
  1143866,
  1145026,
  1,
  'Cj1215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344607.1',
  'hypothetical protein',
  1145023,
  1145226,
  -1,
  'Cj1216c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1216c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344608.1',
  'laccase domain-containing protein',
  1145228,
  1145908,
  -1,
  'Cj1217c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1217c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ribA',
  'riboflavin synthase subunit alpha',
  1145872,
  1146483,
  -1,
  'Cj1218c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1218c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344610.1',
  'periplasmic protein',
  1146492,
  1149032,
  -1,
  'Cj1219c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1219c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'groES',
  'co-chaperonin GroES',
  1149194,
  1149454,
  1,
  'Cj1220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'groEL',
  'chaperone GroEL',
  1149475,
  1151112,
  1,
  'Cj1221',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1221'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dccS',
  'two-component sensor histidine kinase',
  1151155,
  1152345,
  -1,
  'Cj1222c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1222c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dccR',
  'two-component regulator',
  1152338,
  1153003,
  -1,
  'Cj1223c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1223c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344615.1',
  'iron-binding protein',
  1153151,
  1153750,
  1,
  'Cj1224',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1224'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344616.1',
  'hypothetical protein',
  1153761,
  1154009,
  1,
  'Cj1225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAAsn',
  '—',
  1154100,
  1154174,
  -1,
  'Cjp22',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp22'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344617.1',
  'two-component sensor histidine kinase',
  1154267,
  1155514,
  -1,
  'Cj1226c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1226c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344618.1',
  'two-component regulator',
  1155511,
  1156185,
  -1,
  'Cj1227c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1227c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'htrA',
  'serine protease',
  1156261,
  1157679,
  -1,
  'Cj1228c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1228c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cbpA',
  'curved-DNA binding protein',
  1157879,
  1158772,
  1,
  'Cj1229',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1229'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hspR',
  'heat shock transcriptional regulator',
  1158788,
  1159162,
  1,
  'Cj1230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kefB',
  'glutathione-regulated potassium-efflux systemprotein',
  1159168,
  1160793,
  1,
  'Cj1231',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1231'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344623.1',
  'hypothetical protein',
  1160803,
  1161135,
  1,
  'Cj1232',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1232'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344624.1',
  'HAD-superfamily hydrolase',
  1161132,
  1161752,
  1,
  'Cj1233',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1233'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glyS',
  'glycine--tRNA ligase subunit beta',
  1161808,
  1163802,
  1,
  'Cj1234',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1234'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344626.1',
  'peptidase M23 family protein',
  1163799,
  1164620,
  1,
  'Cj1235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344627.1',
  'hypothetical protein',
  1164617,
  1165567,
  1,
  'Cj1236',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1236'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344628.1',
  'phosphatase',
  1165564,
  1166538,
  -1,
  'Cj1237c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1237c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pdxJ',
  'pyridoxine 5''-phosphate synthase',
  1166594,
  1167367,
  1,
  'Cj1238',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1238'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pdxA',
  '4-hydroxythreonine-4-phosphate dehydrogenase',
  1167364,
  1168458,
  1,
  'Cj1239',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1239'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344631.1',
  'periplasmic protein',
  1168448,
  1169050,
  -1,
  'Cj1240c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1240c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344632.1',
  'MFS transport protein',
  1169163,
  1170362,
  1,
  'Cj1241',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1241'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344633.1',
  'hypothetical protein',
  1170418,
  1170738,
  1,
  'Cj1242',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1242'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hemE',
  'uroporphyrinogen decarboxylase',
  1170922,
  1171944,
  1,
  'Cj1243',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1243'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344635.1',
  'radical SAM domain-containing protein',
  1171941,
  1172843,
  1,
  'Cj1244',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1244'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344636.1',
  'membrane protein',
  1172840,
  1174036,
  -1,
  'Cj1245c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1245c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'uvrC',
  'excinuclease ABC subunit C',
  1174038,
  1175840,
  -1,
  'Cj1246c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1246c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344638.1',
  'hypothetical protein',
  1175833,
  1176327,
  -1,
  'Cj1247c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1247c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'guaA',
  'GMP synthase',
  1176466,
  1178001,
  1,
  'Cj1248',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1248'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344640.1',
  'hypothetical protein',
  1178087,
  1179547,
  1,
  'Cj1249',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1249'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purD',
  'phosphoribosylamine--glycine ligase',
  1179787,
  1181037,
  1,
  'Cj1250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344642.1',
  'hypothetical protein',
  1181034,
  1181486,
  1,
  'Cj1251',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1251'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344643.1',
  'hypothetical protein',
  1181476,
  1183524,
  1,
  'Cj1252',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1252'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pnp',
  'polynucleotide phosphorylase',
  1183594,
  1185753,
  1,
  'Cj1253',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1253'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344645.1',
  'hypothetical protein',
  1185750,
  1186232,
  1,
  'Cj1254',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1254'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344646.1',
  'isomerase',
  1186290,
  1186499,
  1,
  'Cj1255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344647.1',
  'membrane protein',
  1186496,
  1187158,
  -1,
  'Cj1256c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1256c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344648.1',
  'efflux pump protein',
  1187176,
  1188360,
  -1,
  'Cj1257c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1257c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344649.1',
  'phosphotyrosine protein phosphatase',
  1188414,
  1188869,
  1,
  'Cj1258',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1258'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'porA',
  'major outer membrane protein',
  1189121,
  1190395,
  1,
  'Cj1259',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1259'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dnaJ',
  'chaperone protein DnaJ',
  1190510,
  1191631,
  -1,
  'Cj1260c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1260c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'racR',
  'two-component regulator',
  1191788,
  1192459,
  1,
  'Cj1261',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1261'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'racS',
  'two-component sensor histidine kinase',
  1192456,
  1193691,
  1,
  'Cj1262',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1262'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'recR',
  'recombination protein RecR',
  1193691,
  1194263,
  1,
  'Cj1263',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1263'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hydD',
  'hydrogenase maturation protease',
  1194260,
  1194796,
  -1,
  'Cj1264c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1264c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hydC',
  'Ni/Fe-hydrogenase B-type cytochrome subunit',
  1194793,
  1195485,
  -1,
  'Cj1265c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1265c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hydB',
  'Ni/Fe-hydrogenase large subunit',
  1195496,
  1197211,
  -1,
  'Cj1266c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1266c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hydA',
  'Ni/Fe-hydrogenase small subunit',
  1197214,
  1198353,
  -1,
  'Cj1267c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1267c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mnmC',
  'bifunctional tRNA(mnm(5)s(2)U34)-methyltransferase/FAD-dependentcmnm(5)s(2)U34 oxidoreductase',
  1198474,
  1200315,
  -1,
  'Cj1268c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1268c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'amiA',
  'N-acetylmuramoyl-L-alanine amidase',
  1200312,
  1202291,
  -1,
  'Cj1269c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1269c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344661.1',
  '2-nitropropane dioxygenase',
  1202291,
  1203382,
  -1,
  'Cj1270c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1270c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tyrS',
  'tyrosine--tRNA ligase',
  1203379,
  1204584,
  -1,
  'Cj1271c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1271c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'spoT',
  'guanosine-3'',5''-bis(diphosphate)3''-pyrophosphohydrolase',
  1204596,
  1206791,
  -1,
  'Cj1272c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1272c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpoZ',
  'DNA-directed RNA polymerase subunit omega',
  1206775,
  1206999,
  -1,
  'Cj1273c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1273c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pyrH',
  'uridylate kinase',
  1207010,
  1207729,
  -1,
  'Cj1274c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1274c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344666.1',
  'peptidase M23 family protein',
  1207781,
  1208974,
  -1,
  'Cj1275c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1275c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344667.1',
  'integral membrane protein',
  1208971,
  1209777,
  -1,
  'Cj1276c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1276c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344668.1',
  'ABC transporter ATP-binding protein',
  1209764,
  1210429,
  -1,
  'Cj1277c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1277c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'trmB',
  'tRNA (guanine-N(7)-)-methyltransferase',
  1210499,
  1211677,
  -1,
  'Cj1278c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1278c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344670.1',
  'fibronectin domain-containing lipoprotein',
  1211677,
  1212912,
  -1,
  'Cj1279c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1279c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344671.1',
  'pseudouridine synthase',
  1212857,
  1213825,
  -1,
  'Cj1280c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1280c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mrdB',
  'rod shape-determining protein RodA',
  1213903,
  1215003,
  1,
  'Cj1282',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1282'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAMet',
  '—',
  1215057,
  1215133,
  1,
  'Cjp23',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp23'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAPhe',
  '—',
  1215241,
  1215316,
  -1,
  'Cjp24',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp24'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ktrB',
  'K+ uptake protein',
  1215456,
  1216799,
  1,
  'Cj1283',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1283'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ktrA',
  'K+ uptake protein',
  1216810,
  1217460,
  1,
  'Cj1284',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1284'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344675.1',
  'hypothetical protein',
  1217457,
  1218128,
  -1,
  'Cj1285c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1285c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'upp',
  'uracil phosphoribosyltransferase',
  1218134,
  1218760,
  -1,
  'Cj1286c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1286c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344677.1',
  'malate oxidoreductase',
  1218757,
  1219992,
  -1,
  'Cj1287c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1287c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gltX',
  'glutamate--tRNA ligase',
  1219994,
  1221385,
  -1,
  'Cj1288c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1288c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344679.1',
  'hypothetical protein',
  1221450,
  1222265,
  1,
  'Cj1289',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1289'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'accC',
  'biotin carboxylase',
  1222303,
  1223634,
  -1,
  'Cj1290c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1290c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'accB',
  'acetyl-CoA carboxylase, biotin carboxyl carrierprotein',
  1223636,
  1224091,
  -1,
  'Cj1291c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1291c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dcd',
  'deoxycytidine triphosphate deaminase',
  1224239,
  1224799,
  1,
  'Cj1292',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1292'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pseB',
  'UDP-N-acetylglucosamine 4,6-dehydratase',
  1224849,
  1225853,
  1,
  'Cj1293',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1293'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pseC',
  'UDP-4-amino-4,6-dideoxy-N-acetyl-beta-L-altrosamine transaminase',
  1225855,
  1226985,
  1,
  'Cj1294',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1294'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344685.1',
  'hypothetical protein',
  1226978,
  1228285,
  1,
  'Cj1295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1228282,
  1229075,
  1,
  'Cj1296',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1296'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344688.1',
  'N-acetyltransferase',
  1229096,
  1229887,
  1,
  'Cj1298',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1298'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'acpP2',
  'acyl carrier protein',
  1229918,
  1230148,
  1,
  'Cj1299',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1299'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344690.1',
  'SAM domain-containing methyltransferase',
  1230145,
  1231038,
  1,
  'Cj1300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344691.1',
  'hypothetical protein',
  1231031,
  1231447,
  1,
  'Cj1301',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1301'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344692.1',
  'HAD-superfamily hydrolase',
  1231444,
  1233006,
  1,
  'Cj1302',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1302'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fabH2',
  '3-oxoacyl-ACP synthase',
  1232996,
  1234057,
  1,
  'Cj1303',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1303'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'acpP3',
  'acyl carrier protein',
  1234057,
  1234278,
  1,
  'Cj1304',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1304'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344695.1',
  'hypothetical protein',
  1234292,
  1235509,
  -1,
  'Cj1305c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1305c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344696.1',
  'hypothetical protein',
  1235522,
  1236748,
  -1,
  'Cj1306c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1306c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344697.1',
  'amino acid activating protein',
  1236809,
  1238317,
  1,
  'Cj1307',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1307'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344698.1',
  'acyl carrier protein',
  1238357,
  1238584,
  1,
  'Cj1308',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1308'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344699.1',
  'hypothetical protein',
  1238581,
  1239651,
  -1,
  'Cj1309c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1309c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344700.1',
  'hypothetical protein',
  1239673,
  1240887,
  -1,
  'Cj1310c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1310c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pseF',
  'pseudaminic acid cytidylyltransferase',
  1240966,
  1241664,
  1,
  'Cj1311',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1311'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pseG',
  'UDP-2,4-diacetamido-2,4,6-trideoxy-beta-L-altropyranose hydrolase',
  1241648,
  1242472,
  1,
  'Cj1312',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1312'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pseH',
  'N-acetyltransferase',
  1242469,
  1242942,
  1,
  'Cj1313',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1313'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisF',
  'imidazole glycerol phosphate synthase subunitHisF',
  1242907,
  1243653,
  -1,
  'Cj1314c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1314c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisH',
  'imidazole glycerol phosphate synthase subunitHisH',
  1243654,
  1244259,
  -1,
  'Cj1315c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1315c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pseA',
  'pseudaminic acid biosynthesis protein PseA',
  1244256,
  1245392,
  -1,
  'Cj1316c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1316c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pseI',
  'pseudaminic acid synthase',
  1245650,
  1246681,
  1,
  'Cj1317',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1317'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344708.1',
  'hypothetical protein',
  1246678,
  1248627,
  1,
  'Cj1318',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1318'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344709.1',
  'NAD-dependent 4,6-dehydratase',
  1248624,
  1249595,
  1,
  'Cj1319',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1319'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344710.1',
  'PLP-dependent aminotransferase',
  1249588,
  1250742,
  1,
  'Cj1320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1250852,
  1251394,
  1,
  'Cj1321',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1321'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1251467,
  1252161,
  1,
  'Cj1322',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1322'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344714.1',
  'hypothetical protein',
  1252278,
  1253399,
  1,
  'Cj1324',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1324'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344715.1',
  'methyltransferase',
  1253417,
  1254092,
  1,
  'Cj1325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'neuB2',
  'N,N''-diacetyllegionaminic acid synthase',
  1254132,
  1255136,
  1,
  'Cj1327',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1327'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'neuC2',
  'GDP/UDP-N,N''-diacetylbacillosamine 2-epimerase',
  1255129,
  1256283,
  1,
  'Cj1328',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1328'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344718.1',
  'sugar-phosphate nucleotide transferase',
  1256292,
  1257317,
  1,
  'Cj1329',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1329'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344719.1',
  'isomerase',
  1257314,
  1258219,
  1,
  'Cj1330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ptmB',
  'CMP-N,N''-diacetyllegionaminic acid synthase',
  1258212,
  1258919,
  1,
  'Cj1331',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1331'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ptmA',
  'flagellin modification protein A',
  1258919,
  1259689,
  1,
  'Cj1332',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1332'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pseD',
  'protein PseD',
  1259677,
  1261638,
  1,
  'Cj1333',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1333'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344723.1',
  'hypothetical protein',
  1261635,
  1263494,
  1,
  'Cj1334',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1334'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344724.1',
  'hypothetical protein',
  1263507,
  1265454,
  1,
  'Cj1335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pseE',
  'protein PseE',
  1265451,
  1267337,
  1,
  'Cj1337',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1337'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flaB',
  'flagellin B',
  1267368,
  1269086,
  -1,
  'Cj1338c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1338c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flaA',
  'flagellin A',
  1269232,
  1270950,
  -1,
  'Cj1339c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1339c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344728.1',
  'motility protein',
  1271047,
  1272864,
  -1,
  'Cj1340c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1340c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344729.1',
  'hypothetical protein',
  1272861,
  1274684,
  -1,
  'Cj1341c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1341c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344730.1',
  'hypothetical protein',
  1274694,
  1275935,
  -1,
  'Cj1342c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1342c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344731.1',
  'periplasmic protein',
  1275935,
  1276450,
  -1,
  'Cj1343c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1343c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344732.1',
  'tRNA N6-adenosine threonylcarbamoyltransferase',
  1276451,
  1277458,
  -1,
  'Cj1344c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1344c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344733.1',
  'periplasmic protein',
  1277455,
  1278849,
  -1,
  'Cj1345c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1345c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dxr',
  '1-deoxy-D-xylulose 5-phosphate reductoisomerase',
  1278851,
  1279921,
  -1,
  'Cj1346c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1346c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cdsA',
  'phosphatidate cytidylyltransferase',
  1279918,
  1280643,
  -1,
  'Cj1347c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1347c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344736.1',
  'hypothetical protein',
  1280652,
  1280990,
  -1,
  'Cj1348c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1348c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344737.1',
  'fibronectin/fibrinogen-binding protein',
  1280992,
  1282299,
  -1,
  'Cj1349c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1349c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mobA',
  'molybdopterin-guanine dinucleotide biosynthesisprotein',
  1282361,
  1282936,
  1,
  'Cj1350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pldA',
  'phospholipase A',
  1282933,
  1283922,
  1,
  'Cj1351',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1351'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ceuB',
  'enterochelin uptake permease',
  1284008,
  1284976,
  1,
  'Cj1352',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1352'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ceuC',
  'enterochelin uptake permease',
  1284969,
  1285907,
  1,
  'Cj1353',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1353'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ceuD',
  'enterochelin uptake ATP-binding protein',
  1285904,
  1286659,
  1,
  'Cj1354',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1354'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ceuE',
  'enterochelin uptake substrate-binding protein',
  1286672,
  1287664,
  1,
  'Cj1355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNASer',
  '—',
  1287737,
  1287826,
  -1,
  'Cjp25',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp25'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344744.1',
  'integral membrane protein',
  1287890,
  1288444,
  -1,
  'Cj1356c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1356c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nrfA',
  'cytochrome c nitrite reductase cytochrome c552subunit',
  1288580,
  1290412,
  -1,
  'Cj1357c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1357c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nrfH',
  'cytochrome c nitrite reductase small subunit',
  1290427,
  1290942,
  -1,
  'Cj1358c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1358c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ppk',
  'polyphosphate kinase',
  1291131,
  1293215,
  1,
  'Cj1359',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1359'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1293300,
  1293658,
  -1,
  'Cjs01',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjs01'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344749.1',
  'hypothetical protein',
  1293659,
  1294111,
  -1,
  'Cj1361c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1361c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ruvB',
  'Holliday junction DNA helicase RuvB',
  1294160,
  1295167,
  1,
  'Cj1362',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1362'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'amaA',
  'acid membrane antigen A',
  1295171,
  1296214,
  1,
  'Cj1363',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1363'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fumC',
  'fumarate hydratase',
  1296244,
  1297635,
  -1,
  'Cj1364c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1364c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344753.1',
  'serine protease',
  1297691,
  1300816,
  -1,
  'Cj1365c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1365c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glmS',
  'glucosamine--fructose-6-phosphateaminotransferase',
  1300819,
  1302615,
  -1,
  'Cj1366c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1366c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344755.1',
  'nucleotidyltransferase',
  1302620,
  1304968,
  -1,
  'Cj1367c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1367c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344756.1',
  'hypothetical protein',
  1305112,
  1306176,
  1,
  'Cj1368',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1368'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344757.1',
  'permease',
  1306186,
  1307505,
  1,
  'Cj1369',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1369'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344758.1',
  'nucleotide phosphoribosyltransferase',
  1307519,
  1307962,
  1,
  'Cj1370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344759.1',
  'periplasmic protein',
  1308007,
  1308705,
  1,
  'Cj1371',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1371'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344760.1',
  'periplasmic protein',
  1308715,
  1309284,
  1,
  'Cj1372',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1372'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344761.1',
  'integral membrane protein',
  1309284,
  1311755,
  1,
  'Cj1373',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1373'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344762.1',
  'Non-canonical purine NTP pyrophosphatase',
  1311786,
  1312388,
  -1,
  'Cj1374c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1374c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344763.1',
  'multidrug efflux transporter',
  1312555,
  1313850,
  1,
  'Cj1375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344764.1',
  'periplasmic protein',
  1313847,
  1314656,
  1,
  'Cj1376',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1376'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344765.1',
  'ferredoxin',
  1314649,
  1316310,
  -1,
  'Cj1377c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1377c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'selA',
  'L-seryl-tRNA(Sec) selenium transferase',
  1316388,
  1317710,
  1,
  'Cj1378',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1378'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'selB',
  'selenocysteine-specific elongation factor',
  1317707,
  1319512,
  1,
  'Cj1379',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1379'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344768.1',
  'periplasmic protein',
  1319561,
  1320271,
  1,
  'Cj1380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344769.1',
  'lipoprotein',
  1320277,
  1320807,
  1,
  'Cj1381',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1381'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fldA',
  'flavodoxin FldA',
  1320852,
  1321343,
  -1,
  'Cj1382c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1382c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344771.1',
  'hypothetical protein',
  1321343,
  1322038,
  -1,
  'Cj1383c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1383c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344772.1',
  'hypothetical protein',
  1322041,
  1322355,
  -1,
  'Cj1384c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1384c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'katA',
  'catalase',
  1322526,
  1323950,
  1,
  'Cj1385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344774.1',
  'ankyrin repeat-containing protein',
  1324007,
  1324477,
  1,
  'Cj1386',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1386'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344775.1',
  'hypothetical protein',
  1324478,
  1325134,
  -1,
  'Cj1387c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1387c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344776.1',
  'endoribonuclease L-PSP',
  1325302,
  1325664,
  1,
  'Cj1388',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1388'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1325668,
  1327107,
  1,
  'Cj1389',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1389'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'metC',
  '—',
  1327120,
  1328282,
  1,
  'Cj1392',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1392'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344779.1',
  'adenylosuccinate lyase',
  1328292,
  1329659,
  1,
  'Cj1394',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1394'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1329668,
  1331008,
  1,
  'Cj1395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344780.1',
  'ferrous iron transport protein',
  1331090,
  1331314,
  1,
  'Cj1397',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1397'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'feoB',
  'ferrous iron transport protein',
  1331311,
  1333152,
  1,
  'Cj1398',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1398'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hydA2',
  'Ni/Fe-hydrogenase small subunit',
  1333149,
  1334642,
  -1,
  'Cj1399c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1399c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fabI',
  'enoyl-ACP reductase',
  1334646,
  1335470,
  -1,
  'Cj1400c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1400c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tpiA',
  'triosephosphate isomerase',
  1335474,
  1336145,
  -1,
  'Cj1401c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1401c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pgk',
  'phosphoglycerate kinase',
  1336142,
  1337344,
  -1,
  'Cj1402c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1402c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gapA',
  'glyceraldehyde 3-phosphate dehydrogenase',
  1337347,
  1338345,
  -1,
  'Cj1403c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1403c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nadD',
  'nicotinate-nucleotide adenylyltransferase',
  1338404,
  1338949,
  1,
  'Cj1404',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1404'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344788.1',
  'fibosomal silencing factor RsfS',
  1338977,
  1339303,
  1,
  'Cj1405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344789.1',
  'periplasmic protein',
  1339362,
  1339712,
  -1,
  'Cj1406c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1406c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344790.1',
  'phospho-sugar mutase',
  1339759,
  1341147,
  -1,
  'Cj1407c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1407c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliL',
  'flagellar basal body-associated protein FliL',
  1341250,
  1341786,
  1,
  'Cj1408',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1408'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'acpS',
  'holo-ACP synthase',
  1341786,
  1342133,
  1,
  'Cj1409',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1409'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344793.1',
  'membrane protein',
  1342134,
  1342553,
  -1,
  'Cj1410c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1410c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344794.1',
  'cytochrome P450',
  1342550,
  1343911,
  -1,
  'Cj1411c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1411c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344795.1',
  'integral membrane protein',
  1343908,
  1345029,
  -1,
  'Cj1412c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1412c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kpsS',
  'capsule polysaccharide modification protein',
  1345102,
  1346286,
  -1,
  'Cj1413c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1413c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kpsC',
  'capsule polysaccharide modification protein',
  1346283,
  1348352,
  -1,
  'Cj1414c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1414c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cysC',
  'adenylyl-sulfate kinase',
  1348349,
  1348861,
  -1,
  'Cj1415c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1415c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344799.1',
  'sugar nucleotidyltransferase',
  1348851,
  1349612,
  -1,
  'Cj1416c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1416c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344800.1',
  'amidotransferase',
  1349614,
  1350216,
  -1,
  'Cj1417c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1417c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344801.1',
  'hypothetical protein',
  1350207,
  1352546,
  -1,
  'Cj1418c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1418c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344802.1',
  'methyltransferase',
  1352561,
  1353322,
  -1,
  'Cj1419c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1419c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344803.1',
  'methyltransferase',
  1353375,
  1354148,
  -1,
  'Cj1420c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1420c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344804.1',
  'sugar transferase',
  1354215,
  1356053,
  -1,
  'Cj1421c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1421c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344805.1',
  'sugar transferase',
  1356108,
  1357985,
  -1,
  'Cj1422c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1422c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hddC',
  'D-glycero-D-manno-heptose 1-phosphateguanosyltransferase',
  1358036,
  1358701,
  -1,
  'Cj1423c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1423c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gmhA2',
  'phosphoheptose isomerase',
  1358689,
  1359294,
  -1,
  'Cj1424c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1424c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hddA',
  'D-glycero-D-manno-heptose 7-phosphate kinase',
  1359282,
  1360301,
  -1,
  'Cj1425c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1425c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344809.1',
  'methyltransferase family protein',
  1360321,
  1361172,
  -1,
  'Cj1426c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1426c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344810.1',
  'sugar-nucleotide epimerase/dehydratease',
  1361191,
  1362132,
  -1,
  'Cj1427c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1427c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fcl',
  'GDP-L-fucose synthetase',
  1362156,
  1363196,
  -1,
  'Cj1428c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1428c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344812.1',
  'hypothetical protein',
  1363196,
  1364122,
  -1,
  'Cj1429c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1429c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rfbC',
  'dTDP-4-dehydrorhamnose 3,5-epimerase',
  1364126,
  1364671,
  -1,
  'Cj1430c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1430c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hddC',
  'capsular polysaccharide heptosyltransferase',
  1364671,
  1366419,
  -1,
  'Cj1431c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1431c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344815.1',
  'sugar transferase',
  1366422,
  1369517,
  -1,
  'Cj1432c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1432c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344816.1',
  'hypothetical protein',
  1369527,
  1370633,
  -1,
  'Cj1433c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1433c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344817.1',
  'sugar transferase',
  1370667,
  1372004,
  -1,
  'Cj1434c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1434c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344818.1',
  'phosphatase',
  1372056,
  1372691,
  -1,
  'Cj1435c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1435c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344819.1',
  'aminotransferase',
  1372695,
  1373867,
  -1,
  'Cj1436c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1436c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344820.1',
  'aminotransferase',
  1373917,
  1375020,
  -1,
  'Cj1437c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1437c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344821.1',
  'sugar transferase',
  1375007,
  1377337,
  -1,
  'Cj1438c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1438c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'glf',
  'UDP-galactopyranose mutase',
  1377339,
  1378445,
  -1,
  'Cj1439c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1439c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344823.1',
  'sugar transferase',
  1378483,
  1379706,
  -1,
  'Cj1440c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1440c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kfiD',
  'UDP-glucose 6-dehydrogenase',
  1379716,
  1380897,
  -1,
  'Cj1441c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1441c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344825.1',
  'sugar transferase',
  1380894,
  1382528,
  -1,
  'Cj1442c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1442c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kpsF',
  'D-arabinose 5-phosphate isomerase',
  1382528,
  1383475,
  -1,
  'Cj1443c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1443c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kpsD',
  'capsule polysaccharide ABC transportersubstrate-binding protein',
  1383486,
  1385144,
  -1,
  'Cj1444c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1444c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kpsE',
  'capsule polysaccharide ABC transporter permease',
  1385146,
  1386264,
  -1,
  'Cj1445c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1445c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kpsT',
  'capsule polysaccharide ABC transporterATP-binding protein',
  1386264,
  1386926,
  -1,
  'Cj1447c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1447c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kpsM',
  'capsule polysaccharide ABC transporter permease',
  1386923,
  1387705,
  -1,
  'Cj1448c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1448c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344831.1',
  'hypothetical protein',
  1387777,
  1388184,
  -1,
  'Cj1449c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1449c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344832.1',
  'ATP/GTP-binding protein',
  1388259,
  1388822,
  1,
  'Cj1450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dut',
  'dUTPase',
  1388859,
  1389548,
  1,
  'Cj1451',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1451'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344834.1',
  'integral membrane protein',
  1389550,
  1390263,
  1,
  'Cj1452',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1452'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tilS',
  'tRNA(Ile)-lysidine synthase',
  1390246,
  1391211,
  -1,
  'Cj1453c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1453c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344836.1',
  'ribosomal protein S12 methylthiotransferase',
  1391201,
  1392520,
  -1,
  'Cj1454c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1454c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'prfB',
  'peptide chain release factor 2',
  1392594,
  1393691,
  1,
  'Cj1455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344838.1',
  'periplasmic protein',
  1393849,
  1394163,
  -1,
  'Cj1456c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1456c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'truD',
  'tRNA pseudouridine synthase D',
  1394285,
  1395403,
  -1,
  'Cj1457c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1457c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'thiL',
  'thiamine monophosphate kinase',
  1395372,
  1396193,
  -1,
  'Cj1458c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1458c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344841.1',
  'hypothetical protein',
  1396280,
  1397353,
  1,
  'Cj1459',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1459'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344842.1',
  'hypothetical protein',
  1397350,
  1397733,
  1,
  'Cj1460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344843.1',
  'DNA methylase',
  1397726,
  1398409,
  1,
  'Cj1461',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1461'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgI',
  'flagellar basal body P-ring protein',
  1398468,
  1399514,
  1,
  'Cj1462',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1462'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgJ',
  'flagellar biosynthesis protein FlgJ',
  1399514,
  1399855,
  1,
  'Cj1463',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1463'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgM',
  'flagellar biosynthesis protein FlgM',
  1399918,
  1400115,
  1,
  'Cj1464',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1464'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344847.1',
  'hypothetical protein',
  1400158,
  1400592,
  1,
  'Cj1465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgK',
  'flagellar hook-associated protein FlgK',
  1400602,
  1402428,
  1,
  'Cj1466',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1466'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344849.1',
  'hypothetical protein',
  1402445,
  1403209,
  1,
  'Cj1467',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1467'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344850.1',
  'integral membrane protein',
  1403213,
  1403977,
  1,
  'Cj1468',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1468'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1403970,
  1405150,
  -1,
  'Cj1470c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1470c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ctsE',
  'type II protein secretion system protein E',
  1405147,
  1406706,
  -1,
  'Cj1471c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1471c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344852.1',
  'membrane protein',
  1406696,
  1407283,
  -1,
  'Cj1472c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1472c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ctsP',
  'ATP/GTP-binding protein',
  1407287,
  1407895,
  -1,
  'Cj1473c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1473c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ctsD',
  'type II protein secretion system protein D',
  1407888,
  1409306,
  -1,
  'Cj1474c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1474c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344855.1',
  'hypothetical protein',
  1409278,
  1409595,
  -1,
  'Cj1475c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1475c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344856.1',
  'pyruvate-flavodoxin oxidoreductase',
  1409619,
  1413179,
  -1,
  'Cj1476c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1476c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344857.1',
  'hydrolase',
  1413272,
  1413913,
  -1,
  'Cj1477c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1477c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cadF',
  'outer membrane fibronectin-binding protein',
  1413913,
  1414872,
  -1,
  'Cj1478c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1478c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsI',
  '30S ribosomal protein S9',
  1414997,
  1415386,
  -1,
  'Cj1479c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1479c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplM',
  '50S ribosomal protein L13',
  1415389,
  1415814,
  -1,
  'Cj1480c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1480c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344861.1',
  'helicase',
  1415898,
  1418663,
  -1,
  'Cj1481c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1481c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344862.1',
  'hypothetical protein',
  1418660,
  1421026,
  -1,
  'Cj1482c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1482c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344863.1',
  'lipoprotein',
  1421023,
  1421544,
  -1,
  'Cj1483c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1483c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344864.1',
  'membrane protein',
  1421531,
  1422133,
  -1,
  'Cj1484c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1484c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344865.1',
  'periplasmic protein',
  1422130,
  1422231,
  -1,
  'Cj1485c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1485c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344866.1',
  'periplasmic protein',
  1422228,
  1422449,
  -1,
  'Cj1486c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1486c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ccoP',
  'cbb3-type cytochrome C oxidase subunit III',
  1422446,
  1423309,
  -1,
  'Cj1487c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1487c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ccoQ',
  'cbb3-type cytochrome C oxidase subunit IV',
  1423309,
  1423572,
  -1,
  'Cj1488c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1488c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ccoO',
  'cbb3-type cytochrome c oxidase subunit II',
  1423577,
  1424242,
  -1,
  'Cj1489c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1489c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ccoN',
  'cbb3-type cytochrome c oxidase subunit I',
  1424255,
  1425721,
  -1,
  'Cj1490c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1490c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344871.1',
  'two-component regulator',
  1425847,
  1426527,
  -1,
  'Cj1491c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1491c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344872.1',
  'two-component sensor',
  1426530,
  1427741,
  -1,
  'Cj1492c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1492c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344873.1',
  'integral membrane protein',
  1427738,
  1428397,
  -1,
  'Cj1493c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1493c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'carA',
  'carbamoyl phosphate synthase small subunit',
  1428394,
  1429512,
  -1,
  'Cj1494c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1494c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344875.1',
  'hypothetical protein',
  1429512,
  1430063,
  -1,
  'Cj1495c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1495c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344876.1',
  'periplasmic protein',
  1430156,
  1430674,
  -1,
  'Cj1496c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1496c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344877.1',
  'hypothetical protein',
  1430667,
  1431095,
  -1,
  'Cj1497c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1497c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purA',
  'adenylosuccinate synthetase',
  1431092,
  1432342,
  -1,
  'Cj1498c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1498c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNASeC',
  '—',
  1432370,
  1432467,
  -1,
  'Cjp26',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp26'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344879.1',
  'inner membrane protein',
  1432607,
  1433815,
  1,
  'Cj1500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344880.1',
  'hypothetical protein',
  1433819,
  1434046,
  1,
  'Cj1501',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1501'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'putP',
  'sodium/proline symporter',
  1434062,
  1435549,
  -1,
  'Cj1502c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1502c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'putA',
  'prolinedehydrogenase/delta-1-pyrroline-5-carboxylatedehydrogenase',
  1435549,
  1439037,
  -1,
  'Cj1503c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1503c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'selD',
  'selenide,water dikinase',
  1439168,
  1440094,
  -1,
  'Cj1504c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1504c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344884.1',
  'two-component response regulator',
  1440200,
  1440772,
  -1,
  'Cj1505c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1505c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344885.1',
  'MCP-type signal transduction protein',
  1440883,
  1442985,
  -1,
  'Cj1506c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1506c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344886.1',
  'regulatory protein',
  1443095,
  1443832,
  -1,
  'Cj1507c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1507c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fdhD',
  'formate dehydrogenase accessory protein',
  1443825,
  1444607,
  -1,
  'Cj1508c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1508c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fdhC',
  'formate dehydrogenase cytochrome B subunit',
  1444774,
  1445706,
  -1,
  'Cj1509c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1509c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fdhB',
  'formate dehydrogenase iron-sulfur subunit',
  1445703,
  1446344,
  -1,
  'Cj1510c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1510c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fdhA',
  'formate dehydrogenase large subunit',
  1446341,
  1449145,
  -1,
  'Cj1511c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1511c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344891.1',
  'hypothetical protein',
  1449145,
  1449336,
  -1,
  'Cj1513c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1513c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344892.1',
  'hypothetical protein',
  1449311,
  1450024,
  -1,
  'Cj1514c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1514c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344893.1',
  'carboxynorspermidine/carboxyspermidinedecarboxylase',
  1450328,
  1451476,
  -1,
  'Cj1515c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1515c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344894.1',
  'oxidoreductase',
  1451600,
  1453141,
  1,
  'Cj1516',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1516'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'moaD',
  'molybdopterin converting factor subunit 1',
  1453143,
  1453364,
  1,
  'Cj1517',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1517'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'moaE',
  'molybdopterin converting factor subunit 2',
  1453365,
  1453811,
  1,
  'Cj1518',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1518'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'moeA2',
  'molybdopterin biosynthesis protein',
  1453815,
  1455005,
  1,
  'Cj1519',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1519'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344898.1',
  'CRISPR-associated endoribonuclease Cas2',
  1455569,
  1456000,
  -1,
  'Cj1521c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1521c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344899.1',
  'CRISPR-associated endonuclease Cas1',
  1455993,
  1456883,
  -1,
  'Cj1522c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1522c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344900.1',
  'CRISPR-associated protein',
  1456880,
  1459834,
  -1,
  'Cj1523c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1523c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1460037,
  1461474,
  1,
  'Cj1528',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1528'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'purM',
  'phosphoribosylformylglycinamidine cyclo-ligase',
  1461504,
  1462493,
  -1,
  'Cj1529c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1529c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'coaE',
  'dephospho-CoA kinase',
  1462554,
  1463159,
  1,
  'Cj1530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dapF',
  'diaminopimelate epimerase',
  1463156,
  1463905,
  1,
  'Cj1531',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1531'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344904.1',
  'periplasmic protein',
  1463880,
  1464611,
  1,
  'Cj1532',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1532'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344905.1',
  'hypothetical protein',
  1464608,
  1465645,
  -1,
  'Cj1533c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1533c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344906.1',
  'bacterioferritin',
  1465710,
  1466159,
  -1,
  'Cj1534c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1534c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pgi',
  'glucose-6-phosphate isomerase',
  1466289,
  1467509,
  -1,
  'Cj1535c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1535c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'galU',
  'UTP-glucose-1-phosphate uridylyltransferase',
  1467503,
  1468327,
  -1,
  'Cj1536c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1536c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'acs',
  'acetyl-CoA synthetase',
  1468409,
  1470382,
  -1,
  'Cj1537c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1537c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344910.1',
  'anion uptake ABC transporter ATP-bindingprotein',
  1470520,
  1471515,
  -1,
  'Cj1538c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1538c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344911.1',
  'anion-uptake ABC transporter permease',
  1471517,
  1472236,
  -1,
  'Cj1539c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1539c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344912.1',
  'periplasmic protein',
  1472282,
  1473091,
  1,
  'Cj1540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344913.1',
  'LamB/YcsF family protein',
  1473233,
  1474000,
  1,
  'Cj1541',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1541'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344914.1',
  'allophanate hydrolase subunit 1',
  1474010,
  1474750,
  1,
  'Cj1542',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1542'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344915.1',
  'allophanate hydrolase subunit 2',
  1474731,
  1475696,
  1,
  'Cj1543',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1543'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344916.1',
  'integral membrane protein',
  1475693,
  1476589,
  -1,
  'Cj1544c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1544c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344917.1',
  'MdaB protein',
  1476622,
  1477200,
  -1,
  'Cj1545c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1545c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344918.1',
  'transcriptional regulator',
  1477300,
  1477647,
  1,
  'Cj1546',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1546'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344919.1',
  'lipocalin family protein',
  1477635,
  1478084,
  1,
  'Cj1547',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1547'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344920.1',
  'NADP-dependent alcohol dehydrogenase',
  1478086,
  1479162,
  -1,
  'Cj1548c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1548c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hsdR',
  'type I restriction enzyme R protein',
  1479390,
  1482485,
  -1,
  'Cj1549c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1549c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rloH',
  'ATP/GTP-binding protein',
  1482488,
  1484254,
  -1,
  'Cj1550c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1550c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hsdS',
  'type I restriction enzyme S protein',
  1484265,
  1485407,
  -1,
  'Cj1551c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1551c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mloB',
  'hypothetical protein',
  1485626,
  1487092,
  -1,
  'Cj1552c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1552c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hsdM',
  'type I restriction enzyme M protein',
  1487089,
  1488591,
  -1,
  'Cj1553c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1553c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344926.1',
  'hypothetical protein',
  1488961,
  1489596,
  -1,
  'Cj1555c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1555c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344927.1',
  'transcriptional regulator',
  1489789,
  1490121,
  1,
  'Cj1556',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1556'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1490206,
  1491152,
  1,
  'Cj1560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1491162,
  1491605,
  1,
  'Cj1561',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1561'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344932.1',
  'transcriptional regulator',
  1491492,
  1491923,
  -1,
  'Cj1563c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1563c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344933.1',
  'methyl-accepting chemotaxis signal transductionprotein',
  1492003,
  1493991,
  1,
  'Cj1564',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1564'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pflA',
  'paralysed flagellum protein',
  1494034,
  1496400,
  -1,
  'Cj1565c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1565c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoN',
  'NADH-quinone oxidoreductase I subunit N',
  1496422,
  1497810,
  -1,
  'Cj1566c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1566c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoM',
  'NADH-quinone oxidoreductase I subunit M',
  1497800,
  1499287,
  -1,
  'Cj1567c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1567c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoL',
  'NADH-quinone oxidoreductase subunit L',
  1499289,
  1501079,
  -1,
  'Cj1568c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1568c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoK',
  'NADH-quinone oxidoreductase I subunit K',
  1501081,
  1501377,
  -1,
  'Cj1569c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1569c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoJ',
  'NADH-quinone oxidoreductase subunit J',
  1501374,
  1501892,
  -1,
  'Cj1570c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1570c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoI',
  'NADH-quinone oxidoreductase subunit I',
  1501889,
  1502530,
  -1,
  'Cj1571c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1571c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoH',
  'NADH-quinone oxidoreductase subunit H',
  1502540,
  1503538,
  -1,
  'Cj1572c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1572c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoG',
  'NADH-quinone oxidoreductase subunit G',
  1503531,
  1505993,
  -1,
  'Cj1573c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1573c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344943.1',
  'hypothetical protein',
  1505990,
  1506682,
  -1,
  'Cj1574c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1574c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344944.1',
  'hypothetical protein',
  1506679,
  1506906,
  -1,
  'Cj1575c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1575c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoD',
  'NADH-quinone oxidoreductase subunit D',
  1506903,
  1508129,
  -1,
  'Cj1576c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1576c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoC',
  'NADH-quinone oxidoreductase subunit C',
  1508131,
  1508925,
  -1,
  'Cj1577c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1577c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoB',
  'NADH-quinone oxidoreductase subunit B',
  1508922,
  1509425,
  -1,
  'Cj1578c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1578c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nuoA',
  'NADH-quinone oxidoreductase subunit A',
  1509407,
  1509796,
  -1,
  'Cj1579c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1579c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344949.1',
  'peptide ABC transporter ATP-binding protein',
  1509909,
  1510574,
  -1,
  'Cj1580c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1580c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344950.1',
  'peptide ABC transporter ATP-binding protein',
  1510567,
  1511277,
  -1,
  'Cj1581c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1581c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344951.1',
  'peptide ABC transporter permease',
  1511274,
  1512068,
  -1,
  'Cj1582c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1582c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344952.1',
  'peptide ABC transporter permease',
  1512055,
  1512999,
  -1,
  'Cj1583c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1583c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344953.1',
  'peptide ABC transporter substrate-bindingprotein',
  1512999,
  1514534,
  -1,
  'Cj1584c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1584c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344954.1',
  'oxidoreductase',
  1514644,
  1517415,
  -1,
  'Cj1585c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1585c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cgb',
  'single domain hemoglobin',
  1517567,
  1517989,
  1,
  'Cj1586',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1586'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344956.1',
  'multidrug ABC transporter permease/ATP-bindingprotein',
  1518009,
  1519640,
  -1,
  'Cj1587c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1587c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344957.1',
  'MFS transport protein',
  1519690,
  1520985,
  -1,
  'Cj1588c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1588c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344958.1',
  'hypothetical protein',
  1521072,
  1521869,
  1,
  'Cj1589',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1589'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'infA',
  'translation initiation factor IF-1',
  1521957,
  1522175,
  1,
  'Cj1590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpmJ',
  '50S ribosomal protein L36',
  1522347,
  1522460,
  1,
  'Cj1591',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1591'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsM',
  '30S ribosomal protein S13',
  1522463,
  1522828,
  1,
  'Cj1592',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1592'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsK',
  '30S ribosomal protein S11',
  1522838,
  1523230,
  1,
  'Cj1593',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1593'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsD',
  '30S ribosomal protein S4',
  1523258,
  1523884,
  1,
  'Cj1594',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1594'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpoA',
  'DNA-directed RNA polymerase subunit alpha',
  1523897,
  1524910,
  1,
  'Cj1595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplQ',
  '50S ribosomal protein L17',
  1524914,
  1525267,
  1,
  'Cj1596',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1596'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisG',
  'ATP phosphoribosyltransferase',
  1525440,
  1526339,
  1,
  'Cj1597',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1597'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisD',
  'histidinol dehydrogenase',
  1526347,
  1527633,
  1,
  'Cj1598',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1598'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisB',
  'bifunctional imidazole glycerol-phosphatedehydratase/histidinol phosphatase',
  1527630,
  1528688,
  1,
  'Cj1599',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1599'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisH',
  'imidazole glycerol phosphate synthase subunitHisH',
  1528685,
  1529272,
  1,
  'Cj1600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisA',
  '1-(5-phosphoribosyl)-5-[(5-phosphoribosylamino)methylideneamino]imidazole-4-carboxamide isomerase',
  1529269,
  1530000,
  1,
  'Cj1601',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1601'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344971.1',
  'hypothetical protein',
  1529985,
  1530941,
  1,
  'Cj1602',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1602'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisF',
  'imidazole glycerol phosphate synthase subunitHisF',
  1530942,
  1531709,
  1,
  'Cj1603',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1603'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'hisI',
  'bifunctional phosphoribosyl-AMPcyclohydrolase/phosphoribosyl-ATP pyrophosphatase',
  1531711,
  1532334,
  1,
  'Cj1604',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1604'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dapD',
  '2,3,4,5-tetrahydropyridine-2,6-dicarboxylateN-succinyltransferase',
  1532359,
  1533519,
  -1,
  'Cj1605c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1605c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mrp',
  'ATP/GTP-binding protein',
  1533545,
  1534651,
  -1,
  'Cj1606c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1606c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ispDF',
  'bifunctional 2-C-methyl-D-erythritol 4-phosphatecytidylyltransferase/2-C-methyl-D-erythritol2,4-cyclodiphosphate synthase',
  1534774,
  1535889,
  1,
  'Cj1607',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1607'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344977.1',
  'two-component regulator',
  1535886,
  1536773,
  1,
  'Cj1608',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1608'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344978.1',
  'sulfate adenylyltransferase',
  1536751,
  1537911,
  1,
  'Cj1609',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1609'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'pgpA',
  'phosphatidylglycerophosphatase',
  1537916,
  1538416,
  1,
  'Cj1610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsT',
  '30S ribosomal protein S20',
  1538495,
  1538758,
  1,
  'Cj1611',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1611'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'prfA',
  'peptide chain release factor 1',
  1538777,
  1539844,
  1,
  'Cj1612',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1612'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344982.1',
  'pyridoxamine 5''-phosphate oxidase',
  1539858,
  1540613,
  -1,
  'Cj1613c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1613c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'chuA',
  'hemin uptake system outer membrane receptor',
  1540807,
  1542936,
  1,
  'Cj1614',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1614'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'chuB',
  'hemin uptake ABC transporter permease',
  1542911,
  1543897,
  1,
  'Cj1615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'chuC',
  'hemin uptake ABC transporter ATP-bindingprotein',
  1543897,
  1544673,
  1,
  'Cj1616',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1616'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'chuD',
  'hemin uptake system substrate-binding protein',
  1544670,
  1545476,
  1,
  'Cj1617',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1617'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344987.1',
  'radical SAM domain-containing protein',
  1545473,
  1546390,
  -1,
  'Cj1618c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1618c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'kgtP',
  'alpha-ketoglutarate permease',
  1546496,
  1547755,
  1,
  'Cj1619',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1619'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'mutY',
  'A/G-specific adenine glycosylase',
  1547741,
  1548760,
  -1,
  'Cj1620c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1620c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344990.1',
  'periplasmic protein',
  1548833,
  1549585,
  1,
  'Cj1621',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1621'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAGly',
  '—',
  1549657,
  1549731,
  1,
  'Cjp27',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp27'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNALeu',
  '—',
  1549741,
  1549829,
  1,
  'Cjp28',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp28'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNACys',
  '—',
  1549848,
  1549921,
  1,
  'Cjp29',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp29'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNASer',
  '—',
  1549943,
  1550030,
  1,
  'Cjp30',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp30'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ribD',
  'riboflavin-specific deaminase/reductase',
  1550235,
  1551245,
  1,
  'Cj1622',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1622'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344992.1',
  'membrane protein',
  1551226,
  1551747,
  1,
  'Cj1623',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1623'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'sdaA',
  'L-serine dehydratase',
  1551755,
  1553119,
  -1,
  'Cj1624c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1624c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'sdaC',
  'amino acid transporter',
  1553134,
  1554384,
  -1,
  'Cj1625c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1625c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344995.1',
  'membrane protein',
  1554644,
  1555060,
  -1,
  'Cj1626c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1626c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002344996.1',
  'hypothetical protein',
  1555124,
  1555867,
  -1,
  'Cj1627c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1627c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'exbB2',
  'ExbB/TolQ family transport protein',
  1556025,
  1556450,
  1,
  'Cj1628',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1628'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'exbD2',
  'ExbD/TolR family transport protein',
  1556443,
  1556832,
  1,
  'Cj1629',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1629'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tonB2',
  'TonB transport protein',
  1556829,
  1557512,
  1,
  'Cj1630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345000.1',
  'hypothetical protein',
  1557525,
  1558394,
  -1,
  'Cj1631c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1631c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345001.1',
  'periplasmic protein',
  1558398,
  1558559,
  -1,
  'Cj1632c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1632c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345002.1',
  'ATP-binding protein',
  1558654,
  1559637,
  1,
  'Cj1633',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1633'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'aroC',
  'chorismate synthase',
  1559723,
  1560811,
  -1,
  'Cj1634c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1634c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rnc',
  'ribonuclease III',
  1560811,
  1561485,
  -1,
  'Cj1635c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1635c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rnhA',
  'ribonuclease H',
  1561472,
  1561912,
  -1,
  'Cj1636c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1636c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345006.1',
  'periplasmic protein',
  1561899,
  1562885,
  -1,
  'Cj1637c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1637c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'dnaG',
  'DNA primase',
  1562955,
  1564772,
  1,
  'Cj1638',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1638'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345008.1',
  'NifU protein',
  1564854,
  1565126,
  1,
  'Cj1639',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1639'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345009.1',
  'hypothetical protein',
  1565113,
  1565664,
  1,
  'Cj1640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'murE',
  'UDP-N-acetylmuramoyl-L-alanyl-D-glutamate--2,6-diaminopimelate ligase',
  1565648,
  1566931,
  1,
  'Cj1641',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1641'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345011.1',
  'nucleoid-associated protein',
  1566935,
  1567246,
  1,
  'Cj1642',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1642'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345012.1',
  'periplasmic protein',
  1567243,
  1568337,
  1,
  'Cj1643',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1643'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ispA',
  'geranyltranstransferase',
  1568334,
  1569179,
  1,
  'Cj1644',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1644'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tkt',
  'transketolase',
  1569190,
  1571088,
  1,
  'Cj1645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'iamB',
  'ABC transporter permease',
  1571090,
  1572199,
  1,
  'Cj1646',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1646'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'iamA',
  'ABC transporter ATP-binding protein',
  1572200,
  1572922,
  1,
  'Cj1647',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1647'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345017.1',
  'ABC transporter substrate-binding protein',
  1572925,
  1573815,
  1,
  'Cj1648',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1648'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345018.1',
  'lipoprotein',
  1573815,
  1574414,
  1,
  'Cj1649',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1649'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345019.1',
  'hypothetical protein',
  1574470,
  1574970,
  1,
  'Cj1650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'map',
  'methionine aminopeptidase',
  1575339,
  1576097,
  -1,
  'Cj1651c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1651c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'murI',
  'glutamate racemase',
  1576099,
  1576851,
  -1,
  'Cj1652c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1652c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345022.1',
  'lipoprotein',
  1576853,
  1577311,
  -1,
  'Cj1653c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1653c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nhaA',
  'Na(+)/H(+) antiporter NhaA',
  1577320,
  1578489,
  -1,
  'Cj1654c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1654c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'nhaA1',
  'Na(+)/H(+) antiporter',
  1578486,
  1579634,
  -1,
  'Cj1655c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1655c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345025.1',
  'hypothetical protein',
  1579777,
  1579959,
  -1,
  'Cj1656c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1656c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345026.1',
  'iron permease',
  1580836,
  1582926,
  1,
  'Cj1658',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1658'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'p19',
  'hypothetical protein',
  1582923,
  1583462,
  1,
  'Cj1659',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1659'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345028.1',
  'integral membrane protein',
  1583545,
  1584948,
  1,
  'Cj1660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345029.1',
  'ABC transporter permease',
  1584935,
  1586227,
  1,
  'Cj1661',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1661'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345030.1',
  'integral membrane protein',
  1586217,
  1587335,
  1,
  'Cj1662',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1662'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345031.1',
  'ABC transporter ATP-binding protein',
  1587332,
  1587985,
  1,
  'Cj1663',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1663'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345032.1',
  'thiredoxin',
  1587982,
  1588470,
  1,
  'Cj1664',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1664'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345033.1',
  'lipoprotein thiredoxin',
  1588431,
  1588934,
  1,
  'Cj1665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345034.1',
  'periplasmic protein',
  1588944,
  1589381,
  -1,
  'Cj1666c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1666c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345036.1',
  'periplasmic protein',
  1589680,
  1590096,
  -1,
  'Cj1668c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1668c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNALeu',
  '—',
  1590271,
  1590355,
  -1,
  'Cjt05',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjt05'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAArg',
  '—',
  1590360,
  1590436,
  -1,
  'Cjt3',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjt3'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAArg',
  '—',
  1590451,
  1590527,
  -1,
  'Cjt4',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjt4'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAHis',
  '—',
  1590531,
  1590607,
  -1,
  'Cjp32',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp32'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAPro',
  '—',
  1590632,
  1590709,
  -1,
  'Cjp33',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp33'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345037.1',
  'ATP-dependent DNA ligase',
  1590752,
  1591600,
  -1,
  'Cj1669c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1669c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cgpA',
  'glycoprotein CpgA',
  1591600,
  1592262,
  -1,
  'Cj1670c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1670c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345039.1',
  'hypothetical protein',
  1592252,
  1592455,
  -1,
  'Cj1671c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1671c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'eno',
  'enolase',
  1592521,
  1593765,
  -1,
  'Cj1672c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1672c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'recA',
  'recombinase A',
  1593765,
  1594796,
  -1,
  'Cj1673c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1673c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345042.1',
  'hypothetical protein',
  1594902,
  1595762,
  1,
  'Cj1674',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1674'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'fliQ',
  'flagellar biosynthesis protein FliQ',
  1595774,
  1596043,
  1,
  'Cj1675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'murB',
  'UDP-N-acetylenolpyruvoylglucosamine reductase',
  1596040,
  1596816,
  1,
  'Cj1676',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1676'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345045.1',
  'lipoprotein',
  1597008,
  1600372,
  1,
  'Cj1677',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1677'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345046.1',
  'hypothetical protein',
  1600574,
  1602328,
  1,
  'Cj1679',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1679'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345047.1',
  'periplasmic protein',
  1602332,
  1603099,
  -1,
  'Cj1680c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1680c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'cysQ',
  '3''(2''),5''-bisphosphate nucleotidase CysQ',
  1603139,
  1603903,
  -1,
  'Cj1681c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1681c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'gltA',
  'citrate synthase',
  1603983,
  1605251,
  -1,
  'Cj1682c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1682c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345050.1',
  'transmembrane transport protein',
  1605366,
  1606541,
  -1,
  'Cj1684c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1684c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'bioB',
  'biotin synthase',
  1606522,
  1607358,
  -1,
  'Cj1685c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1685c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'topA',
  'DNA topoisomerase I',
  1607360,
  1609462,
  -1,
  'Cj1686c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1686c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345053.1',
  'efflux protein',
  1609657,
  1610928,
  1,
  'Cj1687',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1687'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'secY',
  'protein translocase subunit SecY',
  1610956,
  1612221,
  -1,
  'Cj1688c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1688c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplO',
  '50S ribosomal protein L15',
  1612221,
  1612613,
  -1,
  'Cj1689c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1689c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsE',
  '30S ribosomal protein S5',
  1612618,
  1613061,
  -1,
  'Cj1690c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1690c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplR',
  '50S ribosomal protein L18',
  1613073,
  1613429,
  -1,
  'Cj1691c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1691c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplF',
  '50S ribosomal protein L6',
  1613439,
  1613975,
  -1,
  'Cj1692c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1692c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsH',
  '30S ribosomal protein S8',
  1614054,
  1614449,
  -1,
  'Cj1693c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1693c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsN',
  '30S ribosomal protein S14',
  1614459,
  1614644,
  -1,
  'Cj1694c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1694c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplE',
  '50S ribosomal protein L5',
  1614646,
  1615191,
  -1,
  'Cj1695c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1695c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplX',
  '50S ribosomal protein L24',
  1615195,
  1615428,
  -1,
  'Cj1696c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1696c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplN',
  '50S ribosomal protein L14',
  1615428,
  1615796,
  -1,
  'Cj1697c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1697c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsQ',
  '30S ribosomal protein S17',
  1615796,
  1616047,
  -1,
  'Cj1698c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1698c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpmC',
  '50S ribosomal protein L29',
  1616057,
  1616242,
  -1,
  'Cj1699c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1699c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplP',
  '50S ribosomal protein L16',
  1616229,
  1616654,
  -1,
  'Cj1700c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1700c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsC',
  '30S ribosomal protein S3',
  1616657,
  1617358,
  -1,
  'Cj1701c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1701c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplV',
  '50S ribosomal protein L22',
  1617358,
  1617783,
  -1,
  'Cj1702c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1702c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsS',
  '30S ribosomal protein S19',
  1617794,
  1618075,
  -1,
  'Cj1703c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1703c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplB',
  '50S ribosomal protein L2',
  1618077,
  1618907,
  -1,
  'Cj1704c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1704c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplW',
  '50S ribosomal protein L23',
  1618909,
  1619190,
  -1,
  'Cj1705c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1705c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplD',
  '50S ribosomal protein L4',
  1619193,
  1619807,
  -1,
  'Cj1706c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1706c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rplC',
  '50S ribosomal protein L3',
  1619804,
  1620379,
  -1,
  'Cj1707c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1707c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'rpsJ',
  '30S ribosomal protein S10',
  1620389,
  1620700,
  -1,
  'Cj1708c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1708c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345075.1',
  'pseudouridine synthase',
  1620899,
  1621660,
  -1,
  'Cj1709c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1709c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345076.1',
  'metallo-beta-lactamase family protein',
  1621696,
  1623690,
  -1,
  'Cj1710c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1710c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ksgA',
  'rRNA small subunit methyltransferase A',
  1623659,
  1624459,
  -1,
  'Cj1711c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1711c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345078.1',
  'hypothetical protein',
  1624541,
  1625077,
  1,
  'Cj1712',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1712'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345079.1',
  '23S rRNA (adenine(2503)-C(2))-methyltransferaseRlmN',
  1625100,
  1626170,
  1,
  'Cj1713',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1713'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345080.1',
  'hypothetical protein',
  1626167,
  1626265,
  1,
  'Cj1714',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1714'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAMet',
  '—',
  1626279,
  1626355,
  -1,
  'Cjp34',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp34'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNASer',
  '—',
  1626491,
  1626578,
  1,
  'Cjt06',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjt06'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAAla',
  '—',
  1626625,
  1626700,
  1,
  'Cjp35',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp35'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'tRNAVal',
  '—',
  1626704,
  1626779,
  1,
  'Cjp36',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cjp36'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345081.1',
  'acetyltransferase',
  1626807,
  1627337,
  1,
  'Cj1715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'leuD',
  '3-isopropylmalate dehydratase small subunit',
  1627317,
  1627919,
  -1,
  'Cj1716c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1716c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'leuC',
  '3-isopropylmalate dehydratase large subunit',
  1627921,
  1629333,
  -1,
  'Cj1717c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1717c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'leuB',
  '3-isopropylmalate dehydrogenase',
  1629320,
  1630396,
  -1,
  'Cj1718c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1718c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'leuA',
  '2-isopropylmalate synthase',
  1630393,
  1631928,
  -1,
  'Cj1719c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1719c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345086.1',
  'hypothetical protein',
  1632248,
  1632877,
  1,
  'Cj1720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345087.1',
  'outer membrane protein',
  1632901,
  1633545,
  -1,
  'Cj1721c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1721c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  '—',
  '—',
  1633791,
  1634119,
  -1,
  'Cj1723c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1723c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345090.1',
  '7-cyano-7-deazaguanine reductase',
  1634296,
  1634679,
  -1,
  'Cj1724c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1724c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'YP_002345091.1',
  'periplasmic protein',
  1634839,
  1635438,
  1,
  'Cj1725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'metA',
  'homoserine O-succinyltransferase',
  1635443,
  1636324,
  -1,
  'Cj1726c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1726c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'metB',
  'O-acetylhomoserine (thiol)-lyase',
  1636407,
  1637678,
  -1,
  'Cj1727c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1727c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'flgE',
  'flagellar hook protein FlgE',
  1638104,
  1640701,
  -1,
  'Cj1729c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1729c'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  'ruvC',
  'Holliday junction resolvase',
  1640904,
  1641386,
  -1,
  'Cj1731c',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1) AND locus_tag='Cj1731c'
);

INSERT INTO core_taxonomy (taxonomy_id, rank, name, parent_id)
SELECT
  '192222',
  'strain',
  'Campylobacter jejuni subsp. jejuni NCTC 11168 = ATCC 700819',
  NULL
WHERE NOT EXISTS (
  SELECT 1 FROM core_taxonomy WHERE taxonomy_id='192222'
);

UPDATE core_taxonomy
SET
  rank = COALESCE(NULLIF(rank,''), 'strain'),
  name = COALESCE(NULLIF(name,''), 'Campylobacter jejuni subsp. jejuni NCTC 11168 = ATCC 700819'),
  parent_id = COALESCE(parent_id, NULL)
WHERE taxonomy_id='192222';

UPDATE core_genome
SET taxonomy_id = (
  SELECT id FROM core_taxonomy WHERE taxonomy_id='192222' LIMIT 1
)
WHERE genome_accession='NC_002163.1';

INSERT INTO core_experimentaltechnique (name, description, preset_function, EO_term)
SELECT 'ChIP-chip', 'ChIP-chip', NULL, 'ECO:0006007'
WHERE NOT EXISTS (
  SELECT 1 FROM core_experimentaltechnique WHERE EO_term='ECO:0006007'
);

INSERT INTO core_siteinstance (_seq, genome_id, start, end, strand)
SELECT
  'GATAGATA',
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  13027,
  13034,
  1
WHERE NOT EXISTS (
  SELECT 1 FROM core_siteinstance
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
    AND start=13027 AND end=13034 AND strand=1
    AND _seq='GATAGATA'
);

INSERT INTO core_curation_siteinstance
  (curation_id, site_instance_id, annotated_seq, quantitative_value, site_type, TF_function, TF_type)
VALUES
  ((SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42148648' LIMIT 1) ORDER BY curation_id DESC LIMIT 1),
   (SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
          AND start=13027 AND end=13034 AND strand=1
          AND _seq='GATAGATA'
        ORDER BY site_id DESC LIMIT 1),
   'GATAGATA',
   0,
   'variable',
   'activator',
   'monomer');

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42148648' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
          AND start=13027 AND end=13034 AND strand=1
          AND _seq='GATAGATA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='Cj0009' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='Cj0009' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_siteinstance (_seq, genome_id, start, end, strand)
SELECT
  'TAGTAGTA',
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1),
  124185,
  124192,
  1
WHERE NOT EXISTS (
  SELECT 1 FROM core_siteinstance
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
    AND start=124185 AND end=124192 AND strand=1
    AND _seq='TAGTAGTA'
);

INSERT INTO core_curation_siteinstance
  (curation_id, site_instance_id, annotated_seq, quantitative_value, site_type, TF_function, TF_type)
VALUES
  ((SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42148648' LIMIT 1) ORDER BY curation_id DESC LIMIT 1),
   (SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
          AND start=124185 AND end=124192 AND strand=1
          AND _seq='TAGTAGTA'
        ORDER BY site_id DESC LIMIT 1),
   'TAGTAGTA',
   0,
   'variable',
   'activator',
   'monomer');

INSERT INTO core_curation_siteinstance_experimental_techniques
  (curation_siteinstance_id, experimentaltechnique_id)
SELECT (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42148648' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
          AND start=124185 AND end=124192 AND strand=1
          AND _seq='TAGTAGTA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1), (SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0006007'
          LIMIT 1)
WHERE (SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0006007'
          LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM core_curation_siteinstance_experimental_techniques
    WHERE curation_siteinstance_id=(SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42148648' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
          AND start=124185 AND end=124192 AND strand=1
          AND _seq='TAGTAGTA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1)
      AND experimentaltechnique_id=(SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0006007'
          LIMIT 1)
  );

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42148648' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
          AND start=124185 AND end=124192 AND strand=1
          AND _seq='TAGTAGTA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='Cj0121' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='Cj0121' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_002163.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

COMMIT;