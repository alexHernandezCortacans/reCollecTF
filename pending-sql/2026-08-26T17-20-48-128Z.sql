PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

INSERT INTO core_publication
  (publication_type, pmid, authors, title, journal, publication_date, url,
   contains_promoter_data, contains_expression_data, submission_notes, curation_complete,
   reported_TF, reported_species)
SELECT
  'pubmed',
  '39101802',
  'Lacoul A, Kirschen MP',
  'You Say Potato, I Say Potatoe: Seizure Prophylaxis After Pediatric Traumatic Brain Injury.',
  'Pediatric critical care medicine : a journal of the Society of Critical Care Medicine and the World Federation of Pediatric Intensive and Critical Care Societies',
  '2024 Aug 1',
  'https://doi.org/10.1097/PCC.0000000000003543',
  0,
  1,
  'Revision reason: Other reason (specify in notes)
Test Taxonomy 1:
Streptococcus australis',
  1,
  'Fur',
  'Streptococcus australis'
WHERE NOT EXISTS (
  SELECT 1 FROM core_publication WHERE pmid='39101802'
);

UPDATE core_publication
SET
  authors = CASE WHEN authors IS NULL OR authors='' THEN 'Lacoul A, Kirschen MP' ELSE authors END,
  title = CASE WHEN title IS NULL OR title='' THEN 'You Say Potato, I Say Potatoe: Seizure Prophylaxis After Pediatric Traumatic Brain Injury.' ELSE title END,
  journal = CASE WHEN journal IS NULL OR journal='' THEN 'Pediatric critical care medicine : a journal of the Society of Critical Care Medicine and the World Federation of Pediatric Intensive and Critical Care Societies' ELSE journal END,
  publication_date = CASE WHEN publication_date IS NULL OR publication_date='' THEN '2024 Aug 1' ELSE publication_date END,
  url = CASE WHEN url IS NULL OR url='' THEN 'https://doi.org/10.1097/PCC.0000000000003543' ELSE url END,
  reported_TF = CASE WHEN reported_TF IS NULL OR reported_TF='' THEN 'Fur' ELSE reported_TF END,
  reported_species = CASE WHEN reported_species IS NULL OR reported_species='' THEN 'Streptococcus australis' ELSE reported_species END,
  contains_promoter_data = 0,
  contains_expression_data = 1,
  curation_complete = 1,
  submission_notes = CASE
    WHEN submission_notes IS NULL OR submission_notes='' THEN 'Revision reason: Other reason (specify in notes)
Test Taxonomy 1:
Streptococcus australis'
    ELSE submission_notes
  END
WHERE pmid='39101802';

INSERT INTO core_tf (name, family_id, description)
SELECT 'Fur', 6, 'In E. coli and other prokaryotes, Fur (ferric uptake regulation) negatively regulates many genes involved in ferric iron uptake from the environment. Most Fur-regulated genes are derepressed in growth at low iron and are repressed under conditions of high iron, and in vitro DNA binding assays suggest that high levels of iron favor Fur association with DNA. Thus, Fur is considered to be an iron-dependent repressor. The classic binding motif for Fur is GATAATGATwATCATTATC, but studies have shown that Fur polymerizes at many operator sites to generate footprints that are not simple multiples of the 31 bp protected region. Further studies have revealed that Fur can even form helical arrays around the DNA strands [PMID::7991541],[PMID::12367523].'
WHERE NOT EXISTS (
  SELECT 1 FROM core_tf WHERE lower(name)=lower('Fur')
);

UPDATE core_tf
SET
  family_id = COALESCE(family_id, 6),
  description = CASE WHEN description IS NULL THEN 'In E. coli and other prokaryotes, Fur (ferric uptake regulation) negatively regulates many genes involved in ferric iron uptake from the environment. Most Fur-regulated genes are derepressed in growth at low iron and are repressed under conditions of high iron, and in vitro DNA binding assays suggest that high levels of iron favor Fur association with DNA. Thus, Fur is considered to be an iron-dependent repressor. The classic binding motif for Fur is GATAATGATwATCATTATC, but studies have shown that Fur polymerizes at many operator sites to generate footprints that are not simple multiples of the 31 bp protected region. Further studies have revealed that Fur can even form helical arrays around the DNA strands [PMID::7991541],[PMID::12367523].' ELSE description END
WHERE lower(name)=lower('Fur');

INSERT INTO core_tfinstance (refseq_accession, uniprot_accession, description, TF_id, notes, GO_term_id)
SELECT
  'WP_006595818.1',
  'E7SA24',
  'UDP-N-acetylmuramoyl-L-alanyl-D-glutamate--L-lysine ligase',
  (SELECT TF_id FROM core_tf WHERE lower(name)=lower('Fur') LIMIT 1),
  '',
  ''
WHERE NOT EXISTS (
  SELECT 1 FROM core_tfinstance WHERE uniprot_accession='E7SA24'
);

UPDATE core_tfinstance
SET
  TF_id = COALESCE(TF_id, (SELECT TF_id FROM core_tf WHERE lower(name)=lower('Fur') LIMIT 1)),
  refseq_accession = COALESCE(NULLIF(refseq_accession,''), 'WP_006595818.1'),
  description = COALESCE(NULLIF(description,''), 'UDP-N-acetylmuramoyl-L-alanyl-D-glutamate--L-lysine ligase'),
  notes = COALESCE(notes, ''),
  GO_term_id = COALESCE(GO_term_id, '')

WHERE uniprot_accession='E7SA24';

INSERT INTO core_curation
  (TF_species, site_species, experimental_process, forms_complex,
   complex_notes, notes, last_modified, curator_id, publication_id, created, validated_by_id)
VALUES
  ('Streptococcus australis', 'Streptococcus australis', NULL,
   0, NULL, 'Revision reason: Other reason (specify in notes)
Test Taxonomy 1:
Streptococcus australis',
   datetime('now'), (SELECT curator_id FROM core_curator ORDER BY curator_id LIMIT 1), (SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1), datetime('now'), NULL);

INSERT INTO core_curation_TF_instances (curation_id, tfinstance_id)
SELECT (SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1), (SELECT TF_instance_id FROM core_tfinstance WHERE uniprot_accession='E7SA24' LIMIT 1)
WHERE NOT EXISTS (
  SELECT 1 FROM core_curation_TF_instances
  WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1) AND tfinstance_id=(SELECT TF_instance_id FROM core_tfinstance WHERE uniprot_accession='E7SA24' LIMIT 1)
);

