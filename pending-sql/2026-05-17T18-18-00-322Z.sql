PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

INSERT INTO core_publication
  (publication_type, pmid, authors, title, journal, publication_date, url,
   contains_promoter_data, contains_expression_data, submission_notes, curation_complete,
   reported_TF, reported_species)
SELECT
  'ARTICLE',
  '42141772',
  'Kumar A, Kundu M, Krishnan P, Vashisth A',
  'Graphite-Based Electrochemical Degradation of Congo Red in Aqueous Media: An Eco-Sustainable Approach for Treatment of Residual Dye in Wastewater.',
  'Water environment research : a research publication of the Water Environment Federation',
  '2026 May',
  'https://doi.org/10.1002/wer.70409',
  0,
  1,
  'Revision reason: No comparable genome in NCBI
PROVA',
  1,
  'UmuDAb',
  'Haemophilus influenzae Rd KW20'
WHERE NOT EXISTS (
  SELECT 1 FROM core_publication WHERE pmid='42141772'
);

UPDATE core_publication
SET
  authors = CASE WHEN authors IS NULL OR authors='' THEN 'Kumar A, Kundu M, Krishnan P, Vashisth A' ELSE authors END,
  title = CASE WHEN title IS NULL OR title='' THEN 'Graphite-Based Electrochemical Degradation of Congo Red in Aqueous Media: An Eco-Sustainable Approach for Treatment of Residual Dye in Wastewater.' ELSE title END,
  journal = CASE WHEN journal IS NULL OR journal='' THEN 'Water environment research : a research publication of the Water Environment Federation' ELSE journal END,
  publication_date = CASE WHEN publication_date IS NULL OR publication_date='' THEN '2026 May' ELSE publication_date END,
  url = CASE WHEN url IS NULL OR url='' THEN 'https://doi.org/10.1002/wer.70409' ELSE url END,
  reported_TF = CASE WHEN reported_TF IS NULL OR reported_TF='' THEN 'UmuDAb' ELSE reported_TF END,
  reported_species = CASE WHEN reported_species IS NULL OR reported_species='' THEN 'Haemophilus influenzae Rd KW20' ELSE reported_species END,
  contains_promoter_data = 0,
  contains_expression_data = 1,
  curation_complete = 1,
  submission_notes = CASE
    WHEN submission_notes IS NULL OR submission_notes='' THEN 'Revision reason: No comparable genome in NCBI
PROVA'
    ELSE submission_notes
  END
WHERE pmid='42141772';

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
  'WP_003250679',
  'P0A126',
  'integration host factor subunit alpha [Pseudomonas putida KT2440].',
  (SELECT TF_id FROM core_tf WHERE lower(name)=lower('UmuDAb') LIMIT 1),
  ''
WHERE NOT EXISTS (
  SELECT 1 FROM core_tfinstance WHERE uniprot_accession='P0A126'
);

UPDATE core_tfinstance
SET
  TF_id = COALESCE(TF_id, (SELECT TF_id FROM core_tf WHERE lower(name)=lower('UmuDAb') LIMIT 1)),
  refseq_accession = COALESCE(NULLIF(refseq_accession,''), 'WP_003250679'),
  description = COALESCE(NULLIF(description,''), 'integration host factor subunit alpha [Pseudomonas putida KT2440].'),
  notes = COALESCE(notes, '')
WHERE uniprot_accession='P0A126';

INSERT INTO core_curation
  (TF_species, site_species, experimental_process, forms_complex,
   complex_notes, notes, last_modified, curator_id, publication_id, created, validated_by_id)
VALUES
  ('Haemophilus influenzae Rd KW20', 'Haemophilus influenzae Rd KW20', NULL,
   0, NULL, 'Revision reason: No comparable genome in NCBI
PROVA',
   datetime('now'), (SELECT curator_id FROM core_curator ORDER BY curator_id LIMIT 1), (SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1), datetime('now'), NULL);

INSERT INTO core_curation_TF_instances (curation_id, tfinstance_id)
SELECT (SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1), (SELECT TF_instance_id FROM core_tfinstance WHERE uniprot_accession='P0A126' LIMIT 1)
WHERE NOT EXISTS (
  SELECT 1 FROM core_curation_TF_instances
  WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1) AND tfinstance_id=(SELECT TF_instance_id FROM core_tfinstance WHERE uniprot_accession='P0A126' LIMIT 1)
);

