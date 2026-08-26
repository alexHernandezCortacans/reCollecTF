PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

INSERT INTO core_publication
  (publication_type, pmid, authors, title, journal, publication_date, url,
   contains_promoter_data, contains_expression_data, submission_notes, curation_complete,
   reported_TF, reported_species)
SELECT
  'pubmed',
  '42625245',
  'Dhakal R, Peixoto MA, Hoffmann L Jr, Oloka BM, Clough M, Gesteira GS, Zotarelli L, Endelman JB, Yencho GC, Resende MFR',
  'Integrating genomic selection into potato breeding: A comparison of genotyping platforms and cross-environmental predictions.',
  'The plant genome',
  '2026 Sep',
  'https://doi.org/10.1002/tpg2.70293',
  0,
  1,
  'Streptococcus australis',
  1,
  'Mur',
  'Streptococcus australis ATCC 700641'
WHERE NOT EXISTS (
  SELECT 1 FROM core_publication WHERE pmid='42625245'
);

UPDATE core_publication
SET
  authors = CASE WHEN authors IS NULL OR authors='' THEN 'Dhakal R, Peixoto MA, Hoffmann L Jr, Oloka BM, Clough M, Gesteira GS, Zotarelli L, Endelman JB, Yencho GC, Resende MFR' ELSE authors END,
  title = CASE WHEN title IS NULL OR title='' THEN 'Integrating genomic selection into potato breeding: A comparison of genotyping platforms and cross-environmental predictions.' ELSE title END,
  journal = CASE WHEN journal IS NULL OR journal='' THEN 'The plant genome' ELSE journal END,
  publication_date = CASE WHEN publication_date IS NULL OR publication_date='' THEN '2026 Sep' ELSE publication_date END,
  url = CASE WHEN url IS NULL OR url='' THEN 'https://doi.org/10.1002/tpg2.70293' ELSE url END,
  reported_TF = CASE WHEN reported_TF IS NULL OR reported_TF='' THEN 'Mur' ELSE reported_TF END,
  reported_species = CASE WHEN reported_species IS NULL OR reported_species='' THEN 'Streptococcus australis ATCC 700641' ELSE reported_species END,
  contains_promoter_data = 0,
  contains_expression_data = 1,
  curation_complete = 1,
  submission_notes = CASE
    WHEN submission_notes IS NULL OR submission_notes='' THEN 'Streptococcus australis'
    ELSE submission_notes
  END
WHERE pmid='42625245';

INSERT INTO core_tf (name, family_id, description)
SELECT 'Mur', 6, 'Mur is a Fur family transcriptional regulator that mediates manganese-dependent regulation of the manganese uptake system [PMID::17216355 .'
WHERE NOT EXISTS (
  SELECT 1 FROM core_tf WHERE lower(name)=lower('Mur')
);

UPDATE core_tf
SET
  family_id = COALESCE(family_id, 6),
  description = CASE WHEN description IS NULL THEN 'Mur is a Fur family transcriptional regulator that mediates manganese-dependent regulation of the manganese uptake system [PMID::17216355 .' ELSE description END
WHERE lower(name)=lower('Mur');

INSERT INTO core_tfinstance (refseq_accession, uniprot_accession, description, TF_id, notes, GO_term_id)
SELECT
  'WP_006595818.1',
  'E7SA24',
  'UDP-N-acetylmuramoyl-L-alanyl-D-glutamate--L-lysine ligase',
  (SELECT TF_id FROM core_tf WHERE lower(name)=lower('Mur') LIMIT 1),
  '',
  ''
WHERE NOT EXISTS (
  SELECT 1 FROM core_tfinstance WHERE uniprot_accession='E7SA24'
);

UPDATE core_tfinstance
SET
  TF_id = COALESCE(TF_id, (SELECT TF_id FROM core_tf WHERE lower(name)=lower('Mur') LIMIT 1)),
  refseq_accession = COALESCE(NULLIF(refseq_accession,''), 'WP_006595818.1'),
  description = COALESCE(NULLIF(description,''), 'UDP-N-acetylmuramoyl-L-alanyl-D-glutamate--L-lysine ligase'),
  notes = COALESCE(notes, ''),
  GO_term_id = COALESCE(GO_term_id, '')