INSERT INTO core_genome (genome_accession, organism)
SELECT 'NZ_LR134285.1', 'Streptococcus australis'
WHERE NOT EXISTS (
  SELECT 1 FROM core_genome WHERE genome_accession='NZ_LR134285.1'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'DNA-binding protein WhiA',
  3,
  136,
  -1,
  'EL100_RS09725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404036.1',
  'YvcK family protein',
  133,
  1110,
  -1,
  'EL100_RS00010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rapZ',
  'RNase adapter RapZ',
  1107,
  2003,
  -1,
  'EL100_RS00015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404034.1',
  'RidA family protein',
  2115,
  2492,
  -1,
  'EL100_RS00020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596601.1',
  'hypothetical protein',
  2509,
  2670,
  -1,
  'EL100_RS00025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'obgE',
  'GTPase ObgE',
  2694,
  4007,
  -1,
  'EL100_RS00030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596603.1',
  'DUF4044 domain-containing protein',
  4053,
  4184,
  -1,
  'EL100_RS00035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011432.1',
  'hypothetical protein',
  4379,
  4462,
  -1,
  'EL100_RS09730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946462.1',
  'hypothetical protein',
  4615,
  4842,
  -1,
  'EL100_RS00045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011407.1',
  'collagen binding domain-containing protein',
  4899,
  5300,
  -1,
  'EL100_RS09735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011408.1',
  'Ig-like domain-containing protein',
  5364,
  5552,
  -1,
  'EL100_RS09740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011409.1',
  'hypothetical protein',
  5467,
  5844,
  -1,
  'EL100_RS09745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glmM',
  'phosphoglucosamine mutase',
  5887,
  7243,
  -1,
  'EL100_RS00055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404030.1',
  'CdaR family protein',
  7271,
  8011,
  -1,
  'EL100_RS00060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cdaA',
  'diadenylate cyclase CdaA',
  8008,
  8856,
  -1,
  'EL100_RS00065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'murT',
  'lipid II isoglutaminyl synthase subunit MurT',
  9037,
  10377,
  1,
  'EL100_RS00070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gatD',
  'lipid II isoglutaminyl synthase subunit GatD',
  10377,
  11165,
  1,
  'EL100_RS00075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048717218.1',
  'LapA family protein',
  11175,
  11465,
  1,
  'EL100_RS00080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404026.1',
  'MFS transporter',
  11759,
  12946,
  -1,
  'EL100_RS00085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404025.1',
  'MFS transporter',
  13057,
  14235,
  -1,
  'EL100_RS00090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404024.1',
  'XRE/MutR family transcriptional regulator',
  14259,
  15131,
  -1,
  'EL100_RS00095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404023.1',
  'ABC-F family ATP-binding cassettedomain-containing protein',
  15132,
  17039,
  -1,
  'EL100_RS00100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404022.1',
  'hypothetical protein',
  17122,
  17493,
  -1,
  'EL100_RS00105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404021.1',
  'matrixin family metalloprotease',
  17496,
  18215,
  -1,
  'EL100_RS00110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946472.1',
  'DNA/RNA non-specific endonuclease',
  18382,
  19194,
  -1,
  'EL100_RS00115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404019.1',
  'DNA-directed RNA polymerase subunit beta',
  19299,
  19487,
  -1,
  'EL100_RS00120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'murA',
  'UDP-N-acetylglucosamine1-carboxyvinyltransferase',
  19477,
  20760,
  -1,
  'EL100_RS00125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_040803274.1',
  'DUF1146 family protein',
  20827,
  21057,
  -1,
  'EL100_RS00130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596621.1',
  'F0F1 ATP synthase subunit epsilon',
  21144,
  21563,
  -1,
  'EL100_RS00135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'atpD',
  'F0F1 ATP synthase subunit beta',
  21577,
  22983,
  -1,
  'EL100_RS00140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596944.1',
  'F0F1 ATP synthase subunit gamma',
  23072,
  23953,
  -1,
  'EL100_RS00145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'atpA',
  'F0F1 ATP synthase subunit alpha',
  23969,
  25474,
  -1,
  'EL100_RS00150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404018.1',
  'F0F1 ATP synthase subunit delta',
  25490,
  26026,
  -1,
  'EL100_RS00155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'atpF',
  'F0F1 ATP synthase subunit B',
  26026,
  26520,
  -1,
  'EL100_RS00160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'atpB',
  'F0F1 ATP synthase subunit A',
  26536,
  27252,
  -1,
  'EL100_RS00165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596628.1',
  'F0F1 ATP synthase subunit C',
  27285,
  27485,
  -1,
  'EL100_RS00170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404015.1',
  'ZmpA/ZmpB/ZmpC family metallo-endopeptidase',
  27754,
  33693,
  -1,
  'EL100_RS00175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glgA',
  'glycogen synthase GlgA',
  33940,
  35367,
  -1,
  'EL100_RS00180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glgD',
  'glucose-1-phosphate adenylyltransferase subunitGlgD',
  35367,
  36503,
  -1,
  'EL100_RS00185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596633.1',
  'glucose-1-phosphate adenylyltransferase',
  36493,
  37635,
  -1,
  'EL100_RS00190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glgB',
  '1,4-alpha-glucan branching protein GlgB',
  37753,
  39654,
  -1,
  'EL100_RS00195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ptsP',
  'phosphoenolpyruvate--protein phosphotransferase',
  40042,
  41775,
  -1,
  'EL100_RS00200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596636.1',
  'phosphocarrier protein HPr',
  41778,
  42041,
  -1,
  'EL100_RS00205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nrdH',
  'glutaredoxin-like protein NrdH',
  42470,
  42688,
  1,
  'EL100_RS00210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nrdE',
  'class 1b ribonucleoside-diphosphate reductasesubunit alpha',
  42821,
  44980,
  1,
  'EL100_RS00215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nrdF',
  'class 1b ribonucleoside-diphosphate reductasesubunit beta',
  45103,
  46062,
  1,
  'EL100_RS00220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'alaS',
  'alanine--tRNA ligase',
  46323,
  48941,
  -1,
  'EL100_RS00225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_125374277.1',
  'LURP-one-related/scramblase family protein',
  48978,
  49460,
  -1,
  'EL100_RS00230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404007.1',
  'peptidylprolyl isomerase',
  49751,
  50692,
  -1,
  'EL100_RS00235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404006.1',
  'O-methyltransferase',
  50770,
  51483,
  -1,
  'EL100_RS00240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pepF',
  'oligoendopeptidase F',
  51485,
  53287,
  -1,
  'EL100_RS00245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404004.1',
  'competence protein CoiA',
  53357,
  54307,
  -1,
  'EL100_RS00250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404003.1',
  'hypothetical protein',
  54618,
  55172,
  -1,
  'EL100_RS00255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404002.1',
  'hypothetical protein',
  55338,
  55889,
  -1,
  'EL100_RS00260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404001.1',
  'D-alanyl-D-alanine carboxypeptidase familyprotein',
  56355,
  57644,
  -1,
  'EL100_RS00265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404000.1',
  'MFS transporter',
  57725,
  58888,
  -1,
  'EL100_RS00270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403999.1',
  'DUF1958 domain-containing protein',
  58961,
  60295,
  -1,
  'EL100_RS00275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403998.1',
  'glucosamine-6-phosphate deaminase',
  60403,
  61104,
  -1,
  'EL100_RS00280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'queA',
  'tRNA preQ1(34) S-adenosylmethionineribosyltransferase-isomerase QueA',
  61308,
  62336,
  1,
  'EL100_RS00285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596653.1',
  'arginine repressor',
  62349,
  62819,
  1,
  'EL100_RS00290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403997.1',
  'dipeptidase',
  62868,
  64208,
  -1,
  'EL100_RS00295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403996.1',
  'YfcC family protein',
  64228,
  65742,
  -1,
  'EL100_RS00300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'arcC',
  'carbamate kinase',
  65946,
  66890,
  -1,
  'EL100_RS00305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'argF',
  'ornithine carbamoyltransferase',
  66976,
  67992,
  -1,
  'EL100_RS00310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'arcA',
  'arginine deiminase',
  68085,
  69314,
  -1,
  'EL100_RS00315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403993.1',
  'Crp/Fnr family transcriptional regulator',
  69581,
  70267,
  -1,
  'EL100_RS00320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403992.1',
  'serine hydrolase',
  70412,
  71464,
  -1,
  'EL100_RS00325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403991.1',
  'helicase HerA-like domain-containing protein',
  71607,
  73079,
  -1,
  'EL100_RS00330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'sodA',
  'superoxide dismutase SodA',
  73332,
  73937,
  -1,
  'EL100_RS00335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'holA',
  'DNA polymerase III subunit delta',
  74009,
  75046,
  -1,
  'EL100_RS00340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403989.1',
  'DUF805 domain-containing protein',
  75024,
  75689,
  -1,
  'EL100_RS00345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403988.1',
  'DNA internalization-related competence proteinComEC/Rec2',
  75752,
  77992,
  -1,
  'EL100_RS00350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403987.1',
  'helix-hairpin-helix domain-containing protein',
  77976,
  78653,
  -1,
  'EL100_RS00355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403986.1',
  'lysophospholipid acyltransferase family protein',
  78757,
  79500,
  -1,
  'EL100_RS00360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403985.1',
  'cation-translocating P-type ATPase',
  79638,
  81977,
  1,
  'EL100_RS00365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403984.1',
  'tRNA1(Val) (adenine(37)-N6)-methyltransferase',
  82077,
  82823,
  1,
  'EL100_RS00370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403983.1',
  'GIY-YIG nuclease family protein',
  82813,
  83091,
  1,
  'EL100_RS00375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403982.1',
  'GNAT family N-acetyltransferase',
  83161,
  83799,
  -1,
  'EL100_RS00380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'lacD',
  'tagatose-bisphosphate aldolase',
  84049,
  85029,
  -1,
  'EL100_RS00385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403980.1',
  'tagatose-6-phosphate kinase',
  85031,
  85960,
  -1,
  'EL100_RS00390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'lacB',
  'galactose-6-phosphate isomerase subunit LacB',
  85972,
  86487,
  -1,
  'EL100_RS00395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'lacA',
  'galactose-6-phosphate isomerase subunit LacA',
  86504,
  86929,
  -1,
  'EL100_RS00400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403979.1',
  'aldose 1-epimerase family protein',
  86999,
  87883,
  -1,
  'EL100_RS00405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403978.1',
  'PTS transporter subunit IIC',
  87986,
  89461,
  -1,
  'EL100_RS00410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596935.1',
  'PTS sugar transporter subunit IIB',
  89558,
  89863,
  -1,
  'EL100_RS00415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403977.1',
  'PTS sugar transporter subunit IIA',
  89903,
  90379,
  -1,
  'EL100_RS00420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403976.1',
  'DeoR/GlpR family DNA-binding transcriptionregulator',
  90588,
  91334,
  -1,
  'EL100_RS00425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403975.1',
  'degradosome RNA helicase CshA',
  91661,
  93235,
  -1,
  'EL100_RS00430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048715581.1',
  'magnesium transporter CorA family protein',
  93930,
  94838,
  -1,
  'EL100_RS00435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596927.1',
  'PH domain-containing protein',
  94921,
  95301,
  -1,
  'EL100_RS00440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'thiT',
  'energy-coupled thiamine transporter ThiT',
  95609,
  96184,
  1,
  'EL100_RS00445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403973.1',
  'peptide chain release factor 3',
  96406,
  97950,
  -1,
  'EL100_RS00450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403972.1',
  'DUF2207 domain-containing protein',
  98153,
  100078,
  -1,
  'EL100_RS00455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596688.1',
  'YwaF family protein',
  100139,
  100819,
  -1,
  'EL100_RS00460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403971.1',
  'YwaF family protein',
  100832,
  101521,
  -1,
  'EL100_RS00465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403970.1',
  'YwaF family protein',
  101550,
  102251,
  -1,
  'EL100_RS00470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403969.1',
  'NUDIX hydrolase',
  102281,
  102892,
  -1,
  'EL100_RS00475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403968.1',
  'UDP-N-acetylmuramoyl-tripeptide--D-alanyl-D-alanine ligase',
  102882,
  104252,
  -1,
  'EL100_RS00480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403967.1',
  'D-alanine--D-alanine ligase',
  104341,
  105387,
  -1,
  'EL100_RS00485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'recR',
  'recombination mediator RecR',
  105561,
  106157,
  -1,
  'EL100_RS00490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pbp2b',
  'penicillin-binding protein PBP2B',
  106168,
  108249,
  -1,
  'EL100_RS00495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403965.1',
  'exodeoxyribonuclease III',
  108567,
  109394,
  1,
  'EL100_RS00500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403964.1',
  'bleomycin resistance protein',
  109406,
  109792,
  1,
  'EL100_RS00505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403962.1',
  'helix-turn-helix domain-containing protein',
  110234,
  110827,
  1,
  'EL100_RS00510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nth',
  'endonuclease III',
  110853,
  111482,
  -1,
  'EL100_RS00515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403961.1',
  '5''-methylthioadenosine/adenosylhomocysteinenucleosidase',
  111597,
  112289,
  -1,
  'EL100_RS00520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'macP',
  'cell wall synthase accessory phosphoproteinMacP',
  112317,
  112655,
  -1,
  'EL100_RS00525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_125335312.1',
  'NUDIX hydrolase',
  112667,
  113212,
  -1,
  'EL100_RS00530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glmU',
  'bifunctional UDP-N-acetylglucosaminediphosphorylase/glucosamine-1-phosphateN-acetyltransferase GlmU',
  113222,
  114601,
  -1,
  'EL100_RS00535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403959.1',
  'ASCH domain-containing protein',
  114983,
  115423,
  -1,
  'EL100_RS00540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403958.1',
  'putative PEP-binding protein',
  115368,
  116267,
  -1,
  'EL100_RS00545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403957.1',
  'GNAT family N-acetyltransferase',
  116309,
  117037,
  -1,
  'EL100_RS00550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403956.1',
  'NUDIX hydrolase',
  117045,
  117524,
  -1,
  'EL100_RS00555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403955.1',
  'DUF6707 family protein',
  117565,
  118170,
  -1,
  'EL100_RS00560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011410.1',
  'hypothetical protein',
  118230,
  118781,
  -1,
  'EL100_RS00565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403953.1',
  'SMI1/KNR4 family protein',
  118805,
  119392,
  -1,
  'EL100_RS00570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403952.1',
  'hypothetical protein',
  119457,
  119816,
  -1,
  'EL100_RS00575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403951.1',
  'DUF4304 domain-containing protein',
  119969,
  120523,
  -1,
  'EL100_RS00580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946463.1',
  'hypothetical protein',
  120575,
  120895,
  -1,
  'EL100_RS00585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403949.1',
  'hypothetical protein',
  120953,
  121339,
  -1,
  'EL100_RS00590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403948.1',
  'hypothetical protein',
  121429,
  122358,
  -1,
  'EL100_RS00595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403947.1',
  'NTF2 fold immunity protein',
  122447,
  122845,
  -1,
  'EL100_RS00600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403946.1',
  'hypothetical protein',
  122883,
  123446,
  -1,
  'EL100_RS00605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403945.1',
  'hypothetical protein',
  123501,
  123785,
  -1,
  'EL100_RS00610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403944.1',
  'hypothetical protein',
  123883,
  124323,
  -1,
  'EL100_RS00615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011411.1',
  'hypothetical protein',
  124337,
  124876,
  -1,
  'EL100_RS00620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403942.1',
  'Imm50 family immunity protein',
  125308,
  125697,
  -1,
  'EL100_RS00625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403941.1',
  'hypothetical protein',
  125772,
  126398,
  -1,
  'EL100_RS00630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011412.1',
  'Imm26 family immunity protein',
  126410,
  126817,
  -1,
  'EL100_RS00635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403939.1',
  'immunity protein',
  126948,
  127508,
  -1,
  'EL100_RS00640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403938.1',
  'hypothetical protein',
  127505,
  127912,
  -1,
  'EL100_RS00645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011413.1',
  'hypothetical protein',
  127956,
  128345,
  -1,
  'EL100_RS00650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405030.1',
  'DUF7716 domain-containing protein',
  128398,
  128736,
  -1,
  'EL100_RS00655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403937.1',
  '3-oxoacyl-ACP reductase',
  129160,
  129858,
  -1,
  'EL100_RS00660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_000141913.1',
  'DUF2829 domain-containing protein',
  129851,
  130087,
  -1,
  'EL100_RS00665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403936.1',
  'hypothetical protein',
  130188,
  131018,
  -1,
  'EL100_RS00670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403935.1',
  'PadR family transcriptional regulator',
  131015,
  131344,
  -1,
  'EL100_RS00675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'peptide ABC transporter substrate-bindingprotein',
  131581,
  133545,
  1,
  'EL100_RS00680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403934.1',
  'FtsX-like permease family protein',
  133704,
  135707,
  -1,
  'EL100_RS00685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403933.1',
  'ABC transporter ATP-binding protein',
  135700,
  136467,
  -1,
  'EL100_RS00690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003006102.1',
  'SemiSWEET family transporter',
  136643,
  136900,
  -1,
  'EL100_RS00695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403932.1',
  'FtsX-like permease family protein',
  137058,
  139043,
  -1,
  'EL100_RS00700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403931.1',
  'ABC transporter ATP-binding protein',
  139044,
  139802,
  -1,
  'EL100_RS00705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023022528.1',
  'hypothetical protein',
  139818,
  139946,
  -1,
  'EL100_RS09830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403930.1',
  'sensor histidine kinase',
  140105,
  141079,
  -1,
  'EL100_RS00710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403929.1',
  'response regulator transcription factor',
  141072,
  141749,
  -1,
  'EL100_RS00715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403928.1',
  'DUF2974 domain-containing protein',
  141933,
  143117,
  1,
  'EL100_RS00720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403927.1',
  'DUF6287 domain-containing protein',
  143253,
  144521,
  -1,
  'EL100_RS00725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403926.1',
  'DUF2975 domain-containing protein',
  144696,
  145217,
  1,
  'EL100_RS00730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023022515.1',
  'helix-turn-helix domain-containing protein',
  145228,
  145434,
  1,
  'EL100_RS00735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'metG',
  'methionine--tRNA ligase',
  145812,
  147803,
  -1,
  'EL100_RS00740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_002896114.1',
  'phosphoglycerate mutase',
  147960,
  148652,
  -1,
  'EL100_RS00745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403924.1',
  'hypothetical protein',
  148826,
  149353,
  -1,
  'EL100_RS00750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403923.1',
  'hypothetical protein',
  149356,
  150156,
  -1,
  'EL100_RS00755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403922.1',
  'hypothetical protein',
  150146,
  151126,
  -1,
  'EL100_RS00760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403921.1',
  'hypothetical protein',
  151263,
  151778,
  -1,
  'EL100_RS00765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555430.1',
  'hypothetical protein',
  151781,
  152575,
  -1,
  'EL100_RS00770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403920.1',
  'hypothetical protein',
  152565,
  153542,
  -1,
  'EL100_RS00775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403919.1',
  'Fur family transcriptional regulator',
  153666,
  154124,
  -1,
  'EL100_RS00780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596761.1',
  'hypothetical protein',
  154402,
  154557,
  -1,
  'EL100_RS00785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596762.1',
  'non-specific DNA-binding protein Hbs',
  154677,
  154952,
  -1,
  'EL100_RS00790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403918.1',
  'DegV family protein',
  155087,
  155920,
  -1,
  'EL100_RS00795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403917.1',
  'metallophosphoesterase',
  156004,
  156735,
  -1,
  'EL100_RS00800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'recN',
  'DNA repair protein RecN',
  156752,
  158416,
  -1,
  'EL100_RS00805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596766.1',
  'arginine repressor',
  158424,
  158855,
  -1,
  'EL100_RS00810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403915.1',
  'TlyA family RNA methyltransferase',
  158848,
  159663,
  -1,
  'EL100_RS00815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403914.1',
  'polyprenyl synthetase family protein',
  159644,
  160531,
  -1,
  'EL100_RS00820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596769.1',
  'exodeoxyribonuclease VII small subunit',
  160528,
  160740,
  -1,
  'EL100_RS00825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'xseA',
  'exodeoxyribonuclease VII large subunit',
  160718,
  162058,
  -1,
  'EL100_RS00830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403912.1',
  'NAD(P)H-hydrate dehydratase',
  162171,
  163025,
  -1,
  'EL100_RS00835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555429.1',
  'bifunctional methylenetetrahydrofolatedehydrogenase/methenyltetrahydrofolate cyclohydrolase',
  163158,
  164012,
  -1,
  'EL100_RS00840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596773.1',
  'DUF1797 family protein',
  164169,
  164399,
  -1,
  'EL100_RS00845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403910.1',
  'ATP-dependent Clp protease ATP-binding subunit',
  164629,
  166896,
  1,
  'EL100_RS00850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403909.1',
  'NUDIX hydrolase',
  167156,
  167605,
  1,
  'EL100_RS00855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596776.1',
  'DUF1827 family protein',
  167673,
  167975,
  1,
  'EL100_RS00860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403908.1',
  'GNAT family N-acetyltransferase',
  168056,
  168490,
  -1,
  'EL100_RS00865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ileS',
  'isoleucine--tRNA ligase',
  168551,
  171343,
  -1,
  'EL100_RS00870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403906.1',
  'DivIVA domain-containing protein',
  171602,
  172471,
  -1,
  'EL100_RS00875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403905.1',
  'YlmH family RNA-binding protein',
  172481,
  173269,
  -1,
  'EL100_RS00880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403904.1',
  'YggT family protein',
  173266,
  173526,
  -1,
  'EL100_RS00885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403903.1',
  'cell division protein SepF',
  173528,
  174157,
  -1,
  'EL100_RS00890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403902.1',
  'YggS family pyridoxal phosphate-dependentenzyme',
  174167,
  174835,
  -1,
  'EL100_RS00895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ftsZ',
  'cell division protein FtsZ',
  174838,
  176115,
  -1,
  'EL100_RS00900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ftsA',
  'cell division protein FtsA',
  176131,
  177483,
  -1,
  'EL100_RS00905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403899.1',
  'cell division protein FtsQ/DivIB',
  177625,
  178836,
  -1,
  'EL100_RS00910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403898.1',
  'UDP-N-acetylglucosamine--N-acetylmuramyl-(pentapeptide) pyrophosphoryl-undecaprenolN-acetylglucosamine transferase',
  178833,
  179903,
  -1,
  'EL100_RS00915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'murD',
  'UDP-N-acetylmuramoyl-L-alanine--D-glutamateligase',
  179905,
  181257,
  -1,
  'EL100_RS00920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403896.1',
  'DUF3165 family protein',
  181439,
  181705,
  -1,
  'EL100_RS00925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'typA',
  'translational GTPase TypA',
  181728,
  183575,
  -1,
  'EL100_RS00930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403894.1',
  '16S rRNA pseudouridine(516) synthase',
  183813,
  184538,
  1,
  'EL100_RS00935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006597131.1',
  'hypothetical protein',
  184576,
  184809,
  -1,
  'EL100_RS00940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048687808.1',
  'rhodanese-like domain-containing protein',
  184884,
  185228,
  -1,
  'EL100_RS00945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403893.1',
  'YqgQ family protein',
  185267,
  185485,
  -1,
  'EL100_RS00950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596795.1',
  'Dps family protein',
  185610,
  186137,
  -1,
  'EL100_RS00955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403892.1',
  'prepilin peptidase',
  186291,
  186950,
  1,
  'EL100_RS00960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trpB',
  'tryptophan synthase subunit beta',
  186957,
  188144,
  -1,
  'EL100_RS00965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946464.1',
  'VanZ family protein',
  188582,
  189115,
  -1,
  'EL100_RS00970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rlmN',
  'dual-specificity RNA methyltransferase RlmN',
  189093,
  190181,
  -1,
  'EL100_RS00975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403889.1',
  'YutD family protein',
  190200,
  190778,
  -1,
  'EL100_RS00980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403888.1',
  'cache domain-containing sensor histidine kinase',
  191461,
  193179,
  -1,
  'EL100_RS00985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403887.1',
  'response regulator transcription factor',
  193176,
  193910,
  -1,
  'EL100_RS00990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'msrB',
  'peptide-methionine (R)-S-oxide reductase MsrB',
  193969,
  195090,
  -1,
  'EL100_RS00995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS00995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403885.1',
  'redoxin domain-containing protein',
  195103,
  195663,
  -1,
  'EL100_RS01000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403884.1',
  'hypothetical protein',
  195732,
  196052,
  -1,
  'EL100_RS01005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ccdA2',
  'thiol-disulfide oxidoreductase-associatedmembrane protein CcdA2',
  196079,
  196789,
  -1,
  'EL100_RS01010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011422.1',
  'SepM family pheromone-processing serineprotease',
  196951,
  197961,
  -1,
  'EL100_RS01015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'coaD',
  'pantetheine-phosphate adenylyltransferase',
  198063,
  198536,
  -1,
  'EL100_RS01020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rsmD',
  '16S rRNA (guanine(966)-N(2))-methyltransferaseRsmD',
  198526,
  199065,
  -1,
  'EL100_RS01025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403880.1',
  'helix-turn-helix domain-containing protein',
  199248,
  199925,
  1,
  'EL100_RS01030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403879.1',
  'Y-family DNA polymerase',
  199928,
  201340,
  1,
  'EL100_RS01035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403878.1',
  'hypothetical protein',
  201337,
  201708,
  1,
  'EL100_RS01040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403877.1',
  'DUF5960 family protein',
  201689,
  201994,
  1,
  'EL100_RS01045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403876.1',
  'hypothetical protein',
  202016,
  203605,
  -1,
  'EL100_RS01050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dcm',
  'DNA cytosine methyltransferase',
  203683,
  204903,
  -1,
  'EL100_RS01055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403874.1',
  'hypothetical protein',
  204982,
  209457,
  -1,
  'EL100_RS01060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403873.1',
  'valine--tRNA ligase',
  209533,
  212184,
  -1,
  'EL100_RS01065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403872.1',
  'hypothetical protein',
  212357,
  212884,
  -1,
  'EL100_RS01070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403871.1',
  'GNAT family N-acetyltransferase',
  213553,
  214119,
  -1,
  'EL100_RS01075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403870.1',
  'flavin reductase family protein',
  214106,
  214684,
  -1,
  'EL100_RS01080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403869.1',
  'helix-hairpin-helix domain-containing protein',
  215064,
  215411,
  -1,
  'EL100_RS01085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403868.1',
  'DUF1912 family protein',
  215593,
  215847,
  -1,
  'EL100_RS01090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403867.1',
  'DUF438 domain-containing protein',
  215850,
  217196,
  -1,
  'EL100_RS01095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403866.1',
  'DUF1858 domain-containing protein',
  217196,
  217429,
  -1,
  'EL100_RS01100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rlmD',
  '23S rRNA (uracil(1939)-C(5))-methyltransferaseRlmD',
  217562,
  218917,
  -1,
  'EL100_RS01105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'recX',
  'recombination regulator RecX',
  219076,
  219852,
  1,
  'EL100_RS01110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ntdP',
  'nucleoside tri-diphosphate phosphatase',
  219938,
  220471,
  1,
  'EL100_RS01115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048690403.1',
  'DUF960 domain-containing protein',
  220571,
  220888,
  1,
  'EL100_RS01120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  220958,
  221031,
  -1,
  'EL100_RS01125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  221051,
  221124,
  -1,
  'EL100_RS01130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  221161,
  221234,
  -1,
  'EL100_RS01135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  221256,
  221341,
  -1,
  'EL100_RS01140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  221349,
  221420,
  -1,
  'EL100_RS01145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  221444,
  221516,
  -1,
  'EL100_RS01150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  221534,
  221615,
  -1,
  'EL100_RS01155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  221621,
  221693,
  -1,
  'EL100_RS01160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  221725,
  221797,
  -1,
  'EL100_RS01165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  221800,
  221872,
  -1,
  'EL100_RS01170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rrf',
  '—',
  222004,
  222119,
  -1,
  'EL100_RS01175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  222200,
  225099,
  -1,
  'EL100_RS01180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  225228,
  225300,
  -1,
  'EL100_RS01185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  225354,
  226902,
  -1,
  'EL100_RS01190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'hpf',
  'ribosome hibernation-promoting factor, HPF/YfiAfamily',
  227197,
  227742,
  -1,
  'EL100_RS01195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011414.1',
  'ComF family protein',
  227831,
  228436,
  -1,
  'EL100_RS01200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403862.1',
  'ATP-dependent helicase ComFA',
  228499,
  229797,
  -1,
  'EL100_RS01205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403861.1',
  'YigZ family protein',
  229853,
  230485,
  1,
  'EL100_RS01210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cysK',
  'cysteine synthase A',
  230577,
  231506,
  1,
  'EL100_RS01215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403859.1',
  'S1 RNA-binding domain-containing protein',
  231558,
  231926,
  -1,
  'EL100_RS01220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403858.1',
  'bifunctional Cof-type HAD-IIB familyhydrolase/peptidylprolyl isomerase',
  231923,
  233329,
  -1,
  'EL100_RS01225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403857.1',
  'response regulator transcription factor',
  233373,
  234005,
  -1,
  'EL100_RS01230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403856.1',
  'envelope stress sensor histidine kinase LiaS',
  233983,
  235002,
  -1,
  'EL100_RS01235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'liaF',
  'cell wall-active antibiotics response proteinLiaF',
  234999,
  235694,
  -1,
  'EL100_RS01240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pknB',
  'Stk1 family PASTA domain-containing Ser/Thrkinase',
  235825,
  237696,
  -1,
  'EL100_RS01245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048691932.1',
  'Stp1/IreP family PP2C-type Ser/Thr phosphatase',
  237693,
  238433,
  -1,
  'EL100_RS01250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rsmB',
  '16S rRNA (cytosine(967)-C(5))-methyltransferaseRsmB',
  238455,
  239768,
  -1,
  'EL100_RS01255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'fmt',
  'methionyl-tRNA formyltransferase',
  239758,
  240693,
  -1,
  'EL100_RS01260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403851.1',
  'primosomal protein N''',
  240705,
  243095,
  -1,
  'EL100_RS01265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpoZ',
  'DNA-directed RNA polymerase subunit omega',
  243158,
  243472,
  -1,
  'EL100_RS01270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gmk',
  'guanylate kinase',
  243501,
  244130,
  -1,
  'EL100_RS01275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403849.1',
  'ribonuclease Y',
  244327,
  245934,
  -1,
  'EL100_RS01280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403848.1',
  'S-ribosylhomocysteine lyase',
  246206,
  246688,
  1,
  'EL100_RS01285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403847.1',
  'cell division site-positioning protein MapZfamily protein',
  247007,
  248446,
  -1,
  'EL100_RS01290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403846.1',
  'THUMP domain-containing class I SAM-dependentRNA methyltransferase',
  248443,
  249615,
  -1,
  'EL100_RS01295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rnpB',
  '—',
  249680,
  250045,
  -1,
  'EL100_RS01300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gpsB',
  'cell division regulator GpsB',
  250067,
  250411,
  -1,
  'EL100_RS01305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006597078.1',
  'SLOG family protein',
  250481,
  251008,
  -1,
  'EL100_RS01310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'recU',
  'Holliday junction resolvase RecU',
  251075,
  251668,
  1,
  'EL100_RS01315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pbp1a',
  'penicillin-binding protein PBP1A',
  251669,
  253786,
  1,
  'EL100_RS01320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pepC',
  'aminopeptidase C',
  253848,
  255185,
  -1,
  'EL100_RS01325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403843.1',
  'GNAT family N-acetyltransferase',
  255254,
  255805,
  -1,
  'EL100_RS01330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nadE',
  'NAD(+) synthase',
  255862,
  256686,
  -1,
  'EL100_RS01335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403841.1',
  'nicotinate phosphoribosyltransferase',
  256683,
  258140,
  -1,
  'EL100_RS01340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trxB',
  'thioredoxin-disulfide reductase',
  258342,
  259256,
  -1,
  'EL100_RS01345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403839.1',
  'DUF4059 family protein',
  259315,
  259542,
  -1,
  'EL100_RS01350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403838.1',
  'amino acid ABC transporter ATP-binding protein',
  259737,
  260480,
  -1,
  'EL100_RS01355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048715261.1',
  'amino acid ABC transporter permease',
  260477,
  261283,
  -1,
  'EL100_RS01360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403837.1',
  'DEAD/DEAH box helicase',
  261508,
  262851,
  -1,
  'EL100_RS01365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mraY',
  'phospho-N-acetylmuramoyl-pentapeptide-transferase',
  262979,
  263980,
  -1,
  'EL100_RS01370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pbp2x',
  'penicillin-binding protein PBP2X',
  263982,
  266267,
  -1,
  'EL100_RS01375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ftsL',
  'cell division protein FtsL',
  266260,
  266595,
  -1,
  'EL100_RS01380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rsmH',
  '16S rRNA (cytosine(1402)-N(4))-methyltransferaseRsmH',
  266608,
  267558,
  -1,
  'EL100_RS01385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023920274.1',
  'DUF896 family protein',
  267954,
  268211,
  -1,
  'EL100_RS01390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glyS',
  'glycine--tRNA ligase subunit beta',
  268245,
  270281,
  -1,
  'EL100_RS01395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glyQ',
  'glycine--tRNA ligase subunit alpha',
  270488,
  271405,
  -1,
  'EL100_RS01400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403830.1',
  'S8 family serine peptidase',
  272082,
  276572,
  -1,
  'EL100_RS01405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403829.1',
  'aldo/keto reductase',
  276820,
  277662,
  -1,
  'EL100_RS01410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006597076.1',
  'hypothetical protein',
  277664,
  277891,
  -1,
  'EL100_RS01415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nagA',
  'N-acetylglucosamine-6-phosphate deacetylase',
  278069,
  279220,
  -1,
  'EL100_RS01420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403827.1',
  'Na/Pi cotransporter family protein',
  279674,
  281305,
  -1,
  'EL100_RS01425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rbfA',
  '30S ribosome-binding factor RbfA',
  281450,
  281800,
  -1,
  'EL100_RS01430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'infB',
  'translation initiation factor IF-2',
  281874,
  283871,
  -1,
  'EL100_RS01435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'translation initiation factor IF-2 N-terminaldomain-containing protein',
  283943,
  284597,
  -1,
  'EL100_RS09885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403824.1',
  'YlxQ-related RNA-binding protein',
  284614,
  284913,
  -1,
  'EL100_RS01440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rnpM',
  'RNase P modulator RnpM',
  284906,
  285202,
  -1,
  'EL100_RS01445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nusA',
  'transcription termination factor NusA',
  285213,
  286358,
  -1,
  'EL100_RS01450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rimP',
  'ribosome maturation factor RimP',
  286404,
  286892,
  -1,
  'EL100_RS01455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trmB',
  'tRNA (guanosine(46)-N7)-methyltransferase TrmB',
  287058,
  287693,
  -1,
  'EL100_RS01460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ccrZ',
  'cell cycle regulator CcrZ',
  287690,
  288484,
  -1,
  'EL100_RS01465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403821.1',
  'ABC transporter permease',
  288525,
  289580,
  -1,
  'EL100_RS01470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403820.1',
  'ABC transporter ATP-binding protein',
  289577,
  290308,
  -1,
  'EL100_RS01475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403819.1',
  'HIT family protein',
  290376,
  290789,
  1,
  'EL100_RS01480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403818.1',
  'hypothetical protein',
  290803,
  291099,
  1,
  'EL100_RS01485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'lytR',
  'glycopolymer--peptidoglycan transferase LytR',
  291158,
  292330,
  -1,
  'EL100_RS01490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403816.1',
  'GNAT family N-acetyltransferase',
  292327,
  292860,
  -1,
  'EL100_RS01495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tsaE',
  'tRNA(adenosine(37)-N6)-threonylcarbamoyltransferase complexATPase subunit type 1 TsaE',
  292863,
  293312,
  -1,
  'EL100_RS01500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403814.1',
  'NCS2 family permease',
  293434,
  294855,
  -1,
  'EL100_RS01505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403813.1',
  'Cof-type HAD-IIB family hydrolase',
  295120,
  295932,
  1,
  'EL100_RS01510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'adhP',
  'alcohol dehydrogenase AdhP',
  296223,
  297245,
  1,
  'EL100_RS01515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403811.1',
  'PTS sugar transporter subunit IIB',
  297592,
  298581,
  1,
  'EL100_RS01520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048789380.1',
  'PTS mannose/fructose/sorbose transporter subunitIIC',
  298609,
  299412,
  1,
  'EL100_RS01525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403810.1',
  'PTS system mannose/fructose/sorbose familytransporter subunit IID',
  299431,
  300342,
  1,
  'EL100_RS01530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_061564764.1',
  'DUF956 family protein',
  300423,
  300791,
  1,
  'EL100_RS01535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'serS',
  'serine--tRNA ligase',
  301009,
  302286,
  1,
  'EL100_RS01540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_061564762.1',
  'acetyl-CoA carboxylase carboxyl transferasesubunit alpha',
  302329,
  303099,
  -1,
  'EL100_RS01545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'accD',
  'acetyl-CoA carboxylase, carboxyltransferasesubunit beta',
  303099,
  303959,
  -1,
  'EL100_RS01550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048715214.1',
  'acetyl-CoA carboxylase biotin carboxylasesubunit',
  304048,
  305415,
  -1,
  'EL100_RS01555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'fabZ',
  '3-hydroxyacyl-ACP dehydratase FabZ',
  305426,
  305848,
  -1,
  'EL100_RS01560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'accB',
  'acetyl-CoA carboxylase biotin carboxyl carrierprotein',
  305845,
  306333,
  -1,
  'EL100_RS01565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'fabF',
  'beta-ketoacyl-ACP synthase II',
  306335,
  307567,
  -1,
  'EL100_RS01570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'fabG',
  '3-oxoacyl-[acyl-carrier-protein] reductase',
  307586,
  308320,
  -1,
  'EL100_RS01575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'fabD',
  'ACP S-malonyltransferase',
  308333,
  309253,
  -1,
  'EL100_RS01580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'fabK',
  'enoyl-[acyl-carrier-protein] reductase FabK',
  309283,
  310248,
  -1,
  'EL100_RS01585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003003892.1',
  'acyl carrier protein',
  310359,
  310583,
  -1,
  'EL100_RS01590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403808.1',
  'beta-ketoacyl-ACP synthase III',
  310638,
  311612,
  -1,
  'EL100_RS01595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'fabT',
  'fatty acid biosynthesis transcriptionalregulator FabT',
  311612,
  312046,
  -1,
  'EL100_RS01600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403807.1',
  'enoyl-CoA hydratase',
  312145,
  312936,
  -1,
  'EL100_RS01605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403806.1',
  'aspartate kinase',
  313150,
  314499,
  1,
  'EL100_RS01610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  314571,
  314644,
  -1,
  'EL100_RS01615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rrf',
  '—',
  314650,
  314765,
  -1,
  'EL100_RS01620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  314846,
  317745,
  -1,
  'EL100_RS01625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  317875,
  317947,
  -1,
  'EL100_RS01630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  318001,
  319549,
  -1,
  'EL100_RS01635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048714745.1',
  'ATP-binding cassette domain-containing protein',
  319815,
  320738,
  -1,
  'EL100_RS01640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403805.1',
  'ABC transporter ATP-binding protein',
  320748,
  321815,
  -1,
  'EL100_RS01645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'oppC',
  'oligopeptide ABC transporter permease OppC',
  321827,
  322753,
  -1,
  'EL100_RS01650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403804.1',
  'ABC transporter permease',
  322753,
  324252,
  -1,
  'EL100_RS01655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403803.1',
  'peptide ABC transporter substrate-bindingprotein',
  324317,
  326302,
  -1,
  'EL100_RS01660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403802.1',
  'peptide ABC transporter substrate-bindingprotein',
  326483,
  328447,
  -1,
  'EL100_RS01665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pbp3',
  'D-alanyl-D-alanine carboxypeptidase PBP3',
  328622,
  329863,
  1,
  'EL100_RS01670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403800.1',
  'hypothetical protein',
  329929,
  330501,
  -1,
  'EL100_RS01675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'sufB',
  'Fe-S cluster assembly protein SufB',
  330522,
  331934,
  -1,
  'EL100_RS01680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'sufU',
  'Fe-S cluster assembly sulfur transfer proteinSufU',
  332080,
  332514,
  -1,
  'EL100_RS01685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403798.1',
  'cysteine desulfurase',
  332501,
  333727,
  -1,
  'EL100_RS01690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'sufD',
  'Fe-S cluster assembly protein SufD',
  333730,
  334992,
  -1,
  'EL100_RS01695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'sufC',
  'Fe-S cluster assembly ATPase SufC',
  335034,
  335804,
  -1,
  'EL100_RS01700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403795.1',
  'glycosyltransferase family 4 protein',
  335891,
  337048,
  -1,
  'EL100_RS01705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mecA',
  'adaptor protein MecA',
  337045,
  337791,
  -1,
  'EL100_RS01710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403793.1',
  'undecaprenyl-diphosphate phosphatase',
  337959,
  338795,
  -1,
  'EL100_RS01715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403792.1',
  'DUF2207 domain-containing protein',
  338955,
  340862,
  -1,
  'EL100_RS01720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403791.1',
  'ABC transporter substrate-bindingprotein/permease',
  340982,
  342544,
  1,
  'EL100_RS01725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403790.1',
  'amino acid ABC transporter ATP-binding protein',
  342544,
  343284,
  1,
  'EL100_RS01730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006594972.1',
  'capsule biosynthesis transcriptional regulator',
  343480,
  343695,
  -1,
  'EL100_RS01735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403789.1',
  'SPFH domain-containing protein',
  343805,
  344692,
  -1,
  'EL100_RS01740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ilvA',
  'threonine ammonia-lyase IlvA',
  344754,
  346004,
  -1,
  'EL100_RS01745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ilvC',
  'ketol-acid reductoisomerase',
  346220,
  347242,
  -1,
  'EL100_RS01750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ilvN',
  'acetolactate synthase small subunit',
  347310,
  347786,
  -1,
  'EL100_RS01755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403788.1',
  'acetolactate synthase large subunit',
  347779,
  349479,
  -1,
  'EL100_RS01760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403787.1',
  'response regulator transcription factor',
  349666,
  350265,
  -1,
  'EL100_RS01765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403786.1',
  'sensor histidine kinase',
  350267,
  351364,
  -1,
  'EL100_RS01770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003004324.1',
  'ABC transporter permease',
  351361,
  352101,
  -1,
  'EL100_RS01775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403785.1',
  'ABC transporter ATP-binding protein',
  352070,
  352987,
  -1,
  'EL100_RS01780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403784.1',
  'hypothetical protein',
  352974,
  353171,
  -1,
  'EL100_RS01785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023027681.1',
  'hypothetical protein',
  353168,
  353359,
  -1,
  'EL100_RS01790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403783.1',
  'SP0191 family lipoprotein',
  353486,
  354055,
  -1,
  'EL100_RS01795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403782.1',
  'DAK2 domain-containing protein',
  354217,
  355881,
  -1,
  'EL100_RS01800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006594986.1',
  'Asp23/Gls24 family envelope stress responseprotein',
  355884,
  356249,
  -1,
  'EL100_RS01805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpmB',
  '50S ribosomal protein L28',
  356405,
  356593,
  -1,
  'EL100_RS01810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_125330080.1',
  'LiaF transmembrane domain-containing protein',
  356712,
  357407,
  -1,
  'EL100_RS01815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048788766.1',
  'LytTR family DNA-binding domain-containingprotein',
  357412,
  357858,
  -1,
  'EL100_RS01820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403781.1',
  'hypothetical protein',
  358036,
  358347,
  -1,
  'EL100_RS01825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003013947.1',
  'ABC transporter permease',
  358867,
  359652,
  -1,
  'EL100_RS01830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003013825.1',
  'ABC transporter permease',
  359654,
  360448,
  -1,
  'EL100_RS01835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003010129.1',
  'ABC transporter ATP-binding protein',
  360445,
  361431,
  -1,
  'EL100_RS01840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003010127.1',
  'hypothetical protein',
  361424,
  361627,
  -1,
  'EL100_RS01845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_227223595.1',
  'hypothetical protein',
  362298,
  362582,
  -1,
  'EL100_RS01850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_264081591.1',
  'hypothetical protein',
  362652,
  362786,
  -1,
  'EL100_RS09835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cadX',
  'Cd(II)/Zn(II)-sensing metalloregulatorytranscriptional regulator CadX',
  362830,
  363168,
  -1,
  'EL100_RS01855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_002911684.1',
  'CadD family cadmium resistance transporter',
  363180,
  363794,
  -1,
  'EL100_RS01860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403779.1',
  'heavy metal translocating P-type ATPase',
  364440,
  366593,
  -1,
  'EL100_RS01865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_002908710.1',
  'CopY/TcrY family copper transport repressor',
  366613,
  367062,
  -1,
  'EL100_RS01870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  367464,
  367536,
  -1,
  'EL100_RS01875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'GNAT family N-acetyltransferase',
  367584,
  368045,
  -1,
  'EL100_RS09750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403777.1',
  'ABC transporter permease',
  368084,
  368869,
  -1,
  'EL100_RS01890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403776.1',
  'ABC transporter permease',
  368871,
  369689,
  -1,
  'EL100_RS01895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403775.1',
  'ABC transporter ATP-binding protein',
  369691,
  370683,
  -1,
  'EL100_RS01900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'alpha/beta fold hydrolase',
  371043,
  371975,
  -1,
  'EL100_RS01905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403773.1',
  'hypothetical protein',
  372370,
  372681,
  -1,
  'EL100_RS01910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_070590689.1',
  'hypothetical protein',
  372773,
  372979,
  -1,
  'EL100_RS01915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403772.1',
  'hypothetical protein',
  373001,
  373342,
  -1,
  'EL100_RS01920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403771.1',
  'hypothetical protein',
  373370,
  373609,
  -1,
  'EL100_RS01925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403770.1',
  'helix-turn-helix transcriptional regulator',
  373892,
  374314,
  1,
  'EL100_RS09875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403769.1',
  'DUF1097 domain-containing protein',
  374695,
  376230,
  -1,
  'EL100_RS01935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403768.1',
  'protein NO VEIN domain-containing protein',
  376491,
  376823,
  -1,
  'EL100_RS01940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403767.1',
  'phospholipase D-like domain-containing protein',
  376850,
  377176,
  -1,
  'EL100_RS01945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048789867.1',
  'class II fructose-bisphosphate aldolase',
  377366,
  378247,
  -1,
  'EL100_RS01950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403766.1',
  'hypothetical protein',
  378441,
  378893,
  -1,
  'EL100_RS01955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  378975,
  379060,
  -1,
  'EL100_RS01960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_117744905.1',
  'B3/B4 domain-containing protein',
  379224,
  379919,
  -1,
  'EL100_RS01965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpoE',
  'DNA-directed RNA polymerase subunit delta',
  380183,
  380761,
  -1,
  'EL100_RS01970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tig',
  'trigger factor',
  380979,
  382262,
  -1,
  'EL100_RS01975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403765.1',
  'TIGR01440 family protein',
  382481,
  383044,
  -1,
  'EL100_RS01980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048691530.1',
  'ECF transporter S component',
  383048,
  383518,
  -1,
  'EL100_RS01985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403764.1',
  'bifunctional hydroxymethylpyrimidinekinase/phosphomethylpyrimidine kinase',
  383508,
  384269,
  -1,
  'EL100_RS01990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'truA',
  'tRNA pseudouridine(38-40) synthase TruA',
  384259,
  385008,
  -1,
  'EL100_RS01995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS01995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403762.1',
  'family 20 glycosylhydrolase',
  385154,
  388720,
  -1,
  'EL100_RS02000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048691540.1',
  'aminopeptidase',
  389400,
  390641,
  -1,
  'EL100_RS02005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023022162.1',
  'hypothetical protein',
  390660,
  390809,
  -1,
  'EL100_RS02010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403761.1',
  'DUF8309 domain-containing protein',
  390806,
  391501,
  -1,
  'EL100_RS02015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403760.1',
  'PolC-type DNA polymerase III',
  391539,
  395930,
  -1,
  'EL100_RS02020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946465.1',
  'DUF1307 domain-containing protein',
  396098,
  396643,
  1,
  'EL100_RS02025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403759.1',
  'hypothetical protein',
  396752,
  397219,
  1,
  'EL100_RS02030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403758.1',
  'proline--tRNA ligase',
  397430,
  399280,
  -1,
  'EL100_RS02035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rseP',
  'RIP metalloprotease RseP',
  399298,
  400557,
  -1,
  'EL100_RS02040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595031.1',
  'phosphatidate cytidylyltransferase',
  400599,
  401402,
  -1,
  'EL100_RS02045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403757.1',
  'undecaprenyl pyrophosphate synthase',
  401414,
  402163,
  -1,
  'EL100_RS02050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yajC',
  'preprotein translocase subunit YajC',
  402296,
  402625,
  -1,
  'EL100_RS02055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595034.1',
  'hypothetical protein',
  402813,
  403058,
  -1,
  'EL100_RS02060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403755.1',
  'ATP-dependent Clp protease ATP-binding subunit',
  403351,
  405456,
  -1,
  'EL100_RS02065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403754.1',
  'amino acid ABC transporter ATP-binding protein',
  405814,
  406578,
  -1,
  'EL100_RS02070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_009732142.1',
  'amino acid ABC transporter permease',
  406598,
  407284,
  -1,
  'EL100_RS02075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403753.1',
  'amino acid ABC transporter permease',
  407288,
  407980,
  -1,
  'EL100_RS02080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403752.1',
  'transporter substrate-binding domain-containingprotein',
  408046,
  408924,
  -1,
  'EL100_RS02085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403751.1',
  'uroporphyrinogen decarboxylase family protein',
  408952,
  409953,
  -1,
  'EL100_RS02090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403750.1',
  'hypothetical protein',
  410053,
  410253,
  -1,
  'EL100_RS02095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403749.1',
  'uroporphyrinogen decarboxylase family protein',
  410271,
  411272,
  -1,
  'EL100_RS02100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403748.1',
  'Cof-type HAD-IIB family hydrolase',
  411596,
  412417,
  1,
  'EL100_RS02105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glmS',
  'glutamine--fructose-6-phosphate transaminase(isomerizing)',
  412690,
  414498,
  -1,
  'EL100_RS02110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403746.1',
  'ABC transporter permease',
  414825,
  415703,
  -1,
  'EL100_RS02115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403745.1',
  'ABC transporter ATP-binding protein',
  415696,
  416625,
  -1,
  'EL100_RS02120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403744.1',
  'helix-turn-helix domain-containing protein',
  416964,
  417890,
  -1,
  'EL100_RS02125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555428.1',
  'glycoside hydrolase family 1 protein',
  418109,
  419488,
  -1,
  'EL100_RS02130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403742.1',
  'gamma-glutamyl-gamma-aminobutyrate hydrolasefamily protein',
  419635,
  420327,
  -1,
  'EL100_RS02135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403741.1',
  'class IIb bacteriocin, lactobin A/cerein 7Bfamily',
  420496,
  420684,
  1,
  'EL100_RS02140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048717604.1',
  'class IIb bacteriocin, lactobin A/cerein 7Bfamily',
  420899,
  421057,
  1,
  'EL100_RS02145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'leuS',
  'leucine--tRNA ligase',
  421268,
  423769,
  -1,
  'EL100_RS02150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403739.1',
  'peptide ABC transporter substrate-bindingprotein',
  423973,
  425955,
  -1,
  'EL100_RS02155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403738.1',
  'CPBP family intramembrane glutamicendopeptidase',
  426143,
  426817,
  -1,
  'EL100_RS02160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595056.1',
  'bacteriocin',
  426912,
  427052,
  -1,
  'EL100_RS02165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403737.1',
  'helix-turn-helix domain-containing protein',
  427344,
  428267,
  1,
  'EL100_RS02170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403736.1',
  'hypothetical protein',
  428497,
  428727,
  1,
  'EL100_RS02175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403735.1',
  'ABC transporter ATP-binding protein',
  428724,
  429557,
  1,
  'EL100_RS02180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403734.1',
  'ABC transporter permease',
  429550,
  430296,
  1,
  'EL100_RS02185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403733.1',
  'glycerol dehydrogenase',
  430478,
  431569,
  -1,
  'EL100_RS02190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403732.1',
  'M13 family metallopeptidase',
  431843,
  433738,
  -1,
  'EL100_RS02195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403731.1',
  'metal ABC transporter ATP-binding protein',
  433887,
  434609,
  1,
  'EL100_RS02200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403730.1',
  'metal ABC transporter permease',
  434606,
  435448,
  1,
  'EL100_RS02205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'fimA',
  'metal ABC transporter substrate-bindinglipoprotein/fibrin-binding adhesin FimA',
  435460,
  436392,
  1,
  'EL100_RS02210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tpx',
  'thiol peroxidase',
  436480,
  436974,
  1,
  'EL100_RS02215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403727.1',
  'DUF3114 domain-containing protein',
  437082,
  438107,
  -1,
  'EL100_RS02220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403726.1',
  'metal-dependent transcriptional regulator',
  438248,
  438901,
  1,
  'EL100_RS02225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dtd',
  'D-aminoacyl-tRNA deacylase',
  438924,
  439367,
  -1,
  'EL100_RS02230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595074.1',
  'RelA/SpoT family protein',
  439745,
  441964,
  -1,
  'EL100_RS02235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403725.1',
  'bifunctional 2'',3''-cyclic-nucleotide2''-phosphodiesterase/3''-nucleotidase',
  442226,
  444679,
  1,
  'EL100_RS02240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403724.1',
  '16S rRNA (uracil(1498)-N(3))-methyltransferase',
  444721,
  445470,
  -1,
  'EL100_RS02245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'prmA',
  '50S ribosomal protein L11 methyltransferase',
  445472,
  446422,
  -1,
  'EL100_RS02250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403723.1',
  'GNAT family N-acetyltransferase',
  446560,
  447033,
  -1,
  'EL100_RS02255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405023.1',
  'NUDIX hydrolase',
  447030,
  447464,
  -1,
  'EL100_RS02260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403722.1',
  'hypothetical protein',
  447513,
  448055,
  -1,
  'EL100_RS02265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403721.1',
  'site-2 protease family protein',
  448078,
  449151,
  -1,
  'EL100_RS02270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023027600.1',
  'DUF3013 family protein',
  449169,
  449639,
  -1,
  'EL100_RS02275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403720.1',
  'replication-associated recombination protein A',
  449754,
  451025,
  1,
  'EL100_RS02280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ssrS',
  '—',
  451092,
  451285,
  1,
  'EL100_RS09910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  451288,
  451360,
  1,
  'EL100_RS02285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403719.1',
  'tyrosine-type recombinase/integrase',
  451447,
  452586,
  -1,
  'EL100_RS02290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_000369785.1',
  'DUF3173 domain-containing protein',
  452588,
  452776,
  -1,
  'EL100_RS02295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403718.1',
  'replication initiation protein',
  452788,
  453765,
  -1,
  'EL100_RS02300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'hypothetical protein',
  453811,
  453992,
  -1,
  'EL100_RS02305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403717.1',
  'helix-turn-helix domain-containing protein',
  454203,
  454712,
  1,
  'EL100_RS02310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403716.1',
  'ABC transporter ATP-binding protein',
  454786,
  455613,
  1,
  'EL100_RS02315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403715.1',
  'Rv2686c family ABC transporter permease subunit',
  455768,
  456307,
  1,
  'EL100_RS02320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_002885799.1',
  'YeiH family protein',
  456648,
  457658,
  1,
  'EL100_RS02325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403714.1',
  'low temperature requirement protein A',
  458006,
  459151,
  1,
  'EL100_RS02330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403713.1',
  'T6SS immunity protein Tdi1 domain-containingprotein',
  459645,
  460184,
  -1,
  'EL100_RS02335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_197716097.1',
  'polymorphic toxin type 15 domain-containingprotein',
  460201,
  462756,
  -1,
  'EL100_RS09715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403712.1',
  'DUF4176 domain-containing protein',
  462756,
  463511,
  -1,
  'EL100_RS02345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403711.1',
  'TIGR04197 family type VII secretion effector',
  463511,
  463813,
  -1,
  'EL100_RS02350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403710.1',
  'hypothetical protein',
  463823,
  464242,
  -1,
  'EL100_RS02355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'essC',
  'type VII secretion protein EssC',
  464264,
  468724,
  -1,
  'EL100_RS02360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'essB',
  'type VII secretion protein EssB',
  468711,
  469877,
  -1,
  'EL100_RS02365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403707.1',
  'type VII secretion protein, YukD family',
  469890,
  470144,
  -1,
  'EL100_RS02370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403706.1',
  'type VII secretion EssA family protein',
  470150,
  470638,
  -1,
  'EL100_RS02375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'esaA',
  'type VII secretion protein EsaA',
  470648,
  474022,
  -1,
  'EL100_RS02380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403704.1',
  'WXG100 family type VII secretion target',
  474091,
  474384,
  -1,
  'EL100_RS02385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'XRE family transcriptional regulator',
  474773,
  475000,
  1,
  'EL100_RS02390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403703.1',
  'DUF308 domain-containing protein',
  475219,
  475734,
  1,
  'EL100_RS02395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_061597013.1',
  'DUF1269 domain-containing protein',
  476505,
  477110,
  1,
  'EL100_RS02400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'T6SS immunity protein Tdi1 domain-containingprotein',
  477755,
  478096,
  -1,
  'EL100_RS02405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_049486464.1',
  'aldo/keto reductase',
  478199,
  479041,
  1,
  'EL100_RS02410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403701.1',
  'low temperature requirement protein A',
  479206,
  480351,
  1,
  'EL100_RS02415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403700.1',
  'T6SS immunity protein Tdi1 domain-containingprotein',
  480856,
  481398,
  -1,
  'EL100_RS02420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403699.1',
  'hypothetical protein',
  482122,
  482520,
  -1,
  'EL100_RS02425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403698.1',
  'hypothetical protein',
  482812,
  483174,
  -1,
  'EL100_RS02430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403697.1',
  'CsbD family protein',
  483355,
  483558,
  -1,
  'EL100_RS02435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048789255.1',
  'CsbD family protein',
  483822,
  484025,
  -1,
  'EL100_RS02440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403696.1',
  'Asp23/Gls24 family envelope stress responseprotein',
  484073,
  484672,
  -1,
  'EL100_RS02445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403695.1',
  'DUF2273 domain-containing protein',
  484687,
  484857,
  -1,
  'EL100_RS02450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'amaP',
  'alkaline shock response membrane anchor proteinAmaP',
  484869,
  485435,
  -1,
  'EL100_RS02455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403693.1',
  'GlsB/YeaQ/YmgE family stress response membraneprotein',
  485515,
  485754,
  -1,
  'EL100_RS02460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048789255.1',
  'CsbD family protein',
  486386,
  486589,
  -1,
  'EL100_RS02465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403692.1',
  'Asp23/Gls24 family envelope stress responseprotein',
  486634,
  487230,
  -1,
  'EL100_RS02470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048789865.1',
  'DUF2273 domain-containing protein',
  487245,
  487415,
  -1,
  'EL100_RS02475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'amaP',
  'alkaline shock response membrane anchor proteinAmaP',
  487427,
  487993,
  -1,
  'EL100_RS02480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048789863.1',
  'GlsB/YeaQ/YmgE family stress response membraneprotein',
  488078,
  488317,
  -1,
  'EL100_RS02485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403690.1',
  'hypothetical protein',
  488723,
  489214,
  1,
  'EL100_RS02490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403689.1',
  'Type 1 glutamine amidotransferase-likedomain-containing protein',
  489302,
  489901,
  1,
  'EL100_RS02495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403688.1',
  'diacylglycerol/lipid kinase family protein',
  489975,
  490856,
  1,
  'EL100_RS02500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403687.1',
  'SP_0198 family lipoprotein',
  490923,
  491381,
  -1,
  'EL100_RS02505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403686.1',
  'ABC transporter permease',
  492025,
  493128,
  1,
  'EL100_RS02510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048691574.1',
  'ABC transporter ATP-binding protein',
  493130,
  493819,
  1,
  'EL100_RS02515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403685.1',
  'sensor histidine kinase',
  494011,
  495336,
  -1,
  'EL100_RS02520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048790036.1',
  'response regulator transcription factor',
  495333,
  495986,
  -1,
  'EL100_RS02525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'ABC transporter permease',
  496057,
  497433,
  -1,
  'EL100_RS02530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_399553597.1',
  'ABC transporter ATP-binding protein',
  497446,
  498078,
  -1,
  'EL100_RS02535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403684.1',
  'ABC transporter permease',
  498094,
  499359,
  -1,
  'EL100_RS02540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'groL',
  'chaperonin GroEL',
  500622,
  502244,
  -1,
  'EL100_RS02545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'groES',
  'co-chaperone GroES',
  502268,
  502552,
  -1,
  'EL100_RS02550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403682.1',
  'DUF202 domain-containing protein',
  502680,
  502973,
  -1,
  'EL100_RS02555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_040803176.1',
  'PTS system mannose/fructose/sorbose familytransporter subunit IID',
  503076,
  503930,
  -1,
  'EL100_RS02560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595111.1',
  'PTSmannose/fructose/sorbose/N-acetylgalactosamine transportersubunit IIC',
  503914,
  504756,
  -1,
  'EL100_RS02565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595112.1',
  'PTS sugar transporter subunit IIB',
  504819,
  505313,
  -1,
  'EL100_RS02570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403681.1',
  'PTS sugar transporter subunit IIA',
  505331,
  505771,
  -1,
  'EL100_RS02575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403680.1',
  'ABC transporter substrate-binding protein',
  505906,
  507213,
  -1,
  'EL100_RS02580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595115.1',
  'response regulator transcription factor',
  507210,
  507896,
  -1,
  'EL100_RS02585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403679.1',
  'sensor histidine kinase',
  507893,
  509212,
  -1,
  'EL100_RS02590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403678.1',
  'substrate-binding domain-containing protein',
  509212,
  510198,
  -1,
  'EL100_RS02595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_061564657.1',
  'single-stranded DNA-binding protein',
  510418,
  510813,
  -1,
  'EL100_RS02600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ytpR',
  'YtpR family tRNA-binding protein',
  511050,
  511676,
  -1,
  'EL100_RS02605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403676.1',
  'thioredoxin family protein',
  511691,
  512008,
  -1,
  'EL100_RS02610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403675.1',
  'DUF4651 domain-containing protein',
  512005,
  512295,
  -1,
  'EL100_RS02615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pepA',
  'glutamyl aminopeptidase',
  512442,
  513506,
  1,
  'EL100_RS02620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403673.1',
  'DUF1846 domain-containing protein',
  513665,
  515149,
  1,
  'EL100_RS02625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555426.1',
  'hypothetical protein',
  515259,
  515414,
  -1,
  'EL100_RS02630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'folK',
  '2-amino-4-hydroxy-6-hydroxymethyldihydropteridine diphosphokinase',
  515511,
  516326,
  -1,
  'EL100_RS02635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'folE',
  'GTP cyclohydrolase I FolE',
  516353,
  516907,
  -1,
  'EL100_RS02640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403671.1',
  'bifunctional folylpolyglutamatesynthase/dihydrofolate synthase',
  516909,
  518213,
  -1,
  'EL100_RS02645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'folP',
  'dihydropteroate synthase',
  518230,
  519186,
  -1,
  'EL100_RS02650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_224781595.1',
  'CPBP family intramembrane glutamicendopeptidase',
  519345,
  520019,
  -1,
  'EL100_RS02655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403669.1',
  'acetate kinase',
  520172,
  521368,
  -1,
  'EL100_RS02660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403668.1',
  'class I SAM-dependent methyltransferase',
  521417,
  522370,
  -1,
  'EL100_RS02665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'comGG',
  'competence type IV pilus minor pilin ComGG',
  522402,
  522848,
  -1,
  'EL100_RS02670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'comGF',
  'competence type IV pilus minor pilin ComGF',
  522814,
  523266,
  -1,
  'EL100_RS02675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'comGE',
  'competence type IV pilus minor pilin ComGE',
  523250,
  523543,
  -1,
  'EL100_RS02680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'comGD',
  'competence type IV pilus minor pilin ComGD',
  523509,
  523934,
  -1,
  'EL100_RS02685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'comGC',
  'competence type IV pilus major pilin ComGC',
  523903,
  524220,
  -1,
  'EL100_RS02690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'comGB',
  'competence type IV pilus assembly protein ComGB',
  524217,
  525239,
  -1,
  'EL100_RS02695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'comGA',
  'competence type IV pilus ATPase ComGA',
  525181,
  526122,
  -1,
  'EL100_RS02700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048717460.1',
  'DUF1033 family protein',
  526229,
  526606,
  -1,
  'EL100_RS02705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403663.1',
  'family 8 glycosyl hydrolase',
  526814,
  527917,
  -1,
  'EL100_RS02710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'glycosyltransferase family 2 protein',
  527926,
  529236,
  -1,
  'EL100_RS02715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595142.1',
  'hypothetical protein',
  529229,
  529369,
  -1,
  'EL100_RS02720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403662.1',
  'hypothetical protein',
  529379,
  530167,
  -1,
  'EL100_RS02725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'wecB',
  'non-hydrolyzing UDP-N-acetylglucosamine2-epimerase',
  530170,
  531321,
  -1,
  'EL100_RS02730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpoC',
  'DNA-directed RNA polymerase subunit beta''',
  531710,
  535363,
  -1,
  'EL100_RS02735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpoB',
  'DNA-directed RNA polymerase subunit beta',
  535514,
  539083,
  -1,
  'EL100_RS02740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pbp1b',
  'penicillin-binding protein PBP1B',
  539504,
  541900,
  -1,
  'EL100_RS02745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tyrS',
  'tyrosine--tRNA ligase',
  542163,
  543419,
  1,
  'EL100_RS02750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403656.1',
  'methyltransferase domain-containing protein',
  543476,
  544318,
  1,
  'EL100_RS02755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403655.1',
  'response regulator transcription factor',
  544369,
  545667,
  -1,
  'EL100_RS02760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403654.1',
  'sensor histidine kinase',
  545680,
  547326,
  -1,
  'EL100_RS02765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403653.1',
  'YesL family protein',
  547329,
  547940,
  -1,
  'EL100_RS02770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403652.1',
  'ABC transporter substrate-binding protein',
  548138,
  549619,
  -1,
  'EL100_RS02775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006597196.1',
  'carbohydrate ABC transporter permease',
  549683,
  550615,
  -1,
  'EL100_RS02780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403651.1',
  'ABC transporter permease',
  550629,
  551558,
  -1,
  'EL100_RS02785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403650.1',
  'beta-N-acetylhexosaminidase',
  551770,
  553650,
  -1,
  'EL100_RS02790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403649.1',
  'ROK family protein',
  553644,
  554513,
  -1,
  'EL100_RS02795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403648.1',
  'alpha-mannosidase',
  554598,
  557243,
  -1,
  'EL100_RS02800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403647.1',
  'glycoside hydrolase family 125 protein',
  557320,
  558600,
  -1,
  'EL100_RS02805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403646.1',
  'GH92 family glycosyl hydrolase',
  558794,
  560872,
  1,
  'EL100_RS02810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403645.1',
  'DUF6287 domain-containing protein',
  560926,
  561471,
  -1,
  'EL100_RS02815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403644.1',
  'zinc ABC transporter substrate-binding proteinAdcA',
  561585,
  563084,
  -1,
  'EL100_RS02820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946466.1',
  'metal ABC transporter permease',
  563093,
  563896,
  -1,
  'EL100_RS02825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403643.1',
  'metal ABC transporter ATP-binding protein',
  563889,
  564593,
  -1,
  'EL100_RS02830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595170.1',
  'zinc-dependent MarR family transcriptionalregulator',
  564593,
  565030,
  -1,
  'EL100_RS02835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011423.1',
  'HXXEE domain-containing protein',
  565968,
  566357,
  1,
  'EL100_RS02840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'merA',
  'mercury(II) reductase',
  566721,
  568616,
  -1,
  'EL100_RS02845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'merR',
  'mercury resistance transcriptional regulatorMerR',
  568645,
  569037,
  -1,
  'EL100_RS02850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003009660.1',
  'tetratricopeptide repeat protein',
  569235,
  569855,
  -1,
  'EL100_RS02855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403640.1',
  'helix-turn-helix domain-containing protein',
  569953,
  570405,
  -1,
  'EL100_RS02860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403639.1',
  'hypothetical protein',
  570726,
  571199,
  1,
  'EL100_RS02865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403638.1',
  'replication initiation factor domain-containingprotein',
  571240,
  572436,
  1,
  'EL100_RS02870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403637.1',
  'hypothetical protein',
  572439,
  572825,
  1,
  'EL100_RS02875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_150889024.1',
  'DUF3173 domain-containing protein',
  572885,
  573079,
  1,
  'EL100_RS02880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403636.1',
  'tyrosine-type recombinase/integrase',
  573083,
  574216,
  1,
  'EL100_RS02885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  574291,
  574374,
  -1,
  'EL100_RS02890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  574384,
  574455,
  -1,
  'EL100_RS02895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  574469,
  574541,
  -1,
  'EL100_RS02900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  574554,
  574624,
  -1,
  'EL100_RS02905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  574631,
  574711,
  -1,
  'EL100_RS02910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  574727,
  574799,
  -1,
  'EL100_RS02915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  574805,
  574878,
  -1,
  'EL100_RS02920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  574888,
  574977,
  -1,
  'EL100_RS02925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  574987,
  575058,
  -1,
  'EL100_RS02930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  575072,
  575145,
  -1,
  'EL100_RS02935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  575179,
  575249,
  -1,
  'EL100_RS02940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  575258,
  575330,
  -1,
  'EL100_RS02945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rrf',
  '—',
  575462,
  575577,
  -1,
  'EL100_RS02950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  575658,
  578557,
  -1,
  'EL100_RS02955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  578686,
  578758,
  -1,
  'EL100_RS02960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  578812,
  580360,
  -1,
  'EL100_RS02965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403635.1',
  'glutamate-cysteine ligase family protein',
  580608,
  581909,
  -1,
  'EL100_RS02970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplQ',
  '50S ribosomal protein L17',
  582107,
  582493,
  -1,
  'EL100_RS02975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595177.1',
  'DNA-directed RNA polymerase subunit alpha',
  582505,
  583443,
  -1,
  'EL100_RS02980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsK',
  '30S ribosomal protein S11',
  583489,
  583872,
  -1,
  'EL100_RS02985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsM',
  '30S ribosomal protein S13',
  583899,
  584264,
  -1,
  'EL100_RS02990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpmJ',
  '50S ribosomal protein L36',
  584282,
  584398,
  -1,
  'EL100_RS02995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS02995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'infA',
  'translation initiation factor IF-1',
  584422,
  584640,
  -1,
  'EL100_RS03000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006597039.1',
  'adenylate kinase',
  584757,
  585395,
  -1,
  'EL100_RS03005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'secY',
  'preprotein translocase subunit SecY',
  585492,
  586799,
  -1,
  'EL100_RS03010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplO',
  '50S ribosomal protein L15',
  586812,
  587252,
  -1,
  'EL100_RS03015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpmD',
  '50S ribosomal protein L30',
  587398,
  587580,
  -1,
  'EL100_RS03020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsE',
  '30S ribosomal protein S5',
  587595,
  588089,
  -1,
  'EL100_RS03025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplR',
  '50S ribosomal protein L18',
  588107,
  588463,
  -1,
  'EL100_RS03030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplF',
  '50S ribosomal protein L6',
  588547,
  589083,
  -1,
  'EL100_RS03035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsH',
  '30S ribosomal protein S8',
  589277,
  589675,
  -1,
  'EL100_RS03040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_001085699.1',
  'type Z 30S ribosomal protein S14',
  589888,
  590073,
  -1,
  'EL100_RS03045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplE',
  '50S ribosomal protein L5',
  590091,
  590633,
  -1,
  'EL100_RS03050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplX',
  '50S ribosomal protein L24',
  590657,
  590962,
  -1,
  'EL100_RS03055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplN',
  '50S ribosomal protein L14',
  591040,
  591408,
  -1,
  'EL100_RS03060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsQ',
  '30S ribosomal protein S17',
  591434,
  591694,
  -1,
  'EL100_RS03065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpmC',
  '50S ribosomal protein L29',
  591718,
  591924,
  -1,
  'EL100_RS03070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplP',
  '50S ribosomal protein L16',
  591934,
  592347,
  -1,
  'EL100_RS03075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsC',
  '30S ribosomal protein S3',
  592351,
  593004,
  -1,
  'EL100_RS03080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplV',
  '50S ribosomal protein L22',
  593017,
  593361,
  -1,
  'EL100_RS03085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsS',
  '30S ribosomal protein S19',
  593373,
  593654,
  -1,
  'EL100_RS03090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplB',
  '50S ribosomal protein L2',
  593757,
  594590,
  -1,
  'EL100_RS03095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595190.1',
  '50S ribosomal protein L23',
  594608,
  594904,
  -1,
  'EL100_RS03100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplD',
  '50S ribosomal protein L4',
  594904,
  595527,
  -1,
  'EL100_RS03105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplC',
  '50S ribosomal protein L3',
  595552,
  596178,
  -1,
  'EL100_RS03110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsJ',
  '30S ribosomal protein S10',
  596262,
  596570,
  -1,
  'EL100_RS03115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tgt',
  'tRNA guanosine(34) transglycosylase Tgt',
  597004,
  598146,
  -1,
  'EL100_RS03120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011415.1',
  'DUF975 family protein',
  598298,
  599185,
  1,
  'EL100_RS03125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403628.1',
  'CoA-binding protein',
  599347,
  599787,
  -1,
  'EL100_RS03130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'polA',
  'DNA polymerase I',
  599922,
  602567,
  -1,
  'EL100_RS03135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403626.1',
  'DUF1304 domain-containing protein',
  602952,
  603314,
  -1,
  'EL100_RS03140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403625.1',
  'MarR family winged helix-turn-helixtranscriptional regulator',
  603327,
  603752,
  -1,
  'EL100_RS03145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403624.1',
  'HAD-IA family hydrolase',
  604101,
  604724,
  -1,
  'EL100_RS03150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011424.1',
  'MATE family efflux transporter',
  604730,
  605995,
  -1,
  'EL100_RS03155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'thrC',
  'threonine synthase',
  606074,
  607558,
  -1,
  'EL100_RS03160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nrdG',
  'anaerobic ribonucleoside-triphosphate reductaseactivating protein',
  607754,
  608350,
  -1,
  'EL100_RS03165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403620.1',
  'GNAT family N-acetyltransferase',
  608355,
  608855,
  -1,
  'EL100_RS03170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403619.1',
  'hypothetical protein',
  608893,
  609033,
  -1,
  'EL100_RS03175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nrdD',
  'anaerobic ribonucleoside-triphosphate reductase',
  609046,
  611256,
  -1,
  'EL100_RS03180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403617.1',
  'MFS transporter',
  611382,
  613160,
  -1,
  'EL100_RS03185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'hisS',
  'histidine--tRNA ligase',
  613318,
  614592,
  -1,
  'EL100_RS03190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'asnA',
  'aspartate--ammonia ligase',
  614782,
  615774,
  -1,
  'EL100_RS03195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555424.1',
  'LPXTG cell wall anchor domain-containingprotein',
  616178,
  617884,
  1,
  'EL100_RS03200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_061564603.1',
  'autorepressor SdpR family transcription factor',
  618094,
  618375,
  1,
  'EL100_RS03205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403614.1',
  'SdpI family protein',
  618362,
  618997,
  1,
  'EL100_RS03210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpmG',
  '50S ribosomal protein L33',
  619283,
  619432,
  -1,
  'EL100_RS03215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpmF',
  '50S ribosomal protein L32',
  619448,
  619630,
  -1,
  'EL100_RS03220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ilvD',
  'dihydroxy-acid dehydratase',
  619869,
  621572,
  1,
  'EL100_RS03225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403613.1',
  'metal-sulfur cluster assembly factor',
  621621,
  621962,
  -1,
  'EL100_RS03230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403612.1',
  'CynX/NimT family MFS transporter',
  622721,
  623893,
  1,
  'EL100_RS03235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403611.1',
  'LysM peptidoglycan-binding domain-containingprotein',
  624131,
  625303,
  -1,
  'EL100_RS03240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403610.1',
  'V-type ATP synthase subunit D',
  625750,
  626373,
  -1,
  'EL100_RS03245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403609.1',
  'V-type ATP synthase subunit B',
  626395,
  627792,
  -1,
  'EL100_RS03250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403608.1',
  'V-type ATP synthase subunit A',
  627779,
  629569,
  -1,
  'EL100_RS03255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403607.1',
  'GNAT family N-acetyltransferase',
  629603,
  630307,
  -1,
  'EL100_RS03260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023027501.1',
  'V-type ATP synthase subunit F',
  630304,
  630624,
  -1,
  'EL100_RS03265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403606.1',
  'V-type ATPase subunit',
  630614,
  631624,
  -1,
  'EL100_RS03270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403605.1',
  'hypothetical protein',
  631633,
  632223,
  -1,
  'EL100_RS03275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023024938.1',
  'V-type ATP synthase subunit K',
  632309,
  632788,
  -1,
  'EL100_RS03280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403604.1',
  'V-type ATP synthase subunit I',
  632830,
  634779,
  -1,
  'EL100_RS03285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403603.1',
  'hypothetical protein',
  634769,
  635092,
  -1,
  'EL100_RS03290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011425.1',
  'MurR/RpiR family transcriptional regulator',
  635411,
  636199,
  1,
  'EL100_RS03295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403601.1',
  'ROK family protein',
  636576,
  637469,
  -1,
  'EL100_RS03300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403600.1',
  'dihydrodipicolinate synthase family protein',
  637500,
  638417,
  -1,
  'EL100_RS03305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403599.1',
  'YesL family protein',
  638463,
  639110,
  -1,
  'EL100_RS03310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403598.1',
  'NanQ anomerase/TabA/YiaL family protein',
  639132,
  639584,
  -1,
  'EL100_RS03315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048717106.1',
  'carbohydrate ABC transporter permease',
  639749,
  640588,
  -1,
  'EL100_RS03320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555423.1',
  'carbohydrate ABC transporter permease',
  640604,
  641491,
  -1,
  'EL100_RS03325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403597.1',
  'extracellular solute-binding protein',
  641697,
  643013,
  -1,
  'EL100_RS03330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403596.1',
  'N-acetylmannosamine-6-phosphate 2-epimerase',
  643157,
  643855,
  -1,
  'EL100_RS03335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_269148389.1',
  'hypothetical protein',
  644252,
  644377,
  1,
  'EL100_RS09840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_267472029.1',
  'hypothetical protein',
  644393,
  644521,
  1,
  'EL100_RS09845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403595.1',
  'class IIb bacteriocin, lactobin A/cerein 7Bfamily',
  644555,
  644701,
  1,
  'EL100_RS03340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555422.1',
  'hypothetical protein',
  644707,
  644877,
  1,
  'EL100_RS03345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403594.1',
  'class IIb bacteriocin, lactobin A/cerein 7Bfamily',
  644878,
  645030,
  1,
  'EL100_RS03350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023024913.1',
  'hypothetical protein',
  645227,
  645394,
  1,
  'EL100_RS03355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595272.1',
  'hypothetical protein',
  645407,
  645568,
  1,
  'EL100_RS03360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403593.1',
  'ABC transporter permease',
  645728,
  646114,
  -1,
  'EL100_RS03365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403592.1',
  'zinc-dependent alcohol dehydrogenase familyprotein',
  646285,
  647334,
  -1,
  'EL100_RS03370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'adhE',
  'bifunctional acetaldehyde-CoA/alcoholdehydrogenase',
  647557,
  650208,
  -1,
  'EL100_RS03375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403590.1',
  'acyltransferase family protein',
  650567,
  652384,
  -1,
  'EL100_RS03380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403589.1',
  'MORN repeat-containing protein',
  652374,
  652787,
  -1,
  'EL100_RS03385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403588.1',
  'low molecular weightprotein-tyrosine-phosphatase',
  652845,
  653267,
  -1,
  'EL100_RS03390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403587.1',
  'nucleotidyltransferase family protein',
  653386,
  653952,
  -1,
  'EL100_RS03395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ruvB',
  'Holliday junction branch migration DNA helicaseRuvB',
  653959,
  654957,
  -1,
  'EL100_RS03400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403585.1',
  'aldose epimerase family protein',
  655622,
  656662,
  -1,
  'EL100_RS03405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403584.1',
  'SIS domain-containing protein',
  656690,
  657853,
  -1,
  'EL100_RS03410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023024891.1',
  'PTS sugar transporter subunit IIA',
  657951,
  658355,
  -1,
  'EL100_RS03415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_009731973.1',
  'PTS system mannose/fructose/sorbose familytransporter subunit IID',
  658367,
  659188,
  -1,
  'EL100_RS03420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403583.1',
  'PTSmannose/fructose/sorbose/N-acetylgalactosamine transportersubunit IIC',
  659175,
  660089,
  -1,
  'EL100_RS03425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403582.1',
  'PTS sugar transporter subunit IIB',
  660130,
  660606,
  -1,
  'EL100_RS03430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403581.1',
  'glycoside hydrolase family 35 protein',
  660603,
  662390,
  -1,
  'EL100_RS03435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595289.1',
  'GntR family transcriptional regulator',
  662523,
  663239,
  1,
  'EL100_RS03440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'purB',
  'adenylosuccinate lyase',
  663475,
  664773,
  -1,
  'EL100_RS03445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403579.1',
  'phosphoribosylaminoimidazole carboxylase',
  664935,
  665162,
  -1,
  'EL100_RS03450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403578.1',
  'ketopantoate reductase family protein',
  665171,
  666121,
  -1,
  'EL100_RS03455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403577.1',
  'hypothetical protein',
  666219,
  666482,
  -1,
  'EL100_RS03460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'purK',
  '5-(carboxyamino)imidazole ribonucleotidesynthase',
  666484,
  667575,
  -1,
  'EL100_RS03465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'purE',
  '5-(carboxyamino)imidazole ribonucleotide mutase',
  667562,
  668053,
  -1,
  'EL100_RS03470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'purD',
  'phosphoribosylamine--glycine ligase',
  668234,
  669496,
  -1,
  'EL100_RS03475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403573.1',
  'GBS Bsp-like repeat-containing protein',
  669681,
  670694,
  1,
  'EL100_RS03480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'purH',
  'bifunctionalphosphoribosylaminoimidazolecarboxamideformyltransferase/IMP cyclohydrolase',
  670746,
  672293,
  -1,
  'EL100_RS03485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403571.1',
  'GNAT family N-acetyltransferase',
  672295,
  672759,
  -1,
  'EL100_RS03490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'purN',
  'phosphoribosylglycinamide formyltransferase',
  672803,
  673351,
  -1,
  'EL100_RS03495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'purM',
  'phosphoribosylformylglycinamidine cyclo-ligase',
  673536,
  674558,
  -1,
  'EL100_RS03500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'purF',
  'amidophosphoribosyltransferase',
  674589,
  676028,
  -1,
  'EL100_RS03505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403567.1',
  'phosphoribosylformylglycinamidine synthase',
  676041,
  679766,
  -1,
  'EL100_RS03510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'purC',
  'phosphoribosylaminoimidazolesuccinocarboxamidesynthase',
  679830,
  680537,
  -1,
  'EL100_RS03515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595305.1',
  'acyl carrier protein',
  680707,
  680952,
  -1,
  'EL100_RS03520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'plsX',
  'phosphate acyltransferase PlsX',
  680949,
  681953,
  -1,
  'EL100_RS03525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'recO',
  'DNA repair protein RecO',
  681950,
  682729,
  -1,
  'EL100_RS03530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403563.1',
  'pyridoxal phosphate-dependent aminotransferase',
  682713,
  683894,
  -1,
  'EL100_RS03535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'srtB',
  'class B sortase, LPKTxAVK-specific',
  684058,
  684921,
  -1,
  'EL100_RS03540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'abpA',
  'amylase-binding adhesin AbpA',
  685015,
  685632,
  -1,
  'EL100_RS03545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595312.1',
  'ribose-phosphate diphosphokinase',
  686012,
  686986,
  -1,
  'EL100_RS03550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pcsB',
  'peptidoglycan hydrolase PcsB',
  687147,
  688394,
  -1,
  'EL100_RS03555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  688539,
  688626,
  -1,
  'EL100_RS03560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  688631,
  688704,
  -1,
  'EL100_RS03565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  688738,
  688808,
  -1,
  'EL100_RS03570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  688825,
  688897,
  -1,
  'EL100_RS03575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  688903,
  688976,
  -1,
  'EL100_RS03580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  688986,
  689075,
  -1,
  'EL100_RS03585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  689085,
  689158,
  -1,
  'EL100_RS03590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  689175,
  689248,
  -1,
  'EL100_RS03595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  689254,
  689327,
  -1,
  'EL100_RS03600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  689347,
  689420,
  -1,
  'EL100_RS03605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  689442,
  689527,
  -1,
  'EL100_RS03610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  689535,
  689606,
  -1,
  'EL100_RS03615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  689630,
  689702,
  -1,
  'EL100_RS03620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  689720,
  689801,
  -1,
  'EL100_RS03625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  689807,
  689879,
  -1,
  'EL100_RS03630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  689911,
  689983,
  -1,
  'EL100_RS03635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  689986,
  690058,
  -1,
  'EL100_RS03640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rrf',
  '—',
  690190,
  690305,
  -1,
  'EL100_RS03645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  690386,
  693285,
  -1,
  'EL100_RS03650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  693415,
  693487,
  -1,
  'EL100_RS03655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  693541,
  695089,
  -1,
  'EL100_RS03660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595314.1',
  'hypothetical protein',
  695334,
  695816,
  -1,
  'EL100_RS03665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  695989,
  696060,
  -1,
  'EL100_RS03670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ftsH',
  'ATP-dependent zinc metalloprotease FtsH',
  696176,
  698149,
  -1,
  'EL100_RS03675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'hpt',
  'hypoxanthine phosphoribosyltransferase',
  698160,
  698702,
  -1,
  'EL100_RS03680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tilS',
  'tRNA lysidine(34) synthetase TilS',
  698708,
  699982,
  -1,
  'EL100_RS03685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403556.1',
  'serine hydrolase',
  699982,
  701265,
  -1,
  'EL100_RS03690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595319.1',
  'SP_0009 family protein',
  701258,
  701386,
  -1,
  'EL100_RS09850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595320.1',
  'septum formation initiator family protein',
  701386,
  701754,
  -1,
  'EL100_RS03695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403555.1',
  'RNA-binding S4 domain-containing protein',
  701747,
  702013,
  -1,
  'EL100_RS03700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mfd',
  'transcription-repair coupling factor',
  702077,
  705589,
  -1,
  'EL100_RS03705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pth',
  'aminoacyl-tRNA hydrolase',
  705582,
  706151,
  -1,
  'EL100_RS03710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ychF',
  'redox-regulated ATPase YchF',
  706222,
  707337,
  -1,
  'EL100_RS03715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011416.1',
  'DUF1307 domain-containing protein',
  707401,
  707643,
  1,
  'EL100_RS03720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126403553.1',
  'DUF951 domain-containing protein',
  707679,
  707870,
  -1,
  'EL100_RS03725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dnaN',
  'DNA polymerase III subunit beta',
  707934,
  709070,
  -1,
  'EL100_RS03730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dnaA',
  'chromosomal replication initiator protein DnaA',
  709231,
  710601,
  -1,
  'EL100_RS03735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405019.1',
  'ParB/RepB/Spo0J family partition protein',
  710851,
  711612,
  -1,
  'EL100_RS03740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405018.1',
  'serine protease HtrA',
  711678,
  712856,
  -1,
  'EL100_RS03745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rlmH',
  '23S rRNA(pseudouridine(1915)-N(3))-methyltransferase RlmH',
  713059,
  713538,
  1,
  'EL100_RS03750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  713583,
  713656,
  1,
  'EL100_RS03755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405016.1',
  'bacteriocin',
  713898,
  714041,
  1,
  'EL100_RS03760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011417.1',
  'sensor histidine kinase',
  714041,
  715360,
  1,
  'EL100_RS09760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405015.1',
  'response regulator transcription factor',
  715361,
  716113,
  1,
  'EL100_RS03770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  716161,
  716232,
  1,
  'EL100_RS03775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  716241,
  716314,
  1,
  'EL100_RS03780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405014.1',
  'YfhO family protein',
  716396,
  718984,
  -1,
  'EL100_RS03785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595336.1',
  'ATP-binding cassette domain-containing protein',
  719047,
  720669,
  -1,
  'EL100_RS03790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trpS',
  'tryptophan--tRNA ligase',
  721090,
  722115,
  1,
  'EL100_RS03795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'guaB',
  'IMP dehydrogenase',
  722283,
  723764,
  1,
  'EL100_RS03800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'recF',
  'DNA replication/repair protein RecF',
  723846,
  724934,
  -1,
  'EL100_RS03805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yaaA',
  'S4 domain-containing protein YaaA',
  724936,
  725307,
  -1,
  'EL100_RS03810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yfmF',
  'EF-P 5-aminopentanol modification-associatedprotein YfmF',
  725467,
  726717,
  1,
  'EL100_RS03815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yfmH',
  'EF-P 5-aminopentanol modification-associatedprotein YfmH',
  726714,
  728000,
  1,
  'EL100_RS03820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pgsA',
  'CDP-diacylglycerol--glycerol-3-phosphate3-phosphatidyltransferase',
  728097,
  728636,
  1,
  'EL100_RS03825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595344.1',
  'energy-coupling factor ABC transporterATP-binding protein',
  728637,
  729464,
  1,
  'EL100_RS03830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405009.1',
  'energy-coupling factor transporter ATPase',
  729449,
  730291,
  1,
  'EL100_RS03835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405008.1',
  'energy-coupling factor transporter transmembranecomponent T family protein',
  730284,
  731078,
  1,
  'EL100_RS03840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048715090.1',
  'LysM peptidoglycan-binding domain-containingprotein',
  731250,
  731894,
  1,
  'EL100_RS03845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405007.1',
  'HAD hydrolase-like protein',
  732061,
  732687,
  -1,
  'EL100_RS03850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'sdaAA',
  'L-serine ammonia-lyase, iron-sulfur-dependent,subunit alpha',
  732691,
  733563,
  -1,
  'EL100_RS03855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'sdaAB',
  'L-serine ammonia-lyase, iron-sulfur-dependentsubunit beta',
  733573,
  734244,
  -1,
  'EL100_RS03860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'apf',
  'aggregation-promoting factor',
  734473,
  735015,
  1,
  'EL100_RS03865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mnmA',
  'tRNA 2-thiouridine(34) synthase MnmA',
  735219,
  736340,
  1,
  'EL100_RS03870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405003.1',
  'NUDIX hydrolase',
  736478,
  736933,
  1,
  'EL100_RS03875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mnmG',
  'tRNA uridine-5-carboxymethylaminomethyl(34)synthesis enzyme MnmG',
  736939,
  738852,
  1,
  'EL100_RS03880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_462365877.1',
  'DHH family phosphoesterase',
  739066,
  741042,
  1,
  'EL100_RS03885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplI',
  '50S ribosomal protein L9',
  741039,
  741491,
  1,
  'EL100_RS03890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dnaB',
  'replicative DNA helicase',
  741516,
  742871,
  1,
  'EL100_RS03895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595358.1',
  'Veg family protein',
  742875,
  743147,
  1,
  'EL100_RS03900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsD',
  '30S ribosomal protein S4',
  743742,
  744353,
  1,
  'EL100_RS03905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'comA',
  'peptide cleavage/export ABC transporter ComA',
  744636,
  746789,
  1,
  'EL100_RS03910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404998.1',
  'bacteriocin secretion accessory protein',
  746817,
  748178,
  1,
  'EL100_RS03915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404997.1',
  'TetR/AcrR family transcriptional regulator',
  748490,
  749026,
  -1,
  'EL100_RS03920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404996.1',
  'YhgE/Pip domain-containing protein',
  749162,
  751957,
  1,
  'EL100_RS03925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404995.1',
  'DUF4947 domain-containing protein',
  752023,
  752691,
  -1,
  'EL100_RS03930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946479.1',
  'carbohydrate-binding domain-containing protein',
  753009,
  754259,
  -1,
  'EL100_RS03935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404993.1',
  'polyphosphate polymerase domain-containingprotein',
  754487,
  755266,
  1,
  'EL100_RS03940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404992.1',
  'DUF4956 domain-containing protein',
  755259,
  755942,
  1,
  'EL100_RS03945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595368.1',
  'teichoic acid D-Ala incorporation-associatedprotein DltX',
  756422,
  756550,
  1,
  'EL100_RS03950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dltA',
  'D-alanine--poly(phosphoribitol) ligase subunitDltA',
  756565,
  758115,
  1,
  'EL100_RS03955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dltB',
  'D-alanyl-lipoteichoic acid biosynthesis proteinDltB',
  758112,
  759362,
  1,
  'EL100_RS03960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dltC',
  'D-alanine--poly(phosphoribitol) ligase subunitDltC',
  759381,
  759620,
  1,
  'EL100_RS03965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dltD',
  'D-alanyl-lipoteichoic acid biosynthesis proteinDltD',
  759613,
  760881,
  1,
  'EL100_RS03970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946480.1',
  'hypothetical protein',
  761025,
  761261,
  1,
  'EL100_RS03975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'aspS',
  'aspartate--tRNA ligase',
  761362,
  763116,
  1,
  'EL100_RS03980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404986.1',
  'YitT family protein',
  763187,
  764128,
  1,
  'EL100_RS03985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pulA',
  'type I pullulanase',
  764162,
  766213,
  -1,
  'EL100_RS03990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404984.1',
  'LacI family DNA-binding transcriptionalregulator',
  766222,
  767205,
  -1,
  'EL100_RS03995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS03995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404983.1',
  'DUF1189 domain-containing protein',
  767217,
  768029,
  -1,
  'EL100_RS04000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596980.1',
  'sugar ABC transporter permease',
  768258,
  769100,
  -1,
  'EL100_RS04005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404982.1',
  'sugar ABC transporter permease',
  769102,
  770397,
  -1,
  'EL100_RS04010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404981.1',
  'extracellular solute-binding protein',
  770479,
  771735,
  -1,
  'EL100_RS04015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'malQ',
  '4-alpha-glucanotransferase',
  772209,
  773762,
  1,
  'EL100_RS04020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glgP',
  'glycogen/starch/alpha-glucan familyphosphorylase',
  773750,
  776008,
  1,
  'EL100_RS04025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404978.1',
  'ABC transporter permease',
  776182,
  776694,
  1,
  'EL100_RS04030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nrdI',
  'class Ib ribonucleoside-diphosphate reductaseassembly flavoprotein NrdI',
  776750,
  777217,
  1,
  'EL100_RS04035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596982.1',
  'hypothetical protein',
  777458,
  777703,
  -1,
  'EL100_RS04040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'argS',
  'arginine--tRNA ligase',
  777870,
  779558,
  -1,
  'EL100_RS04045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'argR',
  'arginine repressor',
  779661,
  780104,
  1,
  'EL100_RS04050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mutS',
  'DNA mismatch repair protein MutS',
  780211,
  782754,
  1,
  'EL100_RS04055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048715642.1',
  'DUF3021 domain-containing protein',
  782987,
  783445,
  -1,
  'EL100_RS04060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_040802875.1',
  'LytTR family DNA-binding domain-containingprotein',
  783439,
  783879,
  -1,
  'EL100_RS04065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mutL',
  'DNA mismatch repair endonuclease MutL',
  784132,
  786081,
  1,
  'EL100_RS04070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ruvA',
  'Holliday junction branch migration protein RuvA',
  786102,
  786695,
  1,
  'EL100_RS04075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404973.1',
  'DNA-3-methyladenine glycosylase I',
  786705,
  787271,
  1,
  'EL100_RS04080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404972.1',
  'competence/damage-inducible protein A',
  787355,
  788623,
  1,
  'EL100_RS04085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'recA',
  'recombinase RecA',
  788670,
  789812,
  1,
  'EL100_RS04090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'spx',
  'transcriptional regulator Spx',
  789900,
  790298,
  1,
  'EL100_RS04095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_125335101.1',
  'SP0191 family lipoprotein',
  790483,
  791076,
  1,
  'EL100_RS04100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023027380.1',
  'SP0191 family lipoprotein',
  791086,
  791637,
  1,
  'EL100_RS04105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006597020.1',
  'IreB family regulatory phosphoprotein',
  791780,
  792046,
  1,
  'EL100_RS04110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ruvX',
  'Holliday junction resolvase RuvX',
  792046,
  792465,
  1,
  'EL100_RS04115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595405.1',
  'DUF1292 domain-containing protein',
  792483,
  792794,
  1,
  'EL100_RS04120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404971.1',
  'bifunctional folylpolyglutamatesynthase/dihydrofolate synthase',
  793020,
  794267,
  1,
  'EL100_RS04125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404970.1',
  'SP_0198 family lipoprotein',
  794389,
  794811,
  1,
  'EL100_RS04130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cls',
  'cardiolipin synthase',
  795077,
  796612,
  1,
  'EL100_RS04135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946468.1',
  'hypothetical protein',
  796769,
  797632,
  1,
  'EL100_RS04140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cpsA',
  'LCP family glycopolymer transferase CpsA',
  797807,
  799285,
  1,
  'EL100_RS04145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cps4B',
  'capsular polysaccharide biosynthesis proteinCps4B',
  799278,
  800009,
  1,
  'EL100_RS04150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404966.1',
  'Wzz/FepE/Etk N-terminal domain-containingprotein',
  800052,
  800747,
  1,
  'EL100_RS04155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404965.1',
  'tyrosine-protein kinase',
  800760,
  801455,
  1,
  'EL100_RS04160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404964.1',
  'sugar transferase',
  801475,
  802848,
  1,
  'EL100_RS04165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404963.1',
  'LicD family protein',
  802852,
  803637,
  1,
  'EL100_RS04170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_414485334.1',
  'WecB/TagA/CpsF family glycosyltransferase',
  803655,
  804380,
  1,
  'EL100_RS04175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404961.1',
  'glycosyltransferase family 4 protein',
  804355,
  805440,
  1,
  'EL100_RS04180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'wecB',
  'non-hydrolyzing UDP-N-acetylglucosamine2-epimerase',
  805437,
  806531,
  1,
  'EL100_RS04185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404959.1',
  'glycosyltransferase family 2 protein',
  806531,
  807496,
  1,
  'EL100_RS04190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404958.1',
  'IspD/TarI family cytidylyltransferase',
  807554,
  808261,
  1,
  'EL100_RS04195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404957.1',
  'zinc-binding dehydrogenase',
  808263,
  809288,
  1,
  'EL100_RS04200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404956.1',
  'flippase',
  809295,
  810713,
  1,
  'EL100_RS04205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404955.1',
  'O-antigen ligase family protein',
  810916,
  812064,
  1,
  'EL100_RS04210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glf',
  'UDP-galactopyranose mutase',
  812193,
  813290,
  1,
  'EL100_RS04215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404953.1',
  'glycosyltransferase',
  813306,
  814361,
  1,
  'EL100_RS04220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404952.1',
  'GBS Bsp-like repeat-containing protein',
  814478,
  816919,
  1,
  'EL100_RS04225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404951.1',
  'Cna B-type domain-containing protein',
  817362,
  822695,
  1,
  'EL100_RS04230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404950.1',
  'metal ABC transporter solute-binding protein,Zn/Mn family',
  823140,
  824075,
  1,
  'EL100_RS04235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'pneumococcal-type histidine triad protein',
  824085,
  827145,
  1,
  'EL100_RS04240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555445.1',
  'RluA family pseudouridine synthase',
  827624,
  828499,
  -1,
  'EL100_RS04245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pbp2a',
  'penicillin-binding protein PBP2A',
  828683,
  830914,
  1,
  'EL100_RS04250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ypfJ',
  'KPN_02809 family neutral zinc metallopeptidase',
  831239,
  832158,
  -1,
  'EL100_RS04255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpmG',
  '50S ribosomal protein L33',
  832285,
  832437,
  1,
  'EL100_RS04260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'secE',
  'preprotein translocase subunit SecE',
  832447,
  832623,
  1,
  'EL100_RS04265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nusG',
  'transcription termination/antiterminationprotein NusG',
  832809,
  833345,
  1,
  'EL100_RS04270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404946.1',
  'hypothetical protein',
  833434,
  834153,
  -1,
  'EL100_RS04275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  834273,
  834343,
  -1,
  'EL100_RS04280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsB',
  '30S ribosomal protein S2',
  834656,
  835438,
  1,
  'EL100_RS04285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tsf',
  'translation elongation factor Ts',
  835517,
  836557,
  1,
  'EL100_RS04290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404944.1',
  'COG2426 family protein',
  836889,
  837359,
  -1,
  'EL100_RS04295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404943.1',
  'Ig-like domain-containing protein',
  837754,
  844608,
  1,
  'EL100_RS04300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404942.1',
  'alpha-L-fucosidase',
  844714,
  848409,
  1,
  'EL100_RS04305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404941.1',
  'CtsR family transcriptional regulator',
  848640,
  849098,
  1,
  'EL100_RS04310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404940.1',
  'ATP-dependent Clp protease ATP-binding subunit',
  849106,
  851535,
  1,
  'EL100_RS04315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404939.1',
  'ECF transporter S component',
  851547,
  852035,
  1,
  'EL100_RS04320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023024640.1',
  'DUF4430 domain-containing protein',
  852016,
  852420,
  1,
  'EL100_RS04325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404938.1',
  'hypothetical protein',
  852583,
  853317,
  1,
  'EL100_RS04330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404937.1',
  'AAA family ATPase',
  853520,
  854578,
  1,
  'EL100_RS04335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pnuC',
  'nicotinamide riboside transporter PnuC',
  854591,
  855373,
  1,
  'EL100_RS04340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404935.1',
  'NUDIX domain-containing protein',
  855374,
  856171,
  1,
  'EL100_RS04345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dusB',
  'tRNA dihydrouridine synthase DusB',
  856538,
  857518,
  -1,
  'EL100_RS04350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'hslO',
  'Hsp33 family molecular chaperone HslO',
  857505,
  858377,
  -1,
  'EL100_RS04355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003002006.1',
  'hypothetical protein',
  858489,
  858617,
  1,
  'EL100_RS09855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gshAB',
  'bifunctional glutamate--cysteine ligaseGshA/glutathione synthetase GshB',
  858871,
  861126,
  -1,
  'EL100_RS04365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_070665062.1',
  'adenylosuccinate synthase',
  861423,
  862715,
  1,
  'EL100_RS04370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tadA',
  'tRNA adenosine(34) deaminase TadA',
  862935,
  863447,
  1,
  'EL100_RS04375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ffs',
  '—',
  863486,
  863581,
  1,
  'EL100_RS04380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404932.1',
  'glucose-6-phosphate isomerase',
  864300,
  865649,
  1,
  'EL100_RS04385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404931.1',
  'hypothetical protein',
  865832,
  866935,
  1,
  'EL100_RS04390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404930.1',
  'hypothetical protein',
  866957,
  867751,
  1,
  'EL100_RS04395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404929.1',
  'hypothetical protein',
  867961,
  868692,
  1,
  'EL100_RS04400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404928.1',
  'hypothetical protein',
  868703,
  869440,
  1,
  'EL100_RS04405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404927.1',
  'hypothetical protein',
  869462,
  870442,
  1,
  'EL100_RS04410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dapD',
  '2,3,4,5-tetrahydropyridine-2,6-dicarboxylateN-acetyltransferase',
  870607,
  871305,
  1,
  'EL100_RS04415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404925.1',
  'N-acetyldiaminopimelate deacetylase',
  871368,
  872501,
  1,
  'EL100_RS04420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404924.1',
  '5-formyltetrahydrofolate cyclo-ligase',
  872514,
  873053,
  1,
  'EL100_RS04425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404923.1',
  'rhomboid family intramembrane serine protease',
  873037,
  873723,
  1,
  'EL100_RS04430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404922.1',
  'C69 family dipeptidase',
  873951,
  875915,
  1,
  'EL100_RS04435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'galU',
  'UTP--glucose-1-phosphate uridylyltransferaseGalU',
  876141,
  877049,
  -1,
  'EL100_RS04440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_117744778.1',
  'NAD(P)H-dependent glycerol-3-phosphatedehydrogenase',
  877111,
  878127,
  -1,
  'EL100_RS04445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011418.1',
  'Spy0128 family protein',
  878402,
  882664,
  1,
  'EL100_RS09775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_125329260.1',
  'gamma-glutamyl-gamma-aminobutyrate hydrolasefamily protein',
  882821,
  883510,
  1,
  'EL100_RS04465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405079.1',
  'dUTP diphosphatase',
  883748,
  884194,
  1,
  'EL100_RS04470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404920.1',
  'histidine phosphatase family protein',
  884196,
  884735,
  1,
  'EL100_RS04475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'radA',
  'DNA repair protein RadA',
  884773,
  886110,
  1,
  'EL100_RS04480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023024583.1',
  'TIGR00266 family protein',
  886192,
  886887,
  1,
  'EL100_RS04485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023024580.1',
  'beta-class carbonic anhydrase',
  887034,
  887531,
  1,
  'EL100_RS04490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011419.1',
  'DUF2079 domain-containing protein',
  887701,
  889716,
  1,
  'EL100_RS04495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404918.1',
  'LPXTG cell wall anchor domain-containingprotein',
  890112,
  891635,
  1,
  'EL100_RS04500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pgfS',
  'glycosyltransferase PgfS',
  891709,
  892668,
  1,
  'EL100_RS04505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pgfM1',
  'glycosyltransferase PgfM1',
  892689,
  895613,
  1,
  'EL100_RS04510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404915.1',
  'SspB-related isopeptide-forming adhesin',
  895899,
  905627,
  1,
  'EL100_RS04515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404914.1',
  'ABC transporter permease',
  905796,
  906662,
  1,
  'EL100_RS04520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404913.1',
  'ABC transporter ATP-binding protein',
  906659,
  907417,
  1,
  'EL100_RS04525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404912.1',
  'hypothetical protein',
  907986,
  908474,
  1,
  'EL100_RS04530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595487.1',
  'ribonuclease J',
  908842,
  910503,
  1,
  'EL100_RS04535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404911.1',
  'alpha/beta hydrolase',
  910577,
  911359,
  1,
  'EL100_RS04540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gltX',
  'glutamate--tRNA ligase',
  911458,
  912918,
  1,
  'EL100_RS04545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011420.1',
  'LPXTG cell wall anchor domain-containingprotein',
  913105,
  916842,
  1,
  'EL100_RS04550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555456.1',
  'accessory Sec-dependent serine-rich glycoproteinadhesin',
  917082,
  923051,
  1,
  'EL100_RS04555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'secY2',
  'accessory Sec system protein translocase subunitSecY2',
  923356,
  924570,
  1,
  'EL100_RS04560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'asp1',
  'accessory Sec system protein Asp1',
  924579,
  926156,
  1,
  'EL100_RS04565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'asp2',
  'accessory Sec system protein Asp2',
  926158,
  927702,
  1,
  'EL100_RS04570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'asp3',
  'accessory Sec system protein Asp3',
  927708,
  928154,
  1,
  'EL100_RS04575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'secA2',
  'accessory Sec system translocase SecA2',
  928200,
  930575,
  1,
  'EL100_RS04580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gtfA',
  'accessory Sec system glycosyltransferase GtfA',
  930586,
  932100,
  1,
  'EL100_RS04585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gtfB',
  'accessory Sec system glycosylation chaperoneGtfB',
  932084,
  933439,
  1,
  'EL100_RS04590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'asp4',
  'accessory Sec system protein Asp4',
  933432,
  933620,
  1,
  'EL100_RS04595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'asp5',
  'accessory Sec system protein Asp5',
  933622,
  933846,
  1,
  'EL100_RS04600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023024535.1',
  'carboxymuconolactone decarboxylase familyprotein',
  934033,
  934581,
  1,
  'EL100_RS04605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404898.1',
  'TDT family transporter',
  934724,
  935617,
  1,
  'EL100_RS04610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404897.1',
  'CPBP family intramembrane glutamicendopeptidase',
  935777,
  936472,
  1,
  'EL100_RS04615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rnpA',
  'ribonuclease P protein component',
  936579,
  936920,
  1,
  'EL100_RS04620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595514.1',
  'YidC/Oxa1 family membrane protein insertase',
  936925,
  937740,
  1,
  'EL100_RS04625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'jag',
  'RNA-binding cell elongation regulator Jag/EloR',
  937756,
  938700,
  1,
  'EL100_RS04630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_414485336.1',
  'HI_0552 family protein',
  938781,
  939431,
  1,
  'EL100_RS04635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpmH',
  '50S ribosomal protein L34',
  939578,
  939712,
  1,
  'EL100_RS04640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404894.1',
  'TatD family hydrolase',
  939837,
  940607,
  1,
  'EL100_RS04645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rnmV',
  'ribonuclease M5',
  940579,
  941163,
  1,
  'EL100_RS04650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404892.1',
  'immunity protein Imm33 domain-containingprotein',
  941185,
  941811,
  1,
  'EL100_RS04655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rsmA',
  '16S rRNA(adenine(1518)-N(6)/adenine(1519)-N(6))-dimethyltransferase RsmA',
  941885,
  942760,
  1,
  'EL100_RS04660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  942807,
  942896,
  -1,
  'EL100_RS04665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  942901,
  942983,
  -1,
  'EL100_RS04670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404890.1',
  'CPBP family intramembrane glutamicendopeptidase',
  943103,
  944023,
  -1,
  'EL100_RS04675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rsgA',
  'ribosome small subunit-dependent GTPase A',
  944355,
  945233,
  1,
  'EL100_RS04680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpe',
  'ribulose-phosphate 3-epimerase',
  945249,
  945908,
  1,
  'EL100_RS04685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404888.1',
  'thiamine diphosphokinase',
  945868,
  946533,
  1,
  'EL100_RS04690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404887.1',
  'DNA recombination protein RmuC',
  946535,
  947791,
  1,
  'EL100_RS04695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006597096.1',
  '3''-5'' exoribonuclease YhaM family protein',
  947778,
  948728,
  1,
  'EL100_RS04700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'purR',
  'pur operon repressor',
  948858,
  949682,
  1,
  'EL100_RS04705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404885.1',
  'hypothetical protein',
  949705,
  950241,
  1,
  'EL100_RS04710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsL',
  '30S ribosomal protein S12',
  950458,
  950871,
  1,
  'EL100_RS04715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsG',
  '30S ribosomal protein S7',
  950891,
  951361,
  1,
  'EL100_RS04720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'fusA',
  'elongation factor G',
  951638,
  953719,
  1,
  'EL100_RS04725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gap',
  'type I glyceraldehyde-3-phosphate dehydrogenase',
  953974,
  954984,
  1,
  'EL100_RS04730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404883.1',
  'endo-beta-N-acetylglucosaminidase',
  955214,
  960013,
  1,
  'EL100_RS04735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006151517.1',
  'phosphoglycerate kinase',
  960214,
  961413,
  1,
  'EL100_RS04740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404882.1',
  'FUSC family protein',
  961981,
  962514,
  1,
  'EL100_RS04745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404881.1',
  'MerR family transcriptional regulator',
  962584,
  962949,
  1,
  'EL100_RS04750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glnA',
  'type I glutamate--ammonia ligase',
  962991,
  964337,
  1,
  'EL100_RS04755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rnjA',
  'ribonuclease J1',
  964542,
  966224,
  -1,
  'EL100_RS04760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404878.1',
  'DNA-dependent RNA polymerase subunit epsilon',
  966228,
  966458,
  -1,
  'EL100_RS04765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tsaB',
  'tRNA(adenosine(37)-N6)-threonylcarbamoyltransferase complexdimerization subunit type 1 TsaB',
  966741,
  967424,
  1,
  'EL100_RS04770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rimI',
  'ribosomal protein S18-alanineN-acetyltransferase',
  967421,
  967858,
  1,
  'EL100_RS04775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tsaD',
  'tRNA(adenosine(37)-N6)-threonylcarbamoyltransferase complextransferase subunit TsaD',
  967848,
  968864,
  1,
  'EL100_RS04780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404874.1',
  'AzlC family ABC transporter permease',
  968958,
  969653,
  1,
  'EL100_RS04785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405077.1',
  'AzlD domain-containing protein',
  969640,
  969969,
  1,
  'EL100_RS04790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404873.1',
  'hypothetical protein',
  970089,
  970766,
  1,
  'EL100_RS04795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405076.1',
  'sodium-dependent transporter',
  970807,
  972147,
  -1,
  'EL100_RS04800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404872.1',
  'MerR family transcriptional regulator',
  972398,
  973138,
  1,
  'EL100_RS04805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'NUDIX domain-containing protein',
  973168,
  973623,
  -1,
  'EL100_RS04810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405075.1',
  'aminoacetone oxidase',
  973643,
  974818,
  -1,
  'EL100_RS04815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404870.1',
  'hypothetical protein',
  974907,
  975437,
  -1,
  'EL100_RS04820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404869.1',
  'Nramp family divalent metal transporter',
  975725,
  977071,
  1,
  'EL100_RS04825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595550.1',
  'YbaB/EbfC family nucleoid-associated protein',
  977212,
  977511,
  1,
  'EL100_RS04830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404868.1',
  '3''-5'' exonuclease',
  977703,
  978296,
  -1,
  'EL100_RS04835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595552.1',
  'DUF536 domain-containing protein',
  978385,
  978900,
  -1,
  'EL100_RS04840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404867.1',
  'Xaa-Pro dipeptidyl-peptidase',
  979012,
  981291,
  -1,
  'EL100_RS04845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404866.1',
  'DUF308 domain-containing protein',
  981393,
  982673,
  1,
  'EL100_RS04850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404865.1',
  'CppA N-terminal domain-containing protein',
  982779,
  983513,
  1,
  'EL100_RS04855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404864.1',
  'serine hydrolase domain-containing protein',
  983549,
  984502,
  1,
  'EL100_RS04860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mvk',
  'mevalonate kinase',
  984623,
  985501,
  1,
  'EL100_RS04865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mvaD',
  'diphosphomevalonate decarboxylase',
  985483,
  986433,
  1,
  'EL100_RS04870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404861.1',
  'phosphomevalonate kinase',
  986423,
  987448,
  1,
  'EL100_RS04875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'fni',
  'type 2 isopentenyl-diphosphate Delta-isomerase',
  987426,
  988442,
  1,
  'EL100_RS04880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404859.1',
  'hydroxymethylglutaryl-CoA reductase,degradative',
  988720,
  989988,
  -1,
  'EL100_RS04885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404858.1',
  'hydroxymethylglutaryl-CoA synthase',
  989981,
  991159,
  -1,
  'EL100_RS04890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405074.1',
  'hypothetical protein',
  991504,
  991734,
  -1,
  'EL100_RS04895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404857.1',
  'threonine/serine exporter family protein',
  991841,
  992308,
  -1,
  'EL100_RS04900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404856.1',
  'threonine/serine exporter family protein',
  992313,
  993071,
  -1,
  'EL100_RS04905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pflB',
  'formate C-acetyltransferase',
  993212,
  995527,
  -1,
  'EL100_RS04910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dinB',
  'DNA polymerase IV',
  995753,
  996865,
  1,
  'EL100_RS04915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'recD2',
  'SF1B family DNA helicase RecD2',
  996893,
  999328,
  -1,
  'EL100_RS04920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'lepB',
  'signal peptidase I',
  999420,
  1000058,
  -1,
  'EL100_RS04925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rnhC',
  'ribonuclease HIII',
  1000062,
  1000952,
  -1,
  'EL100_RS04930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404850.1',
  'glutathione peroxidase',
  1001008,
  1001487,
  -1,
  'EL100_RS04935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'zapA',
  'cell division protein ZapA',
  1001642,
  1001932,
  1,
  'EL100_RS04940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404849.1',
  'CvpA family protein',
  1001943,
  1002497,
  1,
  'EL100_RS04945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404848.1',
  'endonuclease MutS2',
  1002594,
  1004930,
  1,
  'EL100_RS04950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404847.1',
  'C69 family dipeptidase',
  1005011,
  1006429,
  1,
  'EL100_RS04955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404846.1',
  'alanine/glycine:cation symporter family protein',
  1006813,
  1008153,
  1,
  'EL100_RS04960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'sstT',
  'serine/threonine transporter SstT',
  1008334,
  1009551,
  -1,
  'EL100_RS04965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404843.1',
  'mechanosensitive ion channel family protein',
  1009702,
  1010553,
  1,
  'EL100_RS04970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'def',
  'peptide deformylase',
  1010581,
  1011195,
  -1,
  'EL100_RS04975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404842.1',
  'pseudouridine synthase',
  1011367,
  1012095,
  1,
  'EL100_RS04980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404841.1',
  'Cna B-type domain-containing protein',
  1012315,
  1014417,
  1,
  'EL100_RS04985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsO',
  '30S ribosomal protein S15',
  1014810,
  1015079,
  1,
  'EL100_RS04990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404840.1',
  'DUF4649 family protein',
  1015444,
  1015668,
  1,
  'EL100_RS04995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS04995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trxA',
  'thioredoxin',
  1015681,
  1015995,
  1,
  'EL100_RS05000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404839.1',
  'DUF2785 domain-containing protein',
  1016156,
  1016947,
  -1,
  'EL100_RS05005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pepF',
  'oligoendopeptidase F',
  1017002,
  1018798,
  -1,
  'EL100_RS05010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011384.1',
  'SH3 domain-containing protein',
  1018974,
  1020470,
  1,
  'EL100_RS05015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pnp',
  'polyribonucleotide nucleotidyltransferase',
  1021074,
  1023290,
  1,
  'EL100_RS05020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cysE',
  'serine O-acetyltransferase',
  1023315,
  1023932,
  1,
  'EL100_RS05025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404835.1',
  'GNAT family N-acetyltransferase',
  1023945,
  1024811,
  1,
  'EL100_RS05030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cysS',
  'cysteine--tRNA ligase',
  1024832,
  1026175,
  1,
  'EL100_RS05035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404833.1',
  'Mini-ribonuclease 3',
  1026168,
  1026563,
  1,
  'EL100_RS05040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595596.1',
  'helix-turn-helix domain-containing protein',
  1026563,
  1027423,
  1,
  'EL100_RS05045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404832.1',
  'ABC transporter ATP-binding protein',
  1027547,
  1028677,
  1,
  'EL100_RS05050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404831.1',
  'alpha-glucosidase',
  1028744,
  1030411,
  1,
  'EL100_RS05055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404830.1',
  'LPXTG-anchored zinc carboxypeptidase',
  1030470,
  1033730,
  -1,
  'EL100_RS05060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404829.1',
  'aromatic acid exporter family protein',
  1033902,
  1034867,
  -1,
  'EL100_RS05065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rlmB',
  '23S rRNA(guanosine(2251)-2''-O)-methyltransferase RlmB',
  1034972,
  1035700,
  1,
  'EL100_RS05070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595602.1',
  'NYN domain-containing protein',
  1035731,
  1036246,
  1,
  'EL100_RS05075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404828.1',
  'DegV family protein',
  1036243,
  1037106,
  1,
  'EL100_RS05080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplM',
  '50S ribosomal protein L13',
  1037260,
  1037706,
  1,
  'EL100_RS05085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsI',
  '30S ribosomal protein S9',
  1037725,
  1038117,
  1,
  'EL100_RS05090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404827.1',
  'tyrosine-type recombinase/integrase',
  1038174,
  1039220,
  -1,
  'EL100_RS05095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555444.1',
  'helix-turn-helix domain-containing protein',
  1039311,
  1039490,
  -1,
  'EL100_RS09780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404825.1',
  'replication protein',
  1039483,
  1040097,
  -1,
  'EL100_RS05100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404824.1',
  'hypothetical protein',
  1040303,
  1040908,
  -1,
  'EL100_RS05105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404823.1',
  'P-loop NTPase family protein',
  1040905,
  1042005,
  -1,
  'EL100_RS05110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_037608226.1',
  'hypothetical protein',
  1042005,
  1042325,
  -1,
  'EL100_RS05115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404822.1',
  'RNA polymerase sigma factor',
  1042525,
  1042974,
  -1,
  'EL100_RS05120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011385.1',
  'helix-turn-helix domain-containing protein',
  1043274,
  1044581,
  1,
  'EL100_RS09785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_414485338.1',
  'hypothetical protein',
  1044650,
  1044796,
  1,
  'EL100_RS09895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404821.1',
  'protein kinase family protein',
  1044824,
  1046023,
  1,
  'EL100_RS05135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404820.1',
  'LysR family transcriptional regulator',
  1046598,
  1047476,
  -1,
  'EL100_RS05140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_040803216.1',
  'helix-turn-helix domain-containing protein',
  1047599,
  1047949,
  -1,
  'EL100_RS05145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404819.1',
  'malolactic enzyme',
  1048308,
  1049933,
  1,
  'EL100_RS05150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_049518049.1',
  'AEC family transporter',
  1050017,
  1050964,
  1,
  'EL100_RS05155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404817.1',
  'CsbD family protein',
  1051312,
  1051515,
  -1,
  'EL100_RS05160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404816.1',
  'CPBP family intramembrane glutamicendopeptidase',
  1051974,
  1052681,
  1,
  'EL100_RS05165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404815.1',
  'rhomboid family intramembrane serine protease',
  1052797,
  1053399,
  1,
  'EL100_RS05170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595627.1',
  'ACT domain-containing protein',
  1053550,
  1053816,
  1,
  'EL100_RS05175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404814.1',
  'PFL family protein',
  1053835,
  1055172,
  1,
  'EL100_RS05180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404813.1',
  'histidine phosphatase family protein',
  1055306,
  1056022,
  1,
  'EL100_RS05185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404812.1',
  'histidine phosphatase family protein',
  1056064,
  1056762,
  1,
  'EL100_RS05190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404811.1',
  'M15 family metallopeptidase',
  1056755,
  1057528,
  1,
  'EL100_RS05195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'hrcA',
  'heat-inducible transcriptional repressor HrcA',
  1057695,
  1058729,
  1,
  'EL100_RS05200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'grpE',
  'nucleotide exchange factor GrpE',
  1058754,
  1059278,
  1,
  'EL100_RS05205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dnaK',
  'molecular chaperone DnaK',
  1059522,
  1061345,
  1,
  'EL100_RS05210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404809.1',
  'hypothetical protein',
  1061369,
  1061587,
  1,
  'EL100_RS05215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404808.1',
  'DJ-1/PfpI family protein',
  1061648,
  1062280,
  1,
  'EL100_RS05220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dnaJ',
  'molecular chaperone DnaJ',
  1062438,
  1063583,
  1,
  'EL100_RS05225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gdhA',
  'NADP-specific glutamate dehydrogenase',
  1063678,
  1065024,
  -1,
  'EL100_RS05230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404805.1',
  'dihydroorotate oxidase',
  1065395,
  1066330,
  1,
  'EL100_RS05235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011386.1',
  'helicase BlpT',
  1066479,
  1066808,
  1,
  'EL100_RS05240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'msrB',
  'peptide-methionine (R)-S-oxide reductase MsrB',
  1067090,
  1068025,
  1,
  'EL100_RS05245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011428.1',
  'CapA family protein',
  1068263,
  1069540,
  1,
  'EL100_RS05250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404801.1',
  'MutS-related protein',
  1069559,
  1071241,
  1,
  'EL100_RS05255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404800.1',
  'AraC family transcriptional regulator',
  1071334,
  1072209,
  -1,
  'EL100_RS05260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404799.1',
  'HAD family hydrolase',
  1072455,
  1073288,
  1,
  'EL100_RS05265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404798.1',
  'SGNH/GDSL hydrolase family protein',
  1073341,
  1073973,
  1,
  'EL100_RS05270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'spxB',
  'pyruvate oxidase',
  1074308,
  1076083,
  1,
  'EL100_RS05275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404797.1',
  'VOC family protein',
  1076193,
  1076540,
  1,
  'EL100_RS05280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404796.1',
  '6-phospho-beta-glucosidase',
  1076749,
  1078188,
  1,
  'EL100_RS05285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946484.1',
  'response regulator transcription factor',
  1078325,
  1079014,
  1,
  'EL100_RS05290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404794.1',
  'sensor histidine kinase',
  1079014,
  1079895,
  1,
  'EL100_RS05295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404793.1',
  'ABC transporter permease',
  1079923,
  1080675,
  -1,
  'EL100_RS05300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404792.1',
  'ABC transporter ATP-binding protein',
  1080730,
  1081638,
  -1,
  'EL100_RS05305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595653.1',
  'hypothetical protein',
  1081651,
  1081836,
  -1,
  'EL100_RS05310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404791.1',
  'alpha/beta fold hydrolase',
  1082108,
  1082725,
  -1,
  'EL100_RS05315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pabB',
  'aminodeoxychorismate synthase component I',
  1082725,
  1084452,
  -1,
  'EL100_RS05320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404789.1',
  'acyltransferase family protein',
  1084572,
  1085612,
  1,
  'EL100_RS05325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404788.1',
  'glycoside hydrolase family 13 protein',
  1085727,
  1087340,
  1,
  'EL100_RS05330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'metE',
  '5-methyltetrahydropteroyltriglutamate--homocysteine S-methyltransferase',
  1087610,
  1089859,
  1,
  'EL100_RS05335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'metF',
  'methylenetetrahydrofolate reductase [NAD(P)H]',
  1089927,
  1090802,
  1,
  'EL100_RS05340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404785.1',
  'ATP-binding protein',
  1090935,
  1093871,
  1,
  'EL100_RS05345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'hutG',
  'formimidoylglutamase',
  1093984,
  1094970,
  -1,
  'EL100_RS05350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'hutH',
  'histidine ammonia-lyase',
  1095058,
  1096599,
  -1,
  'EL100_RS05355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404782.1',
  'APC family permease',
  1096828,
  1098156,
  -1,
  'EL100_RS05360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404781.1',
  'HutD/Ves family protein',
  1098177,
  1098755,
  -1,
  'EL100_RS05365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404780.1',
  'formate--tetrahydrofolate ligase',
  1098771,
  1100444,
  -1,
  'EL100_RS05370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_125374493.1',
  'cyclodeaminase/cyclohydrolase family protein',
  1100497,
  1101126,
  -1,
  'EL100_RS05375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ftcD',
  'glutamate formimidoyltransferase',
  1101139,
  1102038,
  -1,
  'EL100_RS05380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404778.1',
  'urocanate hydratase',
  1102120,
  1104150,
  -1,
  'EL100_RS05385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'hutI',
  'imidazolonepropionase',
  1104351,
  1105598,
  1,
  'EL100_RS05390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404776.1',
  'hypothetical protein',
  1105708,
  1106679,
  -1,
  'EL100_RS05395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404775.1',
  'phosphoketolase family protein',
  1107039,
  1109423,
  1,
  'EL100_RS05400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404774.1',
  'SGO_0316/SGO_0317 family LPXTG-anchored serinepeptidase',
  1109668,
  1114017,
  1,
  'EL100_RS05405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404773.1',
  'SGO_0316/SGO_0317 family LPXTG-anchored serinepeptidase',
  1114098,
  1118576,
  1,
  'EL100_RS05410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405071.1',
  'hypothetical protein',
  1118644,
  1119051,
  -1,
  'EL100_RS05415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404772.1',
  'phosphodiester glycosidase family protein',
  1119032,
  1119934,
  -1,
  'EL100_RS05420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404771.1',
  'bifunctional glycosyltransferase family 2/GtrAfamily protein',
  1119921,
  1120973,
  -1,
  'EL100_RS05425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsF',
  '30S ribosomal protein S6',
  1121252,
  1121542,
  1,
  'EL100_RS05430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404770.1',
  'single-stranded DNA-binding protein',
  1121569,
  1122063,
  1,
  'EL100_RS05435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsR',
  '30S ribosomal protein S18',
  1122105,
  1122344,
  1,
  'EL100_RS05440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404769.1',
  'GNAT family N-acetyltransferase',
  1122656,
  1123177,
  1,
  'EL100_RS05445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404768.1',
  'DUF1129 family protein',
  1123212,
  1123886,
  -1,
  'EL100_RS05450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404767.1',
  'magnesium transporter CorA family protein',
  1123915,
  1124859,
  -1,
  'EL100_RS05455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'uvrA',
  'excinuclease ABC subunit UvrA',
  1124981,
  1127806,
  1,
  'EL100_RS05460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404765.1',
  'M24 family metallopeptidase',
  1127803,
  1128870,
  1,
  'EL100_RS05465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'efp',
  'elongation factor P',
  1128956,
  1129516,
  1,
  'EL100_RS05470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595687.1',
  'Asp23/Gls24 family envelope stress responseprotein',
  1129554,
  1129943,
  1,
  'EL100_RS05475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nusB',
  'transcription antitermination factor NusB',
  1129936,
  1130364,
  1,
  'EL100_RS05480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404764.1',
  'LacI family DNA-binding transcriptionalregulator',
  1130613,
  1131578,
  -1,
  'EL100_RS05485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404763.1',
  'sucrose-6-phosphate hydrolase',
  1131559,
  1133013,
  -1,
  'EL100_RS05490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404762.1',
  'sucrose-specific PTS transporter subunit IIBC',
  1133395,
  1135314,
  1,
  'EL100_RS05495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'scrK',
  'fructokinase ScrK',
  1135507,
  1136400,
  1,
  'EL100_RS05500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404760.1',
  'peptide deformylase',
  1136508,
  1136918,
  1,
  'EL100_RS05505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404759.1',
  'phosphatase PAP2 family protein',
  1136961,
  1137476,
  1,
  'EL100_RS05510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'queG',
  'tRNA epoxyqueuosine(34) reductase QueG',
  1137798,
  1138931,
  -1,
  'EL100_RS05515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'manA',
  'mannose-6-phosphate isomerase, class I',
  1139075,
  1140019,
  1,
  'EL100_RS05520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'secA',
  'preprotein translocase subunit SecA',
  1140225,
  1142744,
  1,
  'EL100_RS05525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595698.1',
  '3-deoxy-7-phosphoheptulonate synthase',
  1142765,
  1143796,
  1,
  'EL100_RS05530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'acpS',
  'holo-ACP synthase',
  1143880,
  1144242,
  1,
  'EL100_RS05535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'alr',
  'alanine racemase',
  1144232,
  1145359,
  1,
  'EL100_RS05540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'recG',
  'ATP-dependent DNA helicase RecG',
  1145457,
  1147472,
  1,
  'EL100_RS05545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404754.1',
  'asparaginase',
  1147833,
  1148795,
  -1,
  'EL100_RS05550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404753.1',
  'Cof-type HAD-IIB family hydrolase',
  1148860,
  1150272,
  1,
  'EL100_RS05555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404752.1',
  'universal stress protein',
  1150314,
  1150766,
  -1,
  'EL100_RS05560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404751.1',
  'pyridoxal phosphate-dependent aminotransferase',
  1150981,
  1152195,
  1,
  'EL100_RS05565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'codY',
  'GTP-sensing pleiotropic transcriptionalregulator CodY',
  1152380,
  1153168,
  1,
  'EL100_RS05570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404749.1',
  'cysteine hydrolase family protein',
  1153168,
  1153737,
  1,
  'EL100_RS05575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gatC',
  'Asp-tRNA(Asn)/Glu-tRNA(Gln) amidotransferasesubunit GatC',
  1153874,
  1154176,
  1,
  'EL100_RS05580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gatA',
  'Asp-tRNA(Asn)/Glu-tRNA(Gln) amidotransferasesubunit GatA',
  1154176,
  1155642,
  1,
  'EL100_RS05585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gatB',
  'Asp-tRNA(Asn)/Glu-tRNA(Gln) amidotransferasesubunit GatB',
  1155642,
  1157084,
  1,
  'EL100_RS05590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404746.1',
  'hypothetical protein',
  1157183,
  1157563,
  1,
  'EL100_RS05595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404745.1',
  '2,3-butanediol dehydrogenase',
  1157674,
  1158714,
  1,
  'EL100_RS05600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946448.1',
  'pullulanase',
  1158869,
  1162588,
  1,
  'EL100_RS05605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404743.1',
  'DMT family transporter',
  1162713,
  1163624,
  1,
  'EL100_RS05610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404742.1',
  'TVP38/TMEM64 family protein',
  1163659,
  1164279,
  -1,
  'EL100_RS05615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_045759146.1',
  'YqeG family HAD IIIA-type phosphatase',
  1164471,
  1164998,
  1,
  'EL100_RS05620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yqeH',
  'ribosome biogenesis GTPase YqeH',
  1165001,
  1166107,
  1,
  'EL100_RS05625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yhbY',
  'ribosome assembly RNA-binding protein YhbY',
  1166326,
  1166637,
  1,
  'EL100_RS05630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404740.1',
  'nicotinate-nucleotide adenylyltransferase',
  1166659,
  1167288,
  1,
  'EL100_RS05635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yqeK',
  'bis(5''-nucleosyl)-tetraphosphatase (symmetrical)YqeK',
  1167288,
  1167884,
  1,
  'EL100_RS05640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404738.1',
  'cysteine hydrolase family protein',
  1167885,
  1168385,
  1,
  'EL100_RS05645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rsfS',
  'ribosome silencing factor',
  1168400,
  1168753,
  1,
  'EL100_RS05650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_277870576.1',
  'class I SAM-dependent DNA methyltransferase',
  1169076,
  1169816,
  1,
  'EL100_RS05655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404734.1',
  'nucleotidyltransferase',
  1169823,
  1170917,
  1,
  'EL100_RS05660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003014291.1',
  'type II toxin-antitoxin system Phd/YefM familyantitoxin',
  1171151,
  1171405,
  1,
  'EL100_RS05665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404733.1',
  'Txe/YoeB family addiction module toxin',
  1171409,
  1171663,
  1,
  'EL100_RS05670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404732.1',
  'YebC/PmpR family DNA-binding transcriptionalregulator',
  1171837,
  1172553,
  1,
  'EL100_RS05675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404731.1',
  'amidohydrolase',
  1172742,
  1173884,
  1,
  'EL100_RS05680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404730.1',
  'amino acid ABC transporter substrate-bindingprotein',
  1174011,
  1174838,
  1,
  'EL100_RS05685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404729.1',
  'MetQ/NlpA family ABC transportersubstrate-binding protein',
  1174871,
  1175743,
  1,
  'EL100_RS05690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_125334839.1',
  'M20/M25/M40 family metallo-hydrolase',
  1175812,
  1177185,
  1,
  'EL100_RS05695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404728.1',
  'methionine ABC transporter ATP-binding protein',
  1177178,
  1178245,
  1,
  'EL100_RS05700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595735.1',
  'methionine ABC transporter permease',
  1178242,
  1178934,
  1,
  'EL100_RS05705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404727.1',
  'MptD family putative ECF transporter Scomponent',
  1178950,
  1179528,
  1,
  'EL100_RS05710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404726.1',
  'SAM hydrolase/SAM-dependent halogenase familyprotein',
  1179546,
  1180394,
  1,
  'EL100_RS05715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404725.1',
  'ECF-type riboflavin transportersubstrate-binding protein',
  1180408,
  1180959,
  1,
  'EL100_RS05720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404724.1',
  'helix-turn-helix transcriptional regulator',
  1181099,
  1181293,
  1,
  'EL100_RS05725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404723.1',
  'DUF6773 family protein',
  1181321,
  1181797,
  1,
  'EL100_RS05730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trhO',
  'oxygen-dependent tRNA uridine(34) hydroxylaseTrhO',
  1182234,
  1183217,
  1,
  'EL100_RS05735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404722.1',
  'DUF4299 family protein',
  1183579,
  1184475,
  1,
  'EL100_RS05740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_009731544.1',
  'uracil-xanthine permease family protein',
  1184510,
  1185790,
  -1,
  'EL100_RS05745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405070.1',
  'nucleoside phosphorylase',
  1186250,
  1187023,
  1,
  'EL100_RS05750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'ATP-binding cassette domain-containing protein',
  1187024,
  1187875,
  1,
  'EL100_RS09900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'energy-coupling factor ABC transporterATP-binding protein',
  1187948,
  1188706,
  1,
  'EL100_RS09905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404720.1',
  'energy-coupling factor transporter transmembranecomponent T family protein',
  1188699,
  1189529,
  1,
  'EL100_RS05760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404719.1',
  'SDR family oxidoreductase',
  1189534,
  1190289,
  1,
  'EL100_RS05765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404718.1',
  'carbohydrate kinase family protein',
  1190360,
  1191280,
  1,
  'EL100_RS05770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rsmG',
  '16S rRNA (guanine(527)-N(7))-methyltransferaseRsmG',
  1191310,
  1192023,
  -1,
  'EL100_RS05775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_049472048.1',
  'LemA family protein',
  1192094,
  1192654,
  1,
  'EL100_RS05780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'htpX',
  'zinc metalloprotease HtpX',
  1192656,
  1193552,
  1,
  'EL100_RS05785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404714.1',
  'MFS transporter',
  1194017,
  1195234,
  -1,
  'EL100_RS05790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555441.1',
  'hypothetical protein',
  1195231,
  1195407,
  -1,
  'EL100_RS05795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404713.1',
  'helix-turn-helix domain-containing protein',
  1195672,
  1196532,
  -1,
  'EL100_RS05800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048716562.1',
  'DUF177 domain-containing protein',
  1196739,
  1197278,
  1,
  'EL100_RS05805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003005145.1',
  'flotillin family protein',
  1197402,
  1198880,
  1,
  'EL100_RS05810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gndA',
  'NADP-dependent phosphogluconate dehydrogenase',
  1199050,
  1200474,
  1,
  'EL100_RS05815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404711.1',
  'response regulator transcription factor',
  1200484,
  1201173,
  1,
  'EL100_RS05820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405069.1',
  'PTS transporter subunit IIBC',
  1201451,
  1203640,
  1,
  'EL100_RS05825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404710.1',
  'endonuclease/exonuclease/phosphatase familyprotein',
  1203704,
  1204519,
  1,
  'EL100_RS05830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nrdR',
  'transcriptional regulator NrdR',
  1204633,
  1205106,
  1,
  'EL100_RS05835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404709.1',
  'replication initiation and membrane attachmentfamily protein',
  1205107,
  1206279,
  1,
  'EL100_RS05840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dnaI',
  'primosomal protein DnaI',
  1206280,
  1207179,
  1,
  'EL100_RS05845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404707.1',
  'NADPH-dependent oxidoreductase',
  1207176,
  1207892,
  1,
  'EL100_RS05850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'der',
  'ribosome biogenesis GTPase Der',
  1207909,
  1209219,
  1,
  'EL100_RS05855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555421.1',
  'hypothetical protein',
  1209226,
  1209672,
  1,
  'EL100_RS05860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404706.1',
  'pilus expression-regulating Snf2 familyhelicase',
  1210220,
  1213315,
  1,
  'EL100_RS05865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404705.1',
  'divisome accessory protein ZapJ',
  1213373,
  1214044,
  1,
  'EL100_RS05870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'murC',
  'UDP-N-acetylmuramate--L-alanine ligase',
  1214059,
  1215393,
  1,
  'EL100_RS05875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404703.1',
  'GNAT family N-acetyltransferase',
  1215403,
  1215831,
  1,
  'EL100_RS05880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404702.1',
  'GNAT family N-acetyltransferase',
  1215844,
  1216344,
  1,
  'EL100_RS05885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mltG',
  'endolytic transglycosylase MltG',
  1216407,
  1218017,
  1,
  'EL100_RS05890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'greA',
  'transcription elongation factor GreA',
  1218079,
  1218561,
  1,
  'EL100_RS05895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yidC',
  'membrane protein insertase YidC',
  1218963,
  1219901,
  -1,
  'EL100_RS05900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404699.1',
  'acylphosphatase',
  1219980,
  1220258,
  -1,
  'EL100_RS05905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404698.1',
  'TrmH family RNA methyltransferase',
  1220332,
  1221078,
  1,
  'EL100_RS05910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048715413.1',
  'HDIG domain-containing metalloprotein',
  1221109,
  1221597,
  1,
  'EL100_RS05915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405068.1',
  'Bax inhibitor-1/YccA family protein',
  1221627,
  1222313,
  1,
  'EL100_RS05920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404697.1',
  'diaminopimelate decarboxylase',
  1222396,
  1223646,
  1,
  'EL100_RS05925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595782.1',
  'YneF family protein',
  1223703,
  1223945,
  1,
  'EL100_RS05930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'racE',
  'glutamate racemase',
  1224024,
  1224818,
  1,
  'EL100_RS05935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404696.1',
  'nucleoside-triphosphate diphosphatase',
  1224815,
  1225783,
  1,
  'EL100_RS05940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404695.1',
  'metallophosphoesterase',
  1225768,
  1226289,
  1,
  'EL100_RS05945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cbpB',
  'cyclic-di-AMP-binding protein CbpB',
  1226286,
  1226747,
  1,
  'EL100_RS05950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'xerD',
  'site-specific tyrosine recombinase XerD',
  1226744,
  1227475,
  1,
  'EL100_RS05955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048715402.1',
  'segregation/condensation protein A',
  1227475,
  1228185,
  1,
  'EL100_RS05960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'scpB',
  'SMC-Scp complex subunit ScpB',
  1228178,
  1228747,
  1,
  'EL100_RS05965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023024093.1',
  'pseudouridine synthase',
  1228737,
  1229465,
  1,
  'EL100_RS05970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yidD',
  'membrane protein insertion efficiency factorYidD',
  1229465,
  1229719,
  1,
  'EL100_RS05975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404693.1',
  'TrkH family potassium uptake protein',
  1229797,
  1231257,
  -1,
  'EL100_RS05980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trkA',
  'Trk system potassium transporter TrkA',
  1231261,
  1232616,
  -1,
  'EL100_RS05985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404691.1',
  'tRNA (cytidine(34)-2''-O)-methyltransferase',
  1232917,
  1233459,
  1,
  'EL100_RS05990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595795.1',
  'ECF transporter S component',
  1233980,
  1234537,
  1,
  'EL100_RS05995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS05995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404690.1',
  'phosphatase PAP2 family protein',
  1234527,
  1235177,
  1,
  'EL100_RS06000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404689.1',
  'MGMT family protein',
  1235181,
  1235492,
  1,
  'EL100_RS06005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mnmL',
  'tRNA modification radical SAM protein MnmL/YtqA',
  1235516,
  1236457,
  1,
  'EL100_RS06010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mnmM',
  'tRNA5-(aminomethyl)-2-thiouridylate-methyltransferase MnmM',
  1236459,
  1237016,
  1,
  'EL100_RS06015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404687.1',
  'hypothetical protein',
  1237009,
  1237272,
  1,
  'EL100_RS06020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404686.1',
  'cation:proton antiporter',
  1237276,
  1239330,
  1,
  'EL100_RS06025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404685.1',
  'ABC transporter ATP-binding protein',
  1239414,
  1240217,
  -1,
  'EL100_RS06030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404684.1',
  'AI-2E family transporter',
  1240274,
  1241401,
  1,
  'EL100_RS06035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404683.1',
  'AcpB/EbpR/MafR family transcriptional regulator',
  1241559,
  1243040,
  1,
  'EL100_RS06040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404682.1',
  'hemolysin family protein',
  1243145,
  1244494,
  1,
  'EL100_RS06045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404681.1',
  'hypothetical protein',
  1244607,
  1245758,
  1,
  'EL100_RS06050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404680.1',
  'hypothetical protein',
  1246182,
  1247156,
  1,
  'EL100_RS06055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404679.1',
  'ABC transporter substrate-binding protein',
  1247584,
  1248558,
  1,
  'EL100_RS06060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405066.1',
  'ABC transporter permease',
  1248569,
  1249462,
  1,
  'EL100_RS06065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404678.1',
  'ABC transporter ATP-binding protein',
  1249476,
  1250279,
  1,
  'EL100_RS06070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404677.1',
  'glycosyl hydrolase family 95 catalyticdomain-containing protein',
  1250719,
  1255608,
  -1,
  'EL100_RS06075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'UTRA domain-containing protein',
  1255872,
  1256057,
  -1,
  'EL100_RS06080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pflA',
  'pyruvate formate-lyase-activating protein',
  1256272,
  1257066,
  1,
  'EL100_RS06085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404676.1',
  'manganese-dependent inorganic pyrophosphatase',
  1257194,
  1258129,
  1,
  'EL100_RS06090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404675.1',
  'YiiX/YebB-like N1pC/P60 family cysteinehydrolase',
  1258193,
  1258705,
  1,
  'EL100_RS06095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404674.1',
  'DUF1803 domain-containing protein',
  1258689,
  1259339,
  1,
  'EL100_RS06100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404673.1',
  'UDP-N-acetylmuramoyl-L-alanyl-D-glutamate--L-lysine ligase',
  1259376,
  1260821,
  -1,
  'EL100_RS06105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404672.1',
  'putative polysaccharide biosynthesis protein',
  1260908,
  1262536,
  1,
  'EL100_RS06110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404671.1',
  'cystathionine gamma-synthase',
  1262677,
  1263771,
  1,
  'EL100_RS06115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404670.1',
  'MalY/PatB family protein',
  1263781,
  1264950,
  1,
  'EL100_RS06120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mgtA',
  'magnesium-translocating P-type ATPase',
  1265369,
  1268029,
  1,
  'EL100_RS06125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'upp',
  'uracil phosphoribosyltransferase',
  1268130,
  1268759,
  1,
  'EL100_RS06130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404667.1',
  'ATP-dependent Clp protease proteolytic subunit',
  1268922,
  1269512,
  1,
  'EL100_RS06135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404666.1',
  'DUF2129 domain-containing protein',
  1269641,
  1269925,
  1,
  'EL100_RS06140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404665.1',
  'ABC transporter substrate-binding protein',
  1270020,
  1271177,
  1,
  'EL100_RS06145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_009731472.1',
  'branched-chain amino acid ABC transporterpermease',
  1271259,
  1272128,
  1,
  'EL100_RS06150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595829.1',
  'branched-chain amino acid ABC transporterpermease',
  1272132,
  1273079,
  1,
  'EL100_RS06155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404664.1',
  'ABC transporter ATP-binding protein',
  1273079,
  1273843,
  1,
  'EL100_RS06160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404663.1',
  'ABC transporter ATP-binding protein',
  1273843,
  1274553,
  1,
  'EL100_RS06165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404662.1',
  'CBS domain-containing protein',
  1274904,
  1275560,
  1,
  'EL100_RS06170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404661.1',
  'YitT family protein',
  1275717,
  1276604,
  -1,
  'EL100_RS06175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tmk',
  'dTMP kinase',
  1276777,
  1277415,
  1,
  'EL100_RS06180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404659.1',
  'DNA polymerase III subunit delta''',
  1277412,
  1278311,
  1,
  'EL100_RS06185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yabA',
  'DNA replication initiation control protein YabA',
  1278316,
  1278636,
  1,
  'EL100_RS06190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rsmI',
  '16S rRNA(cytidine(1402)-2''-O)-methyltransferase',
  1278639,
  1279523,
  1,
  'EL100_RS06195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048689681.1',
  'GNAT family N-acetyltransferase',
  1279513,
  1280085,
  1,
  'EL100_RS06200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404657.1',
  'methylated-DNA--[protein]-cysteineS-methyltransferase',
  1280078,
  1280566,
  1,
  'EL100_RS06205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048789566.1',
  'arsenate reductase family protein',
  1280576,
  1280929,
  1,
  'EL100_RS06210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404656.1',
  'ABC-F family ATP-binding cassettedomain-containing protein',
  1281014,
  1282555,
  1,
  'EL100_RS06215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404655.1',
  'peptidylprolyl isomerase',
  1282589,
  1283413,
  -1,
  'EL100_RS06220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946485.1',
  'hypothetical protein',
  1283607,
  1284389,
  1,
  'EL100_RS06225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404654.1',
  'hypothetical protein',
  1284453,
  1285373,
  1,
  'EL100_RS06230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555440.1',
  'hypothetical protein',
  1285537,
  1285812,
  1,
  'EL100_RS06235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404652.1',
  'DNA translocase FtsK',
  1285913,
  1288267,
  1,
  'EL100_RS06240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gloA2',
  'SMU1112c/YaeR family gloxylase I-likemetalloprotein',
  1288369,
  1288755,
  1,
  'EL100_RS06245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404651.1',
  'HAD-IC family P-type ATPase',
  1288840,
  1291185,
  1,
  'EL100_RS06250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404650.1',
  'DUF3397 family protein',
  1291239,
  1291583,
  -1,
  'EL100_RS06255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplK',
  '50S ribosomal protein L11',
  1291745,
  1292170,
  1,
  'EL100_RS06260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplA',
  '50S ribosomal protein L1',
  1292268,
  1292957,
  1,
  'EL100_RS06265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011388.1',
  'accessory Sec-dependent serine-rich glycoproteinadhesin',
  1293112,
  1298451,
  1,
  'EL100_RS09795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pyrH',
  'UMP kinase',
  1298991,
  1299722,
  1,
  'EL100_RS06285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'frr',
  'ribosome recycling factor',
  1299741,
  1300298,
  1,
  'EL100_RS06290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cvfB',
  'RNA-binding virulence regulatory protein CvfB',
  1300405,
  1301259,
  1,
  'EL100_RS06295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023023987.1',
  'YozE family protein',
  1301270,
  1301485,
  1,
  'EL100_RS06300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946450.1',
  'PhoH family protein',
  1301577,
  1302575,
  1,
  'EL100_RS06305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ald',
  'alanine dehydrogenase',
  1302642,
  1303754,
  -1,
  'EL100_RS06310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404645.1',
  'GNAT family N-acetyltransferase',
  1303962,
  1304531,
  1,
  'EL100_RS06315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  1304582,
  1304654,
  1,
  'EL100_RS06320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tetA(46)',
  'tetracycline efflux ABC transporter Tet(46)subunit A',
  1305058,
  1306782,
  1,
  'EL100_RS06325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tetB(46)',
  'tetracycline efflux ABC transporter Tet(46)subunit B',
  1306784,
  1308520,
  1,
  'EL100_RS06330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ybeY',
  'rRNA maturation RNase YbeY',
  1308612,
  1309109,
  1,
  'EL100_RS06335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404638.1',
  'diacylglycerol kinase family protein',
  1309090,
  1309488,
  1,
  'EL100_RS06340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'era',
  'GTPase Era',
  1309518,
  1310417,
  1,
  'EL100_RS06345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mutM',
  'DNA-formamidopyrimidine glycosylase',
  1310463,
  1311287,
  1,
  'EL100_RS06350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'coaE',
  'dephospho-CoA kinase',
  1311288,
  1311884,
  1,
  'EL100_RS06355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_277870575.1',
  'multidrug efflux MFS transporter',
  1311901,
  1313094,
  1,
  'EL100_RS06360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpmG',
  '50S ribosomal protein L33',
  1313084,
  1313233,
  1,
  'EL100_RS06365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'secG',
  'preprotein translocase subunit SecG',
  1313277,
  1313510,
  1,
  'EL100_RS06370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rnr',
  'ribonuclease R',
  1313637,
  1315994,
  1,
  'EL100_RS06375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'smpB',
  'SsrA-binding protein SmpB',
  1315957,
  1316424,
  1,
  'EL100_RS06380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404626.1',
  'C69 family dipeptidase',
  1316609,
  1318354,
  1,
  'EL100_RS06385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tehB',
  'SAM-dependent methyltransferase TehB',
  1318514,
  1319374,
  1,
  'EL100_RS06390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404622.1',
  'CidA/LrgA family protein',
  1319510,
  1319881,
  1,
  'EL100_RS06395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405062.1',
  'LrgB family protein',
  1319881,
  1320576,
  1,
  'EL100_RS06400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404620.1',
  'C69 family dipeptidase',
  1320791,
  1322452,
  1,
  'EL100_RS06405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404618.1',
  'PrsW family glutamic-type intramembraneprotease',
  1322445,
  1323275,
  1,
  'EL100_RS06410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nt5e',
  'cell surface ecto-5''-nucleotidase Nt5e',
  1323636,
  1325834,
  -1,
  'EL100_RS06415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404614.1',
  'TetR/AcrR family transcriptional regulator',
  1326001,
  1326561,
  -1,
  'EL100_RS06420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404612.1',
  'ABC transporter ATP-binding protein',
  1327107,
  1327808,
  1,
  'EL100_RS06425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404610.1',
  'FtsX-like permease family protein',
  1327820,
  1330537,
  1,
  'EL100_RS06430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404608.1',
  'metallophosphoesterase family protein',
  1330606,
  1331448,
  1,
  'EL100_RS06435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404606.1',
  'Rrf2 family transcriptional regulator',
  1331592,
  1332041,
  1,
  'EL100_RS06440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404604.1',
  'hypothetical protein',
  1332138,
  1332476,
  -1,
  'EL100_RS06445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404603.1',
  'M24 family metallopeptidase',
  1332500,
  1333582,
  -1,
  'EL100_RS06450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ccpA',
  'catabolite control protein A',
  1333743,
  1334747,
  1,
  'EL100_RS06455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404601.1',
  'LTA glycolipid anchor biosynthesisglycosyltransferase, IagA/BgsA family',
  1335000,
  1335998,
  1,
  'EL100_RS06460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404599.1',
  'glycosyltransferase family 4 protein',
  1336000,
  1337322,
  1,
  'EL100_RS06465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'thrS',
  'threonine--tRNA ligase',
  1337655,
  1339598,
  1,
  'EL100_RS06470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404595.1',
  'DUF389 domain-containing protein',
  1339959,
  1341008,
  -1,
  'EL100_RS06475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yycF',
  'response regulator YycF',
  1341588,
  1342289,
  1,
  'EL100_RS06480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'vicK',
  'cell wall metabolism sensor histidine kinaseVicK',
  1342282,
  1343628,
  1,
  'EL100_RS06485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_125374345.1',
  'exodeoxyribonuclease WalJ',
  1343637,
  1344446,
  1,
  'EL100_RS06490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_414386485.1',
  'YbaN family protein',
  1344659,
  1345048,
  1,
  'EL100_RS06495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rnc',
  'ribonuclease III',
  1345207,
  1345908,
  1,
  'EL100_RS06500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'smc',
  'chromosome segregation protein SMC',
  1345899,
  1349444,
  1,
  'EL100_RS06505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404589.1',
  'Cof-type HAD-IIB family hydrolase',
  1349434,
  1350231,
  1,
  'EL100_RS06510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404587.1',
  'Cof-type HAD-IIB family hydrolase',
  1350228,
  1351049,
  1,
  'EL100_RS06515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ftsY',
  'signal recognition particle-docking proteinFtsY',
  1351049,
  1352716,
  1,
  'EL100_RS06520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'zwf',
  'glucose-6-phosphate dehydrogenase',
  1352781,
  1354247,
  -1,
  'EL100_RS06525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404582.1',
  'TIGR03943 family putative permease subunit',
  1354412,
  1355227,
  -1,
  'EL100_RS06530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595902.1',
  'permease',
  1355224,
  1356129,
  -1,
  'EL100_RS06535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555439.1',
  'SPJ_0845 family protein',
  1356126,
  1356272,
  -1,
  'EL100_RS06540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404580.1',
  'Tex family protein',
  1356391,
  1358517,
  1,
  'EL100_RS06545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404579.1',
  'SprT family protein',
  1358504,
  1358956,
  1,
  'EL100_RS06550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404577.1',
  'PspC domain-containing protein',
  1359017,
  1359292,
  1,
  'EL100_RS06555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'hprK',
  'HPr(Ser) kinase/phosphatase',
  1359687,
  1360619,
  1,
  'EL100_RS06560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'lgt',
  'prolipoprotein diacylglyceryl transferase',
  1360616,
  1361398,
  1,
  'EL100_RS06565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595909.1',
  'DUF948 domain-containing protein',
  1361410,
  1361793,
  1,
  'EL100_RS06570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404571.1',
  'YtxH domain-containing protein',
  1361809,
  1362276,
  1,
  'EL100_RS06575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595911.1',
  'DUF3270 family protein',
  1362374,
  1362670,
  -1,
  'EL100_RS06580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404570.1',
  'peptidase U32 family protein',
  1362802,
  1363731,
  1,
  'EL100_RS06585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404568.1',
  'peptidase U32 family protein',
  1363894,
  1365180,
  1,
  'EL100_RS06590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_040803002.1',
  'hypothetical protein',
  1365220,
  1365549,
  -1,
  'EL100_RS06595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404567.1',
  'YdbC family protein',
  1365640,
  1365852,
  1,
  'EL100_RS06600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404565.1',
  'cyclase family protein',
  1366070,
  1366801,
  1,
  'EL100_RS06605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gorA',
  'glutathione-disulfide reductase',
  1367152,
  1368501,
  -1,
  'EL100_RS06610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404561.1',
  'efflux RND transporter periplasmic adaptorsubunit',
  1368702,
  1369859,
  1,
  'EL100_RS06615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404559.1',
  'ABC transporter ATP-binding protein',
  1369843,
  1370538,
  1,
  'EL100_RS06620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404557.1',
  'ABC transporter permease',
  1370538,
  1371890,
  1,
  'EL100_RS06625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'lysS',
  'lysine--tRNA ligase',
  1372074,
  1373564,
  1,
  'EL100_RS06630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404554.1',
  'histidine phosphatase family protein',
  1373876,
  1374499,
  -1,
  'EL100_RS06635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_111674403.1',
  'aminoacyl-tRNA deacylase',
  1374514,
  1374987,
  -1,
  'EL100_RS06640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006595924.1',
  'GH25 family lysozyme',
  1375074,
  1375937,
  -1,
  'EL100_RS06645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ftsW',
  'cell division peptidoglycan polymerase FtsW',
  1376194,
  1377432,
  1,
  'EL100_RS06650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ppc',
  'phosphoenolpyruvate carboxylase',
  1377461,
  1380286,
  1,
  'EL100_RS06655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tuf',
  'elongation factor Tu',
  1380542,
  1381738,
  1,
  'EL100_RS06660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tpiA',
  'triose-phosphate isomerase',
  1381903,
  1382661,
  1,
  'EL100_RS06665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404549.1',
  'aminoacyltransferase',
  1382893,
  1384068,
  -1,
  'EL100_RS06670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404548.1',
  'aminoacyltransferase',
  1384077,
  1385291,
  -1,
  'EL100_RS06675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yidA',
  'sugar-phosphatase',
  1385291,
  1386100,
  -1,
  'EL100_RS06680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404545.1',
  'HD domain-containing protein',
  1386090,
  1387400,
  -1,
  'EL100_RS06685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404543.1',
  'YwiB family protein',
  1387511,
  1387894,
  1,
  'EL100_RS06690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404542.1',
  'cation-translocating P-type ATPase',
  1388088,
  1390772,
  1,
  'EL100_RS06695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404540.1',
  'MIP/aquaporin family protein',
  1390894,
  1391562,
  1,
  'EL100_RS06700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404539.1',
  'metallophosphoesterase',
  1391618,
  1392475,
  -1,
  'EL100_RS06705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'prfB',
  'peptide chain release factor 2',
  1392673,
  1393768,
  1,
  'EL100_RS06710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ftsE',
  'cell division ATP-binding protein FtsE',
  1393811,
  1394503,
  1,
  'EL100_RS06715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ftsX',
  'permease-like cell division protein FtsX',
  1394496,
  1395422,
  1,
  'EL100_RS06720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404535.1',
  'MBL fold metallo-hydrolase',
  1395616,
  1396257,
  -1,
  'EL100_RS06725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404533.1',
  'bifunctional DnaQ familyexonuclease/ATP-dependent helicase',
  1396417,
  1398876,
  1,
  'EL100_RS06730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404531.1',
  'YeiH family protein',
  1398878,
  1399885,
  1,
  'EL100_RS06735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404530.1',
  'FtsW/RodA/SpoVE family cell cycle protein',
  1399902,
  1401146,
  1,
  'EL100_RS06740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404529.1',
  'DJ-1 family glyoxalase III',
  1401148,
  1401705,
  1,
  'EL100_RS06745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404528.1',
  'HAD-IA family hydrolase',
  1401884,
  1402447,
  1,
  'EL100_RS06750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gyrB',
  'DNA topoisomerase (ATP-hydrolyzing) subunit B',
  1402460,
  1404409,
  1,
  'EL100_RS06755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ezrA',
  'septation ring formation regulator EzrA',
  1404496,
  1406220,
  1,
  'EL100_RS06760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404526.1',
  'glycerate kinase',
  1406311,
  1407429,
  1,
  'EL100_RS06765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404525.1',
  'DUF1694 domain-containing protein',
  1407487,
  1407930,
  -1,
  'EL100_RS06770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'eno',
  'surface-displayed alpha-enolase',
  1408117,
  1409421,
  1,
  'EL100_RS06775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023023803.1',
  'hypothetical protein',
  1409522,
  1409707,
  -1,
  'EL100_RS06780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946451.1',
  'lactonase family protein',
  1409783,
  1410793,
  -1,
  'EL100_RS06785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404523.1',
  'AI-2E family transporter',
  1410968,
  1412137,
  1,
  'EL100_RS06790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404522.1',
  'tetratricopeptide repeat protein',
  1412127,
  1413365,
  1,
  'EL100_RS06795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'budA',
  'acetolactate decarboxylase',
  1413515,
  1414231,
  1,
  'EL100_RS06800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404520.1',
  'Rqc2 family fibronectin-binding protein',
  1414711,
  1416372,
  -1,
  'EL100_RS06805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trpX',
  'tryptophan ABC transporter substrate-bindingprotein',
  1416990,
  1417922,
  1,
  'EL100_RS06810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pheS',
  'phenylalanine--tRNA ligase subunit alpha',
  1418236,
  1419282,
  1,
  'EL100_RS06815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404518.1',
  'GNAT family N-acetyltransferase',
  1419285,
  1419800,
  1,
  'EL100_RS06820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pheT',
  'phenylalanine--tRNA ligase subunit beta',
  1419958,
  1422363,
  1,
  'EL100_RS06825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405059.1',
  'hypothetical protein',
  1422599,
  1422907,
  1,
  'EL100_RS06830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003002675.1',
  'helix-turn-helix transcriptional regulator',
  1422921,
  1423130,
  1,
  'EL100_RS06835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404515.1',
  'DUF3169 family protein',
  1423133,
  1423906,
  1,
  'EL100_RS06840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_013903836.1',
  'ABC transporter ATP-binding protein',
  1423918,
  1424811,
  1,
  'EL100_RS06845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404514.1',
  'ABC transporter permease',
  1424808,
  1426022,
  1,
  'EL100_RS06850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404513.1',
  'TIGR04197 family type VII secretion effector',
  1426249,
  1426527,
  1,
  'EL100_RS06855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404512.1',
  'cingulin',
  1426530,
  1426877,
  1,
  'EL100_RS06860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404511.1',
  'virulence protein',
  1426868,
  1428472,
  1,
  'EL100_RS06865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003007944.1',
  'hypothetical protein',
  1428483,
  1429091,
  1,
  'EL100_RS06870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404510.1',
  'hypothetical protein',
  1429088,
  1429717,
  1,
  'EL100_RS06875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404509.1',
  'hypothetical protein',
  1429714,
  1430346,
  1,
  'EL100_RS06880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404508.1',
  'hypothetical protein',
  1430343,
  1430969,
  1,
  'EL100_RS06885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404507.1',
  'hypothetical protein',
  1430966,
  1431583,
  1,
  'EL100_RS06890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404506.1',
  'hypothetical protein',
  1431580,
  1432206,
  1,
  'EL100_RS06895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404505.1',
  'hypothetical protein',
  1432203,
  1432802,
  1,
  'EL100_RS06900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404504.1',
  'hypothetical protein',
  1432829,
  1433440,
  1,
  'EL100_RS06905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404503.1',
  'aldo/keto reductase',
  1433552,
  1434475,
  1,
  'EL100_RS06910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404502.1',
  'TetR/AcrR family transcriptional regulator',
  1434625,
  1435200,
  1,
  'EL100_RS06915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404501.1',
  'ABC transporter ATP-binding protein',
  1435197,
  1435877,
  1,
  'EL100_RS06920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404500.1',
  'FtsX-like permease family protein',
  1435881,
  1437026,
  1,
  'EL100_RS06925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404499.1',
  'glycerophosphoryl diester phosphodiesterasemembrane domain-containing protein',
  1437285,
  1439048,
  1,
  'EL100_RS06930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404498.1',
  'ABC transporter ATP-binding protein',
  1439333,
  1441081,
  1,
  'EL100_RS06935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404497.1',
  'ABC transporter ATP-binding protein',
  1441071,
  1442939,
  1,
  'EL100_RS06940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404496.1',
  'YbgA family protein',
  1443447,
  1443824,
  1,
  'EL100_RS06945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404495.1',
  'TIGR02328 family protein',
  1443825,
  1444190,
  1,
  'EL100_RS06950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404494.1',
  'hypothetical protein',
  1444596,
  1444787,
  1,
  'EL100_RS06955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555438.1',
  'hypothetical protein',
  1444789,
  1444962,
  1,
  'EL100_RS06960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404493.1',
  'hypothetical protein',
  1444959,
  1445240,
  1,
  'EL100_RS06965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404492.1',
  'hypothetical protein',
  1445317,
  1445532,
  1,
  'EL100_RS06970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404491.1',
  '16S rRNA processing protein RimM',
  1445593,
  1445820,
  1,
  'EL100_RS06975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404490.1',
  'DEAD/DEAH box helicase family protein',
  1446147,
  1449209,
  1,
  'EL100_RS06980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404489.1',
  'HsdM family class I SAM-dependentmethyltransferase',
  1449209,
  1450813,
  1,
  'EL100_RS06985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404488.1',
  'restriction endonuclease subunit S',
  1450806,
  1452113,
  1,
  'EL100_RS06990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404487.1',
  'hypothetical protein',
  1452132,
  1453199,
  1,
  'EL100_RS06995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS06995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011390.1',
  'hypothetical protein',
  1453196,
  1454584,
  1,
  'EL100_RS07000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404485.1',
  'hypothetical protein',
  1454880,
  1455236,
  1,
  'EL100_RS07005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404484.1',
  'hypothetical protein',
  1455326,
  1455589,
  1,
  'EL100_RS07010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'HigA family addiction module antitoxin',
  1455731,
  1456003,
  1,
  'EL100_RS07015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404482.1',
  'VOC family protein',
  1456166,
  1457017,
  1,
  'EL100_RS07020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404481.1',
  'NADPH-dependent FMN reductase',
  1457165,
  1457704,
  1,
  'EL100_RS07025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404480.1',
  'VIT1/CCC1 transporter family protein',
  1457993,
  1458688,
  -1,
  'EL100_RS07030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404479.1',
  'hypothetical protein',
  1458925,
  1459530,
  1,
  'EL100_RS07035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404478.1',
  'M42 family metallopeptidase',
  1459715,
  1460752,
  1,
  'EL100_RS07040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trpE',
  'anthranilate synthase component I',
  1461245,
  1462600,
  1,
  'EL100_RS07045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404476.1',
  'aminodeoxychorismate/anthranilate synthasecomponent II',
  1462597,
  1463163,
  1,
  'EL100_RS07050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trpD',
  'anthranilate phosphoribosyltransferase',
  1463228,
  1464232,
  1,
  'EL100_RS07055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trpC',
  'indole-3-glycerol phosphate synthase TrpC',
  1464229,
  1464996,
  1,
  'EL100_RS07060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404473.1',
  'phosphoribosylanthranilate isomerase',
  1464983,
  1465564,
  1,
  'EL100_RS07065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trpB',
  'tryptophan synthase subunit beta',
  1465561,
  1466763,
  1,
  'EL100_RS07070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trpA',
  'tryptophan synthase subunit alpha',
  1466766,
  1467551,
  1,
  'EL100_RS07075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404470.1',
  'peptide ABC transporter substrate-bindingprotein',
  1467661,
  1469661,
  1,
  'EL100_RS07080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404469.1',
  'CocE/NonD family hydrolase',
  1469776,
  1472844,
  1,
  'EL100_RS07085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trxA',
  'thioredoxin',
  1472938,
  1473252,
  1,
  'EL100_RS07090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404468.1',
  'alpha-amylase',
  1473619,
  1475070,
  -1,
  'EL100_RS07095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404467.1',
  'CocE/NonD family hydrolase',
  1475545,
  1478637,
  1,
  'EL100_RS07100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405057.1',
  'M20/M25/M40 family metallo-hydrolase',
  1478756,
  1480330,
  1,
  'EL100_RS07105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404466.1',
  'ABC transporter ATP-binding protein',
  1480437,
  1481180,
  1,
  'EL100_RS07110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404465.1',
  'hypothetical protein',
  1481170,
  1482816,
  1,
  'EL100_RS07115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404464.1',
  'DegV family protein',
  1483050,
  1483892,
  -1,
  'EL100_RS07120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596003.1',
  'TetR/AcrR family transcriptional regulator',
  1484020,
  1484598,
  1,
  'EL100_RS07125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404463.1',
  'DNA topology modulation protein',
  1484625,
  1485155,
  -1,
  'EL100_RS07130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsT',
  '30S ribosomal protein S20',
  1485221,
  1485469,
  -1,
  'EL100_RS07135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'coaA',
  'type I pantothenate kinase',
  1485576,
  1486496,
  -1,
  'EL100_RS07140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404461.1',
  'class I SAM-dependent methyltransferase',
  1486592,
  1487185,
  1,
  'EL100_RS07145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404460.1',
  'pyrimidine-nucleoside phosphorylase',
  1487182,
  1488459,
  1,
  'EL100_RS07150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'deoC',
  'deoxyribose-phosphate aldolase',
  1488482,
  1489144,
  1,
  'EL100_RS07155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596010.1',
  'cytidine deaminase',
  1489131,
  1489520,
  1,
  'EL100_RS07160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_120701814.1',
  'BMP family lipoprotein',
  1489599,
  1490654,
  1,
  'EL100_RS07165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946452.1',
  'ABC transporter ATP-binding protein',
  1490792,
  1492327,
  1,
  'EL100_RS07170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555420.1',
  'hypothetical protein',
  1492622,
  1492879,
  -1,
  'EL100_RS07175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_414485340.1',
  'ABC transporter permease',
  1492779,
  1493858,
  1,
  'EL100_RS07180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404457.1',
  'ABC transporter permease',
  1493861,
  1494817,
  1,
  'EL100_RS07185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404456.1',
  'polysaccharide deacetylase family protein',
  1494877,
  1495794,
  -1,
  'EL100_RS07190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404455.1',
  'homoserine dehydrogenase',
  1496016,
  1497302,
  1,
  'EL100_RS07195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'thrB',
  'homoserine kinase',
  1497305,
  1498180,
  1,
  'EL100_RS07200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404453.1',
  'hypothetical protein',
  1498337,
  1499263,
  1,
  'EL100_RS07205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'murB',
  'UDP-N-acetylmuramate dehydrogenase',
  1499398,
  1500300,
  1,
  'EL100_RS07210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404451.1',
  'ABC transporter ATP-binding protein',
  1500506,
  1501663,
  1,
  'EL100_RS07215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023023685.1',
  'ABC transporter permease',
  1501644,
  1502450,
  1,
  'EL100_RS07220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404450.1',
  'ABC transporter permease',
  1502447,
  1503220,
  1,
  'EL100_RS07225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404449.1',
  'ABC transporter substrate-binding protein',
  1503217,
  1504287,
  1,
  'EL100_RS07230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404448.1',
  'CocE/NonD family hydrolase',
  1504563,
  1507550,
  1,
  'EL100_RS07235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006597366.1',
  'glycosyltransferase family 2 protein',
  1507699,
  1508409,
  1,
  'EL100_RS07240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011429.1',
  'DUF2304 domain-containing protein',
  1508450,
  1508746,
  1,
  'EL100_RS07245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404446.1',
  'lipopolysaccharide biosynthesis protein',
  1508730,
  1510013,
  1,
  'EL100_RS07250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404445.1',
  'glycosyltransferase family 2 protein',
  1509997,
  1510779,
  1,
  'EL100_RS07255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011392.1',
  'glycosyltransferase family 2 protein',
  1510879,
  1511853,
  1,
  'EL100_RS07260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404443.1',
  'glycosyltransferase family 2 protein',
  1511910,
  1512836,
  1,
  'EL100_RS07265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rfbD',
  'dTDP-4-dehydrorhamnose reductase',
  1512901,
  1513749,
  1,
  'EL100_RS07270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cps2T',
  'beta 1-4 rhamnosyltransferase Cps2T',
  1513849,
  1514997,
  1,
  'EL100_RS07275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404440.1',
  'glycosyltransferase family 2 protein',
  1514994,
  1515935,
  1,
  'EL100_RS07280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404439.1',
  'ABC transporter permease',
  1515935,
  1516741,
  1,
  'EL100_RS07285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404438.1',
  'ABC transporter ATP-binding protein',
  1516741,
  1517943,
  1,
  'EL100_RS07290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404437.1',
  'glycosyltransferase family 4 protein',
  1517961,
  1519619,
  1,
  'EL100_RS07295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404436.1',
  'rhamnan synthesis F family protein',
  1519621,
  1521366,
  1,
  'EL100_RS07300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404435.1',
  'DUF2142 domain-containing protein',
  1521377,
  1522861,
  1,
  'EL100_RS07305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404434.1',
  'LTA synthase family protein',
  1522898,
  1525426,
  1,
  'EL100_RS07310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596041.1',
  'EbsA family protein',
  1525556,
  1526044,
  1,
  'EL100_RS07315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404433.1',
  'ferredoxin',
  1526041,
  1526238,
  -1,
  'EL100_RS07320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404432.1',
  'SAG1386/EF1546 family surface-associatedprotein',
  1526284,
  1526724,
  1,
  'EL100_RS07325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cmk',
  '(d)CMP kinase',
  1526735,
  1527418,
  1,
  'EL100_RS07330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'infC',
  'translation initiation factor IF-3',
  1527585,
  1528115,
  1,
  'EL100_RS07335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpmI',
  '50S ribosomal protein L35',
  1528149,
  1528349,
  1,
  'EL100_RS07340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplT',
  '50S ribosomal protein L20',
  1528399,
  1528758,
  1,
  'EL100_RS07345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404430.1',
  'deoxycytidylate deaminase',
  1528889,
  1529356,
  1,
  'EL100_RS07350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404429.1',
  'hypothetical protein',
  1529447,
  1530940,
  1,
  'EL100_RS07355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404428.1',
  'cysteine ABC transporter substrate-bindingprotein',
  1531133,
  1531984,
  -1,
  'EL100_RS07360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404427.1',
  'amino acid ABC transporter ATP-binding protein',
  1531996,
  1532754,
  -1,
  'EL100_RS07365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404426.1',
  'amino acid ABC transporter permease',
  1532756,
  1533433,
  -1,
  'EL100_RS07370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_125374917.1',
  'amino acid ABC transporter permease',
  1533393,
  1534073,
  -1,
  'EL100_RS07375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404425.1',
  'hypothetical protein',
  1534307,
  1534801,
  1,
  'EL100_RS07380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404424.1',
  'hypothetical protein',
  1535210,
  1535659,
  1,
  'EL100_RS07385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404423.1',
  'hypothetical protein',
  1535851,
  1536387,
  1,
  'EL100_RS07390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'metK',
  'methionine adenosyltransferase',
  1536598,
  1537788,
  1,
  'EL100_RS07395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404421.1',
  'CopY/TcrY family copper transport repressor',
  1538094,
  1538528,
  1,
  'EL100_RS07400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404420.1',
  'heavy metal translocating P-type ATPase',
  1538525,
  1540753,
  1,
  'EL100_RS07405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'copZ',
  'copper chaperone CopZ',
  1540801,
  1541007,
  1,
  'EL100_RS07410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404418.1',
  'UDP-N-acetylglucosamine1-carboxyvinyltransferase',
  1541268,
  1542530,
  1,
  'EL100_RS07415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404417.1',
  'GNAT family N-acetyltransferase',
  1542543,
  1543094,
  1,
  'EL100_RS07420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'spxR',
  'CBS-HotDog domain-containing transcriptionfactor SpxR',
  1543087,
  1544364,
  1,
  'EL100_RS07425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404415.1',
  'methionyl aminopeptidase',
  1544383,
  1545243,
  1,
  'EL100_RS07430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404414.1',
  'YihY/virulence factor BrkB family protein',
  1545333,
  1546301,
  1,
  'EL100_RS07435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404413.1',
  'MarR family winged helix-turn-helixtranscriptional regulator',
  1546577,
  1547041,
  1,
  'EL100_RS07440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404412.1',
  'B3/B4 domain-containing protein',
  1547038,
  1547745,
  1,
  'EL100_RS07445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404411.1',
  'GtrA family protein',
  1547947,
  1548384,
  -1,
  'EL100_RS07450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404410.1',
  'QueT transporter family protein',
  1548547,
  1549056,
  1,
  'EL100_RS07455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ligA',
  'NAD-dependent DNA ligase LigA',
  1549347,
  1551305,
  1,
  'EL100_RS07460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404406.1',
  'diacylglycerol kinase family lipid kinase',
  1551314,
  1552282,
  1,
  'EL100_RS07465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pulA',
  'type I pullulanase',
  1552359,
  1554656,
  1,
  'EL100_RS07470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404402.1',
  'LTA synthase family protein',
  1554686,
  1556875,
  -1,
  'EL100_RS07475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404400.1',
  'class I SAM-dependent rRNA methyltransferase',
  1557119,
  1558282,
  1,
  'EL100_RS07480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'aroD',
  'type I 3-dehydroquinate dehydratase',
  1558279,
  1558956,
  1,
  'EL100_RS07485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'aroE',
  'shikimate dehydrogenase',
  1558946,
  1559821,
  1,
  'EL100_RS07490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'aroB',
  '3-dehydroquinate synthase',
  1559923,
  1560987,
  1,
  'EL100_RS07495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'aroC',
  'chorismate synthase',
  1561009,
  1562175,
  1,
  'EL100_RS07500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404390.1',
  'prephenate dehydrogenase',
  1562188,
  1563294,
  1,
  'EL100_RS07505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404388.1',
  'YlbF/YmcA family competence regulator',
  1563395,
  1563733,
  1,
  'EL100_RS07510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'aroA',
  '3-phosphoshikimate 1-carboxyvinyltransferase',
  1564009,
  1565292,
  1,
  'EL100_RS07515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404385.1',
  'shikimate kinase',
  1565285,
  1565770,
  1,
  'EL100_RS07520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pheA',
  'prephenate dehydratase',
  1565761,
  1566615,
  1,
  'EL100_RS07525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404381.1',
  'LCP family protein',
  1566612,
  1567937,
  1,
  'EL100_RS07530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rlmD',
  '23S rRNA (uracil(1939)-C(5))-methyltransferaseRlmD',
  1568001,
  1569359,
  1,
  'EL100_RS07535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404376.1',
  'phosphoribosylanthranilate isomerase',
  1569771,
  1570262,
  1,
  'EL100_RS07540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404375.1',
  'DUF7668 domain-containing protein',
  1570342,
  1570716,
  1,
  'EL100_RS07545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405055.1',
  'hypothetical protein',
  1570827,
  1571405,
  1,
  'EL100_RS07550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'aac(6'')',
  'aminoglycoside 6''-N-acetyltransferase',
  1571629,
  1572057,
  1,
  'EL100_RS07555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404372.1',
  'Type 1 glutamine amidotransferase-likedomain-containing protein',
  1572105,
  1572713,
  1,
  'EL100_RS07560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404370.1',
  'TfoX/Sxy family protein',
  1572833,
  1573147,
  1,
  'EL100_RS07565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555435.1',
  'GNAT family N-acetyltransferase',
  1573174,
  1573716,
  1,
  'EL100_RS07570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404366.1',
  'CPBP family intramembrane glutamicendopeptidase',
  1574061,
  1574732,
  1,
  'EL100_RS07575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946453.1',
  'hypothetical protein',
  1574968,
  1575654,
  1,
  'EL100_RS07580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404363.1',
  'hypothetical protein',
  1575670,
  1576260,
  -1,
  'EL100_RS07585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404361.1',
  'glycoside hydrolase family 13 protein',
  1576433,
  1578181,
  1,
  'EL100_RS07590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_414485197.1',
  'RDD family protein',
  1578432,
  1578950,
  1,
  'EL100_RS07595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011393.1',
  'Ltp family lipoprotein',
  1579095,
  1579778,
  1,
  'EL100_RS07600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006597213.1',
  'hypothetical protein',
  1580261,
  1580572,
  1,
  'EL100_RS07605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011394.1',
  'Ltp family lipoprotein',
  1580738,
  1581472,
  1,
  'EL100_RS07610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404357.1',
  'DUF4300 family protein',
  1581836,
  1582723,
  1,
  'EL100_RS07615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404356.1',
  'hypothetical protein',
  1582778,
  1582969,
  1,
  'EL100_RS07620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404354.1',
  'hypothetical protein',
  1583023,
  1583412,
  1,
  'EL100_RS07625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404353.1',
  'CbrC family protein',
  1583479,
  1584330,
  1,
  'EL100_RS07630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_009730828.1',
  'ankyrin repeat domain-containing protein',
  1584618,
  1585289,
  1,
  'EL100_RS07635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404351.1',
  'AcpB/EbpR/MafR family transcriptional regulator',
  1585425,
  1586864,
  1,
  'EL100_RS07640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glpK',
  'glycerol kinase GlpK',
  1587175,
  1588683,
  1,
  'EL100_RS07645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glpO',
  'type 1 glycerol-3-phosphate oxidase',
  1588717,
  1590543,
  1,
  'EL100_RS07650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048716194.1',
  'MIP/aquaporin family protein',
  1590614,
  1591315,
  1,
  'EL100_RS07655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_009730834.1',
  '(S)-acetoin forming diacetyl reductase',
  1591982,
  1592746,
  1,
  'EL100_RS07660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011395.1',
  'hypothetical protein',
  1592923,
  1593525,
  1,
  'EL100_RS07665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404348.1',
  'copper homeostasis protein CutC',
  1593635,
  1594270,
  1,
  'EL100_RS07670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404347.1',
  'MmcQ/YjbR family DNA-binding protein',
  1594347,
  1595006,
  1,
  'EL100_RS07675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404345.1',
  'hypothetical protein',
  1595101,
  1595763,
  -1,
  'EL100_RS07680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404344.1',
  'aminotransferase-like domain-containing protein',
  1595903,
  1597171,
  -1,
  'EL100_RS07685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trhA',
  'PAQR family membrane homeostasis protein TrhA',
  1597260,
  1597907,
  -1,
  'EL100_RS07690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404342.1',
  'DUF1836 domain-containing protein',
  1597910,
  1598362,
  -1,
  'EL100_RS07695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yaaA',
  'peroxide stress protein YaaA',
  1598449,
  1599177,
  1,
  'EL100_RS07700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404338.1',
  'MarR family winged helix-turn-helixtranscriptional regulator',
  1599443,
  1599889,
  -1,
  'EL100_RS07705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404337.1',
  'pyridoxal phosphate-dependent aminotransferase',
  1600189,
  1601367,
  1,
  'EL100_RS07710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404335.1',
  'MucBP domain-containing protein',
  1601560,
  1602612,
  -1,
  'EL100_RS07715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'asnS',
  'asparagine--tRNA ligase',
  1602909,
  1604252,
  1,
  'EL100_RS07720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404331.1',
  'MFS transporter',
  1604523,
  1605722,
  1,
  'EL100_RS07725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404330.1',
  'ABC transporter ATP-binding protein',
  1605839,
  1607575,
  1,
  'EL100_RS07730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404329.1',
  'ABC transporter ATP-binding protein',
  1607572,
  1609299,
  1,
  'EL100_RS07735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946454.1',
  'MFS transporter',
  1609347,
  1610501,
  -1,
  'EL100_RS07740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023026884.1',
  'amino acid ABC transporter ATP-binding protein',
  1610927,
  1611667,
  -1,
  'EL100_RS07745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404325.1',
  'ABC transporter substrate-bindingprotein/permease',
  1611667,
  1613871,
  -1,
  'EL100_RS07750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946455.1',
  'CPBP family intramembrane glutamicendopeptidase',
  1614134,
  1615081,
  1,
  'EL100_RS07755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'uvrB',
  'excinuclease ABC subunit UvrB',
  1615223,
  1617211,
  1,
  'EL100_RS07760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404319.1',
  'NAD(P)H-dependent oxidoreductase',
  1617225,
  1617848,
  1,
  'EL100_RS07765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946456.1',
  '8-oxo-dGTP diphosphatase',
  1618826,
  1619293,
  1,
  'EL100_RS07770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404314.1',
  'PaaI family thioesterase',
  1619396,
  1619800,
  1,
  'EL100_RS07775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404313.1',
  'HAD family hydrolase',
  1619775,
  1620527,
  1,
  'EL100_RS07780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404312.1',
  'zinc ribbon domain-containing protein YjdM',
  1620656,
  1620991,
  1,
  'EL100_RS07785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404311.1',
  'Pr6Pr family membrane protein',
  1621036,
  1621674,
  1,
  'EL100_RS07790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pyrR',
  'bifunctional pyr operon transcriptionalregulator/uracil phosphoribosyltransferase PyrR',
  1621918,
  1622439,
  1,
  'EL100_RS07795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048690641.1',
  'aspartate carbamoyltransferase catalyticsubunit',
  1622533,
  1623450,
  1,
  'EL100_RS07800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404309.1',
  'carbamoyl phosphate synthase small subunit',
  1623541,
  1624638,
  1,
  'EL100_RS07805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011396.1',
  'ATP-binding protein',
  1624635,
  1626362,
  1,
  'EL100_RS07810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pepT',
  'peptidase T',
  1626418,
  1627638,
  -1,
  'EL100_RS07815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404306.1',
  'Cof-type HAD-IIB family hydrolase',
  1627653,
  1628471,
  -1,
  'EL100_RS07820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404305.1',
  'LexA family transcriptional regulator',
  1628468,
  1629220,
  -1,
  'EL100_RS07825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'lepA',
  'translation elongation factor 4',
  1629413,
  1631236,
  1,
  'EL100_RS07830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404304.1',
  'hypothetical protein',
  1631377,
  1632036,
  1,
  'EL100_RS07835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404303.1',
  'hypothetical protein',
  1632323,
  1632964,
  1,
  'EL100_RS07840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_009731114.1',
  'YkgJ family cysteine cluster protein',
  1633049,
  1633543,
  1,
  'EL100_RS07845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pynA',
  'pyrimidine 5''-nucleotidase PynA',
  1633543,
  1634235,
  1,
  'EL100_RS07850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404301.1',
  'hypothetical protein',
  1635029,
  1635778,
  1,
  'EL100_RS07855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsP',
  '30S ribosomal protein S16',
  1635902,
  1636174,
  1,
  'EL100_RS07860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'kphA',
  'RNA-binding protein KphA',
  1636194,
  1636433,
  1,
  'EL100_RS07865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rimM',
  'ribosome maturation factor RimM',
  1636541,
  1637059,
  1,
  'EL100_RS07870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trmD',
  'tRNA (guanosine(37)-N1)-methyltransferase TrmD',
  1637049,
  1637765,
  1,
  'EL100_RS07875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404299.1',
  'coiled-coil domain-containing protein',
  1637895,
  1640102,
  1,
  'EL100_RS07880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404298.1',
  'CAP domain-containing protein',
  1640727,
  1642514,
  1,
  'EL100_RS07885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404297.1',
  'DeoR/GlpR family DNA-binding transcriptionregulator',
  1642783,
  1643526,
  1,
  'EL100_RS07890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pfkB',
  '1-phosphofructokinase',
  1643523,
  1644434,
  1,
  'EL100_RS07895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404295.1',
  'PTS fructose transporter subunit IIABC',
  1644431,
  1646401,
  1,
  'EL100_RS07900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048788860.1',
  'DUF1149 family protein',
  1646699,
  1647073,
  1,
  'EL100_RS07905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404294.1',
  'DegV family protein',
  1647077,
  1647925,
  1,
  'EL100_RS07910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dapB',
  '4-hydroxy-tetrahydrodipicolinate reductase',
  1647935,
  1648702,
  1,
  'EL100_RS07915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404292.1',
  'CCA tRNA nucleotidyltransferase',
  1648699,
  1649919,
  1,
  'EL100_RS07920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404291.1',
  'ABC-F family ATP-binding cassettedomain-containing protein',
  1649916,
  1651787,
  1,
  'EL100_RS07925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404290.1',
  'DUF308 domain-containing protein',
  1651798,
  1652328,
  1,
  'EL100_RS07930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404289.1',
  'ROK family glucokinase',
  1652464,
  1653423,
  1,
  'EL100_RS07935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404288.1',
  'thymidylate synthase',
  1653518,
  1654357,
  1,
  'EL100_RS07940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404287.1',
  'CshA/CshB family fibrillar adhesin-relatedprotein',
  1654596,
  1661969,
  1,
  'EL100_RS07945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023023315.1',
  'dihydrofolate reductase',
  1662119,
  1662631,
  1,
  'EL100_RS07950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'clpX',
  'ATP-dependent Clp protease ATP-binding subunitClpX',
  1662842,
  1664074,
  1,
  'EL100_RS07955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yihA',
  'ribosome biogenesis GTP-binding proteinYihA/YsxC',
  1664086,
  1664682,
  1,
  'EL100_RS07960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404286.1',
  'glucosaminidase domain-containing protein',
  1664829,
  1665527,
  1,
  'EL100_RS07965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404285.1',
  'formate/nitrite transporter family protein',
  1665719,
  1666516,
  1,
  'EL100_RS07970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplJ',
  '50S ribosomal protein L10',
  1666752,
  1667252,
  1,
  'EL100_RS07975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplL',
  '50S ribosomal protein L7/L12',
  1667329,
  1667697,
  1,
  'EL100_RS07980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404283.1',
  'hypothetical protein',
  1667727,
  1667978,
  1,
  'EL100_RS07985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404282.1',
  'hypothetical protein',
  1668038,
  1668160,
  1,
  'EL100_RS09860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'CHAP domain-containing protein',
  1668265,
  1669293,
  1,
  'EL100_RS09720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404281.1',
  'type IV toxin-antitoxin system AbiEi familyantitoxin domain-containing protein',
  1669352,
  1669945,
  1,
  'EL100_RS07995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS07995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'nucleotidyl transferase AbiEii/AbiGii toxinfamily protein',
  1669942,
  1670007,
  1,
  'EL100_RS09915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404280.1',
  'BCCT family transporter',
  1670173,
  1671726,
  1,
  'EL100_RS08000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404279.1',
  'LysR family transcriptional regulator',
  1671736,
  1671897,
  1,
  'EL100_RS08005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404278.1',
  'hypothetical protein',
  1672353,
  1672805,
  1,
  'EL100_RS08010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404277.1',
  'ABC transporter ATP-binding protein',
  1672991,
  1674727,
  1,
  'EL100_RS08015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404276.1',
  'ABC transporter ATP-binding protein',
  1674740,
  1676521,
  1,
  'EL100_RS08020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404275.1',
  'GNAT family N-acetyltransferase',
  1676642,
  1677196,
  1,
  'EL100_RS08025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'brnQ',
  'branched-chain amino acid transport system IIcarrier protein',
  1677392,
  1678708,
  1,
  'EL100_RS08030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ccdA2',
  'thiol-disulfide oxidoreductase-associatedmembrane protein CcdA2',
  1678871,
  1679578,
  1,
  'EL100_RS08035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404273.1',
  'TlpA family protein disulfide reductase',
  1679601,
  1680173,
  1,
  'EL100_RS08040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404272.1',
  'NAD(P)H-dependent oxidoreductase',
  1680204,
  1681439,
  -1,
  'EL100_RS08045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596326.1',
  'NADPH-dependent FMN reductase',
  1681458,
  1682063,
  -1,
  'EL100_RS08050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_414485342.1',
  'FAD:protein FMN transferase',
  1682088,
  1682981,
  -1,
  'EL100_RS08055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'nox',
  'H2O-forming NADH oxidase',
  1683227,
  1684603,
  1,
  'EL100_RS08060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404269.1',
  'ClC family H(+)/Cl(-) exchange transporter',
  1684711,
  1686252,
  1,
  'EL100_RS08065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'efeO',
  'iron uptake system protein EfeO',
  1686346,
  1687215,
  1,
  'EL100_RS08070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'efeB',
  'iron uptake transporterdeferrochelatase/peroxidase subunit',
  1687218,
  1688426,
  1,
  'EL100_RS08075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404267.1',
  'FTR1 family iron permease',
  1688404,
  1690086,
  1,
  'EL100_RS08080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'tatC',
  'twin-arginine translocase subunit TatC',
  1690076,
  1690795,
  1,
  'EL100_RS08085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404265.1',
  'twin-arginine translocase TatA/TatE familysubunit',
  1690799,
  1690996,
  1,
  'EL100_RS08090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023023285.1',
  'hypothetical protein',
  1691251,
  1691376,
  1,
  'EL100_RS09865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404264.1',
  'sugar O-acetyltransferase',
  1691433,
  1691993,
  1,
  'EL100_RS08095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404263.1',
  'alpha/beta fold hydrolase',
  1691990,
  1692700,
  1,
  'EL100_RS08100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'guaC',
  'GMP reductase',
  1692892,
  1693875,
  1,
  'EL100_RS08105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404262.1',
  'xanthine phosphoribosyltransferase',
  1694039,
  1694620,
  1,
  'EL100_RS08110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404261.1',
  'nucleobase:cation symporter-2 family protein',
  1694620,
  1695882,
  1,
  'EL100_RS08115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404260.1',
  'MATE family efflux transporter',
  1695999,
  1697345,
  1,
  'EL100_RS08120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_001117401.1',
  '4-oxalocrotonate tautomerase',
  1697523,
  1697705,
  -1,
  'EL100_RS08125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404259.1',
  'thymidine kinase',
  1698125,
  1698712,
  1,
  'EL100_RS08130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'prfA',
  'peptide chain release factor 1',
  1698722,
  1699801,
  1,
  'EL100_RS08135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'prmC',
  'peptide chain release factor N(5)-glutaminemethyltransferase',
  1699801,
  1700637,
  1,
  'EL100_RS08140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404256.1',
  'L-threonylcarbamoyladenylate synthase',
  1700624,
  1701214,
  1,
  'EL100_RS08145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404255.1',
  'GNAT family N-acetyltransferase',
  1701225,
  1701656,
  1,
  'EL100_RS08150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glyA',
  'serine hydroxymethyltransferase',
  1701669,
  1702925,
  1,
  'EL100_RS08155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404253.1',
  'nucleoid-associated protein',
  1702934,
  1703908,
  1,
  'EL100_RS08160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023026820.1',
  'lysozyme family protein',
  1703908,
  1704510,
  1,
  'EL100_RS08165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404252.1',
  'DUF1002 domain-containing protein',
  1704705,
  1705718,
  1,
  'EL100_RS08170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404251.1',
  'hypothetical protein',
  1705907,
  1706212,
  -1,
  'EL100_RS08175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'guaA',
  'glutamine-hydrolyzing GMP synthase',
  1706394,
  1707959,
  -1,
  'EL100_RS08180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404250.1',
  'GntR family transcriptional regulator',
  1708098,
  1708796,
  1,
  'EL100_RS08185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'glycosyltransferase',
  1708840,
  1710108,
  1,
  'EL100_RS08190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404249.1',
  'NAD-dependent epimerase/dehydratase familyprotein',
  1710105,
  1711082,
  1,
  'EL100_RS08195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404248.1',
  'MBL fold metallo-hydrolase',
  1711057,
  1711872,
  1,
  'EL100_RS08200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404247.1',
  'F390 synthetase-related protein',
  1711850,
  1713118,
  1,
  'EL100_RS08205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404246.1',
  '3-oxoacyl-[acyl-carrier-protein] synthase IIIC-terminal domain-containing protein',
  1713130,
  1714074,
  1,
  'EL100_RS08210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404245.1',
  'putative DNA-binding protein',
  1714154,
  1714486,
  1,
  'EL100_RS08215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_049514330.1',
  'hypothetical protein',
  1714489,
  1714704,
  1,
  'EL100_RS09800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ffh',
  'signal recognition particle protein',
  1714722,
  1716293,
  1,
  'EL100_RS08220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404243.1',
  'alpha/beta hydrolase',
  1716360,
  1717127,
  1,
  'EL100_RS08225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404242.1',
  'acetylxylan esterase',
  1717233,
  1718216,
  1,
  'EL100_RS08230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404241.1',
  'DUF4365 domain-containing protein',
  1718594,
  1720351,
  1,
  'EL100_RS08235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404240.1',
  'LA2681 family HEPN domain-containing protein',
  1720485,
  1721966,
  1,
  'EL100_RS08240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404239.1',
  'hypothetical protein',
  1722507,
  1723106,
  1,
  'EL100_RS08245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pcfF',
  'lantibiotic protection ABC transporterATP-binding protein PcfF',
  1723394,
  1724095,
  1,
  'EL100_RS08250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pcfE',
  'lantibiotic protection ABC transporter permeasePcfE',
  1724100,
  1724840,
  1,
  'EL100_RS08255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pcfG',
  'lantibiotic protection ABC transporter permeasePcfG',
  1724840,
  1725580,
  1,
  'EL100_RS08260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404237.1',
  'response regulator transcription factor',
  1725653,
  1726312,
  1,
  'EL100_RS08265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404236.1',
  'sensor histidine kinase',
  1726303,
  1727670,
  1,
  'EL100_RS08270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404235.1',
  'hypothetical protein',
  1728637,
  1729293,
  -1,
  'EL100_RS08275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555434.1',
  'hypothetical protein',
  1729465,
  1729602,
  1,
  'EL100_RS08280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_269148387.1',
  'hypothetical protein',
  1729602,
  1729733,
  1,
  'EL100_RS09870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404234.1',
  'zinc-ribbon domain-containing protein',
  1729969,
  1730361,
  1,
  'EL100_RS08290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'xerS',
  'tyrosine recombinase XerS',
  1730688,
  1731758,
  1,
  'EL100_RS08295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404233.1',
  'ABC transporter permease',
  1731933,
  1732694,
  -1,
  'EL100_RS08300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404232.1',
  'ABC transporter ATP-binding protein',
  1732696,
  1733622,
  -1,
  'EL100_RS08305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404231.1',
  'hypothetical protein',
  1733853,
  1734986,
  -1,
  'EL100_RS08310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404230.1',
  'putative bacteriocin export ABC transporter',
  1735057,
  1735683,
  -1,
  'EL100_RS08315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404229.1',
  'DUF1430 domain-containing protein',
  1735685,
  1737694,
  -1,
  'EL100_RS08320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596373.1',
  'lipoate--protein ligase',
  1738068,
  1739057,
  -1,
  'EL100_RS08325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'lpdA',
  'dihydrolipoyl dehydrogenase',
  1739116,
  1740822,
  -1,
  'EL100_RS08330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023918161.1',
  'dihydrolipoamide acetyltransferase',
  1740864,
  1741907,
  -1,
  'EL100_RS08335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023026810.1',
  'alpha-ketoacid dehydrogenase subunit beta',
  1742017,
  1743009,
  -1,
  'EL100_RS08340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_049514824.1',
  'thiamine pyrophosphate-dependent dehydrogenaseE1 component subunit alpha',
  1743026,
  1743994,
  -1,
  'EL100_RS08345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404227.1',
  'ATP-grasp domain-containing protein',
  1744305,
  1745471,
  -1,
  'EL100_RS08350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404226.1',
  'esterase family protein',
  1745494,
  1746234,
  -1,
  'EL100_RS08355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404225.1',
  'alpha/beta hydrolase',
  1746274,
  1747101,
  -1,
  'EL100_RS08360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'trmFO',
  'methylenetetrahydrofolate--tRNA-(uracil(54)-C(5))-methyltransferase (FADH(2)-oxidizing) TrmFO',
  1747196,
  1748530,
  -1,
  'EL100_RS08365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404224.1',
  'DUF3307 domain-containing protein',
  1748704,
  1749408,
  -1,
  'EL100_RS08370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404223.1',
  'SatD family protein',
  1749392,
  1750069,
  -1,
  'EL100_RS08375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'topA',
  'type I DNA topoisomerase',
  1750177,
  1752264,
  -1,
  'EL100_RS08380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dprA',
  'DNA-processing protein DprA',
  1752357,
  1753199,
  -1,
  'EL100_RS08385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404220.1',
  'ROK family protein',
  1753276,
  1754202,
  -1,
  'EL100_RS08390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404219.1',
  'ribonuclease HII',
  1754214,
  1754984,
  -1,
  'EL100_RS08395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ylqF',
  'ribosome biogenesis GTPase YlqF',
  1754971,
  1755822,
  -1,
  'EL100_RS08400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006597242.1',
  'ATP cone domain-containing protein',
  1755947,
  1756285,
  -1,
  'EL100_RS08405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dapA',
  '4-hydroxy-tetrahydrodipicolinate synthase',
  1756357,
  1757292,
  -1,
  'EL100_RS08410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404216.1',
  'aspartate-semialdehyde dehydrogenase',
  1757381,
  1758457,
  -1,
  'EL100_RS08415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404215.1',
  'LemA family protein',
  1758614,
  1759168,
  -1,
  'EL100_RS08420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404214.1',
  'DUF3137 domain-containing protein',
  1759171,
  1760181,
  -1,
  'EL100_RS08425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404213.1',
  'DNA alkylation repair protein',
  1760480,
  1761133,
  -1,
  'EL100_RS08430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cls',
  'cardiolipin synthase',
  1761149,
  1762723,
  -1,
  'EL100_RS08435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404211.1',
  'GNAT family N-acetyltransferase',
  1762852,
  1763364,
  -1,
  'EL100_RS08440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404210.1',
  'formate--tetrahydrofolate ligase',
  1763444,
  1765114,
  -1,
  'EL100_RS08445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404209.1',
  'phosphopantothenate--cysteine ligase',
  1765382,
  1766068,
  1,
  'EL100_RS08450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'coaC',
  'phosphopantothenoylcysteine decarboxylase',
  1766074,
  1766613,
  1,
  'EL100_RS08455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_125329433.1',
  'ECF transporter S component',
  1766610,
  1767182,
  1,
  'EL100_RS08460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404207.1',
  'phospho-sugar mutase',
  1767337,
  1769055,
  1,
  'EL100_RS08465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404206.1',
  'DUF6568 family protein',
  1769165,
  1769512,
  1,
  'EL100_RS08470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mutY',
  'A/G-specific adenine glycosylase',
  1769692,
  1770846,
  -1,
  'EL100_RS08475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pta',
  'phosphate acetyltransferase',
  1770938,
  1771912,
  -1,
  'EL100_RS08480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404203.1',
  'RluA family pseudouridine synthase',
  1771933,
  1772823,
  -1,
  'EL100_RS08485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_281281320.1',
  'NAD kinase',
  1772820,
  1773638,
  -1,
  'EL100_RS08490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048690012.1',
  'GTP diphosphokinase',
  1773622,
  1774293,
  -1,
  'EL100_RS08495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404202.1',
  'CYTH domain-containing protein',
  1774389,
  1774955,
  1,
  'EL100_RS08500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404201.1',
  'ribose-phosphate diphosphokinase',
  1775018,
  1775974,
  1,
  'EL100_RS08505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404200.1',
  'cysteine desulfurase family protein',
  1775984,
  1777111,
  1,
  'EL100_RS08510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404199.1',
  'DUF1831 domain-containing protein',
  1777101,
  1777448,
  1,
  'EL100_RS08515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404198.1',
  'DUF4649 family protein',
  1777448,
  1777684,
  1,
  'EL100_RS08520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404197.1',
  'redox-sensing transcriptional repressor Rex',
  1777778,
  1778422,
  1,
  'EL100_RS08525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'radC',
  'RadC family protein',
  1778609,
  1779292,
  -1,
  'EL100_RS08530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596413.1',
  'hypothetical protein',
  1779354,
  1779632,
  -1,
  'EL100_RS08535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404195.1',
  'class A sortase',
  1779942,
  1780691,
  -1,
  'EL100_RS08540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gyrA',
  'DNA gyrase subunit A',
  1780700,
  1783162,
  -1,
  'EL100_RS08545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_117744218.1',
  'L-lactate dehydrogenase',
  1783358,
  1784344,
  1,
  'EL100_RS08550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  1784495,
  1784566,
  -1,
  'EL100_RS08555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsA',
  '30S ribosomal protein S1',
  1784643,
  1785842,
  -1,
  'EL100_RS08560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  1786010,
  1786081,
  -1,
  'EL100_RS08565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  1786131,
  1786211,
  -1,
  'EL100_RS08570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404193.1',
  'DUF2969 domain-containing protein',
  1786264,
  1786494,
  -1,
  'EL100_RS08575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404192.1',
  'branched-chain amino acid aminotransferase',
  1786637,
  1787662,
  -1,
  'EL100_RS08580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'parC',
  'DNA topoisomerase IV subunit A',
  1787837,
  1790290,
  -1,
  'EL100_RS08585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404190.1',
  'aminoglycoside 6-adenylyltransferase',
  1790616,
  1791434,
  -1,
  'EL100_RS08590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'parE',
  'DNA topoisomerase IV subunit B',
  1792035,
  1793984,
  -1,
  'EL100_RS08595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'plsY',
  'glycerol-3-phosphate 1-O-acyltransferase PlsY',
  1794173,
  1794814,
  1,
  'EL100_RS08600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404188.1',
  'glycosyltransferase',
  1794897,
  1796180,
  -1,
  'EL100_RS08605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404187.1',
  'hypothetical protein',
  1796149,
  1796796,
  -1,
  'EL100_RS08610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404186.1',
  'glycosyltransferase',
  1796789,
  1797931,
  -1,
  'EL100_RS08615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405048.1',
  'SDR family NAD(P)-dependent oxidoreductase',
  1797928,
  1798704,
  -1,
  'EL100_RS08620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404185.1',
  'DUF3290 family protein',
  1798872,
  1799324,
  1,
  'EL100_RS08625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_414485199.1',
  'DUF421 domain-containing protein',
  1799324,
  1799953,
  1,
  'EL100_RS08630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011397.1',
  'hypothetical protein',
  1800649,
  1801113,
  -1,
  'EL100_RS08635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011398.1',
  'hypothetical protein',
  1801289,
  1801480,
  -1,
  'EL100_RS09805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404183.1',
  'L-threonylcarbamoyladenylate synthase',
  1801580,
  1802365,
  -1,
  'EL100_RS08645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'leuD',
  '3-isopropylmalate dehydratase small subunit',
  1802462,
  1803052,
  -1,
  'EL100_RS08650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'leuC',
  '3-isopropylmalate dehydratase large subunit',
  1803063,
  1804445,
  -1,
  'EL100_RS08655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404180.1',
  'DUF1294 domain-containing protein',
  1804448,
  1804717,
  -1,
  'EL100_RS08660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'leuB',
  '3-isopropylmalate dehydrogenase',
  1804714,
  1805751,
  -1,
  'EL100_RS08665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404178.1',
  '2-isopropylmalate synthase',
  1805763,
  1807325,
  -1,
  'EL100_RS08670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404177.1',
  'YpmS family protein',
  1807640,
  1808296,
  -1,
  'EL100_RS08675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404176.1',
  'SGNH/GDSL hydrolase family protein',
  1808268,
  1809107,
  -1,
  'EL100_RS08680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404175.1',
  'dihydroorotase',
  1809161,
  1810429,
  -1,
  'EL100_RS08685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404174.1',
  'NUDIX hydrolase',
  1810441,
  1810905,
  -1,
  'EL100_RS08690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404173.1',
  'uracil-DNA glycosylase',
  1810915,
  1811568,
  -1,
  'EL100_RS08695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404172.1',
  'glycosyltransferase-like membrane protein',
  1811699,
  1813204,
  -1,
  'EL100_RS08700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404171.1',
  'hypothetical protein',
  1813473,
  1814000,
  -1,
  'EL100_RS08705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pyrE',
  'orotate phosphoribosyltransferase',
  1814301,
  1814933,
  -1,
  'EL100_RS08710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pyrF',
  'orotidine-5''-phosphate decarboxylase',
  1815198,
  1815890,
  -1,
  'EL100_RS08715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404168.1',
  'dihydroorotate dehydrogenase',
  1816265,
  1817203,
  -1,
  'EL100_RS08720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404167.1',
  'dihydroorotate dehydrogenase electron transfersubunit',
  1817214,
  1818020,
  -1,
  'EL100_RS08725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404166.1',
  'DUF6688 domain-containing protein',
  1818212,
  1819582,
  -1,
  'EL100_RS08730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048689847.1',
  'LysR family transcriptional regulator',
  1819725,
  1820633,
  1,
  'EL100_RS08735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404165.1',
  'NAD-dependent protein deacylase',
  1820705,
  1821436,
  -1,
  'EL100_RS08740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404164.1',
  'Gbs1250 family HEPN protein',
  1821447,
  1822205,
  -1,
  'EL100_RS08745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'deoD',
  'purine-nucleoside phosphorylase',
  1822205,
  1822915,
  -1,
  'EL100_RS08750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404162.1',
  'chloride channel protein',
  1823323,
  1824588,
  -1,
  'EL100_RS08755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404161.1',
  'purine-nucleoside phosphorylase',
  1824594,
  1825403,
  -1,
  'EL100_RS08760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404160.1',
  'DUF1697 domain-containing protein',
  1825417,
  1825959,
  -1,
  'EL100_RS08765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404159.1',
  'phosphopentomutase',
  1825961,
  1827172,
  -1,
  'EL100_RS08770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpiA',
  'ribose-5-phosphate isomerase RpiA',
  1827299,
  1827976,
  -1,
  'EL100_RS08775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mnmE',
  'tRNA uridine-5-carboxymethylaminomethyl(34)synthesis GTPase MnmE',
  1828139,
  1829512,
  1,
  'EL100_RS08780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404156.1',
  'PrsW family glutamic-type intramembraneprotease',
  1829555,
  1830367,
  -1,
  'EL100_RS08785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_229102038.1',
  'hypothetical protein',
  1830607,
  1831035,
  -1,
  'EL100_RS08790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404154.1',
  'hypothetical protein',
  1831419,
  1831781,
  -1,
  'EL100_RS08795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946458.1',
  'hypothetical protein',
  1831793,
  1832305,
  -1,
  'EL100_RS08800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404153.1',
  'DUF6572 domain-containing protein',
  1832556,
  1833200,
  -1,
  'EL100_RS08805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  1833546,
  1833617,
  -1,
  'EL100_RS08810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplS',
  '50S ribosomal protein L19',
  1833661,
  1834008,
  -1,
  'EL100_RS08815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404152.1',
  'chloride channel protein',
  1834125,
  1835336,
  -1,
  'EL100_RS08820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048716815.1',
  'chorismate mutase',
  1835346,
  1835618,
  -1,
  'EL100_RS08825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404151.1',
  'flavodoxin',
  1835752,
  1836195,
  -1,
  'EL100_RS08830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405046.1',
  'DHH family phosphoesterase',
  1836372,
  1837310,
  1,
  'EL100_RS08835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404150.1',
  'hypothetical protein',
  1837490,
  1838491,
  1,
  'EL100_RS08840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003016441.1',
  'type B 50S ribosomal protein L31',
  1838714,
  1838956,
  1,
  'EL100_RS08845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ldcB',
  'LD-carboxypeptidase LdcB/DacB',
  1839057,
  1839830,
  -1,
  'EL100_RS08850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011399.1',
  'TcaA second domain-containing protein',
  1839841,
  1841631,
  -1,
  'EL100_RS09810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404149.1',
  'DUF6574 domain-containing protein',
  1841713,
  1842999,
  -1,
  'EL100_RS08860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404148.1',
  'rhodanese-like domain-containing protein',
  1843098,
  1843379,
  -1,
  'EL100_RS08865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404147.1',
  'prolyl-tRNA synthetase associateddomain-containing protein',
  1843401,
  1843892,
  -1,
  'EL100_RS08870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404146.1',
  'uracil-DNA glycosylase family protein',
  1843917,
  1844519,
  -1,
  'EL100_RS08875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pepV',
  'dipeptidase PepV',
  1844572,
  1845978,
  -1,
  'EL100_RS08880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946459.1',
  'nitroreductase family protein',
  1846115,
  1846720,
  -1,
  'EL100_RS08885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404144.1',
  'hypothetical protein',
  1846846,
  1848489,
  -1,
  'EL100_RS08890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'metallophosphoesterase family protein',
  1848501,
  1849348,
  -1,
  'EL100_RS08895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404143.1',
  'hypothetical protein',
  1849485,
  1849958,
  -1,
  'EL100_RS08900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'uvrC',
  'excinuclease ABC subunit UvrC',
  1850099,
  1851931,
  -1,
  'EL100_RS08905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405043.1',
  'hypothetical protein',
  1852535,
  1852978,
  -1,
  'EL100_RS08910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404141.1',
  'CPBP family intramembrane glutamicendopeptidase',
  1853375,
  1854334,
  -1,
  'EL100_RS08915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404140.1',
  'TIGR01906 family membrane protein',
  1854347,
  1854976,
  -1,
  'EL100_RS08920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404139.1',
  'TIGR01457 family HAD-type hydrolase',
  1854969,
  1855739,
  -1,
  'EL100_RS08925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011400.1',
  'hypothetical protein',
  1855729,
  1856433,
  -1,
  'EL100_RS08930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404138.1',
  'acyl-ACP thioesterase domain-containing protein',
  1856415,
  1857173,
  -1,
  'EL100_RS08935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'hemW',
  'radical SAM family heme chaperone HemW',
  1857177,
  1858307,
  -1,
  'EL100_RS08940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404137.1',
  'ATP-binding cassette domain-containing protein',
  1858626,
  1860149,
  1,
  'EL100_RS08945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'proC',
  'pyrroline-5-carboxylate reductase',
  1860438,
  1861253,
  -1,
  'EL100_RS08950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404135.1',
  'glutamate-5-semialdehyde dehydrogenase',
  1861257,
  1862501,
  -1,
  'EL100_RS08955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'proB',
  'glutamate 5-kinase',
  1862514,
  1863623,
  -1,
  'EL100_RS08960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404133.1',
  'RluA family pseudouridine synthase',
  1863771,
  1864661,
  -1,
  'EL100_RS08965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'lspA',
  'signal peptidase II',
  1864651,
  1865112,
  -1,
  'EL100_RS08970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596491.1',
  'LysR family transcriptional regulator',
  1865116,
  1866018,
  -1,
  'EL100_RS08975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpmA',
  '50S ribosomal protein L27',
  1866143,
  1866436,
  -1,
  'EL100_RS08980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404131.1',
  'ribosomal-processing cysteine protease Prp',
  1866454,
  1866798,
  -1,
  'EL100_RS08985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rplU',
  '50S ribosomal protein L21',
  1866814,
  1867128,
  -1,
  'EL100_RS08990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404130.1',
  'fructose-1,6-bisphosphatase',
  1867449,
  1869359,
  -1,
  'EL100_RS08995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS08995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404129.1',
  'pyruvate, water dikinase regulatory protein',
  1869413,
  1870225,
  -1,
  'EL100_RS09000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_123160191.1',
  'helix-turn-helix transcriptional regulator',
  1870228,
  1870866,
  -1,
  'EL100_RS09005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ppdK',
  'pyruvate, phosphate dikinase',
  1871106,
  1873727,
  1,
  'EL100_RS09010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'thiI',
  'tRNA uracil 4-sulfurtransferase ThiI',
  1873856,
  1875076,
  -1,
  'EL100_RS09015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404126.1',
  'cysteine desulfurase family protein',
  1875098,
  1876240,
  -1,
  'EL100_RS09020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404125.1',
  'hypothetical protein',
  1876481,
  1877044,
  1,
  'EL100_RS09025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011401.1',
  'DUF6556 family protein',
  1877147,
  1877545,
  1,
  'EL100_RS09030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rfbB',
  'dTDP-glucose 4,6-dehydratase',
  1877629,
  1878675,
  -1,
  'EL100_RS09035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_023022979.1',
  'dTDP-4-dehydrorhamnose 3,5-epimerase familyprotein',
  1878878,
  1879471,
  -1,
  'EL100_RS09040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rfbA',
  'glucose-1-phosphate thymidylyltransferase RfbA',
  1879471,
  1880340,
  -1,
  'EL100_RS09045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404121.1',
  'ZIP family metal transporter',
  1880433,
  1880714,
  -1,
  'EL100_RS09050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404120.1',
  'NAD(P)/FAD-dependent oxidoreductase',
  1880939,
  1882054,
  -1,
  'EL100_RS09055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404119.1',
  'Nif3-like dinuclear metal center hexamericprotein',
  1882064,
  1882861,
  -1,
  'EL100_RS09060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404118.1',
  'tRNA (adenine(22)-N(1))-methyltransferase',
  1882848,
  1883537,
  -1,
  'EL100_RS09065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'yghU',
  'glutathione-dependent disulfide-bondoxidoreductase',
  1883619,
  1884410,
  -1,
  'EL100_RS09070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'add',
  'adenosine deaminase',
  1884549,
  1885568,
  1,
  'EL100_RS09075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404115.1',
  'glycerophosphodiester phosphodiesterase familyprotein',
  1885888,
  1887075,
  -1,
  'EL100_RS09080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404114.1',
  'DnaD domain-containing protein',
  1887097,
  1887783,
  -1,
  'EL100_RS09085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'metA',
  'homoserine O-acetyltransferase MetA',
  1887793,
  1888737,
  -1,
  'EL100_RS09090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003002788.1',
  'adenine phosphoribosyltransferase',
  1888839,
  1889351,
  -1,
  'EL100_RS09095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404112.1',
  'TipC family immunity protein',
  1889513,
  1890106,
  -1,
  'EL100_RS09100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'recJ',
  'single-stranded-DNA-specific exonuclease RecJ',
  1890106,
  1892319,
  -1,
  'EL100_RS09105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404110.1',
  'protein-export chaperone SecB',
  1892753,
  1893190,
  -1,
  'EL100_RS09110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404109.1',
  'hypothetical protein',
  1893187,
  1893477,
  -1,
  'EL100_RS09115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404108.1',
  'hypothetical protein',
  1893471,
  1894025,
  -1,
  'EL100_RS09120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404107.1',
  'DUF1492 domain-containing protein',
  1894752,
  1895162,
  -1,
  'EL100_RS09125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555432.1',
  'hypothetical protein',
  1895198,
  1895374,
  -1,
  'EL100_RS09130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405040.1',
  'phage/plasmid primase, P4 family',
  1895676,
  1897103,
  -1,
  'EL100_RS09135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405039.1',
  'MerR family transcriptional regulator',
  1897416,
  1897688,
  -1,
  'EL100_RS09140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404106.1',
  'hypothetical protein',
  1897681,
  1897860,
  -1,
  'EL100_RS09145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404105.1',
  'helix-turn-helix transcriptional regulator',
  1898094,
  1898294,
  -1,
  'EL100_RS09150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011402.1',
  'helix-turn-helix domain-containing protein',
  1898474,
  1898986,
  1,
  'EL100_RS09815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404104.1',
  'hypothetical protein',
  1899125,
  1899379,
  1,
  'EL100_RS09160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404103.1',
  'hypothetical protein',
  1899382,
  1899591,
  1,
  'EL100_RS09165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404102.1',
  'EbhA',
  1899819,
  1900634,
  1,
  'EL100_RS09170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404101.1',
  'site-specific integrase',
  1900934,
  1902106,
  1,
  'EL100_RS09175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011403.1',
  'Ig-like domain-containing protein',
  1902732,
  1904708,
  1,
  'EL100_RS09180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404100.1',
  'hypothetical protein',
  1904930,
  1906288,
  -1,
  'EL100_RS09185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011404.1',
  'hypothetical protein',
  1906599,
  1907375,
  -1,
  'EL100_RS09820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404099.1',
  'GNAT family N-acetyltransferase',
  1907718,
  1908122,
  -1,
  'EL100_RS09200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404098.1',
  'class I SAM-dependent methyltransferase',
  1908124,
  1908834,
  -1,
  'EL100_RS09205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404097.1',
  'SDR family NAD(P)-dependent oxidoreductase',
  1908845,
  1909600,
  -1,
  'EL100_RS09210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rnz',
  'ribonuclease Z',
  1909602,
  1910531,
  -1,
  'EL100_RS09215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555451.1',
  'HIT family protein',
  1910542,
  1911162,
  -1,
  'EL100_RS09220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'hflX',
  'GTPase HflX',
  1911146,
  1912396,
  -1,
  'EL100_RS09225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'miaA',
  'tRNA (adenosine(37)-N6)-dimethylallyltransferaseMiaA',
  1912383,
  1913273,
  -1,
  'EL100_RS09230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_003002781.1',
  'DUF3042 family protein',
  1913357,
  1913527,
  1,
  'EL100_RS09235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404093.1',
  'DUF4298 domain-containing protein',
  1913847,
  1914152,
  -1,
  'EL100_RS09240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'addA',
  'helicase-exonuclease AddAB subunit AddA',
  1914149,
  1917841,
  -1,
  'EL100_RS09245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rexB',
  'ATP-dependent nuclease subunit B',
  1917838,
  1921116,
  -1,
  'EL100_RS09250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405036.1',
  'CPBP family intramembrane glutamicendopeptidase',
  1921252,
  1922016,
  -1,
  'EL100_RS09255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404090.1',
  'potassium channel family protein',
  1922302,
  1922976,
  -1,
  'EL100_RS09260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404089.1',
  'TrkH family potassium uptake protein',
  1922986,
  1924368,
  -1,
  'EL100_RS09265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404088.1',
  'nucleoside phosphorylase',
  1924400,
  1925164,
  -1,
  'EL100_RS09270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404087.1',
  'DEAD/DEAH box helicase family protein',
  1925323,
  1928037,
  1,
  'EL100_RS09275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405035.1',
  'zinc-binding dehydrogenase',
  1928096,
  1929133,
  -1,
  'EL100_RS09280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404086.1',
  'cation diffusion facilitator family transporter',
  1929213,
  1930115,
  -1,
  'EL100_RS09285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_232011431.1',
  'TetR/AcrR family transcriptional regulator',
  1930248,
  1930787,
  1,
  'EL100_RS09290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126405034.1',
  'glucuronide permease',
  1930839,
  1931159,
  1,
  'EL100_RS09880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404084.1',
  'AEC family transporter',
  1931210,
  1932148,
  -1,
  'EL100_RS09295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404083.1',
  'ABC transporter permease/substrate-bindingprotein',
  1932376,
  1933896,
  -1,
  'EL100_RS09300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404082.1',
  'ATP-binding cassette domain-containing protein',
  1933889,
  1934617,
  -1,
  'EL100_RS09305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404081.1',
  'DUF4767 domain-containing protein',
  1934777,
  1935925,
  -1,
  'EL100_RS09310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'alpha/beta hydrolase',
  1936036,
  1936895,
  -1,
  'EL100_RS09315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404080.1',
  'PTS transporter subunit EIIC',
  1936882,
  1938174,
  -1,
  'EL100_RS09320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404079.1',
  'ABC transporter',
  1938330,
  1938638,
  -1,
  'EL100_RS09325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404078.1',
  'DUF1307 domain-containing protein',
  1938794,
  1939378,
  -1,
  'EL100_RS09330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'galE',
  'UDP-glucose 4-epimerase GalE',
  1939507,
  1940505,
  -1,
  'EL100_RS09335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'galT',
  'UDP-glucose--hexose-1-phosphateuridylyltransferase',
  1940569,
  1942041,
  -1,
  'EL100_RS09340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404075.1',
  'HAD family hydrolase',
  1942038,
  1942697,
  -1,
  'EL100_RS09345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404074.1',
  'galactokinase',
  1942709,
  1943875,
  -1,
  'EL100_RS09350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404073.1',
  'LacI family DNA-binding transcriptionalregulator',
  1944017,
  1945018,
  1,
  'EL100_RS09355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'birA',
  'bifunctional biotin--[acetyl-CoA-carboxylase]ligase/biotin operon repressor BirA',
  1945048,
  1945989,
  1,
  'EL100_RS09360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404070.1',
  'DUF3272 family protein',
  1946957,
  1947169,
  -1,
  'EL100_RS09365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dnaX',
  'DNA polymerase III subunit gamma/tau',
  1947208,
  1948884,
  -1,
  'EL100_RS09370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404068.1',
  'free L-methionine (R)-S-oxide reductase MsrC',
  1948884,
  1949381,
  -1,
  'EL100_RS09375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048788887.1',
  'YoaK family protein',
  1949694,
  1950365,
  -1,
  'EL100_RS09380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'udk',
  'uridine kinase',
  1950432,
  1951067,
  -1,
  'EL100_RS09385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404066.1',
  'Gfo/Idh/MocA family protein',
  1951277,
  1952254,
  1,
  'EL100_RS09390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_164555431.1',
  'DEAD/DEAH box helicase',
  1952256,
  1953344,
  1,
  'EL100_RS09395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404064.1',
  'polysaccharide deacetylase family protein',
  1953653,
  1955038,
  -1,
  'EL100_RS09400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gloA',
  'lactoylglutathione lyase',
  1955234,
  1955620,
  -1,
  'EL100_RS09405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404062.1',
  'sensor histidine kinase',
  1955868,
  1957241,
  -1,
  'EL100_RS09410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596563.1',
  'response regulator transcription factor',
  1957231,
  1957905,
  -1,
  'EL100_RS09415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404061.1',
  'hypothetical protein',
  1958019,
  1958615,
  -1,
  'EL100_RS09420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404060.1',
  'biotin transporter BioY',
  1958825,
  1959367,
  1,
  'EL100_RS09425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404059.1',
  'M1 family metallopeptidase',
  1959423,
  1961966,
  -1,
  'EL100_RS09430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'phoU',
  'phosphate signaling complex protein PhoU',
  1962097,
  1962750,
  -1,
  'EL100_RS09435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pstB',
  'phosphate ABC transporter ATP-binding proteinPstB',
  1962765,
  1963523,
  -1,
  'EL100_RS09440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pstB',
  'phosphate ABC transporter ATP-binding proteinPstB',
  1963560,
  1964363,
  -1,
  'EL100_RS09445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pstA',
  'phosphate ABC transporter permease PstA',
  1964375,
  1965259,
  -1,
  'EL100_RS09450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pstC',
  'phosphate ABC transporter permease subunit PstC',
  1965249,
  1966160,
  -1,
  'EL100_RS09455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404056.1',
  'phosphate ABC transporter substrate-bindingprotein PstS family protein',
  1966178,
  1967044,
  -1,
  'EL100_RS09460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404055.1',
  'RsmF rRNA methyltransferase first C-terminaldomain-containing protein',
  1967174,
  1968478,
  -1,
  'EL100_RS09465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404054.1',
  'inositol monophosphatase family protein',
  1968475,
  1969248,
  -1,
  'EL100_RS09470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048689976.1',
  'UPF0223 family protein',
  1969238,
  1969516,
  -1,
  'EL100_RS09475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_040803090.1',
  'Spx/MgsR family RNA polymerase-bindingregulatory protein',
  1969518,
  1969919,
  -1,
  'EL100_RS09480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404053.1',
  'bifunctional riboflavin kinase/FAD synthetase',
  1970047,
  1970964,
  -1,
  'EL100_RS09485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'truB',
  'tRNA pseudouridine(55) synthase TruB',
  1970969,
  1971865,
  -1,
  'EL100_RS09490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404051.1',
  'hypothetical protein',
  1972030,
  1972791,
  -1,
  'EL100_RS09495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_223363364.1',
  'DUF4176 domain-containing protein',
  1972836,
  1972949,
  -1,
  'EL100_RS09500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'hypothetical protein',
  1972949,
  1973389,
  -1,
  'EL100_RS09505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'truB',
  'tRNA pseudouridine(55) synthase TruB',
  1973392,
  1973639,
  -1,
  'EL100_RS09510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404050.1',
  'FAD-containing oxidoreductase',
  1974228,
  1975544,
  1,
  'EL100_RS09515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404049.1',
  'alpha/beta fold hydrolase',
  1975578,
  1976378,
  -1,
  'EL100_RS09520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404048.1',
  'DUF2130 domain-containing protein',
  1976382,
  1977656,
  -1,
  'EL100_RS09525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pcrA',
  'DNA helicase PcrA',
  1978026,
  1980311,
  -1,
  'EL100_RS09530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404046.1',
  'cation diffusion facilitator family transporter',
  1980503,
  1981696,
  1,
  'EL100_RS09535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'lepB',
  'signal peptidase I',
  1981786,
  1982343,
  -1,
  'EL100_RS09540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pyk',
  'pyruvate kinase',
  1982495,
  1984000,
  -1,
  'EL100_RS09545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'pfkA',
  '6-phosphofructokinase',
  1984059,
  1985072,
  -1,
  'EL100_RS09550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404043.1',
  'DNA polymerase III subunit alpha',
  1985158,
  1988259,
  -1,
  'EL100_RS09555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  '—',
  1988387,
  1988474,
  -1,
  'EL100_RS09560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'ssrA',
  '—',
  1988607,
  1988954,
  -1,
  'EL100_RS09565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404042.1',
  'ABC transporter ATP-binding protein',
  1989031,
  1989831,
  -1,
  'EL100_RS09570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596589.1',
  'ABC transporter ATP-binding protein',
  1989841,
  1990548,
  -1,
  'EL100_RS09575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596590.1',
  'metal-sulfur cluster assembly factor',
  1990705,
  1991034,
  -1,
  'EL100_RS09580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpoD',
  'RNA polymerase sigma factor RpoD',
  1991379,
  1992491,
  -1,
  'EL100_RS09585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'dnaG',
  'DNA primase',
  1992494,
  1994278,
  -1,
  'EL100_RS09590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'mscL',
  'large conductance mechanosensitive channelprotein MscL',
  1994517,
  1994897,
  1,
  'EL100_RS09595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rpsU',
  '30S ribosomal protein S21',
  1995000,
  1995176,
  -1,
  'EL100_RS09600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404039.1',
  'hypothetical protein',
  1995323,
  1995634,
  -1,
  'EL100_RS09605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gla',
  'aquaglyceroporin Gla',
  1995714,
  1996583,
  -1,
  'EL100_RS09610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404038.1',
  'NAD(P)/FAD-dependent oxidoreductase',
  1996790,
  1997758,
  1,
  'EL100_RS09615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'whiA',
  'DNA-binding protein WhiA',
  1997797,
  1998717,
  -1,
  'EL100_RS09620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404036.1',
  'YvcK family protein',
  1998714,
  1999691,
  -1,
  'EL100_RS09625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'rapZ',
  'RNase adapter RapZ',
  1999688,
  2000584,
  -1,
  'EL100_RS09630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404034.1',
  'RidA family protein',
  2000696,
  2001073,
  -1,
  'EL100_RS09635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596601.1',
  'hypothetical protein',
  2001090,
  2001251,
  -1,
  'EL100_RS09640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'obgE',
  'GTPase ObgE',
  2001275,
  2002588,
  -1,
  'EL100_RS09645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_006596603.1',
  'DUF4044 domain-containing protein',
  2002634,
  2002765,
  -1,
  'EL100_RS09650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404032.1',
  'Ig-like domain-containing protein',
  2002960,
  2004420,
  -1,
  'EL100_RS09655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'glmM',
  'phosphoglucosamine mutase',
  2004463,
  2005818,
  -1,
  'EL100_RS09660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_126404030.1',
  'CdaR family protein',
  2005846,
  2006586,
  -1,
  'EL100_RS09665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'cdaA',
  'diadenylate cyclase CdaA',
  2006583,
  2007431,
  -1,
  'EL100_RS09670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'murT',
  'lipid II isoglutaminyl synthase subunit MurT',
  2007612,
  2008955,
  1,
  'EL100_RS09675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'gatD',
  'lipid II isoglutaminyl synthase subunit GatD',
  2008955,
  2009744,
  1,
  'EL100_RS09680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_048717218.1',
  'LapA family protein',
  2009754,
  2010044,
  1,
  'EL100_RS09685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  'WP_185946461.1',
  'MFS transporter',
  2010338,
  2011525,
  -1,
  'EL100_RS09690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'Rgg family transcriptional regulator',
  2011549,
  2012423,
  -1,
  'EL100_RS09695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'ABC-F family ATP-binding cassettedomain-containing protein',
  2012424,
  2014305,
  -1,
  'EL100_RS09700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'hypothetical protein',
  2014413,
  2014782,
  -1,
  'EL100_RS09710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  '—',
  'matrixin family metalloprotease',
  2014785,
  2015369,
  -1,
  'EL100_RS09825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1) AND locus_tag='EL100_RS09825'
);