INSERT INTO core_genome (genome_accession, organism)
SELECT 'NC_000907.1', 'Haemophilus influenzae Rd KW20'
WHERE NOT EXISTS (
  SELECT 1 FROM core_genome WHERE genome_accession='NC_000907.1'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gap',
  'type I glyceraldehyde-3-phosphate dehydrogenase',
  2,
  1021,
  1,
  'HI_RS00005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828405.1',
  'AMP-dependent synthetase/ligase',
  1214,
  3013,
  1,
  'HI_RS00010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927873.1',
  'Cof-type HAD-IIB family hydrolase',
  3050,
  3835,
  -1,
  'HI_RS00015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ybeY',
  'rRNA maturation RNase YbeY',
  3854,
  4318,
  -1,
  'HI_RS00020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fdhD',
  'formate dehydrogenase accessorysulfurtransferase FdhD',
  4579,
  5391,
  -1,
  'HI_RS00025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fdnG',
  'formate dehydrogenase-N subunit alpha',
  5662,
  8748,
  1,
  'HI_RS00030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fdxH',
  'formate dehydrogenase subunit beta',
  8750,
  9688,
  1,
  'HI_RS00035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005663315.1',
  'formate dehydrogenase subunit gamma',
  9681,
  10397,
  1,
  'HI_RS00040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fdhE',
  'formate dehydrogenase accessory protein FdhE',
  10467,
  11375,
  1,
  'HI_RS00045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rimI',
  'ribosomal protein S18-alanineN-acetyltransferase',
  11414,
  11854,
  -1,
  'HI_RS00050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'holD',
  'DNA polymerase III subunit psi',
  11857,
  12261,
  -1,
  'HI_RS00055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsmC',
  '16S rRNA (guanine(1207)-N(2))-methyltransferaseRsmC',
  12367,
  13359,
  1,
  'HI_RS00060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'era',
  'GTPase Era',
  13423,
  14331,
  -1,
  'HI_RS00065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rnc',
  'ribonuclease III',
  14328,
  15011,
  -1,
  'HI_RS00070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lepB',
  'signal peptidase I',
  15013,
  16062,
  -1,
  'HI_RS00075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lepA',
  'translation elongation factor 4',
  16071,
  17867,
  -1,
  'HI_RS00080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'grcA',
  'autonomous glycyl radical cofactor GrcA',
  18035,
  18418,
  -1,
  'HI_RS00085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ung',
  'uracil-DNA glycosylase',
  18676,
  19335,
  1,
  'HI_RS00090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'miaB',
  'tRNA (N6-isopentenyladenosine(37)-C2)-methylthiotransferase MiaB',
  19405,
  20829,
  -1,
  'HI_RS00095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005652640.1',
  'anion permease',
  21248,
  22687,
  -1,
  'HI_RS00100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'citG',
  'triphosphoribosyl-dephospho-CoA synthase CitG',
  22689,
  24086,
  -1,
  'HI_RS00105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'citF',
  'citrate lyase subunit alpha',
  24267,
  25769,
  -1,
  'HI_RS00110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'citE',
  'citrate (pro-3S)-lyase subunit beta',
  25784,
  26659,
  -1,
  'HI_RS00115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'citD',
  'citrate lyase acyl carrier protein',
  26656,
  26943,
  -1,
  'HI_RS00120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'citC',
  '[citrate (pro-3S)-lyase] ligase',
  26981,
  27988,
  -1,
  'HI_RS00125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lipA',
  'lipoyl synthase',
  28239,
  29201,
  -1,
  'HI_RS00130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lipB',
  'lipoyl(octanoyl) transferase LipB',
  29255,
  29893,
  -1,
  'HI_RS00135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649857.1',
  'DUF493 family protein YbeD',
  29895,
  30173,
  -1,
  'HI_RS00140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693881.1',
  'D-alanyl-D-alanine carboxypeptidase familyprotein',
  30229,
  31410,
  -1,
  'HI_RS00145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005668014.1',
  'septal ring lytic transglycosylase RlpA familyprotein',
  31426,
  32289,
  -1,
  'HI_RS00150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rodA',
  'rod shape-determining protein RodA',
  32341,
  33456,
  -1,
  'HI_RS00155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mrdA',
  'penicillin-binding protein 2',
  33446,
  35401,
  -1,
  'HI_RS00160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rlmH',
  '23S rRNA(pseudouridine(1915)-N(3))-methyltransferase RlmH',
  35422,
  35889,
  -1,
  'HI_RS00165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsfS',
  'ribosome silencing factor',
  35943,
  36251,
  -1,
  'HI_RS00170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693880.1',
  'putative transporter',
  36376,
  38031,
  -1,
  'HI_RS00175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005668011.1',
  'ABC transporter ATP-binding protein/permease',
  38237,
  40015,
  1,
  'HI_RS00180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005657804.1',
  'rod shape-determining protein',
  40145,
  41200,
  1,
  'HI_RS00185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mreC',
  'rod shape-determining protein MreC',
  41280,
  42335,
  1,
  'HI_RS00190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mreD',
  'rod shape-determining protein MreD',
  42335,
  42823,
  1,
  'HI_RS00195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005657798.1',
  'TIGR01619 family protein',
  42874,
  43650,
  -1,
  'HI_RS00200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'xthA',
  'exodeoxyribonuclease III',
  43660,
  44463,
  -1,
  'HI_RS00205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693879.1',
  'TIGR01621 family pseudouridine synthase',
  44511,
  45185,
  -1,
  'HI_RS00210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868921.1',
  'YcjF family protein',
  45185,
  46249,
  -1,
  'HI_RS00215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649826.1',
  'Bax inhibitor-1/YccA family membrane protein',
  46309,
  46971,
  -1,
  'HI_RS00220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  47152,
  47241,
  1,
  'HI_RS00225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868922.1',
  'YtfJ family protein',
  47298,
  47852,
  -1,
  'HI_RS00230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868923.1',
  'zinc ribbon domain-containing protein YjdM',
  47955,
  48281,
  1,
  'HI_RS00235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693874.1',
  'bifunctional 4-hydroxy-2-oxoglutaratealdolase/2-dehydro-3-deoxy-phosphogluconate aldolase',
  48334,
  48972,
  -1,
  'HI_RS00240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828401.1',
  'SDR family oxidoreductase',
  48991,
  49836,
  -1,
  'HI_RS00245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693872.1',
  'sugar kinase',
  49848,
  50792,
  -1,
  'HI_RS00250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868924.1',
  'TRAP transporter large permease',
  50812,
  52068,
  -1,
  'HI_RS00255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_165442159.1',
  'TRAP transporter small permease',
  52092,
  52562,
  -1,
  'HI_RS00260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693870.1',
  'DctP family TRAP transporter solute-bindingsubunit',
  52628,
  53614,
  -1,
  'HI_RS00265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868926.1',
  'zinc-binding alcohol dehydrogenase familyprotein',
  53641,
  54669,
  -1,
  'HI_RS00270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005687499.1',
  'GntR family transcriptional regulator',
  54830,
  55579,
  1,
  'HI_RS00275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'uxuA',
  'mannonate dehydratase',
  55607,
  56791,
  1,
  'HI_RS00280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693866.1',
  'TerC family protein',
  56844,
  57557,
  -1,
  'HI_RS00285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'uvrC',
  'excinuclease ABC subunit UvrC',
  57655,
  59484,
  -1,
  'HI_RS00290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'kdsB',
  '3-deoxy-manno-octulosonate cytidylyltransferase',
  59486,
  60250,
  -1,
  'HI_RS00295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lpxK',
  'tetraacyldisaccharide 4''-kinase',
  60321,
  61319,
  -1,
  'HI_RS00300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'msbA',
  'lipid A ABC transporter ATP-bindingprotein/permease MsbA',
  61392,
  63155,
  -1,
  'HI_RS00305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693861.1',
  'DNA internalization-related competence proteinComEC/Rec2',
  63196,
  65562,
  -1,
  'HI_RS00310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dksA',
  'RNA polymerase-binding protein DksA',
  65821,
  66258,
  1,
  'HI_RS00315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pcnB',
  'polynucleotide adenylyltransferase PcnB',
  66506,
  67864,
  1,
  'HI_RS00320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'folK',
  '2-amino-4-hydroxy-6-hydroxymethyldihydropteridine diphosphokinase',
  67873,
  68355,
  1,
  'HI_RS00325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tsaE',
  'tRNA(adenosine(37)-N6)-threonylcarbamoyltransferase complexATPase subunit type 1 TsaE',
  68431,
  68907,
  1,
  'HI_RS00330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693856.1',
  'LysM peptidoglycan-binding domain-containingprotein',
  68915,
  70213,
  1,
  'HI_RS00335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mutL',
  'DNA mismatch repair endonuclease MutL',
  70214,
  72103,
  1,
  'HI_RS00340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'miaA',
  'tRNA (adenosine(37)-N6)-dimethylallyltransferaseMiaA',
  72111,
  73046,
  1,
  'HI_RS00345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glnE',
  'bifunctional [glutamate--ammonialigase]-adenylyl-L-tyrosinephosphorylase/[glutamate--ammonia-ligase]adenylyltransferase',
  73052,
  75997,
  1,
  'HI_RS00350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recN',
  'DNA repair protein RecN',
  76082,
  77758,
  -1,
  'HI_RS00355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'NAD(+) kinase',
  77870,
  78759,
  -1,
  'HI_RS00360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'grpE',
  'nucleotide exchange factor GrpE',
  78859,
  79455,
  1,
  'HI_RS00365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693849.1',
  'nucleotidyltransferase family protein',
  79468,
  79812,
  -1,
  'HI_RS00370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693848.1',
  'nucleotidyltransferase substrate bindingprotein',
  79805,
  80245,
  -1,
  'HI_RS00375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nrdD',
  'anaerobic ribonucleoside-triphosphate reductase',
  80526,
  82649,
  1,
  'HI_RS00380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tesB',
  'acyl-CoA thioesterase II',
  82767,
  83627,
  1,
  'HI_RS00385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693845.1',
  'ferritin-like domain-containing protein',
  83638,
  84504,
  1,
  'HI_RS00390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cysS',
  'cysteine--tRNA ligase',
  84580,
  85959,
  -1,
  'HI_RS00395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693842.1',
  'peptidylprolyl isomerase',
  86062,
  86571,
  1,
  'HI_RS00400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693840.1',
  'type II toxin-antitoxin system PemK/MazF familytoxin',
  86575,
  87006,
  1,
  'HI_RS00405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693839.1',
  'TatD family hydrolase',
  87148,
  87936,
  1,
  'HI_RS00410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'acyl-CoA/acyl-ACP dehydrogenase',
  88047,
  88411,
  1,
  'HI_RS00415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'hypothetical protein',
  88435,
  88742,
  1,
  'HI_RS00420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trxA',
  'thioredoxin',
  88739,
  89062,
  -1,
  'HI_RS00425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693834.1',
  '2-hydroxyacid dehydrogenase',
  89182,
  90177,
  -1,
  'HI_RS00430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005661154.1',
  'methionine biosynthesis PLP-dependent protein',
  90190,
  91299,
  -1,
  'HI_RS00435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  91546,
  91621,
  1,
  'HI_RS00440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  91628,
  91701,
  1,
  'HI_RS00445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  91729,
  91815,
  1,
  'HI_RS00450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  91866,
  91941,
  1,
  'HI_RS00455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'thrC',
  'threonine synthase',
  92148,
  93425,
  -1,
  'HI_RS00460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'thrB',
  'homoserine kinase',
  93468,
  94412,
  -1,
  'HI_RS00465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'thrA',
  'bifunctional aspartate kinase/homoserinedehydrogenase I',
  94425,
  96872,
  -1,
  'HI_RS00470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693829.1',
  'YggS family pyridoxal phosphate-dependentenzyme',
  97196,
  97909,
  1,
  'HI_RS00475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649699.1',
  'glycerate kinase',
  97949,
  99085,
  -1,
  'HI_RS00480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693828.1',
  'GntP family permease',
  99094,
  100353,
  -1,
  'HI_RS00485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693827.1',
  'PucR family transcriptional regulator',
  100475,
  101581,
  -1,
  'HI_RS00490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693826.1',
  'GntT/GntP/DsdX family permease',
  101783,
  102103,
  -1,
  'HI_RS00495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693825.1',
  'class I SAM-dependent methyltransferase',
  102453,
  103208,
  -1,
  'HI_RS00500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693822.1',
  'hypothetical protein',
  103542,
  104117,
  1,
  'HI_RS00505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'iron ABC transporter substrate-binding protein',
  104277,
  105274,
  1,
  'HI_RS00510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927854.1',
  'ABC transporter permease',
  105392,
  106912,
  1,
  'HI_RS00515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693820.1',
  'heme ABC transporter ATP-binding protein FbpC',
  106899,
  107969,
  1,
  'HI_RS00520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'D-alanyl-D-alanine carboxypeptidase familyprotein',
  108004,
  108683,
  -1,
  'HI_RS00525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dapE',
  'succinyl-diaminopimelate desuccinylase',
  108685,
  109818,
  -1,
  'HI_RS00530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693817.1',
  'ArsC family reductase',
  109846,
  110190,
  -1,
  'HI_RS00535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'htpG',
  'molecular chaperone HtpG',
  110269,
  112149,
  -1,
  'HI_RS00540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649665.1',
  'Nif3-like dinuclear metal center hexamericprotein',
  112465,
  113220,
  1,
  'HI_RS00545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ffh',
  'signal recognition particle protein',
  113277,
  114665,
  -1,
  'HI_RS00550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828395.1',
  'HlyC/CorC family transporter',
  114946,
  116208,
  1,
  'HI_RS00555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693811.1',
  'threonine/serine exporter family protein',
  116337,
  117230,
  1,
  'HI_RS00560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693810.1',
  'LPS O-antigen chain length determinant proteinWzzB',
  117319,
  117660,
  -1,
  'HI_RS00565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'serS',
  'serine--tRNA ligase',
  117827,
  119116,
  1,
  'HI_RS00570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693808.1',
  'glutathione S-transferase family protein',
  119451,
  120080,
  1,
  'HI_RS00575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'transposase',
  120072,
  120331,
  -1,
  'HI_RS00580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868937.1',
  'TonB-dependenthemoglobin/transferrin/lactoferrin family receptor',
  120441,
  122675,
  1,
  'HI_RS00585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rrf',
  '—',
  123438,
  123553,
  -1,
  'HI_RS00590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  123786,
  126705,
  -1,
  'HI_RS00595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  126969,
  127044,
  -1,
  'HI_RS00600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  127172,
  128717,
  -1,
  'HI_RS00605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  128892,
  128968,
  -1,
  'HI_RS00610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  128990,
  129065,
  -1,
  'HI_RS00615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  129092,
  129168,
  -1,
  'HI_RS00620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rlmKL',
  'bifunctional 23S rRNA(guanine(2069)-N(7))-methyltransferase RlmK/23S rRNA(guanine(2445)-N(2))-methyltransferase RlmL',
  129317,
  131453,
  -1,
  'HI_RS00625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  131584,
  131660,
  -1,
  'HI_RS00630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mltA',
  'murein transglycosylase A',
  131848,
  132959,
  1,
  'HI_RS00635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tcdA',
  'tRNA cyclic N6-threonylcarbamoyladenosine(37)synthase TcdA',
  132959,
  133729,
  1,
  'HI_RS00640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'znuA',
  'zinc ABC transporter substrate-binding proteinZnuA',
  133907,
  134920,
  1,
  'HI_RS00645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005653606.1',
  'DUF2301 domain-containing membrane protein',
  134970,
  135476,
  -1,
  'HI_RS00650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mpl',
  'UDP-N-acetylmuramate:L-alanyl-gamma-D-glutamyl-meso-diaminopimelate ligase',
  135589,
  136950,
  -1,
  'HI_RS00655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'metC',
  'cystathionine beta-lyase',
  137335,
  138525,
  -1,
  'HI_RS00660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pgsA',
  'CDP-diacylglycerol--glycerol-3-phosphate3-phosphatidyltransferase',
  138800,
  139357,
  1,
  'HI_RS00665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  139513,
  139588,
  1,
  'HI_RS00670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  139593,
  139679,
  1,
  'HI_RS00675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  139730,
  139805,
  1,
  'HI_RS00680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005630160.1',
  'inorganic diphosphatase',
  139924,
  140454,
  -1,
  'HI_RS00685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694416.1',
  'NCS2 family permease',
  140689,
  142005,
  1,
  'HI_RS00690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fbpC',
  'ferric ABC transporter ATP-binding protein',
  142163,
  143149,
  -1,
  'HI_RS00695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868940.1',
  'ABC transporter permease',
  143193,
  145091,
  -1,
  'HI_RS00700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694419.1',
  'ABC transporter substrate-binding protein',
  145395,
  146435,
  -1,
  'HI_RS00705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'udk',
  'uridine kinase',
  146601,
  147242,
  1,
  'HI_RS00710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dcd',
  'dCTP deaminase',
  147251,
  147838,
  1,
  'HI_RS00715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694421.1',
  'AsmA family protein',
  147842,
  149017,
  1,
  'HI_RS00720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694422.1',
  'sugar transporter',
  149017,
  150207,
  1,
  'HI_RS00725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'der',
  'ribosome biogenesis GTPase Der',
  150287,
  151801,
  -1,
  'HI_RS00730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  152228,
  152304,
  -1,
  'HI_RS00735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  152328,
  152404,
  -1,
  'HI_RS00740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dnaQ',
  'DNA polymerase III subunit epsilon',
  152492,
  153262,
  -1,
  'HI_RS00745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rnhA',
  'ribonuclease HI',
  153323,
  153787,
  1,
  'HI_RS00750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694426.1',
  'porin',
  154039,
  155118,
  1,
  'HI_RS00755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nagA',
  'N-acetylglucosamine-6-phosphate deacetylase',
  155307,
  156452,
  -1,
  'HI_RS00760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'glucosamine-6-phosphate deaminase',
  156589,
  156675,
  -1,
  'HI_RS00765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005668148.1',
  'glucosamine-6-phosphate deaminase',
  156725,
  157537,
  -1,
  'HI_RS00770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nanA',
  'N-acetylneuraminate lyase',
  157823,
  158704,
  -1,
  'HI_RS00775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868944.1',
  'MurR/RpiR family transcriptional regulator',
  158715,
  159581,
  -1,
  'HI_RS00780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648623.1',
  'N-acetylmannosamine kinase',
  159574,
  160476,
  -1,
  'HI_RS00785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868945.1',
  'putative N-acetylmannosamine-6-phosphate2-epimerase',
  160522,
  161208,
  -1,
  'HI_RS00790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_012054840.1',
  'sialic acid TRAP transporter substrate-bindingprotein SiaP',
  161561,
  162547,
  1,
  'HI_RS00795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694432.1',
  'sialic acid TRAP transporter substrate-bindingprotein SiaT',
  162609,
  164459,
  1,
  'HI_RS00800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828455.1',
  'N-acetylneuraminate epimerase',
  164635,
  165762,
  1,
  'HI_RS00805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'isoprenylcysteine carboxylmethyltransferasefamily protein',
  165924,
  166357,
  1,
  'HI_RS00810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hflC',
  'protease modulator HflC',
  166400,
  167287,
  -1,
  'HI_RS00815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hflK',
  'FtsH protease activity modulator HflK',
  167287,
  168507,
  -1,
  'HI_RS00820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694435.1',
  '4''-phosphopantetheinyl transferase familyprotein',
  168629,
  169336,
  -1,
  'HI_RS00825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'anaerobic C4-dicarboxylate transporter',
  169396,
  170726,
  -1,
  'HI_RS00830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'acpP',
  'acyl carrier protein',
  170930,
  171160,
  -1,
  'HI_RS00835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fabG',
  '3-oxoacyl-ACP reductase FabG',
  171416,
  172144,
  -1,
  'HI_RS00840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fabD',
  'ACP S-malonyltransferase',
  172161,
  173099,
  -1,
  'HI_RS00845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005691510.1',
  'beta-ketoacyl-ACP synthase III',
  173727,
  174677,
  -1,
  'HI_RS00850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpmF',
  '50S ribosomal protein L32',
  174863,
  175033,
  -1,
  'HI_RS00855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yceD',
  '23S rRNA accumulation protein YceD',
  175056,
  175580,
  -1,
  'HI_RS00860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'psd',
  'archaetidylserine decarboxylase',
  175740,
  176609,
  1,
  'HI_RS00865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gorA',
  'glutathione-disulfide reductase',
  176718,
  178088,
  -1,
  'HI_RS00870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694116.1',
  'YajG family lipoprotein',
  178304,
  178903,
  -1,
  'HI_RS00875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005668108.1',
  'BolA family protein',
  178997,
  179308,
  1,
  'HI_RS00880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694115.1',
  'Na(+)-translocating NADH-quinone reductasesubunit A',
  179599,
  180942,
  1,
  'HI_RS00885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005653793.1',
  'NADH:ubiquinone reductase (Na(+)-transporting)subunit B',
  180945,
  182180,
  1,
  'HI_RS00890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005653794.1',
  'Na(+)-translocating NADH-quinone reductasesubunit C',
  182173,
  182907,
  1,
  'HI_RS00895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nqrD',
  'NADH:ubiquinone reductase (Na(+)-transporting)subunit D',
  182907,
  183533,
  1,
  'HI_RS00900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nqrE',
  'NADH:ubiquinone reductase (Na(+)-transporting)subunit E',
  183537,
  184133,
  1,
  'HI_RS00905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nqrF',
  'NADH:ubiquinone reductase (Na(+)-transporting)subunit F',
  184146,
  185381,
  1,
  'HI_RS00910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005668096.1',
  'FAD:protein FMN transferase',
  185525,
  186565,
  1,
  'HI_RS00915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nqrM',
  '(Na+)-NQR maturation NqrM',
  186568,
  186828,
  1,
  'HI_RS00920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mnmA',
  'tRNA 2-thiouridine(34) synthase MnmA',
  186945,
  188096,
  1,
  'HI_RS00925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pgeF',
  'peptidoglycan editing factor PgeF',
  188140,
  188874,
  -1,
  'HI_RS00930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rluD',
  '23S rRNA pseudouridine(1911/1915/1917) synthaseRluD',
  188876,
  189850,
  -1,
  'HI_RS00935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694110.1',
  'outer membrane protein assembly factor BamD',
  189958,
  190746,
  1,
  'HI_RS00940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694109.1',
  'surface-adhesin protein E',
  190826,
  191308,
  -1,
  'HI_RS00945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pflA',
  'pyruvate formate lyase 1-activating protein',
  191340,
  192080,
  -1,
  'HI_RS00950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pflB',
  'formate C-acetyltransferase',
  192211,
  194523,
  -1,
  'HI_RS00955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'focA',
  'formate transporter FocA',
  194557,
  195411,
  -1,
  'HI_RS00960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nagK',
  'N-acetylglucosamine kinase',
  195915,
  196829,
  1,
  'HI_RS00965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828421.1',
  'alanine/glycine:cation symporter family protein',
  197012,
  198451,
  1,
  'HI_RS00970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fghA',
  'S-formylglutathione hydrolase',
  198638,
  199465,
  -1,
  'HI_RS00975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694101.1',
  'S-(hydroxymethyl)glutathione dehydrogenase/classIII alcohol dehydrogenase',
  199474,
  200610,
  -1,
  'HI_RS00980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005691542.1',
  'MerR family transcriptional regulator',
  200733,
  201140,
  1,
  'HI_RS00985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tatA',
  'twin-arginine translocase TatA/TatE familysubunit',
  201358,
  201627,
  1,
  'HI_RS00990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tatB',
  'Sec-independent protein translocase proteinTatB',
  201591,
  202151,
  1,
  'HI_RS00995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS00995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tatC',
  'twin-arginine translocase subunit TatC',
  202161,
  202931,
  1,
  'HI_RS01000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gdhA',
  'NADP-specific glutamate dehydrogenase',
  203291,
  204640,
  1,
  'HI_RS01005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fur',
  'ferric iron uptake transcriptional regulator',
  204748,
  205188,
  -1,
  'HI_RS01010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fldA',
  'flavodoxin FldA',
  205217,
  205741,
  -1,
  'HI_RS01015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005653834.1',
  'alpha/beta fold hydrolase',
  205838,
  206620,
  -1,
  'HI_RS01020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'seqA',
  'replication initiation negative regulator SeqA',
  206691,
  207284,
  1,
  'HI_RS01025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'menE',
  'o-succinylbenzoate--CoA ligase',
  207287,
  208645,
  1,
  'HI_RS01030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mscK',
  'mechanosensitive channel MscK',
  208687,
  212007,
  1,
  'HI_RS01035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aroC',
  'chorismate synthase',
  212017,
  213090,
  1,
  'HI_RS01040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mepA',
  'penicillin-insensitive murein endopeptidase',
  213175,
  214035,
  1,
  'HI_RS01045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005664344.1',
  'TSUP family transporter',
  214053,
  214820,
  1,
  'HI_RS01050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lpxM',
  'lauroyl-Kdo(2)-lipid IV(A) myristoyltransferase',
  214867,
  215823,
  1,
  'HI_RS01055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'selD',
  'selenide, water dikinase SelD',
  215881,
  216921,
  1,
  'HI_RS01060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplS',
  '50S ribosomal protein L19',
  217030,
  217380,
  -1,
  'HI_RS01065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trmD',
  'tRNA (guanosine(37)-N1)-methyltransferase TrmD',
  217417,
  218157,
  -1,
  'HI_RS01070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rimM',
  'ribosome maturation factor RimM',
  218195,
  218722,
  -1,
  'HI_RS01075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsP',
  '30S ribosomal protein S16',
  218767,
  219015,
  -1,
  'HI_RS01080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005689698.1',
  'hypothetical protein',
  219308,
  220081,
  1,
  'HI_RS01085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nadN',
  'NAD nucleotidase',
  220104,
  221915,
  1,
  'HI_RS01090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aroK',
  'shikimate kinase AroK',
  222200,
  222742,
  1,
  'HI_RS01095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aroB',
  '3-dehydroquinate synthase',
  222762,
  223850,
  1,
  'HI_RS01100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868957.1',
  'Dam family site-specificDNA-(adenine-N6)-methyltransferase',
  223852,
  224712,
  1,
  'HI_RS01105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694086.1',
  'phosphatase PAP2 family protein',
  225814,
  226539,
  -1,
  'HI_RS01110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ribA',
  'GTP cyclohydrolase II',
  226608,
  227258,
  1,
  'HI_RS01115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694085.1',
  'peptide ABC transporter substrate-bindingprotein',
  227577,
  229121,
  -1,
  'HI_RS01120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DUF454 domain-containing protein',
  229114,
  229477,
  -1,
  'HI_RS01125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'prlC',
  'oligopeptidase A',
  229603,
  231642,
  1,
  'HI_RS01130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'type I restriction-modification system subunitM',
  231874,
  233393,
  1,
  'HI_RS01135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694081.1',
  'restriction endonuclease subunit S',
  233477,
  234634,
  1,
  'HI_RS01140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694080.1',
  'REP-associated tyrosine transposase',
  234763,
  235293,
  1,
  'HI_RS01145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'type I restriction endonuclease subunit R',
  235441,
  238519,
  1,
  'HI_RS01150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005658466.1',
  'YkgB family protein',
  238674,
  239303,
  -1,
  'HI_RS01155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'response regulator',
  239516,
  241313,
  -1,
  'HI_RS01160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868960.1',
  'uracil-DNA glycosylase family protein',
  241428,
  242015,
  -1,
  'HI_RS01165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rrf',
  '—',
  242276,
  242391,
  -1,
  'HI_RS01170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  242623,
  245542,
  -1,
  'HI_RS01175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  245806,
  245881,
  -1,
  'HI_RS01180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  246009,
  247554,
  -1,
  'HI_RS01185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828419.1',
  'bifunctional biotin--[acetyl-CoA-carboxylase]ligase/biotin operon repressor BirA',
  247910,
  248815,
  -1,
  'HI_RS01190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'guaB',
  'IMP dehydrogenase',
  248948,
  250414,
  1,
  'HI_RS01195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'glutamine amidotransferase',
  250524,
  250628,
  1,
  'HI_RS01200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'hypothetical protein',
  250674,
  251015,
  1,
  'HI_RS01205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'guaA',
  'glutamine-hydrolyzing GMP synthase',
  251125,
  252696,
  1,
  'HI_RS01210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rarD',
  'EamA family transporter RarD',
  252758,
  253648,
  -1,
  'HI_RS01215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868963.1',
  'Lrp/AsnC family transcriptional regulator',
  253772,
  254233,
  1,
  'HI_RS01220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nhaA',
  'Na+/H+ antiporter NhaA',
  254272,
  255474,
  -1,
  'HI_RS01225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'brnQ',
  'branched-chain amino acid transport system IIcarrier protein',
  255662,
  256972,
  1,
  'HI_RS01230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005660595.1',
  'N-acetylneuraminate anomerase',
  257080,
  257547,
  -1,
  'HI_RS01235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'hypothetical protein',
  257623,
  258022,
  -1,
  'HI_RS01240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pnp',
  'polyribonucleotide nucleotidyltransferase',
  258296,
  260425,
  1,
  'HI_RS01245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nlpI',
  'lipoprotein NlpI',
  260507,
  261451,
  1,
  'HI_RS01250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694061.1',
  'DEAD/DEAH box helicase',
  261572,
  263413,
  1,
  'HI_RS01255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mltF',
  'membrane-bound lytic murein transglycosylaseMltF',
  263531,
  264979,
  1,
  'HI_RS01260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005656158.1',
  'DUF5377 family protein',
  265270,
  265416,
  -1,
  'HI_RS01265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927856.1',
  'DUF5377 family protein',
  265433,
  265567,
  -1,
  'HI_RS01270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648813.1',
  'alternative ribosome-rescue factor A',
  265624,
  265833,
  -1,
  'HI_RS01275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'arsC',
  'arsenate reductase (glutaredoxin)',
  265901,
  266251,
  -1,
  'HI_RS01280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'AI-2E family transporter',
  266330,
  267378,
  1,
  'HI_RS01285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'secF',
  'protein translocase subunit SecF',
  267493,
  268467,
  -1,
  'HI_RS01290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'secD',
  'protein translocase subunit SecD',
  268478,
  270328,
  -1,
  'HI_RS01295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yajC',
  'preprotein translocase subunit YajC',
  270398,
  270691,
  -1,
  'HI_RS01300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005634417.1',
  'sulfurtransferase TusA family protein',
  270799,
  271020,
  -1,
  'HI_RS01305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648824.1',
  'hemerythrin domain-containing protein',
  271017,
  271535,
  -1,
  'HI_RS01310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tgt',
  'tRNA guanosine(34) transglycosylase Tgt',
  271600,
  272748,
  -1,
  'HI_RS01315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'queA',
  'tRNA preQ1(34) S-adenosylmethionineribosyltransferase-isomerase QueA',
  273092,
  274183,
  -1,
  'HI_RS01320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005686672.1',
  'hypothetical protein',
  274307,
  274753,
  -1,
  'HI_RS01325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'autotransporter outer membrane beta-barreldomain-containing protein',
  274892,
  279121,
  -1,
  'HI_RS01330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'uvrA',
  'excinuclease ABC subunit UvrA',
  279439,
  282270,
  -1,
  'HI_RS01335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694052.1',
  'single-stranded DNA-binding protein',
  282424,
  282930,
  1,
  'HI_RS01340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868966.1',
  'energy transducer TonB',
  283108,
  283920,
  -1,
  'HI_RS01345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'exbD',
  'TonB system transport protein ExbD',
  283930,
  284373,
  -1,
  'HI_RS01350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'exbB',
  'TonB-system energizer ExbB',
  284377,
  284829,
  -1,
  'HI_RS01355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'bcp',
  'thioredoxin-dependent thiol peroxidase',
  284998,
  285465,
  -1,
  'HI_RS01360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dapA',
  '4-hydroxy-tetrahydrodipicolinate synthase',
  285566,
  286462,
  1,
  'HI_RS01365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'bamC',
  'NlpB/DapX family lipoprotein',
  286573,
  287220,
  1,
  'HI_RS01370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'raiA',
  'ribosome hibernation-promoting factor, HPF/YfiAfamily',
  287390,
  287713,
  1,
  'HI_RS01375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  288153,
  288242,
  -1,
  'HI_RS01380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868968.1',
  'glycosyltransferase family 8 protein',
  288442,
  289434,
  -1,
  'HI_RS01385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rdgB',
  'RdgB/HAM1 family non-canonical purine NTPpyrophosphatase',
  289511,
  290098,
  -1,
  'HI_RS01390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694044.1',
  '3-deoxy-D-manno-octulosonic acid kinase',
  290110,
  290835,
  -1,
  'HI_RS01395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868969.1',
  'glycosyltransferase family 9 protein',
  290912,
  291955,
  1,
  'HI_RS01400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694042.1',
  'heme/hemopexin-binding protein HxuC',
  292279,
  294450,
  1,
  'HI_RS01405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694040.1',
  'heme/hemopexin-binding protein HxuB',
  294525,
  296222,
  1,
  'HI_RS01410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694039.1',
  'heme/hemopexin-binding protein HxuA',
  296234,
  298951,
  1,
  'HI_RS01415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'folB',
  'dihydroneopterin aldolase',
  299047,
  299403,
  -1,
  'HI_RS01420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'plsY',
  'glycerol-3-phosphate 1-O-acyltransferase PlsY',
  299486,
  300085,
  1,
  'HI_RS01425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'narQ',
  'nitrate/nitrite two-component system sensorhistidine kinase NarQ',
  300127,
  301830,
  1,
  'HI_RS01430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'murB',
  'UDP-N-acetylmuramate dehydrogenase',
  301840,
  302865,
  1,
  'HI_RS01435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpoH',
  'RNA polymerase sigma factor RpoH',
  302991,
  303836,
  1,
  'HI_RS01440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dusC',
  'tRNA dihydrouridine(16) synthase DusC',
  303876,
  304808,
  -1,
  'HI_RS01445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'djlA',
  'co-chaperone DjlA',
  304808,
  305674,
  -1,
  'HI_RS01450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pyrE',
  'orotate phosphoribosyltransferase',
  305753,
  306394,
  -1,
  'HI_RS01455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rph',
  'ribonuclease PH',
  306418,
  307134,
  -1,
  'HI_RS01460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  307279,
  307354,
  -1,
  'HI_RS01465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gltX',
  'glutamate--tRNA ligase',
  307435,
  308877,
  -1,
  'HI_RS01470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  309048,
  309123,
  1,
  'HI_RS01475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  309167,
  309242,
  1,
  'HI_RS01480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  309301,
  309376,
  1,
  'HI_RS01485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  309429,
  309504,
  1,
  'HI_RS01490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694030.1',
  'phosphoethanolamine transferase Lpt6',
  309627,
  311282,
  1,
  'HI_RS01495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005656225.1',
  'virulence factor BrkB family protein',
  311302,
  312111,
  -1,
  'HI_RS01500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694029.1',
  'YchJ family protein',
  312108,
  312593,
  -1,
  'HI_RS01505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'MOSC domain-containing protein',
  312596,
  313259,
  -1,
  'HI_RS01510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'udp',
  'uridine phosphorylase',
  313495,
  314253,
  1,
  'HI_RS01515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005660680.1',
  'MFS transporter',
  314478,
  315794,
  -1,
  'HI_RS01520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'menH',
  '2-succinyl-6-hydroxy-2,4-cyclohexadiene-1-carboxylate synthase',
  315850,
  316593,
  -1,
  'HI_RS01525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868971.1',
  '2-succinyl-5-enolpyruvyl-6-hydroxy-3-cyclohexene-1-carboxylic-acid synthase',
  316654,
  318360,
  -1,
  'HI_RS01530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828415.1',
  'isochorismate synthase',
  318376,
  319647,
  -1,
  'HI_RS01535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_080003777.1',
  'hypothetical protein',
  319581,
  319850,
  1,
  'HI_RS01540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694022.1',
  'pyridoxal phosphate-dependent aminotransferase',
  319804,
  321018,
  1,
  'HI_RS01545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mtr',
  'tryptophan permease',
  321135,
  322391,
  1,
  'HI_RS01550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693026.1',
  'L-serine ammonia-lyase',
  322500,
  323867,
  -1,
  'HI_RS01555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005666700.1',
  'HAAAP family serine/threonine permease',
  323902,
  325140,
  -1,
  'HI_RS01560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868972.1',
  'heavy metal translocating P-type ATPase',
  325363,
  327531,
  -1,
  'HI_RS01565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005656255.1',
  'heavy-metal-associated domain-containingprotein',
  327506,
  327712,
  -1,
  'HI_RS01570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005631184.1',
  'heavy-metal-associated domain-containingprotein',
  327787,
  327993,
  -1,
  'HI_RS01575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cueR',
  'Cu(I)-responsive transcriptional regulator',
  328070,
  328456,
  1,
  'HI_RS01580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'metJ',
  'met regulon transcriptional regulator MetJ',
  328470,
  328787,
  -1,
  'HI_RS01585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rho',
  'transcription termination factor Rho',
  329034,
  330296,
  1,
  'HI_RS01590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694370.1',
  'prepilin peptidase',
  330350,
  331042,
  -1,
  'HI_RS01595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694369.1',
  'type II secretion system F family protein',
  331039,
  332259,
  -1,
  'HI_RS01600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694368.1',
  'GspE/PulE family protein',
  332256,
  333650,
  -1,
  'HI_RS01605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694367.1',
  'prepilin-type N-terminal cleavage/methylationdomain-containing protein',
  333647,
  334096,
  -1,
  'HI_RS01610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ampD',
  '1,6-anhydro-N-acetylmuramyl-L-alanine amidaseAmpD',
  334212,
  334766,
  1,
  'HI_RS01615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'corC',
  'CNNM family magnesium/cobalt transport proteinCorC',
  335399,
  336298,
  1,
  'HI_RS01620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lnt',
  'apolipoprotein N-acyltransferase',
  336282,
  337850,
  1,
  'HI_RS01625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsmE',
  '16S rRNA (uracil(1498)-N(3))-methyltransferase',
  337900,
  338637,
  1,
  'HI_RS01630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694360.1',
  'YqgE/AlgH family protein',
  338634,
  339194,
  1,
  'HI_RS01635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ruvX',
  'Holliday junction resolvase RuvX',
  339194,
  339613,
  1,
  'HI_RS01640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rdgC',
  'recombination-associated protein RdgC',
  339663,
  340571,
  -1,
  'HI_RS01645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694358.1',
  'pyrroline-5-carboxylate reductase',
  340637,
  341452,
  1,
  'HI_RS01650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694357.1',
  '3-phenylpropionate MFS transporter',
  341452,
  342618,
  1,
  'HI_RS01655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'xerD',
  'site-specific tyrosine recombinase XerD',
  342649,
  343542,
  1,
  'HI_RS01660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694353.1',
  'DUF5339 domain-containing protein',
  343715,
  344002,
  1,
  'HI_RS01665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ruvB',
  'Holliday junction branch migration DNA helicaseRuvB',
  344054,
  345061,
  -1,
  'HI_RS01670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ruvA',
  'Holliday junction branch migration protein RuvA',
  345069,
  345683,
  -1,
  'HI_RS01675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ruvC',
  'crossover junction endodeoxyribonuclease RuvC',
  345746,
  346318,
  -1,
  'HI_RS01680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649034.1',
  'YebC/PmpR family DNA-binding transcriptionalregulator',
  346365,
  347105,
  -1,
  'HI_RS01685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nudB',
  'dihydroneopterin triphosphate diphosphatase',
  347265,
  347741,
  -1,
  'HI_RS01690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aspS',
  'aspartate--tRNA ligase',
  347763,
  349529,
  -1,
  'HI_RS01695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649040.1',
  'isoprenylcysteine carboxyl methyltransferasefamily protein',
  349748,
  350266,
  1,
  'HI_RS01700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cmoA',
  'carboxy-S-adenosyl-L-methionine synthase CmoA',
  350319,
  351044,
  1,
  'HI_RS01705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649046.1',
  'antitoxin',
  351138,
  351374,
  1,
  'HI_RS01710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868975.1',
  'type II toxin-antitoxin system VapC familytoxin',
  351371,
  351775,
  1,
  'HI_RS01715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gloA',
  'lactoylglutathione lyase',
  351842,
  352249,
  1,
  'HI_RS01720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rnt',
  'ribonuclease T',
  352323,
  353012,
  1,
  'HI_RS01725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694344.1',
  'Na+/H+ antiporter family protein',
  353326,
  354678,
  1,
  'HI_RS01730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'primosomal replication protein N',
  354711,
  355297,
  1,
  'HI_RS01735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  355348,
  355437,
  -1,
  'HI_RS01740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'efp',
  'elongation factor P',
  355648,
  356214,
  -1,
  'HI_RS01745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'epmB',
  'EF-P beta-lysylation protein EpmB',
  356252,
  357268,
  1,
  'HI_RS01750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'oapA',
  'opacity-associated protein OapA',
  357367,
  358662,
  1,
  'HI_RS01755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694341.1',
  'opacity-associated protein OapB',
  358722,
  359126,
  1,
  'HI_RS01760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recO',
  'DNA repair protein RecO',
  359129,
  359839,
  1,
  'HI_RS01765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rlmD',
  '23S rRNA (uracil(1939)-C(5))-methyltransferaseRlmD',
  359839,
  361155,
  1,
  'HI_RS01770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694339.1',
  'GTP diphosphokinase',
  361233,
  363464,
  1,
  'HI_RS01775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694338.1',
  'diacylglycerol kinase',
  363479,
  363835,
  1,
  'HI_RS01780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mog',
  'molybdopterin adenylyltransferase',
  363918,
  364511,
  1,
  'HI_RS01785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glnB',
  'nitrogen regulatory protein P-II',
  364513,
  364851,
  1,
  'HI_RS01790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694337.1',
  'AI-2E family transporter',
  364851,
  365897,
  1,
  'HI_RS01795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'priA',
  'primosomal protein N''',
  365938,
  368130,
  -1,
  'HI_RS01800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trmB',
  'tRNA (guanosine(46)-N7)-methyltransferase TrmB',
  368213,
  368953,
  1,
  'HI_RS01805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694334.1',
  'YggL family protein',
  369038,
  369382,
  1,
  'HI_RS01810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'napF',
  'ferredoxin-type protein NapF',
  369588,
  370117,
  1,
  'HI_RS01815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694331.1',
  'chaperone NapD',
  370110,
  370391,
  1,
  'HI_RS01820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'napA',
  'nitrate reductase catalytic subunit NapA',
  370428,
  372912,
  1,
  'HI_RS01825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'napG',
  'ferredoxin-type protein NapG',
  372967,
  373806,
  1,
  'HI_RS01830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'napH',
  'quinol dehydrogenase ferredoxin subunit NapH',
  373806,
  374669,
  1,
  'HI_RS01835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649106.1',
  'nitrate reductase cytochrome c-type subunit',
  374675,
  375118,
  1,
  'HI_RS01840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868977.1',
  'cytochrome c3 family protein',
  375133,
  375735,
  1,
  'HI_RS01845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'adk',
  'adenylate kinase',
  375895,
  376539,
  -1,
  'HI_RS01850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_050396697.1',
  'MFS transporter',
  376624,
  377862,
  -1,
  'HI_RS01855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'galE',
  'UDP-glucose 4-epimerase GalE',
  378043,
  379059,
  -1,
  'HI_RS01860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_105163174.1',
  'alpha-2,3-sialyltransferase',
  379232,
  380230,
  -1,
  'HI_RS01865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693805.1',
  'ABC transporter ATP-binding protein',
  380643,
  381365,
  1,
  'HI_RS01870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693804.1',
  'ABC transporter permease',
  381362,
  382099,
  1,
  'HI_RS01875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693803.1',
  'ABC transporter substrate-binding protein',
  382121,
  383065,
  1,
  'HI_RS01880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tenA',
  'thiaminase II',
  383075,
  383722,
  1,
  'HI_RS01885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005666622.1',
  'metal ABC transporter permease',
  383822,
  384637,
  -1,
  'HI_RS01890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005666620.1',
  'metal ABC transporter permease',
  384630,
  385478,
  -1,
  'HI_RS01895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005630123.1',
  'ATP-binding cassette domain-containing protein',
  385482,
  386402,
  -1,
  'HI_RS01900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005656358.1',
  'metal ABC transporter substrate-binding protein',
  386402,
  387283,
  -1,
  'HI_RS01905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693802.1',
  'D-alanyl-D-alanine carboxypeptidase familyprotein',
  387648,
  388526,
  -1,
  'HI_RS01910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trmG/rlmN',
  'dual-specificity RNA methyltransferase RlmN',
  388773,
  389924,
  1,
  'HI_RS01915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pilW',
  'type IV pilus biogenesis/stability protein PilW',
  390026,
  390565,
  1,
  'HI_RS01920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693797.1',
  'RodZ domain-containing protein',
  390637,
  391548,
  1,
  'HI_RS01925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ispG',
  'flavodoxin-dependent(E)-4-hydroxy-3-methylbut-2-enyl-diphosphate synthase',
  391558,
  392664,
  1,
  'HI_RS01930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hisS',
  'histidine--tRNA ligase',
  392674,
  393945,
  1,
  'HI_RS01935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693794.1',
  'YfgM family protein',
  393962,
  394576,
  1,
  'HI_RS01940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'iscX',
  'Fe-S cluster assembly protein IscX',
  394627,
  394821,
  -1,
  'HI_RS01945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fdx',
  'ISC system 2Fe-2S type ferredoxin',
  394821,
  395162,
  -1,
  'HI_RS01950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hscA',
  'Fe-S protein assembly chaperone HscA',
  395202,
  397061,
  -1,
  'HI_RS01955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693791.1',
  'DUF2625 domain-containing protein',
  397080,
  397766,
  -1,
  'HI_RS01960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hscB',
  'Fe-S protein assembly co-chaperone HscB',
  397817,
  398341,
  -1,
  'HI_RS01965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'iscA',
  'iron-sulfur cluster assembly protein IscA',
  398354,
  398677,
  -1,
  'HI_RS01970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'iscU',
  'Fe-S cluster assembly scaffold IscU',
  398734,
  399114,
  -1,
  'HI_RS01975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868979.1',
  'IscS subfamily cysteine desulfurase',
  399174,
  400388,
  -1,
  'HI_RS01980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'iscR',
  'Fe-S cluster assembly transcriptional regulatorIscR',
  400455,
  400907,
  -1,
  'HI_RS01985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trmJ',
  'tRNA(cytosine(32)/uridine(32)-2''-O)-methyltransferase TrmJ',
  400960,
  401685,
  -1,
  'HI_RS01990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  401796,
  401871,
  -1,
  'HI_RS01995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS01995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  401895,
  401970,
  -1,
  'HI_RS02000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pal',
  'peptidoglycan-associated lipoprotein Pal',
  402127,
  402588,
  -1,
  'HI_RS02005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tolB',
  'Tol-Pal system beta propeller repeat proteinTolB',
  402612,
  403895,
  -1,
  'HI_RS02010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tolA',
  'cell envelope integrity protein TolA',
  403937,
  405055,
  -1,
  'HI_RS02015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tolR',
  'colicin uptake protein TolR',
  405071,
  405490,
  -1,
  'HI_RS02020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tolQ',
  'protein TolQ',
  405562,
  406248,
  -1,
  'HI_RS02025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ybgC',
  'tol-pal system-associated acyl-CoA thioesterase',
  406265,
  406675,
  -1,
  'HI_RS02030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693783.1',
  'DNA repair helicase YoaA',
  407000,
  408922,
  1,
  'HI_RS02035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tsaB',
  'tRNA(adenosine(37)-N6)-threonylcarbamoyltransferase complexdimerization subunit type 1 TsaB',
  408935,
  409645,
  1,
  'HI_RS02040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693781.1',
  'Slp family lipoprotein',
  409670,
  410221,
  1,
  'HI_RS02045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fadD',
  'long-chain-fatty-acid--CoA ligase FadD',
  410264,
  411952,
  1,
  'HI_RS02050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rnd',
  'ribonuclease D',
  412009,
  413151,
  1,
  'HI_RS02055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'acyltransferase',
  413194,
  415078,
  -1,
  'HI_RS02060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ychF',
  'redox-regulated ATPase YchF',
  415151,
  416242,
  -1,
  'HI_RS02065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pth',
  'aminoacyl-tRNA hydrolase',
  416291,
  416875,
  -1,
  'HI_RS02070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649214.1',
  'RnfH family protein',
  417042,
  417350,
  1,
  'HI_RS02075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693774.1',
  'ribosomal protein uL16 3-hydroxylase',
  417353,
  418567,
  1,
  'HI_RS02080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'xseA',
  'exodeoxyribonuclease VII large subunit',
  418569,
  419888,
  1,
  'HI_RS02085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nudF',
  'ADP-ribose diphosphatase',
  420086,
  420718,
  1,
  'HI_RS02090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cpdA',
  '3'',5''-cyclic-AMP phosphodiesterase',
  420728,
  421552,
  1,
  'HI_RS02095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693769.1',
  'YfcZ/YiiS family protein',
  421650,
  421937,
  -1,
  'HI_RS02100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693768.1',
  'porin',
  422144,
  423523,
  1,
  'HI_RS02105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828387.1',
  'methylated-DNA--[protein]-cysteineS-methyltransferase',
  423600,
  424139,
  1,
  'HI_RS02110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mutH',
  'DNA mismatch repair endonuclease MutH',
  424136,
  424807,
  1,
  'HI_RS02115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tilS',
  'tRNA lysidine(34) synthetase TilS',
  424804,
  426096,
  -1,
  'HI_RS02120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pdxY',
  'pyridoxal kinase',
  426096,
  426962,
  -1,
  'HI_RS02125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'accA',
  'acetyl-CoA carboxylase carboxyl transferasesubunit alpha',
  427035,
  427982,
  -1,
  'HI_RS02130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'znuB',
  'zinc ABC transporter permease subunit ZnuB',
  428072,
  428857,
  -1,
  'HI_RS02135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'znuC',
  'zinc ABC transporter ATP-binding protein ZnuC',
  428857,
  429663,
  -1,
  'HI_RS02140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mepM',
  'murein DD-endopeptidase MepM',
  429841,
  431262,
  1,
  'HI_RS02145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693758.1',
  'sigma-54-dependent transcriptional regulator',
  431377,
  432333,
  1,
  'HI_RS02150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hfq',
  'RNA chaperone Hfq',
  432430,
  432705,
  -1,
  'HI_RS02155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rluC',
  '23S rRNA pseudouridine(955/2504/2580) synthaseRluC',
  432796,
  433764,
  -1,
  'HI_RS02160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rne',
  'ribonuclease E',
  434185,
  436992,
  1,
  'HI_RS02165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'outer membrane beta-barrel protein',
  437224,
  437508,
  1,
  'HI_RS02170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'thiM',
  'hydroxyethylthiazole kinase',
  437766,
  438557,
  1,
  'HI_RS02175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'thiD',
  'bifunctional hydroxymethylpyrimidinekinase/phosphomethylpyrimidine kinase',
  438550,
  439359,
  1,
  'HI_RS02180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693747.1',
  'thiamine phosphate synthase',
  439370,
  440050,
  1,
  'HI_RS02185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828384.1',
  'MFS transporter',
  440034,
  441338,
  1,
  'HI_RS02190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693745.1',
  'prephenate-dependent tRNA uridine(34)hydroxylase TrhP',
  441507,
  442889,
  1,
  'HI_RS02195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693744.1',
  'type II toxin-antitoxin system TacA familyantitoxin',
  443031,
  443330,
  1,
  'HI_RS02200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'srmB',
  'ATP-dependent RNA helicase SrmB',
  444029,
  445348,
  -1,
  'HI_RS02205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828382.1',
  'tRNA1(Val) (adenine(37)-N6)-methyltransferase',
  445418,
  446116,
  1,
  'HI_RS02210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693740.1',
  'tRNA/rRNA methyltransferase',
  446149,
  447204,
  -1,
  'HI_RS02215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pssA',
  'CDP-diacylglycerol--serineO-phosphatidyltransferase',
  447351,
  448718,
  1,
  'HI_RS02220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fadR',
  'fatty acid metabolism transcriptional regulatorFadR',
  448763,
  449488,
  -1,
  'HI_RS02225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nhaB',
  'Na(+)/H(+) antiporter NhaB',
  449613,
  451157,
  1,
  'HI_RS02230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dsbB',
  'disulfide bond formation protein DsbB',
  451167,
  451700,
  1,
  'HI_RS02235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glmS',
  'glutamine--fructose-6-phosphate transaminase(isomerizing)',
  451754,
  453586,
  -1,
  'HI_RS02240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005630954.1',
  'HU family DNA-binding protein',
  453698,
  453970,
  -1,
  'HI_RS02245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693732.1',
  'YjaG family protein',
  454110,
  454700,
  -1,
  'HI_RS02250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nudC',
  'NAD(+) diphosphatase',
  454736,
  455530,
  -1,
  'HI_RS02255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nfuA',
  'Fe-S biogenesis protein NfuA',
  455597,
  456193,
  -1,
  'HI_RS02260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828380.1',
  'ComF family protein',
  456269,
  456955,
  -1,
  'HI_RS02265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693728.1',
  'type IV pilus secretin PilQ family protein',
  456967,
  458304,
  -1,
  'HI_RS02270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693727.1',
  'pilus assembly protein PilP',
  458314,
  458727,
  -1,
  'HI_RS02275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'comC',
  'competence protein ComC',
  458724,
  459245,
  -1,
  'HI_RS02280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'comB',
  'competence protein ComB',
  459242,
  459748,
  -1,
  'HI_RS02285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693722.1',
  'competence protein A',
  459749,
  460546,
  -1,
  'HI_RS02290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693721.1',
  'penicillin-binding protein 1A',
  460645,
  463239,
  1,
  'HI_RS02295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693720.1',
  '23S rRNA (adenine(2030)-N(6))-methyltransferaseRlmJ',
  463327,
  464172,
  1,
  'HI_RS02300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005629464.1',
  'YbaB/EbfC family nucleoid-associated protein',
  464325,
  464654,
  1,
  'HI_RS02305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recR',
  'recombination mediator RecR',
  464716,
  465318,
  1,
  'HI_RS02310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693718.1',
  'DNA topoisomerase III',
  465334,
  467289,
  1,
  'HI_RS02315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'secG',
  'preprotein translocase subunit SecG',
  467398,
  467736,
  1,
  'HI_RS02320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  467760,
  467845,
  1,
  'HI_RS02325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693715.1',
  'fructose-specific PTS transporter subunit EIIC',
  468265,
  469935,
  -1,
  'HI_RS02330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fruK',
  '1-phosphofructokinase',
  469937,
  470878,
  -1,
  'HI_RS02335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fruB',
  'fused PTS fructose transporter subunit IIA/HPrprotein',
  470880,
  472379,
  -1,
  'HI_RS02340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005686915.1',
  'hypothetical protein',
  472451,
  472981,
  -1,
  'HI_RS02345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693712.1',
  'virulence-associated protein VapD',
  473074,
  473349,
  -1,
  'HI_RS02350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649350.1',
  'DUF5397 domain-containing protein',
  473358,
  473549,
  -1,
  'HI_RS02355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868987.1',
  'polyamine export protein PaeA',
  473621,
  474919,
  -1,
  'HI_RS02360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005652096.1',
  'DUF1523 family protein',
  474970,
  475494,
  -1,
  'HI_RS02365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868988.1',
  'YchF/TatD family DNA exonuclease',
  475521,
  476303,
  -1,
  'HI_RS02370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868989.1',
  'DNA polymerase III subunit delta''',
  476358,
  477341,
  -1,
  'HI_RS02375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828392.1',
  'dTMP kinase',
  477338,
  477970,
  -1,
  'HI_RS02380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mltG',
  'endolytic transglycosylase MltG',
  477987,
  479030,
  -1,
  'HI_RS02385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828379.1',
  'peptidylprolyl isomerase',
  479100,
  480035,
  -1,
  'HI_RS02390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pyrR',
  'bifunctional pyr operon transcriptionalregulator/uracil phosphoribosyltransferase PyrR',
  480112,
  480651,
  -1,
  'HI_RS02395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mazG',
  'nucleoside triphosphate pyrophosphohydrolase',
  480783,
  481574,
  1,
  'HI_RS02400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693704.1',
  'VirK/YbjX family protein',
  481624,
  482499,
  -1,
  'HI_RS02405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lon',
  'endopeptidase La',
  482692,
  485103,
  1,
  'HI_RS02410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hemW',
  'radical SAM family heme chaperone HemW',
  485219,
  486370,
  1,
  'HI_RS02415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpiA',
  'ribose-5-phosphate isomerase RpiA',
  486503,
  487162,
  1,
  'HI_RS02420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'serA',
  'phosphoglycerate dehydrogenase',
  487192,
  488424,
  1,
  'HI_RS02425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693695.1',
  'CAF17-like 4Fe-4S cluster assembly/insertionprotein YgfZ',
  488468,
  489310,
  -1,
  'HI_RS02430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693694.1',
  'YicC/YloC family endoribonuclease',
  489320,
  490183,
  -1,
  'HI_RS02435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hisG',
  'ATP phosphoribosyltransferase',
  490631,
  491542,
  1,
  'HI_RS02440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hisD',
  'histidinol dehydrogenase',
  491635,
  492918,
  1,
  'HI_RS02445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hisC',
  'histidinol-phosphate transaminase',
  493032,
  494090,
  1,
  'HI_RS02450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hisB',
  'bifunctionalhistidinol-phosphatase/imidazoleglycerol-phosphatedehydratase HisB',
  494202,
  495290,
  1,
  'HI_RS02455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hisH',
  'imidazole glycerol phosphate synthase subunitHisH',
  495356,
  495955,
  1,
  'HI_RS02460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hisA',
  '1-(5-phosphoribosyl)-5-[(5-phosphoribosylamino)methylideneamino]imidazole-4-carboxamide isomerase',
  495991,
  496740,
  1,
  'HI_RS02465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hisF',
  'imidazole glycerol phosphate synthase subunitHisF',
  496722,
  497498,
  1,
  'HI_RS02470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649391.1',
  'bifunctional phosphoribosyl-AMPcyclohydrolase/phosphoribosyl-ATP diphosphatase HisIE',
  497498,
  498163,
  1,
  'HI_RS02475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693687.1',
  'aromatic amino acid transporter',
  498427,
  499629,
  1,
  'HI_RS02480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'atpC',
  'F0F1 ATP synthase subunit epsilon',
  499815,
  500243,
  -1,
  'HI_RS02485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'atpD',
  'F0F1 ATP synthase subunit beta',
  500273,
  501646,
  -1,
  'HI_RS02490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'atpG',
  'F0F1 ATP synthase subunit gamma',
  501663,
  502532,
  -1,
  'HI_RS02495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'atpA',
  'F0F1 ATP synthase subunit alpha',
  502548,
  504089,
  -1,
  'HI_RS02500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'atpH',
  'F0F1 ATP synthase subunit delta',
  504102,
  504635,
  -1,
  'HI_RS02505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'atpF',
  'F0F1 ATP synthase subunit B',
  504648,
  505118,
  -1,
  'HI_RS02510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'atpE',
  'F0F1 ATP synthase subunit C',
  505168,
  505422,
  -1,
  'HI_RS02515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'atpB',
  'F0F1 ATP synthase subunit A',
  505478,
  506266,
  -1,
  'HI_RS02520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005659757.1',
  'ATP synthase subunit I',
  506303,
  506677,
  -1,
  'HI_RS02525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsmG',
  '16S rRNA (guanine(527)-N(7))-methyltransferaseRsmG',
  506803,
  507414,
  -1,
  'HI_RS02530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693684.1',
  'PRD domain-containing protein',
  507554,
  507931,
  -1,
  'HI_RS02535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005652027.1',
  'beta-phosphoglucomutase family hydrolase',
  508047,
  508649,
  1,
  'HI_RS02540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693683.1',
  'YqaA family protein',
  508649,
  509122,
  1,
  'HI_RS02545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'luxS',
  'S-ribosylhomocysteine lyase',
  509452,
  509955,
  1,
  'HI_RS02550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'IS3 family transposase',
  510056,
  510854,
  1,
  'HI_RS02555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aphA',
  'acid phosphatase AphA',
  510901,
  511609,
  -1,
  'HI_RS02560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hslV',
  'ATP-dependent protease subunit HslV',
  511828,
  512355,
  1,
  'HI_RS02565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hslU',
  'ATP-dependent protease ATPase subunit HslU',
  512366,
  513700,
  1,
  'HI_RS02570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005666442.1',
  'extracellular solute-binding protein',
  513770,
  514822,
  -1,
  'HI_RS02575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693676.1',
  'NAD(P)/FAD-dependent oxidoreductase',
  514963,
  516258,
  1,
  'HI_RS02580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DNA recombination protein RmuC',
  516423,
  517866,
  1,
  'HI_RS02585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rbsD',
  'D-ribose pyranase',
  518034,
  518453,
  1,
  'HI_RS02590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rbsA',
  'ribose ABC transporter ATP-binding protein RbsA',
  518467,
  519948,
  1,
  'HI_RS02595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rbsC',
  'ribose ABC transporter permease',
  519964,
  520932,
  1,
  'HI_RS02600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rbsB',
  'ribose ABC transporter substrate-binding proteinRbsB',
  520952,
  521830,
  1,
  'HI_RS02605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rbsK',
  'ribokinase',
  521928,
  522848,
  1,
  'HI_RS02610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693667.1',
  'substrate-binding domain-containing protein',
  522876,
  523874,
  1,
  'HI_RS02615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649445.1',
  'TIGR00645 family protein',
  523980,
  524531,
  1,
  'HI_RS02620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rraA',
  'ribonuclease E activity regulator RraA',
  524671,
  525159,
  -1,
  'HI_RS02625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'menA',
  '1,4-dihydroxy-2-naphthoateoctaprenyltransferase',
  525211,
  526122,
  -1,
  'HI_RS02630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tsaA',
  'tRNA(N6-threonylcarbamoyladenosine(37)-N6)-methyltransferaseTrmO',
  526184,
  526903,
  1,
  'HI_RS02635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tehA',
  'dicarboxylate transporter/tellurite-resistanceprotein TehA',
  526956,
  527900,
  -1,
  'HI_RS02640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693662.1',
  'HincII family type II restriction endonuclease',
  528159,
  528935,
  -1,
  'HI_RS02645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868995.1',
  'Eco57I restriction-modification methylasedomain-containing protein',
  528932,
  530488,
  -1,
  'HI_RS02650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpoC',
  'DNA-directed RNA polymerase subunit beta''',
  530561,
  534808,
  -1,
  'HI_RS02655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpoB',
  'DNA-directed RNA polymerase subunit beta',
  535050,
  539081,
  -1,
  'HI_RS02660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplA',
  '50S ribosomal protein L1',
  539465,
  540154,
  -1,
  'HI_RS02665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplK',
  '50S ribosomal protein L11',
  540159,
  540587,
  -1,
  'HI_RS02670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'deoD',
  'purine-nucleoside phosphorylase',
  540760,
  541476,
  -1,
  'HI_RS02675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649475.1',
  'NupC/NupG family nucleoside CNT transporter',
  541560,
  542813,
  -1,
  'HI_RS02680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694124.1',
  '4Fe-4S cluster-binding domain-containingprotein',
  542912,
  543700,
  -1,
  'HI_RS02685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yjjI',
  'YjjI family glycine radical enzyme',
  543709,
  545253,
  -1,
  'HI_RS02690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005692076.1',
  'membrane protein YczE',
  545466,
  546122,
  1,
  'HI_RS02695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868996.1',
  'glycosyltransferase family 9 protein',
  546078,
  547118,
  -1,
  'HI_RS02700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fbaA',
  'class II fructose-bisphosphate aldolase',
  547186,
  548265,
  -1,
  'HI_RS02705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pgk',
  'phosphoglycerate kinase',
  548376,
  549536,
  -1,
  'HI_RS02710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694129.1',
  'ribonuclease',
  549638,
  550456,
  -1,
  'HI_RS02715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649491.1',
  'YfhL family 4Fe-4S dicluster ferredoxin',
  550534,
  550794,
  1,
  'HI_RS02720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010868997.1',
  'aromatic amino acid transporter',
  550936,
  552156,
  -1,
  'HI_RS02725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649496.1',
  'thymidine kinase',
  552193,
  552774,
  -1,
  'HI_RS02730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tsaD',
  'tRNA(adenosine(37)-N6)-threonylcarbamoyltransferase complextransferase subunit TsaD',
  552783,
  553811,
  -1,
  'HI_RS02735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsU',
  '30S ribosomal protein S21',
  554043,
  554258,
  1,
  'HI_RS02740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dnaG',
  'DNA primase',
  554392,
  556173,
  1,
  'HI_RS02745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpoD',
  'RNA polymerase sigma factor RpoD',
  556243,
  558132,
  1,
  'HI_RS02750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aspA',
  'aspartate ammonia-lyase',
  558436,
  559854,
  -1,
  'HI_RS02755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869001.1',
  'urease accessory protein UreD',
  560041,
  560826,
  -1,
  'HI_RS02760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ureG',
  'urease accessory protein UreG',
  560901,
  561536,
  -1,
  'HI_RS02765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694141.1',
  'urease accessory protein UreF',
  561681,
  562388,
  -1,
  'HI_RS02770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ureE',
  'urease accessory protein UreE',
  562373,
  562930,
  -1,
  'HI_RS02775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ureC',
  'urease subunit alpha',
  563058,
  564776,
  -1,
  'HI_RS02780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ureB',
  'urease subunit beta',
  564788,
  565093,
  -1,
  'HI_RS02785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ureA',
  'urease subunit gamma',
  565169,
  565471,
  -1,
  'HI_RS02790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005687043.1',
  'co-chaperone GroES',
  565634,
  565924,
  1,
  'HI_RS02795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'groL',
  'chaperonin GroEL',
  565947,
  567593,
  1,
  'HI_RS02800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplI',
  '50S ribosomal protein L9',
  567767,
  568216,
  -1,
  'HI_RS02805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsR',
  '30S ribosomal protein S18',
  568233,
  568460,
  -1,
  'HI_RS02810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'priB',
  'primosomal replication protein N',
  568473,
  568799,
  -1,
  'HI_RS02815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsF',
  '30S ribosomal protein S6',
  568786,
  569163,
  -1,
  'HI_RS02820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'infA',
  'translation initiation factor IF-1',
  569362,
  569580,
  -1,
  'HI_RS02825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsmA',
  '16S rRNA(adenine(1518)-N(6)/adenine(1519)-N(6))-dimethyltransferase RsmA',
  569786,
  570649,
  1,
  'HI_RS02830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694147.1',
  'glycosyltransferase family 25 protein',
  570690,
  571598,
  -1,
  'HI_RS02835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'apaH',
  'bis(5''-nucleosyl)-tetraphosphatase (symmetrical)ApaH',
  571717,
  572544,
  1,
  'HI_RS02840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694148.1',
  'glucose-6-phosphate 1-dehydrogenase familyprotein',
  572554,
  573177,
  1,
  'HI_RS02845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gnd',
  'decarboxylating NADP(+)-dependentphosphogluconate dehydrogenase',
  573303,
  574757,
  -1,
  'HI_RS02850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694149.1',
  'transposase',
  575203,
  575745,
  -1,
  'HI_RS02855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DUF1304 family protein',
  575851,
  576109,
  -1,
  'HI_RS02860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pgl',
  '6-phosphogluconolactonase',
  576109,
  576808,
  -1,
  'HI_RS02865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694154.1',
  'glucose-6-phosphate dehydrogenase',
  576891,
  578375,
  -1,
  'HI_RS02870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cysQ',
  '3''(2''),5''-bisphosphate nucleotidase CysQ',
  578451,
  579224,
  -1,
  'HI_RS02875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'hypothetical protein',
  579264,
  579679,
  -1,
  'HI_RS02880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'oligopeptide transporter, OPT family',
  579736,
  581721,
  -1,
  'HI_RS02885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hslR',
  'ribosome-associated heat shock protein Hsp15',
  581951,
  582346,
  1,
  'HI_RS02890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'asnC',
  'transcriptional regulator AsnC',
  582372,
  582824,
  -1,
  'HI_RS02895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'asnA',
  'aspartate--ammonia ligase',
  582978,
  583970,
  1,
  'HI_RS02900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694158.1',
  'phosphoglycolate phosphatase',
  584035,
  584709,
  -1,
  'HI_RS02905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpe',
  'ribulose-phosphate 3-epimerase',
  584755,
  585429,
  -1,
  'HI_RS02910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gyrB',
  'DNA topoisomerase (ATP-hydrolyzing) subunit B',
  585576,
  587996,
  -1,
  'HI_RS02915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869009.1',
  'Tex family protein',
  588147,
  590435,
  -1,
  'HI_RS02920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'greB',
  'transcription elongation factor GreB',
  590531,
  591007,
  1,
  'HI_RS02925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fabR',
  'HTH-type transcriptional repressor FabR',
  591078,
  591695,
  -1,
  'HI_RS02930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'oxyR',
  'DNA-binding transcriptional regulator OxyR',
  591695,
  592600,
  -1,
  'HI_RS02935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694168.1',
  'hybrid peroxiredoxin PGdx',
  592723,
  593448,
  1,
  'HI_RS02940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694169.1',
  'SlyX family protein',
  593536,
  593757,
  -1,
  'HI_RS02945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fkpA',
  'FKBP-type peptidyl-prolyl cis-trans isomerase',
  593855,
  594580,
  1,
  'HI_RS02950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694171.1',
  'helix-turn-helix transcriptional regulator',
  594669,
  595334,
  1,
  'HI_RS02955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tusD',
  'sulfurtransferase complex subunit TusD',
  595334,
  595714,
  1,
  'HI_RS02960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tusC',
  'sulfurtransferase complex subunit TusC',
  595711,
  596070,
  1,
  'HI_RS02965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649577.1',
  'DsrH/TusB family sulfur relay protein',
  596079,
  596366,
  1,
  'HI_RS02970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tuf',
  'elongation factor Tu',
  596497,
  597681,
  -1,
  'HI_RS02975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fusA',
  'elongation factor G',
  597746,
  599848,
  -1,
  'HI_RS02980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsG',
  '30S ribosomal protein S7',
  599932,
  600402,
  -1,
  'HI_RS02985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsL',
  '30S ribosomal protein S12',
  600559,
  600933,
  -1,
  'HI_RS02990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mnmG',
  'tRNA uridine-5-carboxymethylaminomethyl(34)synthesis enzyme MnmG',
  601115,
  603004,
  -1,
  'HI_RS02995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS02995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'MerR family transcriptional regulator',
  603505,
  603603,
  1,
  'HI_RS03000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cpdB',
  '2'',3''-cyclic-nucleotide 2''-phosphodiesterase',
  603690,
  605663,
  -1,
  'HI_RS03005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694556.1',
  'M20 family metallo-hydrolase',
  605757,
  607028,
  -1,
  'HI_RS03010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dcuC',
  'C4-dicarboxylate transporter DcuC',
  607100,
  608394,
  -1,
  'HI_RS03015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pepE',
  'dipeptidase PepE',
  608461,
  609117,
  -1,
  'HI_RS03020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694560.1',
  'Zn-dependent hydrolase',
  609241,
  610476,
  1,
  'HI_RS03025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_080003783.1',
  'Lrp/AsnC ligand binding domain-containingprotein',
  610512,
  610673,
  -1,
  'HI_RS03030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828472.1',
  'SoxR reducing system RseC family protein',
  610694,
  611110,
  1,
  'HI_RS03035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'potE',
  'putrescine-ornithine antiporter',
  611212,
  612519,
  -1,
  'HI_RS03040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'speF',
  'ornithine decarboxylase SpeF',
  612624,
  614786,
  -1,
  'HI_RS03045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694565.1',
  'leader peptide SpeFL',
  615037,
  615231,
  -1,
  'HI_RS03050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'ornithine carbamoyltransferase',
  615439,
  615623,
  -1,
  'HI_RS03055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'Lrp/AsnC family transcriptional regulator',
  615670,
  615741,
  -1,
  'HI_RS03060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694568.1',
  'YfcC family protein',
  615772,
  617301,
  -1,
  'HI_RS03065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'arcC',
  'carbamate kinase',
  617406,
  618338,
  -1,
  'HI_RS03070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005651072.1',
  'ornithine carbamoyltransferase',
  618348,
  619352,
  -1,
  'HI_RS03075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694570.1',
  'Cof-type HAD-IIB family hydrolase',
  619754,
  620572,
  1,
  'HI_RS03080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'crcB',
  'fluoride efflux transporter CrcB',
  620572,
  621054,
  1,
  'HI_RS03085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recX',
  'recombination regulator RecX',
  620954,
  621412,
  -1,
  'HI_RS03090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recA',
  'recombinase RecA',
  621492,
  622556,
  -1,
  'HI_RS03095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869017.1',
  'DNA transformation protein TfoX',
  622876,
  623529,
  1,
  'HI_RS03100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  623823,
  625368,
  1,
  'HI_RS03105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  625444,
  625520,
  1,
  'HI_RS03110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  625606,
  625681,
  1,
  'HI_RS03115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  626080,
  628999,
  1,
  'HI_RS03120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rrf',
  '—',
  629231,
  629346,
  1,
  'HI_RS03125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rrf',
  '—',
  629395,
  629510,
  1,
  'HI_RS03130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  629523,
  629599,
  1,
  'HI_RS03135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  629628,
  629703,
  1,
  'HI_RS03140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'psiE',
  'phosphate-starvation-inducible protein PsiE',
  629864,
  630282,
  1,
  'HI_RS03145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694537.1',
  'heme biosynthesis protein HemY',
  630346,
  631632,
  -1,
  'HI_RS03150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'HemX protein',
  631643,
  632856,
  -1,
  'HI_RS03155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694539.1',
  'class I adenylate cyclase',
  633161,
  635692,
  1,
  'HI_RS03160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gpsA',
  'NAD(P)H-dependent glycerol-3-phosphatedehydrogenase',
  635766,
  636773,
  1,
  'HI_RS03165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cysE',
  'serine O-acetyltransferase',
  636785,
  637588,
  1,
  'HI_RS03170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694543.1',
  'shikimate 5-dehydrogenase',
  637598,
  638413,
  1,
  'HI_RS03175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869019.1',
  'DASS family sodium-coupled anion symporter',
  638552,
  639937,
  1,
  'HI_RS03180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'folD',
  'bifunctional methylenetetrahydrofolatedehydrogenase/methenyltetrahydrofolate cyclohydrolaseFolD',
  640075,
  640923,
  -1,
  'HI_RS03185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  641105,
  641181,
  1,
  'HI_RS03190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  641229,
  641305,
  1,
  'HI_RS03195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694544.1',
  'L-fucose:H+ symporter permease',
  641451,
  642737,
  -1,
  'HI_RS03200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fucA',
  'L-fuculose-phosphate aldolase',
  642776,
  643426,
  -1,
  'HI_RS03205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fucU',
  'L-fucose mutarotase',
  643446,
  643880,
  -1,
  'HI_RS03210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fucK',
  'L-fuculokinase',
  643894,
  645306,
  -1,
  'HI_RS03215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fucI',
  'L-fucose isomerase',
  645379,
  647148,
  -1,
  'HI_RS03220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005661551.1',
  'DeoR/GlpR family DNA-binding transcriptionregulator',
  647375,
  648124,
  -1,
  'HI_RS03225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rapA',
  'RNA polymerase-associated protein RapA',
  648322,
  651093,
  1,
  'HI_RS03230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rluA',
  'bifunctional tRNA pseudouridine(32) synthase/23SrRNA pseudouridine(746) synthase RluA',
  651096,
  651755,
  1,
  'HI_RS03235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648561.1',
  'rhomboid family intramembrane serine protease',
  651782,
  652360,
  1,
  'HI_RS03240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005661561.1',
  'DeoR/GlpR family transcriptional regulator',
  652390,
  653157,
  1,
  'HI_RS03245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694548.1',
  'MetQ/NlpA family lipoprotein',
  653459,
  654280,
  -1,
  'HI_RS03250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'ABC transporter permease',
  654319,
  655009,
  -1,
  'HI_RS03255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'metN',
  'methionine ABC transporter ATP-binding proteinMetN',
  654999,
  656036,
  -1,
  'HI_RS03260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gmhB',
  'D-glycero-beta-D-manno-heptose 1,7-bisphosphate7-phosphatase',
  656212,
  656766,
  1,
  'HI_RS03265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  657105,
  658650,
  1,
  'HI_RS03270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  658778,
  658853,
  1,
  'HI_RS03275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  659117,
  662036,
  1,
  'HI_RS03280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rrf',
  '—',
  662268,
  662383,
  1,
  'HI_RS03285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'def',
  'peptide deformylase',
  662609,
  663118,
  1,
  'HI_RS03290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fmt',
  'methionyl-tRNA formyltransferase',
  663211,
  664167,
  1,
  'HI_RS03295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsmB',
  '16S rRNA (cytosine(967)-C(5))-methyltransferaseRsmB',
  664167,
  665522,
  1,
  'HI_RS03300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trkA',
  'Trk system potassium transporter TrkA',
  665535,
  666911,
  1,
  'HI_RS03305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mscL',
  'large-conductance mechanosensitive channelprotein MscL',
  666984,
  667370,
  1,
  'HI_RS03310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694645.1',
  'FAD assembly factor SdhE',
  667460,
  667717,
  1,
  'HI_RS03315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpoE',
  'RNA polymerase sigma factor RpoE',
  667825,
  668394,
  1,
  'HI_RS03320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005651258.1',
  'RseA family anti-sigma factor',
  668419,
  669006,
  1,
  'HI_RS03325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rseB',
  'sigma-E factor regulatory protein RseB',
  669086,
  670033,
  1,
  'HI_RS03330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'coaA',
  'type I pantothenate kinase',
  670124,
  671059,
  -1,
  'HI_RS03335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  671274,
  671349,
  1,
  'HI_RS03340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  671379,
  671463,
  1,
  'HI_RS03345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  671506,
  671580,
  1,
  'HI_RS03350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  671584,
  671659,
  1,
  'HI_RS03355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tuf',
  'elongation factor Tu',
  671764,
  672948,
  1,
  'HI_RS03360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694658.1',
  'chloride channel protein',
  673116,
  673493,
  1,
  'HI_RS03365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dusA',
  'tRNA dihydrouridine(20/20a) synthase DusA',
  673496,
  674479,
  1,
  'HI_RS03370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DUF406 family protein',
  674533,
  674637,
  -1,
  'HI_RS03375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869022.1',
  'TonB-dependent receptor domain-containingprotein',
  674692,
  677850,
  -1,
  'HI_RS03380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869023.1',
  'YfcZ/YiiS family protein',
  678239,
  678529,
  -1,
  'HI_RS03385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trpS',
  'tryptophan--tRNA ligase',
  678551,
  679555,
  -1,
  'HI_RS03390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hflD',
  'high frequency lysogenization protein HflD',
  679684,
  680301,
  1,
  'HI_RS03395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purB',
  'adenylosuccinate lyase',
  680324,
  681694,
  1,
  'HI_RS03400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplJ',
  '50S ribosomal protein L10',
  681966,
  682457,
  1,
  'HI_RS03405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplL',
  '50S ribosomal protein L7/L12',
  682512,
  682883,
  1,
  'HI_RS03410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glmU',
  'bifunctional UDP-N-acetylglucosaminediphosphorylase/glucosamine-1-phosphateN-acetyltransferase GlmU',
  683043,
  684413,
  1,
  'HI_RS03415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005665148.1',
  'DUF5389 family protein',
  684452,
  684763,
  -1,
  'HI_RS03420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  684859,
  684935,
  -1,
  'HI_RS03425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  684993,
  685069,
  -1,
  'HI_RS03430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  685090,
  685184,
  -1,
  'HI_RS03435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'torA',
  'trimethylamine-N-oxide reductase TorA',
  685466,
  687943,
  -1,
  'HI_RS03440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869027.1',
  'NapC/NirT family cytochrome c',
  687976,
  689076,
  -1,
  'HI_RS03445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694498.1',
  'alpha/beta fold hydrolase',
  689231,
  690172,
  -1,
  'HI_RS03450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'asd',
  'aspartate-semialdehyde dehydrogenase',
  690227,
  691342,
  -1,
  'HI_RS03455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005654516.1',
  'MgtC/SapB family protein',
  691501,
  692217,
  -1,
  'HI_RS03460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694496.1',
  'NAD(P)H-dependent oxidoreductase',
  692495,
  693073,
  -1,
  'HI_RS03465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rep',
  'DNA helicase Rep',
  693363,
  695375,
  -1,
  'HI_RS03470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005672404.1',
  'YceK/YidQ family lipoprotein',
  695381,
  695593,
  -1,
  'HI_RS03475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'coaD',
  'pantetheine-phosphate adenylyltransferase',
  695590,
  696060,
  -1,
  'HI_RS03480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694491.1',
  'lipid IV(A) 3-deoxy-D-manno-octulosonic acidtransferase',
  696057,
  697340,
  -1,
  'HI_RS03485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694490.1',
  'glycosyltransferase family 2 protein',
  697403,
  698167,
  1,
  'HI_RS03490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694489.1',
  'DNA-3-methyladenine glycosylase I',
  698164,
  698721,
  -1,
  'HI_RS03495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aroE',
  'shikimate dehydrogenase',
  698718,
  699536,
  -1,
  'HI_RS03500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694486.1',
  'L-threonylcarbamoyladenylate synthase type 1TsaC',
  699540,
  700091,
  -1,
  'HI_RS03505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694485.1',
  'DNA topoisomerase family protein',
  700107,
  700643,
  -1,
  'HI_RS03510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694483.1',
  'ABC transporter ATP-binding protein',
  700653,
  702569,
  -1,
  'HI_RS03515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005650837.1',
  'type II toxin-antitoxin system antitoxin ToxA',
  702730,
  703026,
  -1,
  'HI_RS03520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694481.1',
  'type II toxin-antitoxin system toxin ToxT',
  703019,
  703378,
  -1,
  'HI_RS03525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927859.1',
  'TonB-dependenthemoglobin/transferrin/lactoferrin family receptor',
  703648,
  706644,
  -1,
  'HI_RS03530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694625.1',
  'ABC transporter ATP-binding protein/permease',
  707165,
  708910,
  1,
  'HI_RS03535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cydC',
  'thiol reductant ABC exporter subunit CydC',
  708903,
  710561,
  1,
  'HI_RS03540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694624.1',
  'type II toxin-antitoxin system HipA familytoxin',
  710645,
  711676,
  -1,
  'HI_RS03545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005672747.1',
  'HipA N-terminal domain-containing protein',
  711673,
  711993,
  -1,
  'HI_RS03550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869030.1',
  'helix-turn-helix domain-containing protein',
  711981,
  712289,
  -1,
  'HI_RS03555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glpX',
  'class II fructose-bisphosphatase',
  712489,
  713490,
  -1,
  'HI_RS03560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'zapB',
  'cell division protein ZapB',
  713652,
  713870,
  1,
  'HI_RS03565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mioC',
  'FMN-binding protein MioC',
  713967,
  714407,
  1,
  'HI_RS03570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dtd',
  'D-aminoacyl-tRNA deacylase',
  714404,
  714838,
  1,
  'HI_RS03575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ispF',
  '2-C-methyl-D-erythritol 2,4-cyclodiphosphatesynthase',
  715140,
  715616,
  -1,
  'HI_RS03580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ispD',
  '2-C-methyl-D-erythritol 4-phosphatecytidylyltransferase',
  715613,
  716290,
  -1,
  'HI_RS03585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftsB',
  'cell division protein FtsB',
  716290,
  716568,
  -1,
  'HI_RS03590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gpt',
  'xanthine phosphoribosyltransferase',
  716691,
  717158,
  -1,
  'HI_RS03595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694602.1',
  'aminoacyl-histidine dipeptidase',
  717269,
  718723,
  1,
  'HI_RS03600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'xerC',
  'tyrosine recombinase XerC',
  718776,
  719663,
  -1,
  'HI_RS03605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005655034.1',
  'GNAT family N-acetyltransferase',
  719657,
  720097,
  -1,
  'HI_RS03610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tpiA',
  'triose-phosphate isomerase',
  720263,
  721054,
  1,
  'HI_RS03615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glpE',
  'thiosulfate sulfurtransferase GlpE',
  721137,
  721454,
  -1,
  'HI_RS03620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rarD',
  'EamA family transporter RarD',
  721436,
  722332,
  -1,
  'HI_RS03625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ilvY',
  'HTH-type transcriptional activator IlvY',
  722364,
  723242,
  -1,
  'HI_RS03630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ilvC',
  'ketol-acid reductoisomerase',
  723919,
  725397,
  1,
  'HI_RS03635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glpC',
  'anaerobic glycerol-3-phosphate dehydrogenasesubunit GlpC',
  725508,
  726788,
  -1,
  'HI_RS03640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glpB',
  'glycerol-3-phosphate dehydrogenase subunit GlpB',
  726800,
  728098,
  -1,
  'HI_RS03645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glpA',
  'anaerobic glycerol-3-phosphate dehydrogenasesubunit A',
  728088,
  729779,
  -1,
  'HI_RS03650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glpT',
  'glycerol-3-phosphate transporter',
  730072,
  731514,
  1,
  'HI_RS03655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694611.1',
  'DMT family transporter',
  731614,
  732528,
  1,
  'HI_RS03660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869032.1',
  'hypothetical protein',
  732623,
  732934,
  1,
  'HI_RS03665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glpQ',
  'glycerophosphodiester phosphodiesterase',
  732946,
  734040,
  1,
  'HI_RS03670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005689987.1',
  'MIP/aquaporin family protein',
  734270,
  735064,
  1,
  'HI_RS03675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glpK',
  'glycerol kinase GlpK',
  735085,
  736596,
  1,
  'HI_RS03680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gpt',
  'xanthine phosphoribosyltransferase',
  736671,
  737138,
  -1,
  'HI_RS03685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_075913459.1',
  'phosphodiesterase',
  737160,
  737297,
  1,
  'HI_RS03690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869033.1',
  'lipoprotein e(P4)',
  737422,
  738246,
  1,
  'HI_RS03695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828476.1',
  'rRNA large subunit pseudouridine synthase E',
  738425,
  739108,
  1,
  'HI_RS03700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ppx',
  'exopolyphosphatase',
  739234,
  740205,
  -1,
  'HI_RS03705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694581.1',
  'autotransporter assembly complex protein TamB',
  740213,
  744109,
  -1,
  'HI_RS03710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869035.1',
  'autotransporter assembly complex protein TamA',
  744119,
  745855,
  -1,
  'HI_RS03715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'slyD',
  'peptidylprolyl isomerase',
  746006,
  746578,
  -1,
  'HI_RS03720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rraB',
  'ribonuclease E inhibitor RraB',
  746658,
  747119,
  -1,
  'HI_RS03725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'truD',
  'tRNA pseudouridine(13) synthase TruD',
  747228,
  748247,
  1,
  'HI_RS03730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'surE',
  '5''/3''-nucleotidase SurE',
  748257,
  749006,
  1,
  'HI_RS03735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694589.1',
  'YqaA family protein',
  749015,
  749593,
  1,
  'HI_RS03740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005658446.1',
  'hypothetical protein',
  749602,
  749787,
  1,
  'HI_RS03745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nlpD',
  'murein hydrolase activator NlpD',
  749811,
  751028,
  1,
  'HI_RS03750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mutS',
  'DNA mismatch repair protein MutS',
  751161,
  753746,
  1,
  'HI_RS03755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  753787,
  753881,
  -1,
  'HI_RS03760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694593.1',
  'L-seryl-tRNA(Sec) selenium transferase',
  753952,
  755337,
  1,
  'HI_RS03765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'selB',
  'selenocysteine-specific translation elongationfactor',
  755334,
  757193,
  1,
  'HI_RS03770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005692348.1',
  'hypothetical protein',
  757177,
  757302,
  1,
  'HI_RS03775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005661259.1',
  'type II toxin-antitoxin system RelB/DinJ familyantitoxin',
  757421,
  757717,
  1,
  'HI_RS03780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694595.1',
  'YafQ family addiction module toxin',
  757717,
  758025,
  1,
  'HI_RS03785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869038.1',
  'hemoglobin-haptoglobin-binding protein HgpC',
  758082,
  761336,
  -1,
  'HI_RS03790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tig',
  'trigger factor',
  761637,
  762935,
  1,
  'HI_RS03795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'clpP',
  'ATP-dependent Clp endopeptidase proteolyticsubunit ClpP',
  763058,
  763639,
  1,
  'HI_RS03800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'clpX',
  'ATP-dependent protease ATP-binding subunit ClpX',
  763649,
  764884,
  1,
  'HI_RS03805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'secE',
  'preprotein translocase subunit SecE',
  765050,
  765442,
  1,
  'HI_RS03810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nusG',
  'transcription termination/antiterminationprotein NusG',
  765444,
  766001,
  1,
  'HI_RS03815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694634.1',
  'MlaA family lipoprotein',
  766152,
  766904,
  1,
  'HI_RS03820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005630808.1',
  'RidA family protein',
  766961,
  767350,
  1,
  'HI_RS03825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'htpX',
  'protease HtpX',
  767515,
  768369,
  1,
  'HI_RS03830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tusA',
  'sulfurtransferase TusA',
  768411,
  768650,
  -1,
  'HI_RS03835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828482.1',
  'YigZ family protein',
  768766,
  769386,
  1,
  'HI_RS03840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694630.1',
  'TrkH family potassium uptake protein',
  769389,
  770852,
  1,
  'HI_RS03845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  771208,
  772753,
  1,
  'HI_RS03850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  772829,
  772905,
  1,
  'HI_RS03855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  772991,
  773066,
  1,
  'HI_RS03860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  773465,
  776384,
  1,
  'HI_RS03865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rrf',
  '—',
  776616,
  776731,
  1,
  'HI_RS03870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yihI',
  'Der GTPase-activating protein YihI',
  776909,
  777469,
  1,
  'HI_RS03875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693128.1',
  'DUF2489 domain-containing protein',
  777473,
  777913,
  1,
  'HI_RS03880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005652269.1',
  'response regulator',
  777975,
  778601,
  -1,
  'HI_RS03885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lysA',
  'diaminopimelate decarboxylase',
  778807,
  780054,
  -1,
  'HI_RS03890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cyaY',
  'iron donor protein CyaY',
  780315,
  780620,
  1,
  'HI_RS03895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recQ',
  'DNA helicase RecQ',
  780622,
  782481,
  1,
  'HI_RS03900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'proS',
  'proline--tRNA ligase',
  782566,
  784284,
  1,
  'HI_RS03905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lptD',
  'LPS assembly protein LptD',
  784372,
  786720,
  -1,
  'HI_RS03910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'multicopper oxidase domain-containing protein',
  786840,
  788245,
  -1,
  'HI_RS03915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005689023.1',
  '1-acylglycerol-3-phosphate O-acyltransferase',
  788247,
  788969,
  -1,
  'HI_RS03920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lpxH',
  'UDP-2,3-diacylglucosamine diphosphatase',
  789055,
  789768,
  1,
  'HI_RS03925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648534.1',
  'methionine/alanine import family NSS transportersmall subunit',
  789901,
  789996,
  -1,
  'HI_RS03930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693140.1',
  'sodium-dependent transporter',
  789998,
  791524,
  -1,
  'HI_RS03935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693141.1',
  'thiamine pyrophosphate-binding protein',
  791772,
  792569,
  1,
  'HI_RS03940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ilvD',
  'dihydroxy-acid dehydratase',
  792641,
  794479,
  1,
  'HI_RS03945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ilvA',
  'threonine ammonia-lyase, biosynthetic',
  794559,
  796100,
  1,
  'HI_RS03950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dnaE',
  'DNA polymerase III subunit alpha',
  796139,
  799618,
  -1,
  'HI_RS03955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869047.1',
  'phospho-sugar mutase',
  799857,
  801509,
  1,
  'HI_RS03960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_080003771.1',
  'winged helix-turn-helix transcriptionalregulator',
  801560,
  801748,
  -1,
  'HI_RS03965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693146.1',
  'hypothetical protein',
  801658,
  801987,
  1,
  'HI_RS03970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'secB',
  'protein-export chaperone SecB',
  802054,
  802563,
  -1,
  'HI_RS03975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693147.1',
  'rhodanese-like domain-containing protein',
  802577,
  803023,
  -1,
  'HI_RS03980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ansB',
  'L-asparaginase 2',
  803249,
  804298,
  1,
  'HI_RS03985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005655513.1',
  'anaerobic C4-dicarboxylate transporter',
  804454,
  805776,
  1,
  'HI_RS03990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693148.1',
  'NAD(P)/FAD-dependent oxidoreductase',
  805980,
  807314,
  1,
  'HI_RS03995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS03995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'plsB',
  'glycerol-3-phosphate 1-O-acyltransferase PlsB',
  807394,
  809826,
  -1,
  'HI_RS04000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lexA',
  'transcriptional repressor LexA',
  810081,
  810704,
  1,
  'HI_RS04005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dapF',
  'diaminopimelate epimerase',
  810848,
  811672,
  1,
  'HI_RS04010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tpx',
  'thiol peroxidase',
  811891,
  812388,
  -1,
  'HI_RS04015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DUF1440 domain-containing protein',
  812442,
  812653,
  -1,
  'HI_RS04020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purL',
  'phosphoribosylformylglycinamidine synthase',
  813036,
  816929,
  1,
  'HI_RS04025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693152.1',
  'anhydro-N-acetylmuramic acid kinase',
  817101,
  818249,
  1,
  'HI_RS04030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'murQ',
  'N-acetylmuramic acid 6-phosphate etherase',
  818259,
  819170,
  1,
  'HI_RS04035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869050.1',
  'divergent polysaccharide deacetylase familyprotein',
  819200,
  820042,
  -1,
  'HI_RS04040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693155.1',
  'murein hydrolase activator EnvC',
  820042,
  821274,
  -1,
  'HI_RS04045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693156.1',
  '2,3-diphosphoglycerate-dependentphosphoglycerate mutase',
  821450,
  822133,
  1,
  'HI_RS04050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpmE',
  '50S ribosomal protein L31',
  822211,
  822423,
  -1,
  'HI_RS04055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mutY',
  'A/G-specific adenine glycosylase',
  822600,
  823736,
  1,
  'HI_RS04060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648477.1',
  'oxidative damage protection protein',
  823714,
  823986,
  1,
  'HI_RS04065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mltC',
  'membrane-bound lytic murein transglycosylaseMltC',
  824001,
  825074,
  1,
  'HI_RS04070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  825313,
  825388,
  1,
  'HI_RS04075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  825391,
  825466,
  1,
  'HI_RS04080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693159.1',
  'metallophosphoesterase family protein',
  825685,
  826365,
  -1,
  'HI_RS04085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nadR',
  'multifunctional transcriptionalregulator/nicotinamide-nucleotideadenylyltransferase/ribosylnicotinamide kinase NadR',
  826362,
  827585,
  -1,
  'HI_RS04090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005652350.1',
  '3,4-dihydroxy-2-butanone-4-phosphate synthase',
  827846,
  828493,
  1,
  'HI_RS04095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869051.1',
  'glycosyltransferase family 25 protein',
  828520,
  829356,
  1,
  'HI_RS04100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trmL',
  'tRNA(uridine(34)/cytosine(34)/5-carboxymethylaminomethyluridine(34)-2''-O)-methyltransferase TrmL',
  829405,
  829887,
  -1,
  'HI_RS04105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsmD',
  '16S rRNA (guanine(966)-N(2))-methyltransferaseRsmD',
  829898,
  830479,
  -1,
  'HI_RS04110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftsY',
  'signal recognition particle-docking proteinFtsY',
  830576,
  831778,
  1,
  'HI_RS04115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftsE',
  'cell division ATP-binding protein FtsE',
  831797,
  832453,
  1,
  'HI_RS04120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftsX',
  'permease-like cell division protein FtsX',
  832463,
  833395,
  1,
  'HI_RS04125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005666204.1',
  'acetyl-CoA C-acetyltransferase',
  833490,
  834671,
  -1,
  'HI_RS04130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693163.1',
  'TIGR00366 family protein',
  834686,
  836029,
  -1,
  'HI_RS04135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693164.1',
  '3-oxoacid CoA-transferase subunit B',
  836026,
  836697,
  -1,
  'HI_RS04140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'atoD',
  'acetate CoA-transferase subunit alpha',
  836708,
  837361,
  -1,
  'HI_RS04145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005655572.1',
  'LysR family transcriptional regulator',
  837609,
  838514,
  1,
  'HI_RS04150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsJ',
  '30S ribosomal protein S10',
  838750,
  839061,
  1,
  'HI_RS04155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplC',
  '50S ribosomal protein L3',
  839078,
  839704,
  1,
  'HI_RS04160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplD',
  '50S ribosomal protein L4',
  839720,
  840322,
  1,
  'HI_RS04165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplW',
  '50S ribosomal protein L23',
  840319,
  840618,
  1,
  'HI_RS04170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplB',
  '50S ribosomal protein L2',
  840636,
  841457,
  1,
  'HI_RS04175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsS',
  '30S ribosomal protein S19',
  841483,
  841758,
  1,
  'HI_RS04180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplV',
  '50S ribosomal protein L22',
  841770,
  842102,
  1,
  'HI_RS04185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsC',
  '30S ribosomal protein S3',
  842120,
  842827,
  1,
  'HI_RS04190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplP',
  '50S ribosomal protein L16',
  842841,
  843251,
  1,
  'HI_RS04195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpmC',
  '50S ribosomal protein L29',
  843251,
  843442,
  1,
  'HI_RS04200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsQ',
  '30S ribosomal protein S17',
  843442,
  843699,
  1,
  'HI_RS04205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869053.1',
  'hypothetical protein',
  844090,
  844695,
  1,
  'HI_RS04210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplN',
  '50S ribosomal protein L14',
  844976,
  845347,
  1,
  'HI_RS04215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplX',
  '50S ribosomal protein L24',
  845358,
  845669,
  1,
  'HI_RS04220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplE',
  '50S ribosomal protein L5',
  845687,
  846226,
  1,
  'HI_RS04225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsN',
  '30S ribosomal protein S14',
  846238,
  846543,
  1,
  'HI_RS04230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsH',
  '30S ribosomal protein S8',
  846580,
  846972,
  1,
  'HI_RS04235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplF',
  '50S ribosomal protein L6',
  846988,
  847521,
  1,
  'HI_RS04240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplR',
  '50S ribosomal protein L18',
  847535,
  847888,
  1,
  'HI_RS04245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsE',
  '30S ribosomal protein S5',
  847903,
  848403,
  1,
  'HI_RS04250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpmD',
  '50S ribosomal protein L30',
  848410,
  848589,
  1,
  'HI_RS04255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplO',
  '50S ribosomal protein L15',
  848593,
  849027,
  1,
  'HI_RS04260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'secY',
  'preprotein translocase subunit SecY',
  849035,
  850360,
  1,
  'HI_RS04265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpmJ',
  '50S ribosomal protein L36',
  850389,
  850502,
  1,
  'HI_RS04270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsM',
  '30S ribosomal protein S13',
  850642,
  851010,
  1,
  'HI_RS04275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsK',
  '30S ribosomal protein S11',
  851013,
  851402,
  1,
  'HI_RS04280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsD',
  '30S ribosomal protein S4',
  851430,
  852050,
  1,
  'HI_RS04285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpoA',
  'DNA-directed RNA polymerase subunit alpha',
  852082,
  853068,
  1,
  'HI_RS04290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplQ',
  '50S ribosomal protein L17',
  853109,
  853495,
  1,
  'HI_RS04295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'Crp/Fnr family transcriptional regulator',
  853657,
  854216,
  -1,
  'HI_RS04300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'SPASM domain-containing protein',
  854335,
  855035,
  -1,
  'HI_RS04305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693174.1',
  'sulfite exporter TauE/SafE family protein',
  855169,
  855975,
  1,
  'HI_RS04310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ispC',
  '1-deoxy-D-xylulose-5-phosphate reductoisomerase',
  856007,
  857200,
  -1,
  'HI_RS04315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'frr',
  'ribosome recycling factor',
  857310,
  857867,
  -1,
  'HI_RS04320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pckA',
  'phosphoenolpyruvate carboxykinase (ATP)',
  858019,
  859635,
  -1,
  'HI_RS04325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hslO',
  'Hsp33 family molecular chaperone HslO',
  859808,
  860689,
  -1,
  'HI_RS04330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'argH',
  'argininosuccinate lyase',
  860834,
  862207,
  -1,
  'HI_RS04335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'galU',
  'UTP--glucose-1-phosphate uridylyltransferaseGalU',
  862342,
  863229,
  -1,
  'HI_RS04340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'csrA',
  'carbon storage regulator CsrA',
  863251,
  863442,
  -1,
  'HI_RS04345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'alaS',
  'alanine--tRNA ligase',
  863520,
  866144,
  -1,
  'HI_RS04350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'uspA',
  'universal stress protein UspA',
  866332,
  866757,
  -1,
  'HI_RS04355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pepP',
  'Xaa-Pro aminopeptidase',
  866859,
  868151,
  -1,
  'HI_RS04360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693181.1',
  'YecA/YgfB family protein',
  868163,
  868711,
  -1,
  'HI_RS04365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'galM',
  'galactose-1-epimerase',
  868882,
  869904,
  -1,
  'HI_RS04370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'galK',
  'galactokinase',
  869914,
  871068,
  -1,
  'HI_RS04375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'galT',
  'galactose-1-phosphate uridylyltransferase',
  871145,
  872194,
  -1,
  'HI_RS04380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005663077.1',
  'substrate-binding domain-containing protein',
  872402,
  873400,
  1,
  'HI_RS04385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mglB',
  'galactose/glucose ABC transportersubstrate-binding protein MglB',
  873545,
  874540,
  1,
  'HI_RS04390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mglA',
  'galactose/methyl galactoside ABC transporterATP-binding protein MglA',
  874606,
  876126,
  1,
  'HI_RS04395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mglC',
  'galactose/methyl galactoside ABC transporterpermease MglC',
  876143,
  877153,
  1,
  'HI_RS04400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648352.1',
  'hypothetical protein',
  877299,
  878033,
  1,
  'HI_RS04405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005655641.1',
  'septation protein A',
  878039,
  878596,
  1,
  'HI_RS04410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yciA',
  'acyl-CoA thioester hydrolase YciA',
  878596,
  879060,
  1,
  'HI_RS04415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648344.1',
  'YciI family protein',
  879077,
  879373,
  1,
  'HI_RS04420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869063.1',
  'transglycosylase SLT domain-containing protein',
  879389,
  881170,
  1,
  'HI_RS04425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trpR',
  'trp operon repressor',
  881208,
  881513,
  1,
  'HI_RS04430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mtgA',
  'monofunctional biosynthetic peptidoglycantransglycosylase',
  881500,
  882240,
  1,
  'HI_RS04435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'frdD',
  'fumarate reductase subunit FrdD',
  882346,
  882690,
  -1,
  'HI_RS04440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'frdC',
  'fumarate reductase subunit FrdC',
  882703,
  883113,
  -1,
  'HI_RS04445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005639269.1',
  'succinate dehydrogenase/fumarate reductaseiron-sulfur subunit',
  883124,
  883894,
  -1,
  'HI_RS04450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'frdA',
  'fumarate reductase (quinol) flavoproteinsubunit',
  883887,
  885686,
  -1,
  'HI_RS04455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'epmA',
  'elongation factor P--(R)-beta-lysine ligase',
  885898,
  886869,
  1,
  'HI_RS04460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693189.1',
  'response regulator',
  887135,
  887818,
  -1,
  'HI_RS04465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'bamE',
  'outer membrane protein assembly factor BamE',
  887872,
  888285,
  -1,
  'HI_RS04470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yejK',
  'nucleoid-associated protein YejK',
  888351,
  889367,
  -1,
  'HI_RS04475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693192.1',
  'YejL family protein',
  889493,
  889711,
  1,
  'HI_RS04480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693193.1',
  'DUF3413 domain-containing protein',
  889713,
  891470,
  1,
  'HI_RS04485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'amidohydrolase family protein',
  891668,
  892659,
  1,
  'HI_RS04490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mobA',
  'molybdenum cofactor guanylyltransferase MobA',
  892798,
  893376,
  -1,
  'HI_RS04495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693195.1',
  'YihD family protein',
  893463,
  893729,
  1,
  'HI_RS04500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693196.1',
  'thiol:disulfide interchange protein DsbA',
  893740,
  894357,
  1,
  'HI_RS04505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648303.1',
  'MaoP family protein',
  894419,
  894754,
  1,
  'HI_RS04510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trmA',
  'tRNA (uridine(54)-C5)-methyltransferase TrmA',
  894898,
  895989,
  1,
  'HI_RS04515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693198.1',
  'class I SAM-dependent methyltransferase',
  895971,
  896744,
  1,
  'HI_RS04520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005670174.1',
  'SoxR reducing system RseC family protein',
  896738,
  897172,
  1,
  'HI_RS04525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'hypothetical protein',
  897244,
  897441,
  1,
  'HI_RS04530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mobB',
  'molybdopterin-guanine dinucleotide biosynthesisprotein MobB',
  897595,
  898110,
  1,
  'HI_RS04535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869070.1',
  'MDR family MFS transporter',
  898107,
  899498,
  1,
  'HI_RS04540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005670186.1',
  'ABC transporter substrate-binding protein',
  899645,
  901288,
  1,
  'HI_RS04545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hugZ',
  'HugZ family heme oxygenase',
  901464,
  902225,
  1,
  'HI_RS04550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693202.1',
  'serine dehydratase subunit alpha family protein',
  902362,
  902709,
  -1,
  'HI_RS04555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'polA',
  'DNA polymerase I',
  902724,
  905516,
  -1,
  'HI_RS04560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005651366.1',
  'cell division protein ZapA',
  905665,
  905967,
  1,
  'HI_RS04565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ssrS',
  '—',
  906075,
  906272,
  1,
  'HI_RS04570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693206.1',
  '5-formyltetrahydrofolate cyclo-ligase',
  906285,
  906848,
  1,
  'HI_RS04575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'clpB',
  'ATP-dependent chaperone ClpB',
  906976,
  909546,
  1,
  'HI_RS04580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rlmB',
  '23S rRNA(guanosine(2251)-2''-O)-methyltransferase RlmB',
  909583,
  910323,
  -1,
  'HI_RS04585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rnr',
  'ribonuclease R',
  910379,
  912727,
  -1,
  'HI_RS04590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693208.1',
  '7-cyano-7-deazaguanine/7-aminomethyl-7-deazaguanine transporter',
  912919,
  913626,
  -1,
  'HI_RS04595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pdxH',
  'pyridoxamine 5''-phosphate oxidase',
  913819,
  914451,
  1,
  'HI_RS04600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'typA',
  'translational GTPase TypA',
  914539,
  916389,
  -1,
  'HI_RS04605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glnA',
  'glutamate--ammonia ligase',
  916620,
  918038,
  1,
  'HI_RS04610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693214.1',
  'LPS O-antigen chain length determinant proteinWzzB',
  918515,
  919138,
  1,
  'HI_RS04615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693216.1',
  'flippase',
  919376,
  920590,
  1,
  'HI_RS04620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648226.1',
  'glycosyltransferase family 2 protein',
  920571,
  921323,
  1,
  'HI_RS04625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'glycosyltransferase family 2 protein',
  921328,
  922214,
  1,
  'HI_RS04630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693221.1',
  'glycosyltransferase family 52 protein',
  923293,
  924213,
  1,
  'HI_RS04635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'wbaP',
  'undecaprenyl-phosphate galactosephosphotransferase WbaP',
  924206,
  925621,
  1,
  'HI_RS04640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rfbB',
  'dTDP-glucose 4,6-dehydratase',
  925680,
  926696,
  1,
  'HI_RS04645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869079.1',
  'O-antigen ligase family protein',
  926749,
  927948,
  -1,
  'HI_RS04650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pepB',
  'aminopeptidase PepB',
  928097,
  929402,
  1,
  'HI_RS04655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ndk',
  'nucleoside-diphosphate kinase',
  929412,
  929834,
  1,
  'HI_RS04660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cgtA',
  'Obg family GTPase CgtA',
  929904,
  931076,
  -1,
  'HI_RS04665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693231.1',
  'DMT family transporter',
  931104,
  932024,
  -1,
  'HI_RS04670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpmA',
  '50S ribosomal protein L27',
  932105,
  932362,
  -1,
  'HI_RS04675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplU',
  '50S ribosomal protein L21',
  932383,
  932694,
  -1,
  'HI_RS04680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ispB',
  'octaprenyl diphosphate synthase',
  932907,
  933896,
  1,
  'HI_RS04685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005651413.1',
  'epoxyqueuosine reductase QueH',
  933947,
  934684,
  1,
  'HI_RS04690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005666065.1',
  'alanine/glycine:cation symporter family protein',
  934743,
  936113,
  -1,
  'HI_RS04695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'arcA',
  'two-component system response regulator ArcA',
  936511,
  937221,
  -1,
  'HI_RS04700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693234.1',
  'protein-disulfide reductase DsbD',
  937413,
  939152,
  1,
  'HI_RS04705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693236.1',
  'DoxX family protein',
  939264,
  939668,
  1,
  'HI_RS04710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purH',
  'bifunctionalphosphoribosylaminoimidazolecarboxamideformyltransferase/IMP cyclohydrolase',
  939856,
  941454,
  1,
  'HI_RS04715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purD',
  'phosphoribosylamine--glycine ligase',
  941550,
  942839,
  1,
  'HI_RS04720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693240.1',
  'serine hydroxymethyltransferase',
  942963,
  944228,
  1,
  'HI_RS04725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'coaE',
  'dephospho-CoA kinase',
  944299,
  944919,
  1,
  'HI_RS04730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yacG',
  'DNA gyrase inhibitor YacG',
  944912,
  945118,
  1,
  'HI_RS04735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rhlB',
  'ATP-dependent RNA helicase RhlB',
  945236,
  946483,
  1,
  'HI_RS04740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693244.1',
  'efflux transporter AcrAB transcriptionalrepressor AcrR',
  946725,
  947288,
  1,
  'HI_RS04745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693246.1',
  'multidrug efflux RND transporter periplasmicadaptor subunit AcrA',
  947320,
  948516,
  1,
  'HI_RS04750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828333.1',
  'multidrug efflux RND transporter permeasesubunit AcrB',
  948534,
  951614,
  1,
  'HI_RS04755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftsN',
  'cell division protein FtsN',
  951842,
  952618,
  1,
  'HI_RS04760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693249.1',
  'DHA2 family efflux MFS transporter permeasesubunit',
  952635,
  954167,
  -1,
  'HI_RS04765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693250.1',
  'EmrA/EmrK family multidrug efflux transporterperiplasmic adaptor subunit',
  954177,
  955349,
  -1,
  'HI_RS04770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'folA',
  'type 3 dihydrofolate reductase',
  955532,
  956014,
  -1,
  'HI_RS04775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'proB',
  'glutamate 5-kinase',
  956115,
  957221,
  1,
  'HI_RS04780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rppH',
  'RNA pyrophosphohydrolase',
  957302,
  957892,
  1,
  'HI_RS04785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693253.1',
  'sulfite exporter TauE/SafE family protein',
  957892,
  958686,
  1,
  'HI_RS04790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lgt',
  'prolipoprotein diacylglyceryl transferase',
  958695,
  959501,
  1,
  'HI_RS04795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648113.1',
  'thymidylate synthase',
  959511,
  960362,
  1,
  'HI_RS04800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tadA',
  'tRNA adenosine(34) deaminase TadA',
  960362,
  960883,
  1,
  'HI_RS04805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693258.1',
  'DUF721 domain-containing protein',
  960911,
  961225,
  -1,
  'HI_RS04810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005655841.1',
  'secA translation cis-regulator SecM',
  961305,
  961607,
  1,
  'HI_RS04815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'secA',
  'preprotein translocase subunit SecA',
  961732,
  964437,
  1,
  'HI_RS04820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mutT',
  '8-oxo-dGTP diphosphatase MutT',
  964502,
  964912,
  1,
  'HI_RS04825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869086.1',
  'monovalent cation:proton antiporter-2 (CPA2)family protein',
  965021,
  966877,
  1,
  'HI_RS04830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005666039.1',
  'class I SAM-dependent methyltransferase',
  966978,
  967742,
  1,
  'HI_RS04835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsB',
  '30S ribosomal protein S2',
  967920,
  968642,
  1,
  'HI_RS04840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tsf',
  'translation elongation factor Ts',
  968775,
  969626,
  1,
  'HI_RS04845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lpxD',
  'UDP-3-O-(3-hydroxymyristoyl)glucosamineN-acyltransferase',
  969806,
  970831,
  -1,
  'HI_RS04850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693263.1',
  'OmpH/Skp family outer membrane protein',
  970844,
  971437,
  -1,
  'HI_RS04855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'bamA',
  'outer membrane protein assembly factor BamA',
  971545,
  973932,
  -1,
  'HI_RS04860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rseP',
  'RIP metalloprotease RseP',
  973952,
  975283,
  -1,
  'HI_RS04865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693266.1',
  'phosphatidate cytidylyltransferase',
  975293,
  976159,
  -1,
  'HI_RS04870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'uppS',
  'polyprenyl diphosphate synthase',
  976177,
  976896,
  -1,
  'HI_RS04875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'leuS',
  'leucine--tRNA ligase',
  977145,
  979730,
  1,
  'HI_RS04880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005659127.1',
  'LPS-assembly lipoprotein LptE',
  979825,
  980328,
  1,
  'HI_RS04885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'holA',
  'DNA polymerase III subunit delta',
  980328,
  981362,
  1,
  'HI_RS04890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  981435,
  981511,
  -1,
  'HI_RS04895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glyS',
  'glycine--tRNA ligase subunit beta',
  981597,
  983663,
  -1,
  'HI_RS04900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693271.1',
  'endonuclease domain-containing protein',
  984000,
  984365,
  -1,
  'HI_RS04905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693272.1',
  'hypothetical protein',
  984395,
  984655,
  -1,
  'HI_RS04910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glyQ',
  'glycine--tRNA ligase subunit alpha',
  984714,
  985622,
  -1,
  'HI_RS04915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693274.1',
  'catalase',
  985888,
  987414,
  1,
  'HI_RS04920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869087.1',
  'glutathionylspermidine synthase family protein',
  987646,
  988827,
  -1,
  'HI_RS04925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869088.1',
  'hypothetical protein',
  988828,
  989448,
  -1,
  'HI_RS04930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869089.1',
  'DUF2251 domain-containing protein',
  989421,
  989840,
  -1,
  'HI_RS04935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'eno',
  'phosphopyruvate hydratase',
  989924,
  991234,
  -1,
  'HI_RS04940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693280.1',
  'BaiN/RdsA family NAD(P)/FAD-dependentoxidoreductase',
  991355,
  992560,
  -1,
  'HI_RS04945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nrfF',
  'heme lyase NrfEFG subunit NrfF',
  992557,
  993711,
  -1,
  'HI_RS04950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693282.1',
  'DsbE family thiol:disulfide interchange protein',
  993708,
  994238,
  -1,
  'HI_RS04955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nrfE',
  'heme lyase NrfEFG subunit NrfE',
  994238,
  996145,
  -1,
  'HI_RS04960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'suhB',
  'inositol-1-monophosphatase',
  996254,
  997057,
  -1,
  'HI_RS04965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693285.1',
  'pilus assembly FimT family protein',
  997258,
  997770,
  1,
  'HI_RS04970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693287.1',
  'PulJ/GspJ family protein',
  997770,
  998486,
  1,
  'HI_RS04975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869091.1',
  'DUF2572 family protein',
  998486,
  999169,
  1,
  'HI_RS04980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828334.1',
  'DUF5374 domain-containing protein',
  999162,
  999449,
  1,
  'HI_RS04985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recC',
  'exodeoxyribonuclease V subunit gamma',
  999495,
  1002860,
  1,
  'HI_RS04990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nrdR',
  'transcriptional regulator NrdR',
  1002915,
  1003364,
  1,
  'HI_RS04995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS04995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ribD',
  'bifunctionaldiaminohydroxyphosphoribosylaminopyrimidinedeaminase/5-amino-6-(5-phosphoribosylamino)uracilreductase RibD',
  1003367,
  1004485,
  1,
  'HI_RS05000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'degS',
  'outer membrane-stress sensor serineendopeptidase DegS',
  1004486,
  1005508,
  1,
  'HI_RS05005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mutM',
  'DNA-formamidopyrimidine glycosylase',
  1005582,
  1006397,
  -1,
  'HI_RS05010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693296.1',
  'L-2,4-diaminobutyrate decarboxylase',
  1006630,
  1008165,
  -1,
  'HI_RS05015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'vapC',
  'type II toxin-antitoxin systemtRNA(fMet)-specific endonuclease VapC',
  1008185,
  1008583,
  -1,
  'HI_RS05020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005648011.1',
  'type II toxin-antitoxin system antitoxin VapB2',
  1008583,
  1008816,
  -1,
  'HI_RS05025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693298.1',
  'diaminobutyrate--2-oxoglutarate transaminase',
  1008963,
  1010327,
  -1,
  'HI_RS05030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpmG',
  '50S ribosomal protein L33',
  1010675,
  1010845,
  -1,
  'HI_RS05035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpmB',
  '50S ribosomal protein L28',
  1010857,
  1011093,
  -1,
  'HI_RS05040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'radC',
  'RadC family protein',
  1011307,
  1011972,
  -1,
  'HI_RS05045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'coaBC',
  'bifunctional phosphopantothenoylcysteinedecarboxylase/phosphopantothenate--cysteine ligase CoaBC',
  1012136,
  1013338,
  1,
  'HI_RS05050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dut',
  'dUTP diphosphatase',
  1013386,
  1013841,
  1,
  'HI_RS05055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'slmA',
  'nucleoid occlusion factor SlmA',
  1013845,
  1014501,
  1,
  'HI_RS05060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'YheU family protein',
  1014523,
  1014775,
  1,
  'HI_RS05065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'crp',
  'cAMP-activated global transcriptional regulatorCRP',
  1014760,
  1015434,
  1,
  'HI_RS05070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rlmC',
  '23S rRNA (uracil(747)-C(5))-methyltransferaseRlmC',
  1015799,
  1016977,
  -1,
  'HI_RS05075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nagZ',
  'beta-N-acetylhexosaminidase',
  1016970,
  1018025,
  -1,
  'HI_RS05080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647993.1',
  'YcfL family putative periplasmic lipoprotein',
  1018029,
  1018379,
  -1,
  'HI_RS05085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hinT',
  'purine nucleoside phosphoramidase',
  1018379,
  1018729,
  -1,
  'HI_RS05090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ileS',
  'isoleucine--tRNA ligase',
  1018846,
  1021671,
  -1,
  'HI_RS05095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ribF',
  'bifunctional riboflavin kinase/FAD synthetase',
  1021700,
  1022626,
  -1,
  'HI_RS05100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'murJ',
  'murein biosynthesis integral membrane proteinMurJ',
  1022673,
  1024247,
  -1,
  'HI_RS05105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsT',
  '30S ribosomal protein S20',
  1024514,
  1024777,
  1,
  'HI_RS05110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693313.1',
  'DUF5358 domain-containing protein',
  1024850,
  1025416,
  -1,
  'HI_RS05115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'menB',
  '1,4-dihydroxy-2-naphthoyl-CoA synthase',
  1025562,
  1026419,
  1,
  'HI_RS05120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'menC',
  'o-succinylbenzoate synthase',
  1026488,
  1027477,
  1,
  'HI_RS05125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aroQ',
  'type II 3-dehydroquinate dehydratase',
  1027535,
  1027984,
  1,
  'HI_RS05130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693317.1',
  'acetyl-CoA carboxylase biotin carboxyl carrierprotein',
  1028137,
  1028604,
  1,
  'HI_RS05135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'accC',
  'acetyl-CoA carboxylase biotin carboxylasesubunit',
  1028779,
  1030125,
  1,
  'HI_RS05140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693319.1',
  'Slam-dependent surface lipoprotein',
  1030275,
  1031144,
  1,
  'HI_RS05145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DUF560 domain-containing protein',
  1031208,
  1032653,
  1,
  'HI_RS05150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647974.1',
  'YhdT family protein',
  1032765,
  1033022,
  1,
  'HI_RS05155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'panF',
  'sodium/pantothenate symporter',
  1033019,
  1034473,
  1,
  'HI_RS05160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869098.1',
  'DMT family transporter',
  1034593,
  1034979,
  1,
  'HI_RS05165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869099.1',
  'DMT family transporter',
  1034952,
  1035464,
  1,
  'HI_RS05170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005690872.1',
  'protein adenylyltransferase Fic',
  1035466,
  1036041,
  1,
  'HI_RS05175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'prmA',
  '50S ribosomal protein L11 methyltransferase',
  1036082,
  1036972,
  1,
  'HI_RS05180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dusB',
  'tRNA dihydrouridine synthase DusB',
  1037121,
  1038113,
  1,
  'HI_RS05185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fis',
  'DNA-binding transcriptional regulator Fis',
  1038094,
  1038393,
  1,
  'HI_RS05190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'smpB',
  'SsrA-binding protein SmpB',
  1038488,
  1038973,
  -1,
  'HI_RS05195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pfkA',
  '6-phosphofructokinase',
  1039212,
  1040177,
  -1,
  'HI_RS05200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693323.1',
  'hypothetical protein',
  1040273,
  1040854,
  -1,
  'HI_RS05205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yaaA',
  'peroxide stress protein YaaA',
  1040847,
  1041623,
  -1,
  'HI_RS05210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dprA',
  'DNA-processing protein DprA',
  1041677,
  1042798,
  -1,
  'HI_RS05215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'leuA',
  '2-isopropylmalate synthase',
  1043355,
  1044902,
  1,
  'HI_RS05220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'leuB',
  '3-isopropylmalate dehydrogenase',
  1044988,
  1046064,
  1,
  'HI_RS05225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'leuC',
  '3-isopropylmalate dehydratase large subunit',
  1046240,
  1047649,
  1,
  'HI_RS05230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'leuD',
  '3-isopropylmalate dehydratase small subunit',
  1047673,
  1048275,
  1,
  'HI_RS05235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693332.1',
  'IgA-specific serine endopeptidaseautotransporter IgaA1',
  1048389,
  1053473,
  -1,
  'HI_RS05240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recF',
  'DNA replication/repair protein RecF',
  1053715,
  1054794,
  -1,
  'HI_RS05245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dnaN',
  'DNA polymerase III subunit beta',
  1054796,
  1055896,
  -1,
  'HI_RS05250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dnaA',
  'chromosomal replication initiator protein DnaA',
  1055909,
  1057273,
  -1,
  'HI_RS05255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693337.1',
  'transferrin-binding protein Tbp1',
  1057465,
  1060203,
  -1,
  'HI_RS05260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693338.1',
  'transferrin-binding protein Tbp2',
  1060231,
  1062108,
  -1,
  'HI_RS05265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DUF560 domain-containing protein',
  1062206,
  1063651,
  1,
  'HI_RS05270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpmH',
  '50S ribosomal protein L34',
  1063832,
  1063966,
  1,
  'HI_RS05275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rnpA',
  'ribonuclease P protein component',
  1063986,
  1064345,
  1,
  'HI_RS05280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yidD',
  'membrane protein insertion efficiency factorYidD',
  1064309,
  1064569,
  1,
  'HI_RS05285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yidC',
  'membrane protein insertase YidC',
  1064569,
  1066194,
  1,
  'HI_RS05290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mnmE',
  'tRNA uridine-5-carboxymethylaminomethyl(34)synthesis GTPase MnmE',
  1066352,
  1067710,
  1,
  'HI_RS05295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'peptidyl-prolyl cis-trans isomerase',
  1067898,
  1069767,
  1,
  'HI_RS05300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693345.1',
  'phosphoethanolamine transferase',
  1069855,
  1071414,
  1,
  'HI_RS05305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lspA',
  'signal peptidase II',
  1071484,
  1071999,
  1,
  'HI_RS05310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ispH',
  '4-hydroxy-3-methylbut-2-enyl diphosphatereductase',
  1071996,
  1072940,
  1,
  'HI_RS05315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869106.1',
  'helix-hairpin-helix domain-containing protein',
  1073118,
  1073456,
  1,
  'HI_RS05320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_015702000.1',
  'DeoR/GlpR family DNA-binding transcriptionregulator',
  1073504,
  1074262,
  -1,
  'HI_RS05325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005665973.1',
  'L-threonate dehydrogenase',
  1074433,
  1075338,
  1,
  'HI_RS05330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693348.1',
  '3-oxo-tetronate kinase',
  1075341,
  1076582,
  1,
  'HI_RS05335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647883.1',
  '3-oxo-tetronate 4-phosphate decarboxylase',
  1076579,
  1077211,
  1,
  'HI_RS05340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693349.1',
  '2-oxo-tetronate isomerase',
  1077214,
  1077990,
  1,
  'HI_RS05345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693350.1',
  'D-erythronate dehydrogenase',
  1078046,
  1078993,
  1,
  'HI_RS05350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693351.1',
  'GntP family permease',
  1079002,
  1080468,
  1,
  'HI_RS05355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'cyclase family protein',
  1080488,
  1081026,
  1,
  'HI_RS05360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828337.1',
  'MIP/aquaporin family protein',
  1081232,
  1081795,
  1,
  'HI_RS05365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'IS1595 family transposase',
  1081864,
  1082514,
  -1,
  'HI_RS05370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'thiB',
  'thiamine ABC transporter substrate bindingsubunit',
  1082773,
  1083771,
  1,
  'HI_RS05375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'thiP',
  'thiamine/thiamine pyrophosphate ABC transporterpermease',
  1083776,
  1085392,
  1,
  'HI_RS05380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'thiQ',
  'thiamine ABC transporter ATP-binding protein',
  1085376,
  1086023,
  1,
  'HI_RS05385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'bioB',
  'biotin synthase BioB',
  1086136,
  1087137,
  1,
  'HI_RS05390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tkt',
  'transketolase',
  1087262,
  1089259,
  -1,
  'HI_RS05395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693359.1',
  '3-keto-L-gulonate-6-phosphate decarboxylaseUlaD',
  1089388,
  1090065,
  -1,
  'HI_RS05400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'araD',
  'L-ribulose-5-phosphate 4-epimerase',
  1090115,
  1090810,
  -1,
  'HI_RS05405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693360.1',
  'L-ribulose-5-phosphate 3-epimerase',
  1090804,
  1091664,
  -1,
  'HI_RS05410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869108.1',
  'FGGY-family carbohydrate kinase',
  1091678,
  1093135,
  -1,
  'HI_RS05415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647844.1',
  'TRAP transporter substrate-binding protein',
  1093194,
  1094180,
  -1,
  'HI_RS05420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647842.1',
  'TRAP transporter large permease subunit',
  1094211,
  1095488,
  -1,
  'HI_RS05425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647840.1',
  'TRAP transporter small permease',
  1095485,
  1095967,
  -1,
  'HI_RS05430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yiaK',
  '3-dehydro-L-gulonate 2-dehydrogenase',
  1096042,
  1097040,
  -1,
  'HI_RS05435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647833.1',
  'IclR family transcriptional regulator',
  1097234,
  1098022,
  1,
  'HI_RS05440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'serB',
  'phosphoserine phosphatase',
  1098172,
  1099116,
  1,
  'HI_RS05445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005651674.1',
  'YajQ family cyclic di-GMP-binding protein',
  1099134,
  1099625,
  1,
  'HI_RS05450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'corA',
  'magnesium/cobalt transporter CorA',
  1099920,
  1100867,
  1,
  'HI_RS05455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869110.1',
  'YggT family protein',
  1100867,
  1101412,
  1,
  'HI_RS05460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927861.1',
  'class II glutamine amidotransferase',
  1101593,
  1102429,
  -1,
  'HI_RS05465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693372.1',
  'ATP-binding protein',
  1102856,
  1104058,
  1,
  'HI_RS05470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869112.1',
  'HindVP family restriction endonuclease',
  1104411,
  1105415,
  1,
  'HI_RS05475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869113.1',
  'DNA cytosine methyltransferase',
  1105412,
  1106326,
  1,
  'HI_RS05480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_080003770.1',
  'vitamin B12 dependent-methionine synthaseactivation domain-containing protein',
  1106472,
  1107911,
  -1,
  'HI_RS05485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828348.1',
  'B12-binding domain-containing protein',
  1107905,
  1108153,
  -1,
  'HI_RS05490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'napF',
  'ferredoxin-type protein NapF',
  1108431,
  1108931,
  -1,
  'HI_RS05495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dmsD',
  'Tat proofreading chaperone DmsD',
  1108931,
  1109542,
  -1,
  'HI_RS05500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693381.1',
  'dimethyl sulfoxide reductase anchor subunitfamily protein',
  1109654,
  1110493,
  -1,
  'HI_RS05505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dmsB',
  'DMSO/selenate family reductase complex Bsubunit',
  1110495,
  1111112,
  -1,
  'HI_RS05510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693382.1',
  'DMSO/selenate family reductase complex Asubunit',
  1111123,
  1113543,
  -1,
  'HI_RS05515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869115.1',
  'transglutaminase-like domain-containing protein',
  1113797,
  1114906,
  1,
  'HI_RS05520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869116.1',
  'membrane protein',
  1114948,
  1115241,
  1,
  'HI_RS05525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005662887.1',
  'heavy-metal-associated domain-containingprotein',
  1115250,
  1115528,
  1,
  'HI_RS05530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005686318.1',
  'ABC transporter ATP-binding protein',
  1115653,
  1117497,
  -1,
  'HI_RS05535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005665936.1',
  'cupin domain-containing protein',
  1117575,
  1118471,
  -1,
  'HI_RS05540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005651693.1',
  'carboxymuconolactone decarboxylase familyprotein',
  1118583,
  1118924,
  1,
  'HI_RS05545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DEAD/DEAH box helicase family protein',
  1119024,
  1121811,
  -1,
  'HI_RS05550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'site-specific DNA-methyltransferase',
  1121801,
  1122385,
  -1,
  'HI_RS05555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869120.1',
  'site-specific DNA-methyltransferase',
  1123464,
  1124048,
  -1,
  'HI_RS05560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rnhB',
  'ribonuclease HII',
  1124264,
  1124857,
  -1,
  'HI_RS05565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lpxB',
  'lipid-A-disaccharide synthase',
  1124850,
  1126022,
  -1,
  'HI_RS05570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lpxA',
  'acyl-ACP--UDP-N-acetylglucosamineO-acyltransferase',
  1126089,
  1126877,
  -1,
  'HI_RS05575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fabZ',
  '3-hydroxyacyl-ACP dehydratase FabZ',
  1126891,
  1127295,
  -1,
  'HI_RS05580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'phosphoethanolamine transferase',
  1127423,
  1129038,
  -1,
  'HI_RS05585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pyrH',
  'UMP kinase',
  1129110,
  1129823,
  1,
  'HI_RS05590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nrfD',
  'cytochrome c nitrite reductase subunit NrfD',
  1130062,
  1131027,
  -1,
  'HI_RS05595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nrfC',
  'cytochrome c nitrite reductase Fe-S protein',
  1131024,
  1131701,
  -1,
  'HI_RS05600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nrfB',
  'cytochrome c nitrite reductase pentahemesubunit',
  1131698,
  1132345,
  -1,
  'HI_RS05605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nrfA',
  'ammonia-forming nitrite reductase cytochromec552 subunit',
  1132422,
  1133948,
  -1,
  'HI_RS05610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hrpA',
  'ATP-dependent RNA helicase HrpA',
  1134200,
  1138114,
  -1,
  'HI_RS05615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693396.1',
  'DUF423 domain-containing protein',
  1138111,
  1138485,
  -1,
  'HI_RS05620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693397.1',
  'DUF441 domain-containing protein',
  1138486,
  1138938,
  -1,
  'HI_RS05625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cydB',
  'cytochrome d ubiquinol oxidase subunit II',
  1139203,
  1140339,
  -1,
  'HI_RS05630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869127.1',
  'cytochrome ubiquinol oxidase subunit I',
  1140354,
  1141919,
  -1,
  'HI_RS05635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pyrG',
  'glutamine hydrolyzing CTP synthase',
  1142571,
  1144208,
  1,
  'HI_RS05640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'nicotinamide riboside transporter PnuC',
  1144353,
  1145035,
  -1,
  'HI_RS05645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869128.1',
  'amino acid ABC transporter ATP-binding protein',
  1145211,
  1145978,
  -1,
  'HI_RS05650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693404.1',
  'amino acid ABC transporter permease',
  1145988,
  1146704,
  -1,
  'HI_RS05655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005662813.1',
  'amino acid ABC transporter substrate-bindingprotein',
  1146688,
  1147461,
  -1,
  'HI_RS05660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'murA',
  'UDP-N-acetylglucosamine1-carboxyvinyltransferase',
  1147762,
  1149036,
  -1,
  'HI_RS05665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005686372.1',
  'BolA family protein',
  1149047,
  1149304,
  -1,
  'HI_RS05670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693407.1',
  'STAS domain-containing protein',
  1149325,
  1149642,
  -1,
  'HI_RS05675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mlaC',
  'phospholipid-binding protein MlaC',
  1149653,
  1150297,
  -1,
  'HI_RS05680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mlaD',
  'outer membrane lipid asymmetry maintenanceprotein MlaD',
  1150327,
  1150830,
  -1,
  'HI_RS05685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mlaE',
  'lipid asymmetry maintenance ABC transporterpermease subunit MlaE',
  1150841,
  1151626,
  -1,
  'HI_RS05690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mlaF',
  'phospholipid ABC transporter ATP-binding proteinMlaF',
  1151623,
  1152417,
  -1,
  'HI_RS05695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sodA',
  'superoxide dismutase [Mn]',
  1152847,
  1153494,
  -1,
  'HI_RS05700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ccmA',
  'cytochrome c biogenesis heme-transporting ATPaseCcmA',
  1153743,
  1154381,
  1,
  'HI_RS05705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ccmB',
  'heme exporter protein CcmB',
  1154386,
  1155051,
  1,
  'HI_RS05710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693415.1',
  'heme ABC transporter permease',
  1155109,
  1155849,
  1,
  'HI_RS05715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ccmD',
  'heme exporter protein CcmD',
  1155891,
  1156094,
  1,
  'HI_RS05720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ccmE',
  'cytochrome c maturation protein CcmE',
  1156091,
  1156612,
  1,
  'HI_RS05725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693418.1',
  'heme lyase CcmF/NrfE family subunit',
  1156609,
  1158555,
  1,
  'HI_RS05730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005657352.1',
  'DsbE family thiol:disulfide interchange protein',
  1158694,
  1159239,
  1,
  'HI_RS05735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005686388.1',
  'cytochrome c-type biogenesis protein',
  1159239,
  1159700,
  1,
  'HI_RS05740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ccmI',
  'c-type cytochrome biogenesis protein CcmI',
  1159701,
  1160618,
  1,
  'HI_RS05745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927875.1',
  'DUF8095 domain-containing protein',
  1161040,
  1161237,
  1,
  'HI_RS05750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647674.1',
  'hypothetical protein',
  1161248,
  1161547,
  1,
  'HI_RS05755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ligA',
  'NAD-dependent DNA ligase LigA',
  1161552,
  1163564,
  -1,
  'HI_RS05760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'zipA',
  'cell division protein ZipA',
  1163676,
  1164662,
  -1,
  'HI_RS05765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cysZ',
  'sulfate transporter CysZ',
  1164815,
  1165633,
  1,
  'HI_RS05770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cysK',
  'cysteine synthase A',
  1165732,
  1166682,
  1,
  'HI_RS05775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'IS1595 family transposase',
  1166915,
  1167023,
  -1,
  'HI_RS08980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693428.1',
  'MFS transporter',
  1167406,
  1168629,
  1,
  'HI_RS05785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'waaF',
  'lipopolysaccharide heptosyltransferase II',
  1168738,
  1169778,
  -1,
  'HI_RS05790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869130.1',
  'XylR family transcriptional regulator',
  1169854,
  1171017,
  -1,
  'HI_RS05795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nhaC',
  'Na+/H+ antiporter NhaC',
  1171129,
  1172535,
  -1,
  'HI_RS05800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'pyridoxal phosphate-dependent aminotransferase',
  1172537,
  1173709,
  -1,
  'HI_RS05805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869132.1',
  'sugar ABC transporter permease',
  1173984,
  1175111,
  -1,
  'HI_RS05810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'xylG',
  'D-xylose ABC transporter ATP-binding protein',
  1175115,
  1176626,
  -1,
  'HI_RS05815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'xylF',
  'D-xylose ABC transporter substrate-bindingprotein',
  1176677,
  1177675,
  -1,
  'HI_RS05820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'xylA',
  'xylose isomerase',
  1177909,
  1179228,
  1,
  'HI_RS05825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'xylB',
  'xylulokinase',
  1179285,
  1180766,
  1,
  'HI_RS05830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rfaD',
  'ADP-glyceromanno-heptose 6-epimerase',
  1180817,
  1181743,
  -1,
  'HI_RS05835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693438.1',
  'protein disulfide oxidoreductase',
  1181796,
  1182299,
  -1,
  'HI_RS05840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693439.1',
  'deoxyribose-phosphate aldolase',
  1182410,
  1183081,
  1,
  'HI_RS05845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869133.1',
  'YifB family Mg chelatase-like AAA ATPase',
  1183115,
  1184644,
  -1,
  'HI_RS05850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005651790.1',
  'ribosome biogenesis GTP-binding proteinYihA/YsxC',
  1184759,
  1185376,
  -1,
  'HI_RS05855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005651791.1',
  'VirK/YbjX family protein',
  1185481,
  1186347,
  1,
  'HI_RS05860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'oppF',
  'murein tripeptide/oligopeptide ABC transporterATP binding protein OppF',
  1186387,
  1187385,
  -1,
  'HI_RS05865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005651797.1',
  'ABC transporter ATP-binding protein',
  1187382,
  1188353,
  -1,
  'HI_RS05870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'oppC',
  'oligopeptide ABC transporter permease OppC',
  1188363,
  1189298,
  -1,
  'HI_RS05875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'oppB',
  'oligopeptide ABC transporter permease OppB',
  1189308,
  1190228,
  -1,
  'HI_RS05880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869134.1',
  'ABC transporter substrate-binding protein',
  1190309,
  1191934,
  -1,
  'HI_RS05885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tal',
  'transaldolase',
  1192230,
  1193183,
  1,
  'HI_RS05890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005663910.1',
  'zinc ribbon domain-containing protein',
  1193834,
  1194064,
  -1,
  'HI_RS05895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'carbon starvation protein A',
  1194261,
  1195848,
  1,
  'HI_RS05900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mraZ',
  'division/cell wall cluster transcriptionalrepressor MraZ',
  1196050,
  1196505,
  1,
  'HI_RS05905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsmH',
  '16S rRNA (cytosine(1402)-N(4))-methyltransferaseRsmH',
  1196536,
  1197501,
  1,
  'HI_RS05910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftsL',
  'cell division protein FtsL',
  1197504,
  1197827,
  1,
  'HI_RS05915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693446.1',
  'peptidoglycan synthase FtsI',
  1197840,
  1199672,
  1,
  'HI_RS05920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'murE',
  'UDP-N-acetylmuramoyl-L-alanyl-D-glutamate--2,6-diaminopimelate ligase',
  1199682,
  1201148,
  1,
  'HI_RS05925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'murF',
  'UDP-N-acetylmuramoyl-tripeptide--D-alanyl-D-alanine ligase',
  1201162,
  1202535,
  1,
  'HI_RS05930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mraY',
  'phospho-N-acetylmuramoyl-pentapeptide-transferase',
  1202529,
  1203611,
  1,
  'HI_RS05935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'murD',
  'UDP-N-acetylmuramoyl-L-alanine--D-glutamateligase',
  1203734,
  1205047,
  1,
  'HI_RS05940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftsW',
  'putative lipid II flippase FtsW',
  1205069,
  1206253,
  1,
  'HI_RS05945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'murG',
  'undecaprenyldiphospho-muramoylpentapeptidebeta-N-acetylglucosaminyltransferase',
  1206265,
  1207320,
  1,
  'HI_RS05950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'murC',
  'UDP-N-acetylmuramate--L-alanine ligase',
  1207458,
  1208885,
  1,
  'HI_RS05955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693454.1',
  'D-alanine--D-alanine ligase',
  1208957,
  1209877,
  1,
  'HI_RS05960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693455.1',
  'cell division protein FtsQ/DivIB',
  1209877,
  1210641,
  1,
  'HI_RS05965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftsA',
  'cell division protein FtsA',
  1210660,
  1211937,
  1,
  'HI_RS05970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftsZ',
  'cell division protein FtsZ',
  1212021,
  1213286,
  1,
  'HI_RS05975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lpxC',
  'UDP-3-O-acyl-N-acetylglucosamine deacetylase',
  1213325,
  1214242,
  1,
  'HI_RS05980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pheA',
  'prephenate dehydratase',
  1214369,
  1215526,
  1,
  'HI_RS05985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rapZ',
  'RNase adapter RapZ',
  1215571,
  1216428,
  -1,
  'HI_RS05990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ptsN',
  'PTS IIA-like nitrogen regulatory protein PtsN',
  1216446,
  1216940,
  -1,
  'HI_RS05995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS05995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lptB',
  'LPS export ABC transporter ATP-binding protein',
  1216943,
  1217668,
  -1,
  'HI_RS06000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lptA',
  'lipopolysaccharide transport periplasmic proteinLptA',
  1217672,
  1218190,
  -1,
  'HI_RS06005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lptC',
  'LPS export ABC transporter periplasmic proteinLptC',
  1218171,
  1218785,
  -1,
  'HI_RS06010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005651852.1',
  'ribosome biogenesis factor YjgA',
  1218836,
  1219372,
  -1,
  'HI_RS06015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pmbA',
  'metalloprotease PmbA',
  1219461,
  1220816,
  1,
  'HI_RS06020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hpt',
  'hypoxanthine phosphoribosyltransferase',
  1221027,
  1221566,
  1,
  'HI_RS06025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005651858.1',
  'hypothetical protein',
  1221568,
  1221777,
  1,
  'HI_RS06030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693469.1',
  'L-cystine transporter',
  1221872,
  1223194,
  1,
  'HI_RS06035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nrdG',
  'anaerobic ribonucleoside-triphosphatereductase-activating protein',
  1223294,
  1223761,
  -1,
  'HI_RS06040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ffs',
  '—',
  1223890,
  1223988,
  1,
  'HI_RS06045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cydC',
  'heme ABC transporter ATP-bindingprotein/permease CydC',
  1224009,
  1225739,
  -1,
  'HI_RS06050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cydD',
  'heme ABC transporter permease/ATP-bindingprotein CydD',
  1225739,
  1227499,
  -1,
  'HI_RS06055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trxB',
  'thioredoxin-disulfide reductase',
  1227571,
  1228527,
  -1,
  'HI_RS06060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'co-chaperone YbbN',
  1228601,
  1229459,
  -1,
  'HI_RS06065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hemH',
  'ferrochelatase',
  1229539,
  1230510,
  -1,
  'HI_RS06070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693476.1',
  'hotdog fold thioesterase',
  1230507,
  1230923,
  -1,
  'HI_RS06075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DUF559 domain-containing protein',
  1231406,
  1231785,
  -1,
  'HI_RS06080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694279.1',
  'D-2-hydroxyglutarate dehydrogenase YdiJ',
  1231849,
  1234932,
  -1,
  'HI_RS06085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ompA',
  'porin OmpA',
  1235301,
  1236362,
  1,
  'HI_RS06090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'grxD',
  'Grx4 family monothiol glutaredoxin',
  1236513,
  1236836,
  1,
  'HI_RS06095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694274.1',
  'histidinol-phosphate transaminase',
  1236913,
  1238013,
  -1,
  'HI_RS06100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'serC',
  '3-phosphoserine/phosphohydroxythreoninetransaminase',
  1238101,
  1239189,
  -1,
  'HI_RS06105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005653635.1',
  'DUF496 family protein',
  1239380,
  1239724,
  1,
  'HI_RS06110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694272.1',
  'aminotransferase class IV family protein',
  1239765,
  1240331,
  -1,
  'HI_RS06115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694271.1',
  'aminodeoxychorismate synthase component I',
  1240331,
  1241317,
  -1,
  'HI_RS06120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694270.1',
  'anthranilate synthase component II',
  1241359,
  1241940,
  1,
  'HI_RS06125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'metK',
  'methionine adenosyltransferase',
  1242025,
  1243179,
  1,
  'HI_RS06130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869145.1',
  'SprT family zinc-dependent metalloprotease',
  1243518,
  1243988,
  1,
  'HI_RS06135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'outer membrane beta-barrel protein',
  1244039,
  1244552,
  1,
  'HI_RS06140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'hypothetical protein',
  1244650,
  1244962,
  -1,
  'HI_RS06145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'artM',
  'arginine ABC transporter permease ArtM',
  1245169,
  1245852,
  -1,
  'HI_RS06150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'artQ',
  'arginine ABC transporter permease ArtQ',
  1245852,
  1246517,
  -1,
  'HI_RS06155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694262.1',
  'lysine/arginine/ornithine ABC transportersubstrate-binding protein',
  1246521,
  1247240,
  -1,
  'HI_RS06160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'artP',
  'arginine ABC transporter ATP-binding proteinArtP',
  1247258,
  1247989,
  -1,
  'HI_RS06165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lpcA',
  'D-sedoheptulose 7-phosphate isomerase',
  1248116,
  1248700,
  -1,
  'HI_RS06170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DNA ligase',
  1248907,
  1249712,
  1,
  'HI_RS06175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005691143.1',
  'peptide ABC transporter ATP-binding protein',
  1249741,
  1250724,
  -1,
  'HI_RS06180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dppD',
  'dipeptide ABC transporter ATP-binding protein',
  1250727,
  1251719,
  -1,
  'HI_RS06185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005653671.1',
  'ABC transporter permease subunit',
  1251729,
  1252616,
  -1,
  'HI_RS06190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927863.1',
  'ABC transporter permease subunit',
  1252631,
  1253632,
  -1,
  'HI_RS06195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'uvrD',
  'DNA helicase II',
  1253722,
  1255902,
  -1,
  'HI_RS06200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005686506.1',
  '7-carboxy-7-deazaguanine synthase QueE',
  1256516,
  1257151,
  -1,
  'HI_RS06205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'queD',
  '6-carboxytetrahydropterin synthase QueD',
  1257152,
  1257577,
  -1,
  'HI_RS06210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'queC',
  '7-cyano-7-deazaguanine synthase QueC',
  1257570,
  1258257,
  -1,
  'HI_RS06215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005634891.1',
  'hypothetical protein',
  1258413,
  1258556,
  1,
  'HI_RS08985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ilvE',
  'branched-chain-amino-acid transaminase',
  1258603,
  1259634,
  -1,
  'HI_RS06220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869150.1',
  'transcriptional regulator GcvA',
  1260108,
  1261001,
  1,
  'HI_RS06225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rlmM',
  '23S rRNA (cytidine(2498)-2''-O)-methyltransferaseRlmM',
  1260994,
  1262085,
  1,
  'HI_RS06230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sucC',
  'ADP-forming succinate--CoA ligase subunit beta',
  1262121,
  1263290,
  1,
  'HI_RS06235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sucD',
  'succinate--CoA ligase subunit alpha',
  1263290,
  1264171,
  1,
  'HI_RS06240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005667400.1',
  'L-threonylcarbamoyladenylate synthase',
  1264292,
  1264915,
  1,
  'HI_RS06245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rluB',
  '23S rRNA pseudouridine(2605) synthase RluB',
  1264963,
  1266036,
  1,
  'HI_RS06250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cysB',
  'HTH-type transcriptional regulator CysB',
  1266047,
  1267018,
  1,
  'HI_RS06255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'prmB',
  '50S ribosomal protein L3 N(5)-glutaminemethyltransferase',
  1267077,
  1268021,
  -1,
  'HI_RS06260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'smrB',
  'endonuclease SmrB',
  1268153,
  1268656,
  1,
  'HI_RS06265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pta',
  'phosphate acetyltransferase',
  1268731,
  1270866,
  -1,
  'HI_RS06270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694241.1',
  'acetate kinase',
  1270934,
  1272139,
  -1,
  'HI_RS06275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694240.1',
  'terminus macrodomain insulation protein YfbV',
  1272354,
  1272797,
  1,
  'HI_RS06280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694239.1',
  'CvpA family protein',
  1272884,
  1273375,
  1,
  'HI_RS06285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purF',
  'amidophosphoribosyltransferase',
  1273386,
  1274903,
  1,
  'HI_RS06290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694236.1',
  'TIGR01777 family oxidoreductase',
  1274958,
  1275848,
  -1,
  'HI_RS06295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'argR',
  'transcriptional regulator ArgR',
  1275848,
  1276303,
  -1,
  'HI_RS06300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mdh',
  'malate dehydrogenase',
  1276510,
  1277445,
  1,
  'HI_RS06305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lysS',
  'lysine--tRNA ligase',
  1277530,
  1279038,
  -1,
  'HI_RS06310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'prfB',
  'peptide chain release factor 2',
  1279189,
  1280287,
  -1,
  'HI_RS06315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dsbC',
  'bifunctional protein-disulfideisomerase/oxidoreductase DsbC',
  1280420,
  1281109,
  1,
  'HI_RS06320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recJ',
  'single-stranded-DNA-specific exonuclease RecJ',
  1281398,
  1283125,
  1,
  'HI_RS06325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694231.1',
  'thiol:disulfide interchange protein DsbA/DsbL',
  1283118,
  1283825,
  1,
  'HI_RS06330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694230.1',
  '5''-methylthioadenosine/adenosylhomocysteinenucleosidase',
  1283822,
  1284511,
  1,
  'HI_RS06335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694229.1',
  'TonB-dependent receptor domain-containingprotein',
  1284588,
  1287329,
  -1,
  'HI_RS06340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_165442163.1',
  'lactate permease LctP family transporter',
  1287584,
  1289179,
  -1,
  'HI_RS06345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cmk',
  '(d)CMP kinase',
  1289456,
  1290157,
  1,
  'HI_RS06350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsA',
  '30S ribosomal protein S1',
  1290233,
  1291882,
  1,
  'HI_RS06355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694284.1',
  'integration host factor subunit beta',
  1292005,
  1292289,
  1,
  'HI_RS06360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005650128.1',
  'LapA family protein',
  1292364,
  1292657,
  1,
  'HI_RS06365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lapB',
  'lipopolysaccharide assembly protein LapB',
  1292657,
  1293847,
  1,
  'HI_RS06370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pyrF',
  'orotidine-5''-phosphate decarboxylase',
  1293871,
  1294563,
  1,
  'HI_RS06375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yciH',
  'stress response translation initiation inhibitorYciH',
  1294570,
  1294890,
  1,
  'HI_RS06380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694288.1',
  'DnaA regulatory inactivator Hda',
  1294919,
  1295614,
  -1,
  'HI_RS06385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694289.1',
  'nucleobase:cation symporter-2 family protein',
  1295680,
  1296924,
  -1,
  'HI_RS06390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'upp',
  'uracil phosphoribosyltransferase',
  1297029,
  1297655,
  -1,
  'HI_RS06395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dnaX',
  'DNA polymerase III subunit gamma/tau',
  1297779,
  1299845,
  -1,
  'HI_RS06400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'apt',
  'adenine phosphoribosyltransferase',
  1299857,
  1300399,
  -1,
  'HI_RS06405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lpdA',
  'dihydrolipoyl dehydrogenase',
  1300547,
  1301983,
  -1,
  'HI_RS06410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aceF',
  'pyruvate dehydrogenase complexdihydrolipoyllysine-residue acetyltransferase',
  1302097,
  1303800,
  -1,
  'HI_RS06415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aceE',
  'pyruvate dehydrogenase (acetyl-transferring),homodimeric type',
  1303863,
  1306523,
  -1,
  'HI_RS06420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mgsA',
  'methylglyoxal synthase',
  1306823,
  1307281,
  1,
  'HI_RS06425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DUF945 family protein',
  1307437,
  1308878,
  -1,
  'HI_RS06430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dnaK',
  'molecular chaperone DnaK',
  1309144,
  1311051,
  1,
  'HI_RS06435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dnaJ',
  'molecular chaperone DnaJ',
  1311138,
  1312286,
  1,
  'HI_RS06440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'proA',
  'glutamate-5-semialdehyde dehydrogenase',
  1312365,
  1313618,
  -1,
  'HI_RS06445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694300.1',
  'trimeric intracellular cation channel familyprotein',
  1313639,
  1314301,
  -1,
  'HI_RS06450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694301.1',
  'hypothetical protein',
  1314399,
  1315199,
  1,
  'HI_RS06455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694302.1',
  'Bcr/CflA family multidrug efflux MFStransporter',
  1315231,
  1316427,
  -1,
  'HI_RS06460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsuA',
  '16S rRNA pseudouridine(516) synthase RsuA',
  1316429,
  1317127,
  -1,
  'HI_RS06465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694305.1',
  'DUF1919 domain-containing protein',
  1317218,
  1317838,
  -1,
  'HI_RS06470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694306.1',
  'NADP-dependent malic enzyme',
  1318036,
  1320306,
  1,
  'HI_RS06475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828439.1',
  'LTA synthase family protein',
  1320534,
  1322459,
  1,
  'HI_RS06480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'uvrB',
  'excinuclease ABC subunit UvrB',
  1322490,
  1324529,
  -1,
  'HI_RS06485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1324965,
  1325040,
  1,
  'HI_RS06490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'zevB',
  'zinc transporter permease subunit ZevB',
  1325143,
  1326111,
  -1,
  'HI_RS06495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'zevA',
  'zinc transporter binding subunit ZevA',
  1326114,
  1326734,
  -1,
  'HI_RS06500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694311.1',
  'type II toxin-antitoxin system RelE/ParE familytoxin',
  1327059,
  1327364,
  1,
  'HI_RS06505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005650217.1',
  'HigA family addiction module antitoxin',
  1327375,
  1327698,
  1,
  'HI_RS06510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ettA',
  'energy-dependent translational throttle proteinEttA',
  1327861,
  1329531,
  1,
  'HI_RS06515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005666735.1',
  'SirB2 family protein',
  1329593,
  1329934,
  1,
  'HI_RS06520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'tRNA(Met) cytidine acetyltransferase',
  1329939,
  1331908,
  1,
  'HI_RS06525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005652999.1',
  'DUF5363 family protein',
  1331905,
  1332078,
  1,
  'HI_RS06530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mfd',
  'transcription-repair coupling factor',
  1332180,
  1335620,
  1,
  'HI_RS06535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694316.1',
  'DegQ family serine endoprotease',
  1335673,
  1337073,
  -1,
  'HI_RS06540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'accD',
  'acetyl-CoA carboxylase, carboxyltransferasesubunit beta',
  1337267,
  1338157,
  1,
  'HI_RS06545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'folC',
  'bifunctional tetrahydrofolatesynthase/dihydrofolate synthase',
  1338159,
  1339463,
  1,
  'HI_RS06550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869167.1',
  'SanA/YdcF family protein',
  1339751,
  1340431,
  -1,
  'HI_RS06555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694320.1',
  'homoserine O-acetyltransferase MetX',
  1340589,
  1341665,
  1,
  'HI_RS06560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gyrA',
  'DNA topoisomerase (ATP-hydrolyzing) subunit A',
  1341719,
  1344361,
  -1,
  'HI_RS06565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869168.1',
  '30S ribosomal protein S12 methylthiotransferaseaccessory factor YcaO',
  1344944,
  1346707,
  -1,
  'HI_RS06570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694510.1',
  'hypothetical protein',
  1346844,
  1347230,
  -1,
  'HI_RS06575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'ABC transporter substrate-binding protein',
  1347179,
  1347744,
  1,
  'HI_RS06580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'iron ABC transporter permease',
  1347741,
  1348478,
  1,
  'HI_RS06585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828469.1',
  'ATP-binding cassette domain-containing protein',
  1348492,
  1349259,
  1,
  'HI_RS06590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694515.1',
  'methyltransferase domain-containing protein',
  1349256,
  1350062,
  1,
  'HI_RS06595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gloB',
  'hydroxyacylglutathione hydrolase',
  1350114,
  1350830,
  1,
  'HI_RS06600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tehB',
  'SAM-dependent methyltransferase TehB',
  1350886,
  1351746,
  -1,
  'HI_RS06605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'metG',
  'methionine--tRNA ligase',
  1351859,
  1353907,
  -1,
  'HI_RS06610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'apbC',
  'iron-sulfur cluster carrier protein ApbC',
  1354058,
  1355170,
  1,
  'HI_RS06615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694521.1',
  'NAD(P)H-dependent oxidoreductase',
  1355217,
  1355879,
  -1,
  'HI_RS06620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828466.1',
  '5-acetyl neuraminic acid cytidyl-transferase',
  1355996,
  1356670,
  1,
  'HI_RS06625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'IS3 family transposase',
  1356742,
  1357482,
  1,
  'HI_RS06630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ssrA',
  '—',
  1357564,
  1357929,
  -1,
  'HI_RS06635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1358358,
  1358434,
  1,
  'HI_RS06640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rimP',
  'ribosome maturation factor RimP',
  1358656,
  1359111,
  1,
  'HI_RS06645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nusA',
  'transcription termination factor NusA',
  1359128,
  1360615,
  1,
  'HI_RS06650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'infB',
  'translation initiation factor IF-2',
  1360627,
  1363116,
  1,
  'HI_RS06655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694526.1',
  'type I restriction endonuclease subunit R',
  1363195,
  1366362,
  -1,
  'HI_RS06660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694527.1',
  'restriction endonuclease subunit S',
  1366454,
  1367833,
  -1,
  'HI_RS06665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869173.1',
  'N-6 DNA methylase',
  1367826,
  1369556,
  -1,
  'HI_RS06670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rbfA',
  '30S ribosome-binding factor RbfA',
  1369672,
  1370058,
  1,
  'HI_RS06675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'truB',
  'tRNA pseudouridine(55) synthase TruB',
  1370058,
  1370996,
  1,
  'HI_RS06680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tyrA',
  'bifunctional chorismate mutase/prephenatedehydrogenase',
  1371065,
  1372189,
  1,
  'HI_RS06685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'queF',
  'NADPH-dependent 7-cyano-7-deazaguanine reductaseQueF',
  1372222,
  1373061,
  -1,
  'HI_RS06690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694477.1',
  'Zn-ribbon-containing protein',
  1373188,
  1373973,
  -1,
  'HI_RS06695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694476.1',
  'SufE family protein',
  1373964,
  1374344,
  -1,
  'HI_RS06700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869175.1',
  'aminotransferase class V-fold PLP-dependentenzyme',
  1374341,
  1375534,
  -1,
  'HI_RS06705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927865.1',
  'thermonuclease family protein',
  1375488,
  1376024,
  -1,
  'HI_RS06710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694471.1',
  'CidA/LrgA family protein',
  1376139,
  1376561,
  1,
  'HI_RS06715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694470.1',
  'CidB/LrgB family autolysis modulator',
  1376580,
  1377275,
  1,
  'HI_RS06720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'deoxyguanosinetriphosphate triphosphohydrolasefamily protein',
  1377398,
  1378752,
  1,
  'HI_RS06725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694468.1',
  'ABC transporter ATP-binding protein',
  1378846,
  1380789,
  1,
  'HI_RS06730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'can',
  'carbonate dehydratase',
  1380817,
  1381506,
  -1,
  'HI_RS06735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'asnS',
  'asparagine--tRNA ligase',
  1381582,
  1382985,
  -1,
  'HI_RS06740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ribE',
  '6,7-dimethyl-8-ribityllumazine synthase',
  1383211,
  1383684,
  1,
  'HI_RS06745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nusB',
  'transcription antitermination factor NusB',
  1383688,
  1384122,
  1,
  'HI_RS06750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'thiL',
  'thiamine-phosphate kinase',
  1384190,
  1385176,
  1,
  'HI_RS06755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694464.1',
  'phosphatidylglycerophosphatase A family protein',
  1385173,
  1385664,
  1,
  'HI_RS06760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_011962151.1',
  'LysE family transporter',
  1385664,
  1386293,
  1,
  'HI_RS06765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dapB',
  '4-hydroxy-tetrahydrodipicolinate reductase',
  1386310,
  1387122,
  1,
  'HI_RS06770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005650353.1',
  'class I ribonucleotide reductase maintenanceprotein YfaE',
  1387117,
  1387365,
  -1,
  'HI_RS06775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828459.1',
  'hypothetical protein',
  1387411,
  1388151,
  1,
  'HI_RS06780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pheS',
  'phenylalanine--tRNA ligase subunit alpha',
  1388300,
  1389289,
  1,
  'HI_RS06785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pheT',
  'phenylalanine--tRNA ligase subunit beta',
  1389323,
  1391710,
  1,
  'HI_RS06790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005652847.1',
  'integration host factor subunit alpha',
  1391712,
  1392002,
  1,
  'HI_RS06795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869179.1',
  'NlpC/P60 family protein',
  1392055,
  1392540,
  1,
  'HI_RS06800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694455.1',
  'SLC5 family protein',
  1392706,
  1393023,
  1,
  'HI_RS06805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694454.1',
  'sulfatase/phosphatase domain-containing protein',
  1393010,
  1393996,
  1,
  'HI_RS06810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_165442164.1',
  'D-hexose-6-phosphate mutarotase',
  1394066,
  1394893,
  1,
  'HI_RS06815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'infC',
  'translation initiation factor IF-3',
  1395026,
  1395568,
  1,
  'HI_RS06820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpmI',
  '50S ribosomal protein L35',
  1395779,
  1395976,
  1,
  'HI_RS06825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplT',
  '50S ribosomal protein L20',
  1396043,
  1396396,
  1,
  'HI_RS06830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recB',
  'exodeoxyribonuclease V subunit beta',
  1396509,
  1400144,
  1,
  'HI_RS06835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recD',
  'exodeoxyribonuclease V subunit alpha',
  1400144,
  1402066,
  1,
  'HI_RS06840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'matP',
  'macrodomain Ter protein MatP',
  1402135,
  1402581,
  -1,
  'HI_RS06845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828458.1',
  'AAA family ATPase',
  1402708,
  1404483,
  1,
  'HI_RS06850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fabA',
  'bifunctional 3-hydroxydecanoyl-ACPdehydratase/trans-2-decenoyl-ACP isomerase',
  1404652,
  1405185,
  1,
  'HI_RS06855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005662421.1',
  'BUD32 family EKC/KEOPS complex subunit',
  1405419,
  1406147,
  1,
  'HI_RS06860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsO',
  '30S ribosomal protein S15',
  1406417,
  1406686,
  1,
  'HI_RS06865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'IS1595 family transposase',
  1406758,
  1407406,
  -1,
  'HI_RS06870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dacB',
  'serine-type D-Ala-D-Ala carboxypeptidase',
  1407458,
  1408897,
  -1,
  'HI_RS06875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'greA',
  'transcription elongation factor GreA',
  1409061,
  1409537,
  1,
  'HI_RS06880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yhbY',
  'ribosome assembly RNA-binding protein YhbY',
  1409576,
  1409875,
  -1,
  'HI_RS06885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rlmE',
  '23S rRNA (uridine(2552)-2''-O)-methyltransferaseRlmE',
  1410002,
  1410631,
  1,
  'HI_RS06890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftsH',
  'ATP-dependent zinc metalloprotease FtsH',
  1410722,
  1412629,
  1,
  'HI_RS06895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'folP',
  'dihydropteroate synthase',
  1412741,
  1413568,
  1,
  'HI_RS06900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glmM',
  'phosphoglucosamine mutase',
  1413606,
  1414943,
  1,
  'HI_RS06905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sixA',
  'phosphohistidine phosphatase SixA',
  1415002,
  1415496,
  1,
  'HI_RS06910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828485.1',
  'hypothetical protein',
  1415710,
  1416087,
  1,
  'HI_RS06915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869184.1',
  'TolC family protein',
  1416165,
  1417490,
  -1,
  'HI_RS06920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'Zn-ribbon-containing protein',
  1417617,
  1418150,
  -1,
  'HI_RS06925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'cysteine desulfurase',
  1418143,
  1418718,
  -1,
  'HI_RS06930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'ATP-binding cassette domain-containing protein',
  1418729,
  1420123,
  1,
  'HI_RS06935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005650701.1',
  'extracellular solute-binding protein',
  1420204,
  1421286,
  -1,
  'HI_RS06940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'potC',
  'spermidine/putrescine ABC transporter permeasePotC',
  1421416,
  1422159,
  -1,
  'HI_RS06945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'potB',
  'spermidine/putrescine ABC transporter permeasePotB',
  1422185,
  1423045,
  -1,
  'HI_RS06950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'potA',
  'spermidine/putrescine ABC transporterATP-binding protein PotA',
  1423029,
  1424147,
  -1,
  'HI_RS06955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pepT',
  'peptidase T',
  1424443,
  1425681,
  1,
  'HI_RS06960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005650692.1',
  'Dps family protein',
  1426245,
  1426727,
  -1,
  'HI_RS06965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cdd',
  'cytidine deaminase',
  1427001,
  1427879,
  1,
  'HI_RS06970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cmoB',
  'tRNA 5-methoxyuridine(34)/uridine 5-oxyaceticacid(34) synthase CmoB',
  1427922,
  1428887,
  -1,
  'HI_RS06975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'putP',
  'sodium/proline symporter PutP',
  1428884,
  1430398,
  -1,
  'HI_RS06980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rng',
  'ribonuclease G',
  1430514,
  1431989,
  1,
  'HI_RS06985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glnS',
  'glutamine--tRNA ligase',
  1432412,
  1434082,
  1,
  'HI_RS06990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005650678.1',
  'YcgN family cysteine cluster protein',
  1434160,
  1434612,
  1,
  'HI_RS06995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS06995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'malQ',
  '4-alpha-glucanotransferase',
  1434683,
  1436773,
  1,
  'HI_RS07000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glgB',
  '1,4-alpha-glucan branching protein GlgB',
  1436783,
  1438975,
  1,
  'HI_RS07005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glgX',
  'glycogen debranching protein GlgX',
  1439071,
  1441050,
  1,
  'HI_RS07010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glgC',
  'glucose-1-phosphate adenylyltransferase',
  1441073,
  1442374,
  1,
  'HI_RS07015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glgA',
  'glycogen synthase GlgA',
  1442482,
  1443912,
  1,
  'HI_RS07020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693999.1',
  'glycogen/starch/alpha-glucan phosphorylase',
  1444158,
  1446623,
  1,
  'HI_RS07025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pntA',
  'Re/Si-specific NAD(P)(+) transhydrogenasesubunit alpha',
  1446885,
  1448423,
  1,
  'HI_RS07030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pntB',
  'Re/Si-specific NAD(P)(+) transhydrogenasesubunit beta',
  1448434,
  1449858,
  1,
  'HI_RS07035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869193.1',
  'LysR family transcriptional regulator',
  1449976,
  1450842,
  -1,
  'HI_RS07040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'topA',
  'type I DNA topoisomerase',
  1450938,
  1453544,
  1,
  'HI_RS07045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693994.1',
  'FMN-dependent NADH-azoreductase',
  1453620,
  1454204,
  -1,
  'HI_RS07050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'thrS',
  'threonine--tRNA ligase',
  1454489,
  1456420,
  1,
  'HI_RS07055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693992.1',
  'M16 family metallopeptidase',
  1456539,
  1459319,
  -1,
  'HI_RS07060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927867.1',
  'TonB-dependent receptor plug domain-containingprotein',
  1459423,
  1461825,
  -1,
  'HI_RS07065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005631673.1',
  'TOBE domain-containing protein',
  1461986,
  1462195,
  -1,
  'HI_RS07070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693989.1',
  'TusE/DsrC/DsvC family sulfur relay protein',
  1462303,
  1462632,
  -1,
  'HI_RS07075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ttcA',
  'tRNA 2-thiocytidine(32) synthetase TtcA',
  1462634,
  1463575,
  -1,
  'HI_RS07080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mukF',
  'chromosome partition protein MukF',
  1463725,
  1465059,
  1,
  'HI_RS07085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mukE',
  'chromosome partition protein MukE',
  1465106,
  1465837,
  1,
  'HI_RS07090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mukB',
  'chromosome partition protein MukB',
  1465837,
  1470369,
  1,
  'HI_RS07095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693981.1',
  'DUF5655 domain-containing protein',
  1470440,
  1471348,
  1,
  'HI_RS07100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693980.1',
  'hypothetical protein',
  1471351,
  1472226,
  1,
  'HI_RS07105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sbcB',
  'exodeoxyribonuclease I',
  1472239,
  1473660,
  1,
  'HI_RS07110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'phoR',
  'phosphate regulon sensor histidine kinase PhoR',
  1474351,
  1475628,
  -1,
  'HI_RS07115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'phoB',
  'phosphate regulon transcriptional regulatorPhoB',
  1475625,
  1476320,
  -1,
  'HI_RS07120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pstB',
  'phosphate ABC transporter ATP-binding proteinPstB',
  1476415,
  1477183,
  -1,
  'HI_RS07125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pstA',
  'phosphate ABC transporter permease PstA',
  1477193,
  1478041,
  -1,
  'HI_RS07130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pstC',
  'phosphate ABC transporter permease subunit PstC',
  1478043,
  1478990,
  -1,
  'HI_RS07135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pstS',
  'phosphate ABC transporter substrate-bindingprotein PstS',
  1479081,
  1480099,
  -1,
  'HI_RS07140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftnA',
  'non-heme ferritin',
  1480601,
  1481089,
  1,
  'HI_RS07145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ftnA',
  'non-heme ferritin',
  1481105,
  1481602,
  1,
  'HI_RS07150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'glycosyl transferase',
  1481788,
  1482058,
  1,
  'HI_RS07155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869199.1',
  'hypothetical protein',
  1481976,
  1482422,
  1,
  'HI_RS07160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trpE',
  'anthranilate synthase component I',
  1482528,
  1484084,
  1,
  'HI_RS07165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693974.1',
  'aminodeoxychorismate/anthranilate synthasecomponent II',
  1484097,
  1484678,
  1,
  'HI_RS07170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005666933.1',
  'tautomerase family protein',
  1484727,
  1485113,
  1,
  'HI_RS07175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trpD',
  'anthranilate phosphoribosyltransferase',
  1485166,
  1486167,
  1,
  'HI_RS07180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trpCF',
  'bifunctional indole-3-glycerol-phosphatesynthase TrpC/phosphoribosylanthranilate isomerase TrpF',
  1486207,
  1487637,
  1,
  'HI_RS07185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hybG',
  'hydrogenase maturation factor HybG',
  1487699,
  1487971,
  1,
  'HI_RS07190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'valS',
  'valine--tRNA ligase',
  1488005,
  1490869,
  -1,
  'HI_RS07195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869200.1',
  'DNA-methyltransferase',
  1490870,
  1491799,
  -1,
  'HI_RS07200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869201.1',
  'HindIII family type II restriction endonuclease',
  1491780,
  1492682,
  -1,
  'HI_RS07205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869202.1',
  'N(4)-acetylcytidine aminohydrolase',
  1492630,
  1493001,
  -1,
  'HI_RS07210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869203.1',
  'zeta toxin family protein',
  1493223,
  1493621,
  -1,
  'HI_RS07215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693965.1',
  'hypothetical protein',
  1493611,
  1493781,
  -1,
  'HI_RS08990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693964.1',
  'DNA polymerase III subunit chi',
  1493866,
  1494300,
  -1,
  'HI_RS07220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fumC',
  'class II fumarate hydratase',
  1494535,
  1495929,
  1,
  'HI_RS07225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005656697.1',
  'chalcone isomerase family protein',
  1496057,
  1496665,
  1,
  'HI_RS07230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693963.1',
  'RNase RNM',
  1496764,
  1497588,
  -1,
  'HI_RS07235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pyrD',
  'quinone-dependent dihydroorotate dehydrogenase',
  1497588,
  1498607,
  -1,
  'HI_RS07240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693961.1',
  'hypothetical protein',
  1498837,
  1499139,
  -1,
  'HI_RS07245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869205.1',
  'phage tail protein',
  1499076,
  1499624,
  -1,
  'HI_RS07250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DUF2612 domain-containing protein',
  1499657,
  1500109,
  -1,
  'HI_RS07255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693957.1',
  'DUF2213 domain-containing protein',
  1500122,
  1501222,
  -1,
  'HI_RS07260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693956.1',
  'DUF2513 domain-containing protein',
  1501283,
  1501639,
  -1,
  'HI_RS07265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'minor capsid protein',
  1501918,
  1503344,
  -1,
  'HI_RS07270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693954.1',
  'DUF1073 domain-containing protein',
  1503394,
  1504704,
  -1,
  'HI_RS07275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'PBSX family phage terminase large subunit',
  1504706,
  1506048,
  -1,
  'HI_RS07280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693952.1',
  'terminase small subunit',
  1506035,
  1506550,
  -1,
  'HI_RS07285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869207.1',
  'Rha family transcriptional regulator',
  1506560,
  1507081,
  -1,
  'HI_RS07290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693951.1',
  'Rz1-like lysis system protein LysC',
  1507209,
  1507490,
  -1,
  'HI_RS07295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693950.1',
  'DUF2570 family protein',
  1507402,
  1507677,
  -1,
  'HI_RS07300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693948.1',
  'glycoside hydrolase family 19 protein',
  1507670,
  1508272,
  -1,
  'HI_RS07305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005650535.1',
  'phage holin, lambda family',
  1508241,
  1508597,
  -1,
  'HI_RS07310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_165442161.1',
  'hypothetical protein',
  1508721,
  1508858,
  -1,
  'HI_RS08995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'hypothetical protein',
  1508934,
  1509601,
  -1,
  'HI_RS07315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693946.1',
  'type II toxin-antitoxin system RelE/ParE familytoxin',
  1509962,
  1510261,
  1,
  'HI_RS07320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005643896.1',
  'addiction module antidote protein',
  1510258,
  1510551,
  1,
  'HI_RS07325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_050396694.1',
  'hypothetical protein',
  1510582,
  1510944,
  -1,
  'HI_RS07330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693944.1',
  'P22AR C-terminal domain-containing protein',
  1511013,
  1511588,
  1,
  'HI_RS07335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693943.1',
  'hypothetical protein',
  1511874,
  1512158,
  1,
  'HI_RS07340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693942.1',
  'site-specific integrase',
  1512159,
  1513073,
  -1,
  'HI_RS07345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1513211,
  1513296,
  -1,
  'HI_RS07350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005662331.1',
  'fumarate/nitrate reduction transcriptionalregulator Fnr',
  1513585,
  1514358,
  1,
  'HI_RS07355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'uspE',
  'universal stress protein UspE',
  1514479,
  1515408,
  1,
  'HI_RS07360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693940.1',
  'DUF4198 domain-containing protein',
  1515608,
  1516444,
  1,
  'HI_RS07365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purN',
  'phosphoribosylglycinamide formyltransferase',
  1516529,
  1517167,
  -1,
  'HI_RS07370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purM',
  'phosphoribosylformylglycinamidine cyclo-ligase',
  1517222,
  1518256,
  -1,
  'HI_RS07375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693935.1',
  'SDR family oxidoreductase',
  1518436,
  1519194,
  1,
  'HI_RS07380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trpB',
  'tryptophan synthase subunit beta',
  1519211,
  1520404,
  1,
  'HI_RS07385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'trpA',
  'tryptophan synthase subunit alpha',
  1520404,
  1521210,
  1,
  'HI_RS07390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693928.1',
  'oxidoreductase',
  1521348,
  1522301,
  -1,
  'HI_RS07395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ybaK',
  'Cys-tRNA(Pro) deacylase',
  1522360,
  1522836,
  1,
  'HI_RS07400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cspD',
  'cold shock domain-containing protein CspD',
  1522993,
  1523211,
  -1,
  'HI_RS07405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869211.1',
  'YoaH family protein',
  1523361,
  1523519,
  -1,
  'HI_RS07410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'truC',
  'tRNA pseudouridine(65) synthase TruC',
  1523512,
  1524232,
  -1,
  'HI_RS07415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869213.1',
  'YqcC family protein',
  1524226,
  1524546,
  -1,
  'HI_RS07420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'thiI',
  'tRNA 4-thiouridine(8) synthase ThiI',
  1524561,
  1526019,
  -1,
  'HI_RS07425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'xseB',
  'exodeoxyribonuclease VII small subunit',
  1526179,
  1526433,
  1,
  'HI_RS07430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ispA',
  '(2E,6E)-farnesyl diphosphate synthase',
  1526433,
  1527320,
  1,
  'HI_RS07435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dxs',
  '1-deoxy-D-xylulose-5-phosphate synthase',
  1527362,
  1529239,
  1,
  'HI_RS07440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005650453.1',
  'ClpXP protease specificity-enhancing factor',
  1529275,
  1529727,
  -1,
  'HI_RS07445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sspA',
  'stringent starvation protein SspA',
  1529727,
  1530365,
  -1,
  'HI_RS07450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsI',
  '30S ribosomal protein S9',
  1530546,
  1530938,
  -1,
  'HI_RS07455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplM',
  '50S ribosomal protein L13',
  1530955,
  1531383,
  -1,
  'HI_RS07460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'metF',
  'methylenetetrahydrofolate reductase',
  1531847,
  1532725,
  1,
  'HI_RS07465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'bioD',
  'dethiobiotin synthase',
  1532814,
  1533542,
  -1,
  'HI_RS07470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005650445.1',
  'YcgL domain-containing protein',
  1533645,
  1533911,
  -1,
  'HI_RS07475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'folE',
  'GTP cyclohydrolase I FolE',
  1533972,
  1534628,
  -1,
  'HI_RS07480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'moeA',
  'molybdopterin molybdotransferase MoeA',
  1534766,
  1535980,
  1,
  'HI_RS07485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'moeB',
  'molybdopterin-synthase adenylyltransferase MoeB',
  1535984,
  1536715,
  1,
  'HI_RS07490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005628170.1',
  'HI1450 family dsDNA-mimic protein',
  1536782,
  1537105,
  1,
  'HI_RS07495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693915.1',
  'LysO family transporter',
  1537173,
  1537760,
  -1,
  'HI_RS07500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005652758.1',
  'redoxin domain-containing protein',
  1537998,
  1538468,
  -1,
  'HI_RS07505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005628783.1',
  'cytochrome c biogenesis protein CcdA',
  1538510,
  1539151,
  -1,
  'HI_RS07510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'msrAB',
  'bifunctional peptide-methionine (S)-S-oxidereductase MsrA/peptide-methionine (R)-S-oxide reductaseMsrB',
  1539163,
  1540224,
  -1,
  'HI_RS07515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927868.1',
  'DUF2846 domain-containing protein',
  1540419,
  1540925,
  -1,
  'HI_RS07520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693912.1',
  'opacity family porin',
  1540879,
  1541415,
  -1,
  'HI_RS07525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'helix-turn-helix transcriptional regulator',
  1541571,
  1541953,
  1,
  'HI_RS07530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693910.1',
  'anti-sigma factor family protein',
  1542024,
  1542221,
  -1,
  'HI_RS07535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869218.1',
  'sigma-70 family RNA polymerase sigma factor',
  1542231,
  1542776,
  -1,
  'HI_RS07540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_100066293.1',
  'hypothetical protein',
  1542998,
  1543237,
  -1,
  'HI_RS07545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_165442162.1',
  'hypothetical protein',
  1543707,
  1543856,
  -1,
  'HI_RS09000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS09000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869219.1',
  'toxin/drug exporter TdeA',
  1544081,
  1545445,
  1,
  'HI_RS07550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828485.1',
  'hypothetical protein',
  1545523,
  1545900,
  -1,
  'HI_RS07555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sixA',
  'phosphohistidine phosphatase SixA',
  1546114,
  1546608,
  -1,
  'HI_RS07560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glmM',
  'phosphoglucosamine mutase',
  1546667,
  1548004,
  -1,
  'HI_RS07565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'folP',
  'dihydropteroate synthase',
  1548042,
  1548869,
  -1,
  'HI_RS07570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hflB',
  'ATP-dependent zinc metalloprotease FtsH',
  1548981,
  1550141,
  -1,
  'HI_RS07575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'TonB-dependent receptor',
  1550264,
  1552466,
  1,
  'HI_RS07580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693484.1',
  'ABC transporter ATP-binding protein/permease',
  1552525,
  1554294,
  1,
  'HI_RS07585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpsO',
  '30S ribosomal protein S15',
  1554432,
  1554701,
  -1,
  'HI_RS07590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693485.1',
  'substrate-binding domain-containing protein',
  1554685,
  1555032,
  -1,
  'HI_RS07595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693486.1',
  'molybdate ABC transporter ATP-binding proteinMolC',
  1555042,
  1555803,
  -1,
  'HI_RS07600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693487.1',
  'molybdate ABC transporter permease MolB',
  1555796,
  1556809,
  -1,
  'HI_RS07605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693488.1',
  'molybdate ABC transporter substrate-bindingprotein MolA',
  1556796,
  1557851,
  -1,
  'HI_RS07610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693490.1',
  'ModD protein',
  1557919,
  1558764,
  -1,
  'HI_RS07615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005645090.1',
  'ABC transporter ATP-binding protein',
  1558774,
  1559373,
  -1,
  'HI_RS07620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'ABC transporter permease subunit',
  1559375,
  1559722,
  -1,
  'HI_RS07625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693492.1',
  'LexA family transcriptional regulator',
  1559962,
  1560681,
  -1,
  'HI_RS07630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693493.1',
  'helix-turn-helix domain-containing protein',
  1560909,
  1561178,
  1,
  'HI_RS07635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869221.1',
  'transposase domain-containing protein',
  1561212,
  1563275,
  1,
  'HI_RS07640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693495.1',
  'DNA-binding domain-containing protein',
  1563332,
  1563604,
  1,
  'HI_RS07645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693497.1',
  'hypothetical protein',
  1563537,
  1564007,
  -1,
  'HI_RS07650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869222.1',
  'AAA family ATPase',
  1564041,
  1564904,
  1,
  'HI_RS07655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869223.1',
  'hypothetical protein',
  1564965,
  1565282,
  1,
  'HI_RS07660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693500.1',
  'host-nuclease inhibitor Gam family protein',
  1565297,
  1565806,
  1,
  'HI_RS07665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693501.1',
  'hypothetical protein',
  1565803,
  1565964,
  1,
  'HI_RS09005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS09005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927869.1',
  'hypothetical protein',
  1565964,
  1566233,
  1,
  'HI_RS07670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693504.1',
  'ANR family transcriptional regulator',
  1566436,
  1566657,
  1,
  'HI_RS07675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693505.1',
  'hypothetical protein',
  1566657,
  1566830,
  1,
  'HI_RS09010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS09010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693506.1',
  'DUF5420 family protein',
  1566833,
  1567393,
  1,
  'HI_RS07680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869224.1',
  'gp16 family protein',
  1567567,
  1568124,
  1,
  'HI_RS07685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693508.1',
  'hypothetical protein',
  1568121,
  1568675,
  1,
  'HI_RS07690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'transcriptional regulator',
  1568867,
  1569300,
  1,
  'HI_RS07695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693510.1',
  'hypothetical protein',
  1569309,
  1569815,
  1,
  'HI_RS07700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'N-acetylmuramoyl-L-alanine amidase',
  1569897,
  1570441,
  1,
  'HI_RS07705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693512.1',
  'DUF2644 domain-containing protein',
  1570448,
  1570708,
  1,
  'HI_RS07710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693513.1',
  'DUF2681 domain-containing protein',
  1570705,
  1570959,
  1,
  'HI_RS07715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693516.1',
  'TraR/DksA family transcriptional regulator',
  1571077,
  1571304,
  1,
  'HI_RS07720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828368.1',
  'DUF2730 domain-containing protein',
  1571304,
  1571630,
  1,
  'HI_RS07725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869227.1',
  'VpaChn25_0724 family phage protein',
  1571635,
  1571943,
  1,
  'HI_RS07730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869228.1',
  'DUF3486 family protein',
  1571955,
  1572524,
  1,
  'HI_RS07735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693520.1',
  'terminase large subunit domain-containingprotein',
  1572524,
  1574050,
  1,
  'HI_RS07740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869229.1',
  'DUF935 domain-containing protein',
  1574062,
  1575624,
  1,
  'HI_RS07745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869230.1',
  'phage head morphogenesis protein',
  1575715,
  1576959,
  1,
  'HI_RS07750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693523.1',
  'phage virion morphogenesis protein',
  1577097,
  1577537,
  1,
  'HI_RS07755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693524.1',
  'phage protease',
  1577768,
  1578835,
  1,
  'HI_RS07760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693526.1',
  'Mu-like prophage major head subunit gpT familyprotein',
  1578835,
  1579761,
  1,
  'HI_RS07765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'hypothetical protein',
  1579844,
  1580229,
  1,
  'HI_RS07770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828369.1',
  'gp436 family protein',
  1580235,
  1580657,
  1,
  'HI_RS07775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693530.1',
  'DUF1834 family protein',
  1580657,
  1581208,
  1,
  'HI_RS07780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693531.1',
  'DUF2635 domain-containing protein',
  1581221,
  1581412,
  1,
  'HI_RS07785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693532.1',
  'phage tail sheath subtilisin-likedomain-containing protein',
  1581412,
  1582875,
  1,
  'HI_RS07790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693533.1',
  'phage tail tube protein',
  1582885,
  1583241,
  1,
  'HI_RS07795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693534.1',
  'phage tail assembly protein',
  1583254,
  1583637,
  1,
  'HI_RS07800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869233.1',
  'tape measure protein',
  1583718,
  1585613,
  1,
  'HI_RS07805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869234.1',
  'DNA circularization protein',
  1585613,
  1586980,
  1,
  'HI_RS07810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_164927870.1',
  'phage baseplate assembly protein',
  1586980,
  1587765,
  1,
  'HI_RS07815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'phage tail protein',
  1587765,
  1588240,
  1,
  'HI_RS07820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693539.1',
  'phage baseplate assembly protein V',
  1588277,
  1588825,
  1,
  'HI_RS07825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693540.1',
  'phage GP46 family protein',
  1588834,
  1589241,
  1,
  'HI_RS07830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693541.1',
  'baseplate J/gp47 family protein',
  1589241,
  1590308,
  1,
  'HI_RS07835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_165442165.1',
  'YmfQ family protein',
  1590334,
  1590900,
  1,
  'HI_RS07840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693543.1',
  'phage tail fiber protein',
  1590900,
  1592771,
  1,
  'HI_RS07845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693545.1',
  'Com family DNA-binding transcriptionalregulator',
  1593255,
  1593374,
  1,
  'HI_RS07850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828356.1',
  'hypothetical protein',
  1593430,
  1594275,
  1,
  'HI_RS07855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'molybdate ABC transporter permease subunit',
  1594399,
  1594854,
  -1,
  'HI_RS07860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'modA',
  'molybdate ABC transporter substrate-bindingprotein',
  1594829,
  1595566,
  -1,
  'HI_RS07865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hldE',
  'bifunctionalD-glycero-beta-D-manno-heptose-7-phosphatekinase/D-glycero-beta-D-manno-heptose 1-phosphateadenylyltransferase HldE',
  1595753,
  1597183,
  -1,
  'HI_RS07870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693550.1',
  'lipid A biosynthesis lauroyl acyltransferaseHtrB',
  1597280,
  1598215,
  1,
  'HI_RS07875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'parE',
  'DNA topoisomerase IV subunit B',
  1598289,
  1600187,
  1,
  'HI_RS07880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'parC',
  'DNA topoisomerase IV subunit A',
  1600254,
  1602497,
  1,
  'HI_RS07885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gltS',
  'sodium/glutamate symporter',
  1602539,
  1603753,
  1,
  'HI_RS07890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693559.1',
  'RimK family alpha-L-glutamate ligase',
  1603792,
  1604700,
  -1,
  'HI_RS07895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'grxA',
  'GrxA family glutaredoxin',
  1604817,
  1605080,
  1,
  'HI_RS07900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fabB',
  'beta-ketoacyl-ACP synthase I',
  1605147,
  1606367,
  -1,
  'HI_RS07905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mnmC',
  'bifunctional tRNA(5-methylaminomethyl-2-thiouridine)(34)-methyltransferaseMnmD/FAD-dependent5-carboxymethylaminomethyl-2-thiouridine(34)oxidoreductase MnmC',
  1606516,
  1608528,
  1,
  'HI_RS07910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_105163169.1',
  'phosphorylcholine kinase LicA',
  1608603,
  1609583,
  1,
  'HI_RS07915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005672105.1',
  'choline transport protein LicB',
  1609583,
  1610461,
  1,
  'HI_RS07920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693563.1',
  'NTP transferase domain-containing protein',
  1610458,
  1611159,
  1,
  'HI_RS07925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693564.1',
  'lipopolysaccharide cholinephosphotransferaseLicD',
  1611159,
  1611956,
  1,
  'HI_RS07930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sppA',
  'signal peptide peptidase SppA',
  1611994,
  1613841,
  -1,
  'HI_RS07935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693567.1',
  'NAD(P)H nitroreductase',
  1613939,
  1614493,
  1,
  'HI_RS07940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693568.1',
  'TorD/DmsD family molecular chaperone',
  1614541,
  1615095,
  -1,
  'HI_RS07945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693569.1',
  'NAD(P)H-dependent oxidoreductase',
  1615095,
  1615703,
  -1,
  'HI_RS07950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sstT',
  'serine/threonine transporter SstT',
  1615824,
  1617068,
  -1,
  'HI_RS07955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869241.1',
  'LexA family protein',
  1617353,
  1617775,
  1,
  'HI_RS07960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aroG',
  '3-deoxy-7-phosphoheptulonate synthase AroG',
  1617864,
  1618931,
  -1,
  'HI_RS07965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lolE',
  'lipoprotein-releasing ABC transporter permeasesubunit LolE',
  1619170,
  1620420,
  -1,
  'HI_RS07970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lolD',
  'lipoprotein-releasing ABC transporterATP-binding protein LolD',
  1620420,
  1621103,
  -1,
  'HI_RS07975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'bioD',
  'ATP-dependent dethiobiotin synthetase BioD',
  1621185,
  1621825,
  -1,
  'HI_RS07980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'bioC',
  'malonyl-ACP O-methyltransferase BioC',
  1621835,
  1622617,
  -1,
  'HI_RS07985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693578.1',
  'DUF452 family protein',
  1622605,
  1623252,
  -1,
  'HI_RS07990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'bioF',
  '8-amino-7-oxononanoate synthase',
  1623262,
  1624404,
  -1,
  'HI_RS07995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS07995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693582.1',
  'adenosylmethionine--8-amino-7-oxononanoatetransaminase',
  1624413,
  1625705,
  -1,
  'HI_RS08000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005654778.1',
  'lipoprotein-releasing ABC transporter permeasesubunit',
  1625724,
  1626905,
  -1,
  'HI_RS08005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693583.1',
  '2-hydroxyacid dehydrogenase',
  1626905,
  1627852,
  -1,
  'HI_RS08010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'kdsA',
  '3-deoxy-8-phosphooctulonate synthase',
  1627912,
  1628766,
  -1,
  'HI_RS08015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005654786.1',
  'SirB1 family protein',
  1628781,
  1629584,
  -1,
  'HI_RS08020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'prmC',
  'peptide chain release factor N(5)-glutaminemethyltransferase',
  1629584,
  1630462,
  -1,
  'HI_RS08025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005688499.1',
  'RDD family protein',
  1630462,
  1630902,
  -1,
  'HI_RS08030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'prfA',
  'peptide chain release factor 1',
  1630955,
  1632037,
  -1,
  'HI_RS08035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005688500.1',
  'hypothetical protein',
  1632147,
  1632359,
  -1,
  'HI_RS08040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005688501.1',
  'elongation factor P hydroxylase',
  1632558,
  1633094,
  -1,
  'HI_RS08045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005688502.1',
  'hypothetical protein',
  1633127,
  1633279,
  -1,
  'HI_RS09015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS09015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'TonB-dependenthemoglobin/transferrin/lactoferrin family receptor',
  1633785,
  1636722,
  1,
  'HI_RS08050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693592.1',
  'phage virion morphogenesis protein',
  1636791,
  1637207,
  -1,
  'HI_RS08055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'hypothetical protein',
  1637331,
  1638037,
  -1,
  'HI_RS08060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_100066292.1',
  'phage portal protein family protein',
  1638049,
  1638282,
  -1,
  'HI_RS08065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'pyruvate kinase',
  1638282,
  1638795,
  1,
  'HI_RS08070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'site-specific integrase',
  1638752,
  1639726,
  -1,
  'HI_RS08075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1639927,
  1640003,
  -1,
  'HI_RS08080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pyk',
  'pyruvate kinase',
  1640232,
  1641668,
  1,
  'HI_RS08085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828363.1',
  'replicative DNA helicase',
  1641810,
  1643216,
  1,
  'HI_RS08090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'alr',
  'alanine racemase',
  1643226,
  1644308,
  1,
  'HI_RS08095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pgi',
  'glucose-6-phosphate isomerase',
  1644405,
  1646054,
  1,
  'HI_RS08100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'transposase',
  1646128,
  1646611,
  1,
  'HI_RS08105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693601.1',
  'glycosyltransferase family 2 protein',
  1646702,
  1647673,
  1,
  'HI_RS08110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869250.1',
  'outer membrane lipoprotein',
  1647856,
  1648323,
  -1,
  'HI_RS08115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'glucose-6-phosphate isomerase',
  1648349,
  1648600,
  -1,
  'HI_RS08120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'VOC family protein',
  1648637,
  1649217,
  -1,
  'HI_RS08125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'argS',
  'arginine--tRNA ligase',
  1649297,
  1651030,
  1,
  'HI_RS08130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ilvN',
  'acetolactate synthase small subunit',
  1651323,
  1651814,
  -1,
  'HI_RS08135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005671546.1',
  'acetolactate synthase 3 large subunit',
  1651814,
  1653535,
  -1,
  'HI_RS08140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005653280.1',
  'hypothetical protein',
  1653585,
  1653734,
  -1,
  'HI_RS08145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828365.1',
  'Na+/H+ antiporter NhaC family protein',
  1653802,
  1655322,
  -1,
  'HI_RS08150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647241.1',
  'H-NS histone family protein',
  1655765,
  1656169,
  1,
  'HI_RS08155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purU',
  'formyltetrahydrofolate deformylase',
  1656239,
  1657075,
  1,
  'HI_RS08160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'aroA',
  '3-phosphoshikimate 1-carboxyvinyltransferase',
  1657075,
  1658373,
  1,
  'HI_RS08165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869253.1',
  'replication-associated recombination protein A',
  1658455,
  1659795,
  -1,
  'HI_RS08170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lolA',
  'outer membrane lipoprotein periplasmic chaperoneLolA',
  1659856,
  1660473,
  -1,
  'HI_RS08175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DUF87 domain-containing protein',
  1660491,
  1663260,
  -1,
  'HI_RS08180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lrp',
  'leucine-responsive transcriptional regulatorLrp',
  1663262,
  1663741,
  -1,
  'HI_RS08185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'radA',
  'DNA repair protein RadA',
  1663821,
  1665197,
  -1,
  'HI_RS08190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828366.1',
  'CYTH domain-containing protein',
  1665333,
  1666379,
  -1,
  'HI_RS08195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693614.1',
  'HvfC family RiPP maturation protein',
  1666703,
  1667419,
  -1,
  'HI_RS08200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647267.1',
  'HvfB family MNIO-type RiPP peptide maturase',
  1667409,
  1668332,
  -1,
  'HI_RS08205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005691265.1',
  'oxazolone/thioamide-modified RiPP metallophoreHvfA',
  1668392,
  1668679,
  -1,
  'HI_RS08210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005691264.1',
  'HvfX family Cu-binding RiPP maturation protein',
  1668718,
  1669173,
  -1,
  'HI_RS08215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647270.1',
  'TIGR00153 family protein',
  1669381,
  1670061,
  1,
  'HI_RS08220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869255.1',
  'inorganic phosphate transporter',
  1670086,
  1671348,
  1,
  'HI_RS08225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869256.1',
  'TIGR04211 family SH3 domain-containing protein',
  1671414,
  1672025,
  1,
  'HI_RS08230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693619.1',
  'multifunctional CCA addition/repair protein',
  1672032,
  1673282,
  1,
  'HI_RS08235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lolB',
  'lipoprotein insertase outer membrane proteinLolB',
  1673354,
  1673974,
  1,
  'HI_RS08240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ispE',
  '4-(cytidine5''-diphospho)-2-C-methyl-D-erythritol kinase',
  1673986,
  1674927,
  1,
  'HI_RS08245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005647284.1',
  'ribose-phosphate pyrophosphokinase',
  1674929,
  1675876,
  1,
  'HI_RS08250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869258.1',
  'tyrosine--tRNA ligase',
  1675940,
  1677145,
  -1,
  'HI_RS08255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sfsA',
  'DNA/RNA nuclease SfsA',
  1677346,
  1678062,
  -1,
  'HI_RS08260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'hmrM',
  'sodium-coupled multidrug efflux MATE transporterHmrM',
  1678071,
  1679465,
  -1,
  'HI_RS08265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ribE',
  'riboflavin synthase',
  1679509,
  1680123,
  1,
  'HI_RS08270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pepN',
  'aminopeptidase N',
  1680195,
  1682804,
  -1,
  'HI_RS08275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purE',
  '5-(carboxyamino)imidazole ribonucleotide mutase',
  1682965,
  1683459,
  1,
  'HI_RS08280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purK',
  '5-(carboxyamino)imidazole ribonucleotidesynthase',
  1683529,
  1684617,
  1,
  'HI_RS08285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693630.1',
  'amino acid aminotransferase',
  1684756,
  1685946,
  1,
  'HI_RS08290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'hydrogenase expression/formation protein HypE',
  1686035,
  1686166,
  -1,
  'HI_RS08295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869260.1',
  'energy-coupling factor ABC transporterATP-binding protein',
  1686173,
  1686790,
  -1,
  'HI_RS08300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'energy-coupling factor transporter transmembraneprotein EcfT',
  1686792,
  1687425,
  -1,
  'HI_RS08305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cbiM',
  'cobalt transporter CbiM',
  1687425,
  1688045,
  -1,
  'HI_RS08310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693634.1',
  'hypothetical protein',
  1688045,
  1688530,
  -1,
  'HI_RS08315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005689200.1',
  'DUF4198 domain-containing protein',
  1688543,
  1689226,
  -1,
  'HI_RS08320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005633867.1',
  'Cd(II)/Pb(II)-responsive transcriptionalregulator',
  1689316,
  1689723,
  1,
  'HI_RS08325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869261.1',
  'tetratricopeptide repeat protein',
  1689783,
  1690280,
  -1,
  'HI_RS08330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693636.1',
  'YwiC-like family protein',
  1690281,
  1690997,
  -1,
  'HI_RS08335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693637.1',
  'RidA family protein',
  1691109,
  1691459,
  1,
  'HI_RS08340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005653154.1',
  'Z-ring associated ZapG family protein',
  1691490,
  1691894,
  1,
  'HI_RS08345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'DedA family protein',
  1691941,
  1692544,
  -1,
  'HI_RS08350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rplY',
  '50S ribosomal protein L25',
  1692762,
  1693049,
  1,
  'HI_RS08355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693640.1',
  'DUF2726 domain-containing protein',
  1693148,
  1693720,
  -1,
  'HI_RS08360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1693872,
  1693946,
  -1,
  'HI_RS08365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1693994,
  1694068,
  -1,
  'HI_RS08370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1694097,
  1694181,
  -1,
  'HI_RS08375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1694187,
  1694263,
  -1,
  'HI_RS08380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693641.1',
  'ACT domain-containing protein',
  1694577,
  1694942,
  1,
  'HI_RS08385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purA',
  'adenylosuccinate synthase',
  1695071,
  1696369,
  1,
  'HI_RS08390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dapD',
  '2,3,4,5-tetrahydropyridine-2,6-dicarboxylateN-succinyltransferase',
  1696426,
  1697253,
  -1,
  'HI_RS08395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'purR',
  'HTH-type transcriptional repressor PurR',
  1697612,
  1698622,
  1,
  'HI_RS08400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ppc',
  'phosphoenolpyruvate carboxylase',
  1698805,
  1701444,
  1,
  'HI_RS08405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693645.1',
  'YcjX family GTP-binding protein',
  1701481,
  1702893,
  -1,
  'HI_RS08410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693646.1',
  'ABC transporter substrate-binding protein',
  1702963,
  1704660,
  1,
  'HI_RS08415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693647.1',
  'ABC transporter permease',
  1704660,
  1705625,
  1,
  'HI_RS08420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693648.1',
  'ABC transporter permease subunit',
  1705615,
  1706502,
  1,
  'HI_RS08425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693649.1',
  'peptide ABC transporter ATP-binding protein',
  1706506,
  1707555,
  1,
  'HI_RS08430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005670537.1',
  'peptide ABC transporter ATP-binding protein',
  1707555,
  1708364,
  1,
  'HI_RS08435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005693652.1',
  'YeiH family protein',
  1708376,
  1709392,
  1,
  'HI_RS08440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'truA',
  'tRNA pseudouridine(38-40) synthase TruA',
  1709484,
  1710293,
  -1,
  'HI_RS08445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'fbp',
  'class 1 fructose-bisphosphatase',
  1710527,
  1711528,
  1,
  'HI_RS08450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'cmk',
  '(d)CMP kinase',
  1711447,
  1712121,
  -1,
  'HI_RS08455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pdxS',
  'pyridoxal 5''-phosphate synthase lyase subunitPdxS',
  1712590,
  1713465,
  1,
  'HI_RS08460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pdxT',
  'pyridoxal 5''-phosphate synthase glutaminasesubunit PdxT',
  1713466,
  1714044,
  1,
  'HI_RS08465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'dld',
  'D-lactate dehydrogenase',
  1714592,
  1716286,
  -1,
  'HI_RS08470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694377.1',
  'Hpt domain-containing protein',
  1716772,
  1717050,
  -1,
  'HI_RS08475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'transposase family protein',
  1717339,
  1717622,
  1,
  'HI_RS08480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005659678.1',
  'NlpC/P60 family protein',
  1717801,
  1718352,
  -1,
  'HI_RS08485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'tldD',
  'metalloprotease TldD',
  1718465,
  1719912,
  -1,
  'HI_RS08490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsmI',
  '16S rRNA(cytidine(1402)-2''-O)-methyltransferase',
  1720014,
  1720865,
  -1,
  'HI_RS08495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694381.1',
  'penicillin-binding protein activator',
  1720937,
  1722664,
  1,
  'HI_RS08500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694382.1',
  'YraN family protein',
  1722664,
  1723023,
  1,
  'HI_RS08505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694384.1',
  'D-sedoheptulose-7-phosphate isomerase',
  1723036,
  1723620,
  1,
  'HI_RS08510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yraP',
  'division/outer membrane stress-associatedlipid-binding lipoprotein',
  1723677,
  1724258,
  1,
  'HI_RS08515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nrdA',
  'class 1a ribonucleoside-diphosphate reductasesubunit alpha',
  1724513,
  1726783,
  1,
  'HI_RS08520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nrdB',
  'class Ia ribonucleoside-diphosphate reductasesubunit beta',
  1726925,
  1728055,
  1,
  'HI_RS08525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'odhB',
  '2-oxoglutarate dehydrogenase complexdihydrolipoyllysine-residue succinyltransferase',
  1728171,
  1729400,
  -1,
  'HI_RS08530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sucA',
  '2-oxoglutarate dehydrogenase E1 component',
  1729503,
  1732310,
  -1,
  'HI_RS08535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694389.1',
  'MBL fold metallo-hydrolase',
  1732513,
  1733151,
  -1,
  'HI_RS08540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694391.1',
  'TatD family hydrolase',
  1733161,
  1733916,
  -1,
  'HI_RS08545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'YcbK family protein',
  1733968,
  1734527,
  -1,
  'HI_RS08550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694392.1',
  'L,D-transpeptidase family protein',
  1734543,
  1736012,
  -1,
  'HI_RS08555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'prc',
  'carboxy terminal-processing peptidase',
  1736086,
  1738167,
  -1,
  'HI_RS08560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'proQ',
  'RNA chaperone ProQ',
  1738195,
  1738832,
  -1,
  'HI_RS08565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005667179.1',
  'paraquat-inducible protein A',
  1739016,
  1740266,
  1,
  'HI_RS08570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694394.1',
  'PqiB family protein',
  1740250,
  1742895,
  1,
  'HI_RS08575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'moaE',
  'molybdopterin synthase catalytic subunit MoaE',
  1742950,
  1743402,
  -1,
  'HI_RS08580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'moaD',
  'molybdopterin synthase sulfur carrier subunit',
  1743403,
  1743648,
  -1,
  'HI_RS08585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'moaC',
  'cyclic pyranopterin monophosphate synthase MoaC',
  1743650,
  1744132,
  -1,
  'HI_RS08590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'moaA',
  'GTP 3'',8-cyclase MoaA',
  1744224,
  1745237,
  -1,
  'HI_RS08595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ytfE',
  'iron-sulfur cluster repair protein YtfE',
  1745682,
  1746353,
  1,
  'HI_RS08600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rnpB',
  '—',
  1746430,
  1746806,
  -1,
  'HI_RS08605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_032828451.1',
  'KpsF/GutQ family sugar isomerase',
  1746968,
  1747903,
  1,
  'HI_RS08610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005665007.1',
  'KdsC family phosphatase',
  1747913,
  1748455,
  1,
  'HI_RS08615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'yccS',
  'YccS family putative transporter',
  1748553,
  1750709,
  -1,
  'HI_RS08620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005654151.1',
  'curli polymerization inhibitor CsgI-relatedprotein',
  1750777,
  1751442,
  -1,
  'HI_RS08625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'sohB',
  'protease SohB',
  1751640,
  1752701,
  1,
  'HI_RS08630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsxA',
  'electron transport complex subunit RsxA',
  1752983,
  1753561,
  1,
  'HI_RS08635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsxB',
  'electron transport complex subunit RsxB',
  1753649,
  1754230,
  1,
  'HI_RS08640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsxC',
  'electron transport complex subunit RsxC',
  1754231,
  1756690,
  1,
  'HI_RS08645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsxD',
  'electron transport complex subunit RsxD',
  1756695,
  1757771,
  1,
  'HI_RS08650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsxG',
  'electron transport complex subunit RsxG',
  1757771,
  1758394,
  1,
  'HI_RS08655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005658208.1',
  'electron transport complex subunit E',
  1758396,
  1759103,
  1,
  'HI_RS08660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'nth',
  'endonuclease III',
  1759288,
  1759923,
  1,
  'HI_RS08665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694179.1',
  'sodium-dependent transporter',
  1759981,
  1761354,
  1,
  'HI_RS08670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'modC',
  'molybdenum ABC transporter ATP-binding proteinModC',
  1761378,
  1762433,
  -1,
  'HI_RS08675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'modB',
  'molybdate ABC transporter permease subunit',
  1762420,
  1763148,
  -1,
  'HI_RS08680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'modA',
  'molybdate ABC transporter substrate-bindingprotein',
  1763283,
  1764047,
  -1,
  'HI_RS08685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694183.1',
  'TOBE domain-containing protein',
  1764185,
  1764952,
  1,
  'HI_RS08690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lsgF',
  'lipooligosaccharide biosynthesisgalactosyltransferase LsgF',
  1765061,
  1765864,
  -1,
  'HI_RS08695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lsgE',
  'lipooligosaccharide biosynthesisN-acetyl-glucosamine transferase LsgE',
  1765866,
  1766750,
  -1,
  'HI_RS08700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lsgD',
  'lipooligosaccharide biosynthesisgalactosyltransferase LsgD',
  1766762,
  1767535,
  -1,
  'HI_RS08705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lsgC',
  'lipooligosaccharide biosynthesis family 4glycosyltransferase LsgC',
  1767547,
  1768608,
  -1,
  'HI_RS08710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lsgB',
  'lipooligosaccharide biosynthesissialyltransferase LsgB',
  1768610,
  1769524,
  -1,
  'HI_RS08715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lsgA',
  'lipooligosaccharide flippase LsgA',
  1769521,
  1770726,
  -1,
  'HI_RS08720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694191.1',
  'YdcF family protein',
  1770861,
  1771604,
  1,
  'HI_RS08725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'metE',
  '5-methyltetrahydropteroyltriglutamate--homocysteine S-methyltransferase',
  1771826,
  1774096,
  -1,
  'HI_RS08730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lptG',
  'LPS export ABC transporter permease LptG',
  1774289,
  1775365,
  -1,
  'HI_RS08735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lptF',
  'LPS export ABC transporter permease LptF',
  1775349,
  1776467,
  -1,
  'HI_RS08740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694194.1',
  'leucyl aminopeptidase',
  1776575,
  1778050,
  1,
  'HI_RS08745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694195.1',
  'BCCT family transporter',
  1778086,
  1780113,
  -1,
  'HI_RS08750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'qseC',
  'quorum sensing histidine kinase QseC',
  1780390,
  1781745,
  -1,
  'HI_RS08755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649974.1',
  'response regulator',
  1781742,
  1782407,
  -1,
  'HI_RS08760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005631924.1',
  'YgiW/YdeI family stress tolerance OB foldprotein',
  1782470,
  1782835,
  -1,
  'HI_RS08765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005654344.1',
  'hypothetical protein',
  1782950,
  1783162,
  -1,
  'HI_RS08770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'crr',
  'PTS glucose transporter subunit IIA',
  1783345,
  1783845,
  -1,
  'HI_RS08775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'ptsI',
  'phosphoenolpyruvate-protein phosphotransferasePtsI',
  1783905,
  1785632,
  -1,
  'HI_RS08780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649965.1',
  'HPr family phosphocarrier protein',
  1785712,
  1785969,
  -1,
  'HI_RS08785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rsgA',
  'small ribosomal subunit biogenesis GTPase RsgA',
  1786128,
  1787168,
  -1,
  'HI_RS08790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'orn',
  'oligoribonuclease',
  1787239,
  1787787,
  1,
  'HI_RS08795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1787881,
  1787956,
  1,
  'HI_RS08800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'wecA',
  'UDP-N-acetylglucosamine--undecaprenyl-phosphateN-acetylglucosaminephosphotransferase',
  1788088,
  1789155,
  -1,
  'HI_RS08805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'hypothetical protein',
  1789352,
  1790369,
  -1,
  'HI_RS08815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'glnD',
  'bifunctionaluridylyltransferase/uridylyl-removing protein GlnD',
  1790426,
  1793017,
  -1,
  'HI_RS08820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_100066296.1',
  'IS3-like element ISHin1 family transposase',
  1793136,
  1794463,
  1,
  'HI_RS08825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'map',
  'type I methionyl aminopeptidase',
  1794526,
  1795332,
  -1,
  'HI_RS08830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'erpA',
  'iron-sulfur cluster insertion protein ErpA',
  1795468,
  1795812,
  1,
  'HI_RS08835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869281.1',
  'YacL family protein',
  1795814,
  1796167,
  1,
  'HI_RS08840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'mrcB',
  'penicillin-binding protein 1B',
  1796174,
  1798519,
  1,
  'HI_RS08845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649949.1',
  'phosphoribosylaminoimidazolesuccinocarboxamidesynthase',
  1798692,
  1799564,
  1,
  'HI_RS08850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'argG',
  'argininosuccinate synthase',
  1799720,
  1801054,
  1,
  'HI_RS08855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694214.1',
  'NRAMP family divalent metal transporter',
  1801125,
  1802318,
  -1,
  'HI_RS08860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pxpA',
  '5-oxoprolinase subunit PxpA',
  1802362,
  1803099,
  -1,
  'HI_RS08865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694216.1',
  '5-oxoprolinase subunit C family protein',
  1803086,
  1804015,
  -1,
  'HI_RS08870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'pxpB',
  '5-oxoprolinase subunit PxpB',
  1804012,
  1804653,
  -1,
  'HI_RS08875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  'Hia/Hsf adhesin N-terminal domain-containingprotein',
  1804886,
  1807267,
  -1,
  'HI_RS08880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_050396695.1',
  'ESPR domain-containing protein',
  1807963,
  1808859,
  -1,
  'HI_RS08885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rnb',
  'exoribonuclease II',
  1809215,
  1811194,
  -1,
  'HI_RS08890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005649928.1',
  'enoyl-ACP reductase FabI',
  1811277,
  1812065,
  -1,
  'HI_RS08895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'prfC',
  'peptide chain release factor 3',
  1812244,
  1813827,
  1,
  'HI_RS08900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005632089.1',
  'YgjV family protein',
  1813903,
  1814136,
  -1,
  'HI_RS08905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005658306.1',
  'branched-chain amino acid transporter permease',
  1814239,
  1814568,
  -1,
  'HI_RS08910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'azlC',
  'azaleucine resistance protein AzlC',
  1814565,
  1815299,
  -1,
  'HI_RS08915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_005694223.1',
  'LysR family transcriptional regulator',
  1815309,
  1816238,
  -1,
  'HI_RS08920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rrf',
  '—',
  1816478,
  1816593,
  -1,
  'HI_RS08925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1816825,
  1819744,
  -1,
  'HI_RS08930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1820143,
  1820218,
  -1,
  'HI_RS08935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1820304,
  1820380,
  -1,
  'HI_RS08940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  '—',
  '—',
  1820456,
  1822001,
  -1,
  'HI_RS08945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'lldD',
  'FMN-dependent L-lactate dehydrogenase LldD',
  1822366,
  1823511,
  -1,
  'HI_RS08950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'WP_010869285.1',
  'glutamate racemase',
  1823723,
  1824532,
  -1,
  'HI_RS08955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'recG',
  'ATP-dependent DNA helicase RecG',
  1824562,
  1826643,
  -1,
  'HI_RS08960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'spoT',
  'bifunctional GTPdiphosphokinase/guanosine-3'',5''-bis pyrophosphate3''-pyrophosphohydrolase',
  1826640,
  1828754,
  -1,
  'HI_RS08965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'rpoZ',
  'DNA-directed RNA polymerase subunit omega',
  1828934,
  1829200,
  -1,
  'HI_RS08970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  'gmk',
  'guanylate kinase',
  1829263,
  1829889,
  -1,
  'HI_RS08975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1) AND locus_tag='HI_RS08975'
);