WHERE uniprot_accession='E7SA24';

INSERT INTO core_curation
  (TF_species, site_species, experimental_process, forms_complex,
   complex_notes, notes, last_modified, curator_id, publication_id, created, validated_by_id)
VALUES
  ('Streptococcus australis ATCC 700641', 'Streptococcus australis ATCC 700641', NULL,
   0, NULL, 'Streptococcus australis',
   datetime('now'), (SELECT curator_id FROM core_curator ORDER BY curator_id LIMIT 1), (SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1), datetime('now'), NULL);

INSERT INTO core_curation_TF_instances (curation_id, tfinstance_id)
SELECT (SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1), (SELECT TF_instance_id FROM core_tfinstance WHERE uniprot_accession='E7SA24' LIMIT 1)
WHERE NOT EXISTS (
  SELECT 1 FROM core_curation_TF_instances
  WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1) AND tfinstance_id=(SELECT TF_instance_id FROM core_tfinstance WHERE uniprot_accession='E7SA24' LIMIT 1)
);

INSERT INTO core_genome (genome_accession, organism)
SELECT 'NZ_AFUD01000039', 'Streptococcus australis ATCC 700641'
WHERE NOT EXISTS (
  SELECT 1 FROM core_genome WHERE genome_accession='NZ_AFUD01000039'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'mgtA',
  'magnesium-translocating P-type ATPase',
  1,
  2029,
  -1,
  'HMPREF9961_RS07575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595822.1',
  'MalY/PatB family protein',
  2447,
  3616,
  -1,
  'HMPREF9961_RS07580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595821.1',
  'cystathionine gamma-synthase',
  3626,
  4720,
  -1,
  'HMPREF9961_RS07585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595819.1',
  'putative polysaccharide biosynthesis protein',
  4861,
  6489,
  -1,
  'HMPREF9961_RS07590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595818.1',
  'UDP-N-acetylmuramoyl-L-alanyl-D-glutamate--L-lysine ligase',
  6576,
  8021,
  1,
  'HMPREF9961_RS07595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595817.1',
  'DUF1803 domain-containing protein',
  8058,
  8708,
  -1,
  'HMPREF9961_RS07600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595816.1',
  'YiiX/YebB-like N1pC/P60 family cysteinehydrolase',
  8692,
  9204,
  -1,
  'HMPREF9961_RS07605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595815.1',
  'manganese-dependent inorganic pyrophosphatase',
  9268,
  10203,
  -1,
  'HMPREF9961_RS07610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'pflA',
  'pyruvate formate-lyase-activating protein',
  10331,
  11125,
  -1,
  'HMPREF9961_RS07615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  '—',
  'UTRA domain-containing protein',
  11343,
  11528,
  1,
  'HMPREF9961_RS07620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006597290.1',
  'glycosyl hydrolase family 95 catalyticdomain-containing protein',
  11793,
  15422,
  1,
  'HMPREF9961_RS10565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS10565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_043395008.1',
  'LPXTG cell wall anchor domain-containingprotein',
  15347,
  16648,
  1,
  'HMPREF9961_RS11615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS11615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595811.1',
  'ABC transporter ATP-binding protein',
  17067,
  17870,
  -1,
  'HMPREF9961_RS07635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006597286.1',
  'ABC transporter permease',
  17884,
  18777,
  -1,
  'HMPREF9961_RS07640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595809.1',
  'ABC transporter substrate-binding protein',
  18788,
  19762,
  -1,
  'HMPREF9961_RS07645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595808.1',
  'polyadenylate binding domain-containing protein',
  20190,
  21164,
  -1,
  'HMPREF9961_RS07650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  '—',
  'IS3 family transposase',
  21611,
  22959,
  -1,
  'HMPREF9961_RS10575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS10575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595806.1',
  'hypothetical protein',
  23027,
  24226,
  -1,
  'HMPREF9961_RS07670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595805.1',
  'hemolysin family protein',
  24339,
  25688,
  -1,
  'HMPREF9961_RS07675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006597289.1',
  'AcpB/EbpR/MafR family transcriptional regulator',
  25858,
  27273,
  -1,
  'HMPREF9961_RS07680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595803.1',
  'AI-2E family transporter',
  27428,
  28555,
  -1,
  'HMPREF9961_RS07685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595802.1',
  'ABC transporter ATP-binding protein',
  28612,
  29415,
  1,
  'HMPREF9961_RS07690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595801.1',
  'cation:proton antiporter',
  29499,
  31553,
  -1,
  'HMPREF9961_RS07695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595800.1',
  'hypothetical protein',
  31557,
  31820,
  -1,
  'HMPREF9961_RS07700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'mnmM',
  'tRNA5-(aminomethyl)-2-thiouridylate-methyltransferase MnmM',
  31813,
  32370,
  -1,
  'HMPREF9961_RS07705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'mnmL',
  'tRNA modification radical SAM protein MnmL/YtqA',
  32372,
  33313,
  -1,
  'HMPREF9961_RS07710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595797.1',
  'MGMT family protein',
  33337,
  33648,
  -1,
  'HMPREF9961_RS07715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595796.1',
  'phosphatase PAP2 family protein',
  33652,
  34302,
  -1,
  'HMPREF9961_RS07720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595795.1',
  'ECF transporter S component',
  34292,
  34849,
  -1,
  'HMPREF9961_RS07725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595794.1',
  'tRNA (cytidine(34)-2''-O)-methyltransferase',
  35308,
  35850,
  -1,
  'HMPREF9961_RS07730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'trkA',
  'Trk system potassium transporter TrkA',
  36150,
  37505,
  1,
  'HMPREF9961_RS07735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595792.1',
  'TrkH family potassium uptake protein',
  37509,
  38969,
  1,
  'HMPREF9961_RS07740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'yidD',
  'membrane protein insertion efficiency factorYidD',
  39046,
  39300,
  -1,
  'HMPREF9961_RS07745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  '—',
  'pseudouridine synthase',
  39300,
  40027,
  -1,
  'HMPREF9961_RS07750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'scpB',
  'SMC-Scp complex subunit ScpB',
  40017,
  40586,
  -1,
  'HMPREF9961_RS07755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595788.1',
  'segregation/condensation protein A',
  40579,
  41289,
  -1,
  'HMPREF9961_RS07760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'xerD',
  'site-specific tyrosine recombinase XerD',
  41289,
  42020,
  -1,
  'HMPREF9961_RS07765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'cbpB',
  'cyclic-di-AMP-binding protein CbpB',
  42017,
  42478,
  -1,
  'HMPREF9961_RS07770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595785.1',
  'metallophosphoesterase',
  42475,
  42996,
  -1,
  'HMPREF9961_RS07775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595784.1',
  'nucleoside-triphosphate diphosphatase',
  42981,
  43949,
  -1,
  'HMPREF9961_RS07780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'racE',
  'glutamate racemase',
  43946,
  44740,
  -1,
  'HMPREF9961_RS07785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595782.1',
  'YneF family protein',
  44819,
  45061,
  -1,
  'HMPREF9961_RS07790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006597295.1',
  'diaminopimelate decarboxylase',
  45118,
  46368,
  -1,
  'HMPREF9961_RS07795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595780.1',
  'Bax inhibitor-1/YccA family protein',
  46451,
  47137,
  -1,
  'HMPREF9961_RS07800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006597294.1',
  'HD domain-containing protein',
  47167,
  47655,
  -1,
  'HMPREF9961_RS07805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006597288.1',
  'TrmH family RNA methyltransferase',
  47687,
  48433,
  -1,
  'HMPREF9961_RS07810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'WP_006595777.1',
  'acylphosphatase',
  48507,
  48785,
  1,
  'HMPREF9961_RS07815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  'yidC',
  'membrane protein insertase YidC',
  48863,
  49801,
  1,
  'HMPREF9961_RS07820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1) AND locus_tag='HMPREF9961_RS07820'
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
WHERE genome_accession='NZ_AFUD01000039';

INSERT INTO core_experimentaltechnique (name, description, preset_function, EO_term)
SELECT 'Beta-gal reporter assay', 'Beta-gal reporter assay', NULL, 'ECO:0005616'
WHERE NOT EXISTS (
  SELECT 1 FROM core_experimentaltechnique WHERE EO_term='ECO:0005616'
);

INSERT INTO core_siteinstance (_seq, genome_id, start, end, strand)
SELECT
  'ACTGACTG',
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  41102,
  41109,
  1
WHERE NOT EXISTS (
  SELECT 1 FROM core_siteinstance
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
    AND start=41102 AND end=41109 AND strand=1
    AND _seq='ACTGACTG'
);

INSERT INTO core_curation_siteinstance
  (curation_id, site_instance_id, annotated_seq, quantitative_value, site_type, TF_function, TF_type)
VALUES
  ((SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1),
   (SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=41102 AND end=41109 AND strand=1
          AND _seq='ACTGACTG'
        ORDER BY site_id DESC LIMIT 1),
   'ACTGACTG',
   0,
   'motif_associated',
   'ACT',
   'MONOMER');

INSERT INTO core_curation_siteinstance_experimental_techniques
  (curation_siteinstance_id, experimentaltechnique_id)
SELECT (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=41102 AND end=41109 AND strand=1
          AND _seq='ACTGACTG'
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
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=41102 AND end=41109 AND strand=1
          AND _seq='ACTGACTG'
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
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=41102 AND end=41109 AND strand=1
          AND _seq='ACTGACTG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
        (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07745' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1),
        'exp_verified',
        NULL
      WHERE (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07745' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
      SELECT
        (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=41102 AND end=41109 AND strand=1
          AND _seq='ACTGACTG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
        (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07750' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1),
        'inferred',
        NULL
      WHERE (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07750' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
      SELECT
        (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=41102 AND end=41109 AND strand=1
          AND _seq='ACTGACTG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
        (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07755' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1),
        'inferred',
        NULL
      WHERE (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07755' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
      SELECT
        (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=41102 AND end=41109 AND strand=1
          AND _seq='ACTGACTG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
        (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07760' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1),
        'inferred',
        NULL
      WHERE (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07760' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_siteinstance (_seq, genome_id, start, end, strand)
SELECT
  'CTGCATG',
  (SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1),
  3744,
  3750,
  1
WHERE NOT EXISTS (
  SELECT 1 FROM core_siteinstance
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
    AND start=3744 AND end=3750 AND strand=1
    AND _seq='CTGCATG'
);

INSERT INTO core_curation_siteinstance
  (curation_id, site_instance_id, annotated_seq, quantitative_value, site_type, TF_function, TF_type)
VALUES
  ((SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1),
   (SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=3744 AND end=3750 AND strand=1
          AND _seq='CTGCATG'
        ORDER BY site_id DESC LIMIT 1),
   'CTGCATG',
   0,
   'motif_associated',
   'ACT',
   'MONOMER');

INSERT INTO core_curation_siteinstance_experimental_techniques
  (curation_siteinstance_id, experimentaltechnique_id)
SELECT (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=3744 AND end=3750 AND strand=1
          AND _seq='CTGCATG'
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
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=3744 AND end=3750 AND strand=1
          AND _seq='CTGCATG'
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
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=3744 AND end=3750 AND strand=1
          AND _seq='CTGCATG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
        (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07580' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1),
        'exp_verified',
        NULL
      WHERE (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07580' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
      SELECT
        (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42625245' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
          AND start=3744 AND end=3750 AND strand=1
          AND _seq='CTGCATG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
        (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07585' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1),
        'inferred',
        NULL
      WHERE (SELECT gene_id FROM core_gene
      WHERE locus_tag='HMPREF9961_RS07585' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NZ_AFUD01000039' LIMIT 1)
      ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

COMMIT;