INSERT INTO core_taxonomy (taxonomy_id, rank, name, parent_id)
SELECT
  '1239',
  'phylum',
  'Bacillota',
  NULL
WHERE NOT EXISTS (
  SELECT 1 FROM core_taxonomy WHERE taxonomy_id='1239'
);

UPDATE core_taxonomy
SET
  rank = COALESCE(NULLIF(rank,''), 'phylum'),
  name = COALESCE(NULLIF(name,''), 'Bacillota'),
  parent_id = COALESCE(parent_id, NULL)
WHERE taxonomy_id='1239';

INSERT INTO core_taxonomy (taxonomy_id, rank, name, parent_id)
SELECT
  '91061',
  'class',
  'Bacilli',
  (SELECT id FROM core_taxonomy WHERE taxonomy_id='1239' LIMIT 1)
WHERE NOT EXISTS (
  SELECT 1 FROM core_taxonomy WHERE taxonomy_id='91061'
);

UPDATE core_taxonomy
SET
  rank = COALESCE(NULLIF(rank,''), 'class'),
  name = COALESCE(NULLIF(name,''), 'Bacilli'),
  parent_id = COALESCE(parent_id, (SELECT id FROM core_taxonomy WHERE taxonomy_id='1239' LIMIT 1))
WHERE taxonomy_id='91061';