INSERT INTO core_experimentaltechnique (name, description, preset_function, EO_term)
SELECT 'Cya fusion reporter', 'Cya fusion reporter', NULL, 'ECO:0006002'
WHERE NOT EXISTS (
  SELECT 1 FROM core_experimentaltechnique WHERE EO_term='ECO:0006002'
);

INSERT INTO core_siteinstance (_seq, genome_id, start, end, strand)
SELECT
  'AAAAAAAAAAAAA',
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  7373,
  7385,
  1
WHERE NOT EXISTS (
  SELECT 1 FROM core_siteinstance
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
    AND start=7373 AND end=7385 AND strand=1
    AND _seq='AAAAAAAAAAAAA'
);

INSERT INTO core_curation_siteinstance
  (curation_id, site_instance_id, annotated_seq, quantitative_value, site_type, TF_function, TF_type)
VALUES
  ((SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1),
   (SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=7373 AND end=7385 AND strand=1
          AND _seq='AAAAAAAAAAAAA'
        ORDER BY site_id DESC LIMIT 1),
   'AAAAAAAAAAAAA',
   0,
   'variable',
   'dual',
   'monomer');

INSERT INTO core_curation_siteinstance_experimental_techniques
  (curation_siteinstance_id, experimentaltechnique_id)
SELECT (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=7373 AND end=7385 AND strand=1
          AND _seq='AAAAAAAAAAAAA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1), (SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0006002'
          LIMIT 1)