INSERT INTO core_taxonomy (taxonomy_id, rank, name, parent_id)
SELECT
  '186826',
  'order',
  'Lactobacillales',
  (SELECT id FROM core_taxonomy WHERE taxonomy_id='91061' LIMIT 1)
WHERE NOT EXISTS (
  SELECT 1 FROM core_taxonomy WHERE taxonomy_id='186826'
);

UPDATE core_taxonomy
SET
  rank = COALESCE(NULLIF(rank,''), 'order'),
  name = COALESCE(NULLIF(name,''), 'Lactobacillales'),
  parent_id = COALESCE(parent_id, (SELECT id FROM core_taxonomy WHERE taxonomy_id='91061' LIMIT 1))
WHERE taxonomy_id='186826';

INSERT INTO core_taxonomy (taxonomy_id, rank, name, parent_id)
SELECT
  '1300',
  'family',
  'Streptococcaceae',
  (SELECT id FROM core_taxonomy WHERE taxonomy_id='186826' LIMIT 1)
WHERE NOT EXISTS (
  SELECT 1 FROM core_taxonomy WHERE taxonomy_id='1300'
);

UPDATE core_taxonomy
SET
  rank = COALESCE(NULLIF(rank,''), 'family'),
  name = COALESCE(NULLIF(name,''), 'Streptococcaceae'),
  parent_id = COALESCE(parent_id, (SELECT id FROM core_taxonomy WHERE taxonomy_id='186826' LIMIT 1))
WHERE taxonomy_id='1300';

INSERT INTO core_taxonomy (taxonomy_id, rank, name, parent_id)
SELECT
  '1301',
  'genus',
  'Streptococcus',
  (SELECT id FROM core_taxonomy WHERE taxonomy_id='1300' LIMIT 1)
WHERE NOT EXISTS (
  SELECT 1 FROM core_taxonomy WHERE taxonomy_id='1301'
);

UPDATE core_taxonomy
SET
  rank = COALESCE(NULLIF(rank,''), 'genus'),
  name = COALESCE(NULLIF(name,''), 'Streptococcus'),
  parent_id = COALESCE(parent_id, (SELECT id FROM core_taxonomy WHERE taxonomy_id='1300' LIMIT 1))
WHERE taxonomy_id='1301';

INSERT INTO core_taxonomy (taxonomy_id, rank, name, parent_id)
SELECT
  '113107',
  'species',
  'Streptococcus australis',
  (SELECT id FROM core_taxonomy WHERE taxonomy_id='1301' LIMIT 1)
WHERE NOT EXISTS (
  SELECT 1 FROM core_taxonomy WHERE taxonomy_id='113107'
);

UPDATE core_taxonomy
SET
  rank = COALESCE(NULLIF(rank,''), 'species'),
  name = COALESCE(NULLIF(name,''), 'Streptococcus australis'),
  parent_id = COALESCE(parent_id, (SELECT id FROM core_taxonomy WHERE taxonomy_id='1301' LIMIT 1))