WHERE (SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0006002'
          LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM core_curation_siteinstance_experimental_techniques
    WHERE curation_siteinstance_id=(SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=7373 AND end=7385 AND strand=1
          AND _seq='AAAAAAAAAAAAA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1)
      AND experimentaltechnique_id=(SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0006002'
          LIMIT 1)
  );

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=7373 AND end=7385 AND strand=1
          AND _seq='AAAAAAAAAAAAA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00025' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00025' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=7373 AND end=7385 AND strand=1
          AND _seq='AAAAAAAAAAAAA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00045' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00045' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=7373 AND end=7385 AND strand=1
          AND _seq='AAAAAAAAAAAAA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00040' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00040' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=7373 AND end=7385 AND strand=1
          AND _seq='AAAAAAAAAAAAA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00035' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00035' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=7373 AND end=7385 AND strand=1
          AND _seq='AAAAAAAAAAAAA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00030' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00030' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_siteinstance (_seq, genome_id, start, end, strand)
SELECT
  'TTTTTTTTTTTTTTT',
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  65424,
  65438,
  -1
WHERE NOT EXISTS (
  SELECT 1 FROM core_siteinstance
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
    AND start=65424 AND end=65438 AND strand=-1
    AND _seq='TTTTTTTTTTTTTTT'
);

INSERT INTO core_curation_siteinstance
  (curation_id, site_instance_id, annotated_seq, quantitative_value, site_type, TF_function, TF_type)
VALUES
  ((SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1),
   (SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=65424 AND end=65438 AND strand=-1
          AND _seq='TTTTTTTTTTTTTTT'
        ORDER BY site_id DESC LIMIT 1),
   'TTTTTTTTTTTTTTT',
   0,
   'variable',
   'activator',
   'monomer');

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=65424 AND end=65438 AND strand=-1
          AND _seq='TTTTTTTTTTTTTTT'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00285' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00285' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=65424 AND end=65438 AND strand=-1
          AND _seq='TTTTTTTTTTTTTTT'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00290' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00290' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=65424 AND end=65438 AND strand=-1
          AND _seq='TTTTTTTTTTTTTTT'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00295' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00295' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=65424 AND end=65438 AND strand=-1
          AND _seq='TTTTTTTTTTTTTTT'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00300' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00300' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_siteinstance (_seq, genome_id, start, end, strand)
SELECT
  'GGGGGGGGGGGG',
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1),
  12961,
  12972,
  1
WHERE NOT EXISTS (
  SELECT 1 FROM core_siteinstance
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
    AND start=12961 AND end=12972 AND strand=1
    AND _seq='GGGGGGGGGGGG'
);

INSERT INTO core_curation_siteinstance
  (curation_id, site_instance_id, annotated_seq, quantitative_value, site_type, TF_function, TF_type)
VALUES
  ((SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1),
   (SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=12961 AND end=12972 AND strand=1
          AND _seq='GGGGGGGGGGGG'
        ORDER BY site_id DESC LIMIT 1),
   'GGGGGGGGGGGG',
   0,
   'variable',
   'activator',
   'monomer');

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=12961 AND end=12972 AND strand=1
          AND _seq='GGGGGGGGGGGG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00050' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00050' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=12961 AND end=12972 AND strand=1
          AND _seq='GGGGGGGGGGGG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00055' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00055' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42141772' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
          AND start=12961 AND end=12972 AND strand=1
          AND _seq='GGGGGGGGGGGG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00060' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='HI_RS00060' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000907.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

COMMIT;