WHERE taxonomy_id='113107';

UPDATE core_genome
SET taxonomy_id = (
  SELECT id FROM core_taxonomy WHERE taxonomy_id='113107' LIMIT 1
)
WHERE genome_accession='NZ_LR134285.1';

INSERT INTO core_experimentaltechnique (name, description, preset_function, EO_term)
SELECT 'Beta-gal reporter assay', 'Beta-gal reporter assay', NULL, 'ECO:0005616'
WHERE NOT EXISTS (
  SELECT 1 FROM core_experimentaltechnique WHERE EO_term='ECO:0005616'
);

INSERT INTO core_siteinstance (_seq, genome_id, start, end, strand)
SELECT
  'ACTGACTGA',
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  272837,
  272845,
  1
WHERE NOT EXISTS (
  SELECT 1 FROM core_siteinstance
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
    AND start=272837 AND end=272845 AND strand=1
    AND _seq='ACTGACTGA'
);

INSERT INTO core_curation_siteinstance
  (curation_id, site_instance_id, annotated_seq, quantitative_value, site_type, TF_function, TF_type)
VALUES
  ((SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1),
   (SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
          AND start=272837 AND end=272845 AND strand=1
          AND _seq='ACTGACTGA'
        ORDER BY site_id DESC LIMIT 1),
   'ACTGACTGA',
   0,
   'motif_associated',
   'ACT',
   'MONOMER');

INSERT INTO core_curation_siteinstance_experimental_techniques
  (curation_siteinstance_id, experimentaltechnique_id)
SELECT (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
          AND start=272837 AND end=272845 AND strand=1
          AND _seq='ACTGACTGA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1), (SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0005616'
          LIMIT 1)
WHERE (SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0005616'
          LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM core_curation_siteinstance_experimental_techniques
    WHERE curation_siteinstance_id=(SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
          AND start=272837 AND end=272845 AND strand=1
          AND _seq='ACTGACTGA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1)
      AND experimentaltechnique_id=(SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0005616'
          LIMIT 1)
  );

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
      SELECT
        (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
          AND start=272837 AND end=272845 AND strand=1
          AND _seq='ACTGACTGA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
        (SELECT gene_id FROM core_gene
      WHERE locus_tag='EL100_RS01400' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1),
        'exp_verified',
        NULL
      WHERE (SELECT gene_id FROM core_gene
      WHERE locus_tag='EL100_RS01400' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
      SELECT
        (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
          AND start=272837 AND end=272845 AND strand=1
          AND _seq='ACTGACTGA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
        (SELECT gene_id FROM core_gene
      WHERE locus_tag='EL100_RS01405' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1),
        'inferred',
        NULL
      WHERE (SELECT gene_id FROM core_gene
      WHERE locus_tag='EL100_RS01405' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_siteinstance (_seq, genome_id, start, end, strand)
SELECT
  'AACGATGCA',
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1),
  542158,
  542166,
  1
WHERE NOT EXISTS (
  SELECT 1 FROM core_siteinstance
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
    AND start=542158 AND end=542166 AND strand=1
    AND _seq='AACGATGCA'
);

INSERT INTO core_curation_siteinstance
  (curation_id, site_instance_id, annotated_seq, quantitative_value, site_type, TF_function, TF_type)
VALUES
  ((SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1),
   (SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
          AND start=542158 AND end=542166 AND strand=1
          AND _seq='AACGATGCA'
        ORDER BY site_id DESC LIMIT 1),
   'AACGATGCA',
   0,
   'motif_associated',
   'ACT',
   'MONOMER');

INSERT INTO core_curation_siteinstance_experimental_techniques
  (curation_siteinstance_id, experimentaltechnique_id)
SELECT (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
          AND start=542158 AND end=542166 AND strand=1
          AND _seq='AACGATGCA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1), (SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0005616'
          LIMIT 1)
WHERE (SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0005616'
          LIMIT 1) IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM core_curation_siteinstance_experimental_techniques
    WHERE curation_siteinstance_id=(SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
          AND start=542158 AND end=542166 AND strand=1
          AND _seq='AACGATGCA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1)
      AND experimentaltechnique_id=(SELECT technique_id
          FROM core_experimentaltechnique
          WHERE EO_term='ECO:0005616'
          LIMIT 1)
  );

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
      SELECT
        (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
          AND start=542158 AND end=542166 AND strand=1
          AND _seq='AACGATGCA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
        (SELECT gene_id FROM core_gene
      WHERE locus_tag='EL100_RS02745' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1),
        'inferred',
        NULL
      WHERE (SELECT gene_id FROM core_gene
      WHERE locus_tag='EL100_RS02745' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
      SELECT
        (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
          AND start=542158 AND end=542166 AND strand=1
          AND _seq='AACGATGCA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
        (SELECT gene_id FROM core_gene
      WHERE locus_tag='EL100_RS02750' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1),
        'exp_verified',
        NULL
      WHERE (SELECT gene_id FROM core_gene
      WHERE locus_tag='EL100_RS02750' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
      SELECT
        (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='39101802' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
          AND start=542158 AND end=542166 AND strand=1
          AND _seq='AACGATGCA'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
        (SELECT gene_id FROM core_gene
      WHERE locus_tag='EL100_RS02755' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1),
        'inferred',
        NULL
      WHERE (SELECT gene_id FROM core_gene
      WHERE locus_tag='EL100_RS02755' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_LR134285.1' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

COMMIT;