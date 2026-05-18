PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

INSERT INTO core_publication
  (publication_type, pmid, authors, title, journal, publication_date, url,
   contains_promoter_data, contains_expression_data, submission_notes, curation_complete,
   reported_TF, reported_species)
SELECT
  'ARTICLE',
  '42146179',
  'Baradel IC, Simon AP, Oldoni TLC, Anaissi FJ, Sikora MS',
  'Starch-Based Eco-Friendly Electrolyte from Manihot esculenta for the Anodic Synthesis of Nanostructured TiO(2) Films.',
  'ACS omega',
  '2026 May 12',
  'https://doi.org/10.1021/acsomega.5c11864',
  0,
  1,
  NULL,
  1,
  'AlkS',
  'Chlamydophila pneumoniae CWL029'
WHERE NOT EXISTS (
  SELECT 1 FROM core_publication WHERE pmid='42146179'
);

UPDATE core_publication
SET
  authors = CASE WHEN authors IS NULL OR authors='' THEN 'Baradel IC, Simon AP, Oldoni TLC, Anaissi FJ, Sikora MS' ELSE authors END,
  title = CASE WHEN title IS NULL OR title='' THEN 'Starch-Based Eco-Friendly Electrolyte from Manihot esculenta for the Anodic Synthesis of Nanostructured TiO(2) Films.' ELSE title END,
  journal = CASE WHEN journal IS NULL OR journal='' THEN 'ACS omega' ELSE journal END,
  publication_date = CASE WHEN publication_date IS NULL OR publication_date='' THEN '2026 May 12' ELSE publication_date END,
  url = CASE WHEN url IS NULL OR url='' THEN 'https://doi.org/10.1021/acsomega.5c11864' ELSE url END,
  reported_TF = CASE WHEN reported_TF IS NULL OR reported_TF='' THEN 'AlkS' ELSE reported_TF END,
  reported_species = CASE WHEN reported_species IS NULL OR reported_species='' THEN 'Chlamydophila pneumoniae CWL029' ELSE reported_species END,
  contains_promoter_data = 0,
  contains_expression_data = 1,
  curation_complete = 1,
  submission_notes = CASE
    WHEN submission_notes IS NULL OR submission_notes='' THEN submission_notes
    ELSE submission_notes
  END
WHERE pmid='42146179';

INSERT INTO core_tf (name, family_id, description)
SELECT 'AlkS', 2, 'AlkS,  a LuxR family transcriptional regulator, activates the expression of genes necessary for the assimilation of alkanes [PMID::10692156].'
WHERE NOT EXISTS (
  SELECT 1 FROM core_tf WHERE lower(name)=lower('AlkS')
);

UPDATE core_tf
SET
  family_id = COALESCE(family_id, 2),
  description = CASE WHEN description IS NULL THEN 'AlkS,  a LuxR family transcriptional regulator, activates the expression of genes necessary for the assimilation of alkanes [PMID::10692156].' ELSE description END
WHERE lower(name)=lower('AlkS');

INSERT INTO core_tfinstance (refseq_accession, uniprot_accession, description, TF_id, notes)
SELECT
  'WP_002211684',
  'Q0WF12',
  'LysR family transcriptional regulator [Yersinia pseudotuberculosis YPIII].',
  (SELECT TF_id FROM core_tf WHERE lower(name)=lower('AlkS') LIMIT 1),
  ''
WHERE NOT EXISTS (
  SELECT 1 FROM core_tfinstance WHERE uniprot_accession='Q0WF12'
);

UPDATE core_tfinstance
SET
  TF_id = COALESCE(TF_id, (SELECT TF_id FROM core_tf WHERE lower(name)=lower('AlkS') LIMIT 1)),
  refseq_accession = COALESCE(NULLIF(refseq_accession,''), 'WP_002211684'),
  description = COALESCE(NULLIF(description,''), 'LysR family transcriptional regulator [Yersinia pseudotuberculosis YPIII].'),
  notes = COALESCE(notes, '')
WHERE uniprot_accession='Q0WF12';

INSERT INTO core_curation
  (TF_species, site_species, experimental_process, forms_complex,
   complex_notes, notes, last_modified, curator_id, publication_id, created, validated_by_id)
VALUES
  ('Chlamydophila pneumoniae CWL029', 'Chlamydophila pneumoniae CWL029', NULL,
   0, NULL, '',
   datetime('now'), (SELECT curator_id FROM core_curator ORDER BY curator_id LIMIT 1), (SELECT publication_id FROM core_publication WHERE pmid='42146179' LIMIT 1), datetime('now'), NULL);

INSERT INTO core_curation_TF_instances (curation_id, tfinstance_id)
SELECT (SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42146179' LIMIT 1) ORDER BY curation_id DESC LIMIT 1), (SELECT TF_instance_id FROM core_tfinstance WHERE uniprot_accession='Q0WF12' LIMIT 1)
WHERE NOT EXISTS (
  SELECT 1 FROM core_curation_TF_instances
  WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42146179' LIMIT 1) ORDER BY curation_id DESC LIMIT 1) AND tfinstance_id=(SELECT TF_instance_id FROM core_tfinstance WHERE uniprot_accession='Q0WF12' LIMIT 1)
);

INSERT INTO core_genome (genome_accession, organism)
SELECT 'NC_000922.1', 'Chlamydophila pneumoniae CWL029'
WHERE NOT EXISTS (
  SELECT 1 FROM core_genome WHERE genome_accession='NC_000922.1'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882656.1',
  'DUF378 domain-containing protein',
  1,
  282,
  -1,
  'CPN_RS00005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'gatC',
  'Asp-tRNA(Asn)/Glu-tRNA(Gln) amidotransferasesubunit GatC',
  573,
  878,
  1,
  'CPN_RS00010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'gatA',
  'Asp-tRNA(Asn)/Glu-tRNA(Gln) amidotransferasesubunit GatA',
  895,
  2373,
  1,
  'CPN_RS00015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'gatB',
  'Asp-tRNA(Asn)/Glu-tRNA(Gln) amidotransferasesubunit GatB',
  2370,
  3836,
  1,
  'CPN_RS00020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882660.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  4127,
  6895,
  1,
  'CPN_RS00025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882662.1',
  'DUF1978 domain-containing protein',
  7605,
  10499,
  1,
  'CPN_RS00030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892173.1',
  'IncA family protein',
  10885,
  11688,
  1,
  'CPN_RS00035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_072054065.1',
  'DUF1978 domain-containing protein',
  11725,
  13122,
  1,
  'CPN_RS00040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882665.1',
  'IncA family protein',
  13435,
  14328,
  1,
  'CPN_RS05595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'DUF1978 domain-containing protein',
  14328,
  15749,
  1,
  'CPN_RS05600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882667.1',
  'IncA family protein',
  15892,
  16617,
  1,
  'CPN_RS00050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989984.1',
  'DUF1978 domain-containing protein',
  16740,
  18215,
  1,
  'CPN_RS00055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882669.1',
  'autotransporter domain-containing protein',
  18584,
  21109,
  1,
  'CPN_RS00060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126043.1',
  'hypothetical protein',
  21392,
  21925,
  1,
  'CPN_RS00065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010895264.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  21859,
  24177,
  1,
  'CPN_RS00070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126044.1',
  'Pmp family polymorphic membrane proteinautotransporter adhesin',
  24416,
  26191,
  1,
  'CPN_RS05605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_045014832.1',
  'autotransporter outer membrane beta-barreldomain-containing protein',
  26109,
  27173,
  1,
  'CPN_RS05610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010895268.1',
  'hypothetical protein',
  27522,
  29006,
  1,
  'CPN_RS00090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_046879168.1',
  'autotransporter domain-containing protein',
  29022,
  30359,
  1,
  'CPN_RS00095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882670.1',
  'CT351 family outer membrane beta-barrel protein',
  30600,
  32687,
  -1,
  'CPN_RS00100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882671.1',
  'HEAT repeat domain-containing protein',
  32704,
  34410,
  -1,
  'CPN_RS00105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882672.1',
  'Maf-like protein',
  34392,
  34982,
  -1,
  'CPN_RS00110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882673.1',
  'ABC-F family ATP-binding cassettedomain-containing protein',
  35011,
  36603,
  -1,
  'CPN_RS00115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882674.1',
  'tyrosine recombinase XerC',
  36658,
  37596,
  -1,
  'CPN_RS00120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882675.1',
  'ribonuclease Z',
  37681,
  38604,
  -1,
  'CPN_RS00125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882676.1',
  'hypothetical protein',
  38759,
  39625,
  -1,
  'CPN_RS00130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lon',
  'endopeptidase La',
  39775,
  42234,
  -1,
  'CPN_RS00135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882678.1',
  'DUF648 domain-containing protein',
  42540,
  43325,
  -1,
  'CPN_RS00140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882680.1',
  'tRNA threonylcarbamoyladenosine biosynthesisprotein TsaB',
  43891,
  44532,
  1,
  'CPN_RS00150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsU',
  '30S ribosomal protein S21',
  44711,
  44887,
  1,
  'CPN_RS00155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dnaJ',
  'molecular chaperone DnaJ',
  44923,
  46101,
  1,
  'CPN_RS00160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882683.1',
  'dehydrogenase E1 component subunit alpha/beta',
  46138,
  48174,
  1,
  'CPN_RS00165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882684.1',
  'hypothetical protein',
  48207,
  49457,
  -1,
  'CPN_RS00170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882685.1',
  'ComEC/Rec2 family competence protein',
  49566,
  51029,
  -1,
  'CPN_RS00175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882686.1',
  'hypothetical protein',
  51002,
  51799,
  1,
  'CPN_RS00180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882687.1',
  'HPr family phosphocarrier protein',
  51792,
  52118,
  1,
  'CPN_RS00185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ptsP',
  'phosphoenolpyruvate--protein phosphotransferase',
  52119,
  53834,
  1,
  'CPN_RS00190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882689.1',
  'YbaB/EbfC family nucleoid-associated protein',
  53960,
  54250,
  -1,
  'CPN_RS00195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dnaX',
  'DNA polymerase III subunit gamma/tau',
  54315,
  55643,
  -1,
  'CPN_RS00200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'DUF1978 domain-containing protein',
  56431,
  58185,
  1,
  'CPN_RS05615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892160.1',
  'hypothetical protein',
  58182,
  58328,
  1,
  'CPN_RS00215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882693.1',
  'DUF1978 domain-containing protein',
  58447,
  60375,
  1,
  'CPN_RS00220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_162009221.1',
  'hypothetical protein',
  60509,
  60781,
  1,
  'CPN_RS05620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882695.1',
  'DUF1978 domain-containing protein',
  61069,
  62793,
  1,
  'CPN_RS00230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882696.1',
  'hypothetical protein',
  62790,
  63266,
  1,
  'CPN_RS05625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882698.1',
  'HD family phosphohydrolase',
  63687,
  65804,
  1,
  'CPN_RS00240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882702.1',
  'hydroxymethylbilane synthase',
  67301,
  68005,
  -1,
  'CPN_RS00260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'radA',
  'DNA repair protein RadA',
  67983,
  69344,
  -1,
  'CPN_RS00265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rnc',
  'ribonuclease III',
  69310,
  70023,
  -1,
  'CPN_RS00270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882705.1',
  'DUF5070 domain-containing protein',
  70129,
  70593,
  1,
  'CPN_RS00275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882706.1',
  'phospho-sugar mutase',
  70953,
  72749,
  1,
  'CPN_RS00280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882707.1',
  'superoxide dismutase',
  72934,
  73557,
  1,
  'CPN_RS00285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'accD',
  'acetyl-CoA carboxylase, carboxyltransferasesubunit beta',
  73639,
  74565,
  1,
  'CPN_RS00290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dut',
  'dUTP diphosphatase',
  74616,
  75053,
  1,
  'CPN_RS00295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882710.1',
  'PTS sugar transporter subunit IIA',
  75055,
  75531,
  1,
  'CPN_RS00300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882711.1',
  'PTS sugar transporter subunit IIA',
  75534,
  76211,
  1,
  'CPN_RS00305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882712.1',
  'hypothetical protein',
  76308,
  77693,
  1,
  'CPN_RS00310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882714.1',
  'hypothetical protein',
  78346,
  78579,
  1,
  'CPN_RS00315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882715.1',
  'IncA family protein',
  78924,
  80654,
  1,
  'CPN_RS00320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882716.1',
  'DUF687 domain-containing protein',
  80925,
  82658,
  1,
  'CPN_RS00325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882717.1',
  'hypothetical protein',
  82953,
  84056,
  1,
  'CPN_RS00330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882718.1',
  'hypothetical protein',
  84328,
  84903,
  -1,
  'CPN_RS00335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882719.1',
  'DUF687 family protein',
  85236,
  87089,
  1,
  'CPN_RS00340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  87450,
  87522,
  -1,
  'CPN_RS00345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882721.1',
  'SufE family protein',
  87596,
  88045,
  -1,
  'CPN_RS00350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882722.1',
  'hypothetical protein',
  88054,
  89061,
  -1,
  'CPN_RS00355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'infA',
  'translation initiation factor IF-1',
  89356,
  89577,
  1,
  'CPN_RS00360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  89657,
  89728,
  1,
  'CPN_RS00365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tuf',
  'elongation factor Tu',
  89774,
  90958,
  1,
  'CPN_RS00370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  90998,
  91070,
  1,
  'CPN_RS00375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'secE',
  'preprotein translocase subunit SecE',
  91102,
  91353,
  1,
  'CPN_RS00380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'nusG',
  'transcription termination/antiterminationprotein NusG',
  91358,
  91906,
  1,
  'CPN_RS00385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplK',
  '50S ribosomal protein L11',
  92013,
  92438,
  1,
  'CPN_RS00390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplA',
  '50S ribosomal protein L1',
  92465,
  93163,
  1,
  'CPN_RS00395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplJ',
  '50S ribosomal protein L10',
  93179,
  93691,
  1,
  'CPN_RS00400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplL',
  '50S ribosomal protein L7/L12',
  93735,
  94124,
  1,
  'CPN_RS00405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpoB',
  'DNA-directed RNA polymerase subunit beta',
  94261,
  98019,
  1,
  'CPN_RS00410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpoC',
  'DNA-directed RNA polymerase subunit beta''',
  98043,
  102224,
  1,
  'CPN_RS00415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tal',
  'transaldolase',
  102332,
  103315,
  1,
  'CPN_RS00420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126057.1',
  'hypothetical protein',
  103374,
  103754,
  1,
  'CPN_RS00425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882735.1',
  'hypothetical protein',
  103763,
  104506,
  -1,
  'CPN_RS00430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882736.1',
  'V-type ATP synthase subunit E',
  104904,
  105530,
  1,
  'CPN_RS00435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882737.1',
  'DUF2764 family protein',
  105579,
  106379,
  1,
  'CPN_RS00440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882738.1',
  'V-type ATP synthase subunit A',
  106373,
  108148,
  1,
  'CPN_RS00445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882739.1',
  'V-type ATP synthase subunit B',
  108153,
  109469,
  1,
  'CPN_RS00450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882740.1',
  'V-type ATP synthase subunit D',
  109454,
  110083,
  1,
  'CPN_RS00455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882741.1',
  'V-type ATP synthase subunit I',
  110074,
  112056,
  1,
  'CPN_RS00460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882742.1',
  'ATP synthase subunit C',
  112151,
  112576,
  1,
  'CPN_RS00465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882743.1',
  'hypothetical protein',
  112509,
  113018,
  1,
  'CPN_RS00470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882744.1',
  'valine--tRNA ligase',
  113152,
  115974,
  1,
  'CPN_RS00475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pknD',
  'serine/threonine-protein kinase PknD',
  115995,
  118793,
  1,
  'CPN_RS00480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'uvrA',
  'excinuclease ABC subunit UvrA',
  118834,
  124314,
  -1,
  'CPN_RS00485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pyk',
  'pyruvate kinase',
  124555,
  126009,
  1,
  'CPN_RS00490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882748.1',
  'lipid A biosynthesis lauroyl acyltransferase',
  126088,
  127491,
  -1,
  'CPN_RS00495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_020971687.1',
  'hypothetical protein',
  127544,
  127843,
  -1,
  'CPN_RS00500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882750.1',
  'CdaR family protein',
  127879,
  129141,
  -1,
  'CPN_RS00505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'cdaA',
  'diadenylate cyclase CdaA',
  129138,
  129932,
  -1,
  'CPN_RS00510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882752.1',
  'cytochrome ubiquinol oxidase subunit I',
  130123,
  131469,
  1,
  'CPN_RS00515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'cydB',
  'cytochrome d ubiquinol oxidase subunit II',
  131480,
  132514,
  1,
  'CPN_RS00520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882754.1',
  'SH3 domain-containing protein',
  132673,
  133875,
  -1,
  'CPN_RS00525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_041466976.1',
  'hypothetical protein',
  134026,
  134763,
  -1,
  'CPN_RS00530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882756.1',
  'PhoH family protein',
  135091,
  136377,
  1,
  'CPN_RS00535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882757.1',
  'macro domain-containing protein',
  136389,
  137162,
  -1,
  'CPN_RS00540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882758.1',
  'hypothetical protein',
  137300,
  137857,
  -1,
  'CPN_RS00545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ssrA',
  '—',
  138068,
  138493,
  -1,
  'CPN_RS00550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ileS',
  'isoleucine--tRNA ligase',
  138655,
  141786,
  1,
  'CPN_RS00555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lepB',
  'signal peptidase I',
  141824,
  143734,
  -1,
  'CPN_RS00560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882761.1',
  'hypothetical protein',
  143931,
  144686,
  -1,
  'CPN_RS00565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882762.1',
  'type B 50S ribosomal protein L31',
  144767,
  145096,
  1,
  'CPN_RS00570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'prfA',
  'peptide chain release factor 1',
  145335,
  146408,
  1,
  'CPN_RS00575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'prmC',
  'peptide chain release factor N(5)-glutaminemethyltransferase',
  146398,
  147264,
  1,
  'CPN_RS00580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ffh',
  'signal recognition particle protein',
  147279,
  148625,
  1,
  'CPN_RS00585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882766.1',
  '30S ribosomal protein S16',
  148616,
  148975,
  1,
  'CPN_RS00590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'trmD',
  'tRNA (guanosine(37)-N1)-methyltransferase TrmD',
  148989,
  150074,
  1,
  'CPN_RS00595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplS',
  '50S ribosomal protein L19',
  150102,
  150467,
  1,
  'CPN_RS00600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882769.1',
  'ribonuclease HII',
  150523,
  151167,
  1,
  'CPN_RS00605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'gmk',
  'guanylate kinase',
  151164,
  151781,
  1,
  'CPN_RS00610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882771.1',
  'hypothetical protein',
  151778,
  152071,
  1,
  'CPN_RS00615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'metG',
  'methionine--tRNA ligase',
  152071,
  153726,
  1,
  'CPN_RS00620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'recD2',
  'SF1B family DNA helicase RecD2',
  153771,
  155969,
  -1,
  'CPN_RS00625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882774.1',
  'DUF1978 domain-containing protein',
  156614,
  158071,
  1,
  'CPN_RS00630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882775.1',
  'hypothetical protein',
  158096,
  158608,
  1,
  'CPN_RS00635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989985.1',
  'DUF1978 domain-containing protein',
  158830,
  161088,
  1,
  'CPN_RS00640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882777.1',
  'DMT family transporter',
  161127,
  162143,
  -1,
  'CPN_RS00645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882778.1',
  'BPL-N domain-containing protein',
  162277,
  163056,
  1,
  'CPN_RS00650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882779.1',
  'hypothetical protein',
  163061,
  163717,
  -1,
  'CPN_RS05630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882780.1',
  'hypothetical protein',
  163748,
  164245,
  -1,
  'CPN_RS05635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  164318,
  164389,
  -1,
  'CPN_RS00660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126074.1',
  'hypothetical protein',
  164561,
  165583,
  1,
  'CPN_RS00665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882782.1',
  'hypothetical protein',
  165587,
  166564,
  1,
  'CPN_RS00670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882783.1',
  'AsmA family protein',
  166561,
  167334,
  -1,
  'CPN_RS00675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'groL',
  'chaperonin GroEL',
  167464,
  169098,
  -1,
  'CPN_RS00680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882785.1',
  'co-chaperone GroES',
  169140,
  169448,
  -1,
  'CPN_RS00685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pepF',
  'oligoendopeptidase F',
  169566,
  171401,
  -1,
  'CPN_RS00690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882787.1',
  'Nif3-like dinuclear metal center hexamericprotein',
  171499,
  172254,
  -1,
  'CPN_RS00695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'hemL',
  'glutamate-1-semialdehyde 2,1-aminomutase',
  172697,
  174019,
  -1,
  'CPN_RS00700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_041466948.1',
  'YqgE/AlgH family protein',
  174090,
  174659,
  -1,
  'CPN_RS00705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882790.1',
  'bifunctional nuclease family protein',
  174670,
  175110,
  -1,
  'CPN_RS00710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpiA',
  'ribose-5-phosphate isomerase RpiA',
  175107,
  175802,
  -1,
  'CPN_RS00715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882793.1',
  '5-methyltetrahydropteroyltriglutamate--homocysteine S-methyltransferase',
  176211,
  177335,
  -1,
  'CPN_RS00725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882794.1',
  'ATP-dependent Clp protease ATP-binding subunit',
  177963,
  180563,
  1,
  'CPN_RS00730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892125.1',
  'transglutaminase family protein',
  180804,
  182372,
  1,
  'CPN_RS00735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882796.1',
  'hypothetical protein',
  182613,
  183098,
  1,
  'CPN_RS00740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882797.1',
  'hypothetical protein',
  183225,
  183674,
  1,
  'CPN_RS00745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882798.1',
  'SUMF1/EgtB/PvdO family nonheme iron enzyme',
  183846,
  185705,
  1,
  'CPN_RS00750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ligA',
  'NAD-dependent DNA ligase LigA',
  185715,
  187703,
  1,
  'CPN_RS00755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882800.1',
  'hypothetical protein',
  187834,
  192447,
  1,
  'CPN_RS00760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882801.1',
  'FAD-dependent oxidoreductase',
  192622,
  194142,
  -1,
  'CPN_RS00765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882802.1',
  'alpha/beta hydrolase',
  194315,
  195265,
  -1,
  'CPN_RS00770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'leuS',
  'leucine--tRNA ligase',
  195433,
  197895,
  1,
  'CPN_RS00775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'waaA',
  'lipid IV(A) 3-deoxy-D-manno-octulosonic acidtransferase',
  197892,
  199205,
  1,
  'CPN_RS00780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  199229,
  199301,
  1,
  'CPN_RS00785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  199317,
  199390,
  1,
  'CPN_RS00790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882806.1',
  'hypothetical protein',
  199767,
  200117,
  -1,
  'CPN_RS00800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882807.1',
  'DUF648 domain-containing protein',
  200295,
  200723,
  -1,
  'CPN_RS00805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882808.1',
  'hypothetical protein',
  200891,
  201430,
  -1,
  'CPN_RS00810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226990000.1',
  'DUF648 domain-containing protein',
  201464,
  201781,
  -1,
  'CPN_RS00815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882810.1',
  'diphosphate--fructose-6-phosphate1-phosphotransferase',
  202124,
  203791,
  -1,
  'CPN_RS00820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_042253943.1',
  'alpha/beta hydrolase',
  203795,
  204580,
  -1,
  'CPN_RS00825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882812.1',
  'DUF648 domain-containing protein',
  204800,
  205828,
  -1,
  'CPN_RS00830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882813.1',
  'hypothetical protein',
  206026,
  206397,
  1,
  'CPN_RS00835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989986.1',
  'hypothetical protein',
  206600,
  207001,
  1,
  'CPN_RS00840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882815.1',
  'hypothetical protein',
  206998,
  207585,
  1,
  'CPN_RS00845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882816.1',
  'hypothetical protein',
  207630,
  207965,
  1,
  'CPN_RS00850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989987.1',
  'hypothetical protein',
  207974,
  208276,
  -1,
  'CPN_RS00855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989988.1',
  'hypothetical protein',
  208414,
  208578,
  -1,
  'CPN_RS00860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882819.1',
  'hypothetical protein',
  208707,
  209501,
  -1,
  'CPN_RS00865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882820.1',
  'amidohydrolase family protein',
  210022,
  211026,
  -1,
  'CPN_RS00870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'guaA',
  'glutamine-hydrolyzing GMP synthase',
  211146,
  212414,
  -1,
  'CPN_RS00875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'guaB',
  'IMP dehydrogenase',
  212437,
  213501,
  -1,
  'CPN_RS00880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_172643915.1',
  'hypothetical protein',
  213771,
  213920,
  -1,
  'CPN_RS05575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989989.1',
  'hypothetical protein',
  214263,
  214727,
  1,
  'CPN_RS00890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882826.1',
  'hypothetical protein',
  214898,
  215278,
  1,
  'CPN_RS00895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882827.1',
  'MAC/perforin domain-containing protein',
  215286,
  216521,
  1,
  'CPN_RS00900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882828.1',
  'gamma-glutamylcyclotransferase family protein',
  216605,
  217459,
  -1,
  'CPN_RS00905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882829.1',
  'hypothetical protein',
  217786,
  218052,
  -1,
  'CPN_RS00910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882830.1',
  'hypothetical protein',
  218053,
  218403,
  -1,
  'CPN_RS00915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882831.1',
  'hypothetical protein',
  218352,
  218906,
  -1,
  'CPN_RS05580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'accC',
  'acetyl-CoA carboxylase biotin carboxylasesubunit',
  219331,
  220695,
  -1,
  'CPN_RS00930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'accB',
  'acetyl-CoA carboxylase biotin carboxyl carrierprotein',
  220692,
  221195,
  -1,
  'CPN_RS00935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882835.1',
  'elongation factor P',
  221218,
  221775,
  -1,
  'CPN_RS00940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpe',
  'ribulose-phosphate 3-epimerase',
  221762,
  222451,
  -1,
  'CPN_RS00945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882837.1',
  'inclusion membrane protein IncA',
  222899,
  224071,
  1,
  'CPN_RS00950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882838.1',
  'class I SAM-dependent methyltransferase',
  224248,
  225048,
  1,
  'CPN_RS00955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882839.1',
  'YihY/virulence factor BrkB family protein',
  225111,
  226403,
  1,
  'CPN_RS00960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882840.1',
  'hypothetical protein',
  226400,
  229828,
  1,
  'CPN_RS00965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882841.1',
  'hypothetical protein',
  229919,
  231277,
  1,
  'CPN_RS00970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882842.1',
  'ATP-binding cassette domain-containing protein',
  231311,
  231991,
  -1,
  'CPN_RS00975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882843.1',
  'amino acid ABC transporter permease',
  231981,
  232634,
  -1,
  'CPN_RS00980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'argR',
  'arginine repressor',
  232683,
  233126,
  -1,
  'CPN_RS00985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tsaD',
  'tRNA(adenosine(37)-N6)-threonylcarbamoyltransferase complextransferase subunit TsaD',
  233210,
  234244,
  1,
  'CPN_RS00990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882846.1',
  'peptide ABC transporter substrate-bindingprotein',
  234190,
  235788,
  1,
  'CPN_RS00995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS00995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882847.1',
  'peptide ABC transporter substrate-bindingprotein',
  235939,
  237522,
  1,
  'CPN_RS01000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882848.1',
  'ABC transporter substrate-binding protein',
  237578,
  238885,
  1,
  'CPN_RS01005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892102.1',
  'peptide ABC transporter substrate-bindingprotein',
  239163,
  240749,
  1,
  'CPN_RS01010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882850.1',
  'ABC transporter permease',
  241042,
  241986,
  1,
  'CPN_RS01015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882851.1',
  'ABC transporter permease',
  242017,
  242871,
  1,
  'CPN_RS01020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882852.1',
  'ABC transporter ATP-binding protein',
  242864,
  243718,
  1,
  'CPN_RS01025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882853.1',
  'ABC transporter ATP-binding protein',
  243715,
  244503,
  1,
  'CPN_RS01030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882854.1',
  'DUF648 domain-containing protein',
  245008,
  245805,
  1,
  'CPN_RS01035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882857.1',
  'DUF1186 domain-containing protein',
  246409,
  247164,
  1,
  'CPN_RS01050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882858.1',
  'anion permease',
  247208,
  248620,
  1,
  'CPN_RS01055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882859.1',
  'diphosphate--fructose-6-phosphate1-phosphotransferase',
  248953,
  250605,
  1,
  'CPN_RS01060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882860.1',
  'DUF648 domain-containing protein',
  251036,
  251275,
  1,
  'CPN_RS01065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882861.1',
  'hypothetical protein',
  251437,
  252384,
  -1,
  'CPN_RS01070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882862.1',
  'hypothetical protein',
  252460,
  252756,
  -1,
  'CPN_RS01075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989990.1',
  'IncA family protein',
  252885,
  254060,
  -1,
  'CPN_RS01080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882865.1',
  'hypothetical protein',
  254443,
  255657,
  -1,
  'CPN_RS01085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882866.1',
  'coiled-coil domain-containing protein',
  255756,
  257015,
  -1,
  'CPN_RS01090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882867.1',
  'hypothetical protein',
  257171,
  257608,
  -1,
  'CPN_RS01095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882868.1',
  'queuosine precursor transporter',
  257896,
  258582,
  1,
  'CPN_RS01100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882869.1',
  'hypothetical protein',
  258579,
  259058,
  -1,
  'CPN_RS01105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tgt',
  'tRNA guanosine(34) transglycosylase Tgt',
  259357,
  260475,
  1,
  'CPN_RS01110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989991.1',
  'hypothetical protein',
  260777,
  261241,
  1,
  'CPN_RS01115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882872.1',
  'hypothetical protein',
  261657,
  262067,
  1,
  'CPN_RS01120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882873.1',
  'rolling circle replication-associated protein',
  262504,
  262845,
  1,
  'CPN_RS01125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882874.1',
  'hypothetical protein',
  262956,
  263336,
  1,
  'CPN_RS01130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882875.1',
  'hypothetical protein',
  263435,
  263677,
  1,
  'CPN_RS01135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882876.1',
  'IncA family protein',
  263873,
  264544,
  1,
  'CPN_RS01140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882877.1',
  'hypothetical protein',
  264566,
  264970,
  1,
  'CPN_RS01145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882878.1',
  'disulfide formation protein',
  265006,
  265416,
  -1,
  'CPN_RS01150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_172643917.1',
  'thioredoxin domain-containing protein',
  265409,
  266077,
  -1,
  'CPN_RS01155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882881.1',
  'hypothetical protein',
  266328,
  267563,
  1,
  'CPN_RS01160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882882.1',
  'hypothetical protein',
  267573,
  268253,
  -1,
  'CPN_RS01165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882883.1',
  'ABC transporter ATP-binding protein',
  268250,
  268957,
  -1,
  'CPN_RS01170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  268992,
  269065,
  -1,
  'CPN_RS01175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  269070,
  269142,
  -1,
  'CPN_RS01180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882884.1',
  '5''-methylthioadenosine/S-adenosylhomocysteinenucleosidase family protein',
  269229,
  270122,
  -1,
  'CPN_RS01185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882886.1',
  'hypothetical protein',
  270545,
  271240,
  -1,
  'CPN_RS01195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'kdsB',
  '3-deoxy-manno-octulosonate cytidylyltransferase',
  271416,
  272180,
  1,
  'CPN_RS01200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882888.1',
  'CTP synthase',
  272156,
  273769,
  1,
  'CPN_RS01205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ruvX',
  'Holliday junction resolvase RuvX',
  273762,
  274217,
  1,
  'CPN_RS01210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'zwf',
  'glucose-6-phosphate dehydrogenase',
  274303,
  275841,
  1,
  'CPN_RS01215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pgl',
  '6-phosphogluconolactonase',
  275899,
  276675,
  1,
  'CPN_RS01220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'garD',
  'inclusion membrane protein GarD',
  276695,
  277849,
  -1,
  'CPN_RS01225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'garD',
  'inclusion membrane protein GarD',
  278200,
  279354,
  -1,
  'CPN_RS01230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882894.1',
  'hypothetical protein',
  279484,
  279918,
  -1,
  'CPN_RS01235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882896.1',
  'adenylate kinase',
  280918,
  281559,
  1,
  'CPN_RS01245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882897.1',
  'C40 family peptidase',
  281645,
  282502,
  1,
  'CPN_RS01250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsI',
  '30S ribosomal protein S9',
  282548,
  282952,
  -1,
  'CPN_RS01255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplM',
  '50S ribosomal protein L13',
  282966,
  283415,
  -1,
  'CPN_RS01260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882900.1',
  'ABC transporter ATP-binding protein',
  283647,
  284327,
  -1,
  'CPN_RS01265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882901.1',
  'ABC transporter permease',
  284330,
  285841,
  -1,
  'CPN_RS01270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpmG',
  '50S ribosomal protein L33',
  285899,
  286057,
  -1,
  'CPN_RS01275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rimO',
  '30S ribosomal protein S12 methylthiotransferaseRimO',
  286156,
  287562,
  1,
  'CPN_RS01280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_123838457.1',
  'hypothetical protein',
  287573,
  287908,
  -1,
  'CPN_RS01285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_046879173.1',
  'hypothetical protein',
  287947,
  288456,
  -1,
  'CPN_RS01290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882904.1',
  'hypothetical protein',
  288456,
  289262,
  -1,
  'CPN_RS01295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882905.1',
  'hypothetical protein',
  289326,
  290165,
  -1,
  'CPN_RS01300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882906.1',
  'hypothetical protein',
  290395,
  291264,
  -1,
  'CPN_RS01305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882907.1',
  'hypothetical protein',
  291264,
  292127,
  -1,
  'CPN_RS01310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010895307.1',
  'hypothetical protein',
  292130,
  292516,
  -1,
  'CPN_RS05640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126093.1',
  'hypothetical protein',
  292438,
  292986,
  -1,
  'CPN_RS05645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  293317,
  293399,
  -1,
  'CPN_RS01320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  293405,
  293477,
  -1,
  'CPN_RS01325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882908.1',
  'YecA family protein',
  293545,
  294045,
  -1,
  'CPN_RS01330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882909.1',
  'tRNA 2-thiocytidine biosynthesis TtcA familyprotein',
  294302,
  295036,
  1,
  'CPN_RS01335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'surE',
  '5''/3''-nucleotidase SurE',
  295091,
  295936,
  1,
  'CPN_RS01340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  296075,
  296147,
  1,
  'CPN_RS01345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  296151,
  296224,
  1,
  'CPN_RS01350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882911.1',
  'YitT family protein',
  296249,
  297139,
  1,
  'CPN_RS01355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882912.1',
  'flavin prenyltransferase UbiX',
  297152,
  297730,
  -1,
  'CPN_RS01360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882913.1',
  '4-hydroxybenzoate octaprenyltransferase',
  297727,
  298620,
  -1,
  'CPN_RS01365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882914.1',
  'hypothetical protein',
  299184,
  299879,
  1,
  'CPN_RS01370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126095.1',
  'hypothetical protein',
  300131,
  300913,
  1,
  'CPN_RS01375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126096.1',
  'hypothetical protein',
  300977,
  301321,
  1,
  'CPN_RS01380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882917.1',
  'dipeptidase',
  301473,
  302450,
  -1,
  'CPN_RS01385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882918.1',
  'L-threonylcarbamoyladenylate synthase',
  302465,
  303325,
  -1,
  'CPN_RS01390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882919.1',
  'alpha/beta hydrolase family protein',
  303634,
  304365,
  1,
  'CPN_RS01395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882920.1',
  'DNA polymerase III subunit delta''',
  304337,
  305233,
  -1,
  'CPN_RS01400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tmk',
  'dTMP kinase',
  305224,
  305844,
  -1,
  'CPN_RS01405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'gyrA',
  'DNA topoisomerase (ATP-hydrolyzing) subunit A',
  305849,
  308353,
  -1,
  'CPN_RS01410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'gyrB',
  'DNA topoisomerase (ATP-hydrolyzing) subunit B',
  308369,
  310786,
  -1,
  'CPN_RS01415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882924.1',
  'hypothetical protein',
  310790,
  311137,
  -1,
  'CPN_RS01420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882925.1',
  'hypothetical protein',
  311401,
  311910,
  -1,
  'CPN_RS01425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882926.1',
  'MetQ/NlpA family ABC transportersubstrate-binding protein',
  312057,
  312875,
  -1,
  'CPN_RS01430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882927.1',
  'methionine ABC transporter permease',
  312872,
  313537,
  -1,
  'CPN_RS01435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882928.1',
  'methionine ABC transporter ATP-binding protein',
  313547,
  314572,
  -1,
  'CPN_RS01440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882929.1',
  'class I fructose-bisphosphate aldolase',
  315057,
  316106,
  1,
  'CPN_RS01445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882930.1',
  'amino acid permease',
  316126,
  317532,
  1,
  'CPN_RS01450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882931.1',
  'hypothetical protein',
  317529,
  318497,
  -1,
  'CPN_RS01455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882932.1',
  'hypothetical protein',
  318548,
  319045,
  -1,
  'CPN_RS01460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882933.1',
  'CT214 family putative inclusion membraneprotein',
  319048,
  320595,
  -1,
  'CPN_RS01465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'mgtE',
  'magnesium transporter',
  320647,
  322059,
  -1,
  'CPN_RS01470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882935.1',
  'tetratricopeptide repeat protein',
  322086,
  324221,
  -1,
  'CPN_RS01475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882936.1',
  'hypothetical protein',
  324568,
  325716,
  -1,
  'CPN_RS01480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882937.1',
  'dicarboxylate/amino acid:cation symporter',
  325812,
  326999,
  1,
  'CPN_RS01485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882938.1',
  'sodium-dependent transporter',
  327042,
  328526,
  1,
  'CPN_RS01490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'incB',
  'inclusion membrane protein IncB',
  328667,
  329197,
  1,
  'CPN_RS01495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882940.1',
  'inclusion membrane protein IncC',
  329228,
  329839,
  1,
  'CPN_RS01500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882941.1',
  'MFS transporter',
  329949,
  332726,
  1,
  'CPN_RS01505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882942.1',
  'cyclic nucleotide-binding domain-containingprotein',
  333092,
  333505,
  1,
  'CPN_RS01510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'acpP',
  'acyl carrier protein',
  333624,
  333863,
  -1,
  'CPN_RS01515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'fabG',
  '3-oxoacyl-ACP reductase FabG',
  334019,
  334765,
  -1,
  'CPN_RS01520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'fabD',
  'ACP S-malonyltransferase',
  334771,
  335697,
  -1,
  'CPN_RS01525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'fabH',
  'ketoacyl-ACP synthase III',
  335714,
  336721,
  -1,
  'CPN_RS01530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'recR',
  'recombination mediator RecR',
  336816,
  337418,
  1,
  'CPN_RS01535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'bamA',
  'outer membrane protein assembly factor BamA',
  337783,
  340155,
  1,
  'CPN_RS01540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882949.1',
  'OmpH/Skp family outer membrane protein',
  340250,
  340765,
  1,
  'CPN_RS01545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lpxD',
  'UDP-3-O-(3-hydroxymyristoyl)glucosamineN-acyltransferase',
  340787,
  341869,
  1,
  'CPN_RS01550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882951.1',
  'hypothetical protein',
  341918,
  342958,
  -1,
  'CPN_RS01555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882952.1',
  'thiamine pyrophosphate-dependent enzyme',
  343133,
  344161,
  1,
  'CPN_RS01560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882953.1',
  'alpha-ketoacid dehydrogenase subunit beta',
  344154,
  345140,
  1,
  'CPN_RS01565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882954.1',
  'pyruvate dehydrogenase complex dihydrolipoamideacetyltransferase',
  345145,
  346434,
  1,
  'CPN_RS01570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_162008450.1',
  'glycogen/starch/alpha-glucan phosphorylase',
  346512,
  348938,
  -1,
  'CPN_RS01575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882956.1',
  'hypothetical protein',
  349234,
  349599,
  1,
  'CPN_RS01580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dnaA',
  'chromosomal replication initiator protein DnaA',
  349592,
  350974,
  -1,
  'CPN_RS01585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'yidC',
  'membrane protein insertase YidC',
  351046,
  353433,
  -1,
  'CPN_RS01590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882959.1',
  'prolipoprotein diacylglyceryl transferase',
  353572,
  354438,
  -1,
  'CPN_RS01595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882960.1',
  'hypothetical protein',
  354524,
  354979,
  1,
  'CPN_RS01600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'acpS',
  'holo-ACP synthase',
  354990,
  355358,
  1,
  'CPN_RS01605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'trxB',
  'thioredoxin-disulfide reductase',
  355350,
  356285,
  -1,
  'CPN_RS01610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsA',
  '30S ribosomal protein S1',
  356977,
  358719,
  1,
  'CPN_RS01615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'nusA',
  'transcription termination factor NusA',
  358820,
  360124,
  1,
  'CPN_RS01620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'infB',
  'translation initiation factor IF-2',
  360081,
  362753,
  1,
  'CPN_RS01625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rbfA',
  '30S ribosome-binding factor RbfA',
  362767,
  363129,
  1,
  'CPN_RS01630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'truB',
  'tRNA pseudouridine(55) synthase TruB',
  363175,
  363882,
  1,
  'CPN_RS01635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126108.1',
  'bifunctional riboflavin kinase/FAD synthetase',
  363866,
  364786,
  1,
  'CPN_RS01640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ychF',
  'redox-regulated ATPase YchF',
  364764,
  365858,
  -1,
  'CPN_RS01645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sctU',
  'type III secretion system export apparatussubunit SctU',
  366249,
  367331,
  1,
  'CPN_RS01650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sctV',
  'type III secretion system export apparatussubunit SctV',
  367331,
  369463,
  1,
  'CPN_RS01655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sctW',
  'type III secretion system gatekeeper subunitSctW',
  369492,
  370691,
  1,
  'CPN_RS01660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882973.1',
  'CesT family type III secretion system chaperone',
  370708,
  371151,
  1,
  'CPN_RS01665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882974.1',
  '4-alpha-glucanotransferase',
  371148,
  372728,
  1,
  'CPN_RS01670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpmB',
  '50S ribosomal protein L28',
  372945,
  373214,
  1,
  'CPN_RS01675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882976.1',
  'menaquinone biosynthesis decarboxylase',
  373241,
  374995,
  1,
  'CPN_RS01680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882977.1',
  'phospholipase D-like domain-containing protein',
  375088,
  376149,
  1,
  'CPN_RS01685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882978.1',
  'hypothetical protein',
  376199,
  376675,
  -1,
  'CPN_RS01690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882979.1',
  'hypothetical protein',
  376698,
  378437,
  -1,
  'CPN_RS01695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ltuB',
  'late transcription unit protein LtuB',
  378797,
  379090,
  -1,
  'CPN_RS01700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892065.1',
  'hypothetical protein',
  379362,
  379826,
  1,
  'CPN_RS01705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'folD',
  'bifunctional methylenetetrahydrofolatedehydrogenase/methenyltetrahydrofolate cyclohydrolaseFolD',
  379817,
  380677,
  1,
  'CPN_RS01710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882984.1',
  'FAD:protein FMN transferase',
  380650,
  381594,
  1,
  'CPN_RS01715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'smpB',
  'SsrA-binding protein SmpB',
  381572,
  382027,
  -1,
  'CPN_RS01720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dnaN',
  'DNA polymerase III subunit beta',
  382278,
  383378,
  1,
  'CPN_RS01725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'recF',
  'DNA replication/repair protein RecF',
  383426,
  384498,
  1,
  'CPN_RS01730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'esterase/lipase family protein',
  384622,
  385598,
  1,
  'CPN_RS01735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882987.1',
  'M50 family metallopeptidase',
  385555,
  387420,
  -1,
  'CPN_RS01740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dxr',
  '1-deoxy-D-xylulose-5-phosphate reductoisomerase',
  387433,
  388572,
  -1,
  'CPN_RS01745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882989.1',
  'metal ABC transporter permease',
  388701,
  389675,
  -1,
  'CPN_RS01750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882990.1',
  'iron chelate uptake ABC transporter familypermease subunit',
  389675,
  391021,
  -1,
  'CPN_RS01755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882991.1',
  'metal ABC transporter ATP-binding protein',
  391024,
  391803,
  -1,
  'CPN_RS01760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882992.1',
  'metal ABC transporter solute-binding protein,Zn/Mn family',
  391787,
  392770,
  -1,
  'CPN_RS01765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ddbA',
  'DNA binding protein DdbA',
  393181,
  393687,
  1,
  'CPN_RS01770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'npt1',
  'NTP/NDP exchange transporter Npt1',
  393888,
  395435,
  1,
  'CPN_RS01775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989993.1',
  'DUF1389 domain-containing protein',
  395553,
  396833,
  1,
  'CPN_RS01780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882997.1',
  'DUF1389 domain-containing protein',
  397167,
  398510,
  1,
  'CPN_RS01790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989994.1',
  'DUF1389 domain-containing protein',
  398588,
  399883,
  -1,
  'CPN_RS01795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'DUF1389 domain-containing protein',
  400106,
  401317,
  -1,
  'CPN_RS01805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lepA',
  'translation elongation factor 4',
  402012,
  403820,
  1,
  'CPN_RS01810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'gnd',
  'decarboxylating NADP(+)-dependentphosphogluconate dehydrogenase',
  403919,
  405358,
  -1,
  'CPN_RS01815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tyrS',
  'tyrosine--tRNA ligase',
  405379,
  406617,
  -1,
  'CPN_RS01820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892050.1',
  'hypothetical protein',
  406780,
  407103,
  1,
  'CPN_RS01825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883005.1',
  'FliA/WhiG family RNA polymerase sigma factor',
  407052,
  407825,
  -1,
  'CPN_RS01830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883006.1',
  'EscV/YscV/HrcV family type III secretion systemexport apparatus protein',
  407940,
  409688,
  -1,
  'CPN_RS01835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  409848,
  409922,
  1,
  'CPN_RS01840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883007.1',
  '2Fe-2S iron-sulfur cluster-binding protein',
  409966,
  410241,
  1,
  'CPN_RS01845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883008.1',
  'hypothetical protein',
  410528,
  411547,
  1,
  'CPN_RS01850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883009.1',
  'hypothetical protein',
  411976,
  412443,
  1,
  'CPN_RS01855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883010.1',
  'macro domain-containing protein',
  413102,
  413839,
  1,
  'CPN_RS01860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883011.1',
  'macro domain-containing protein',
  413790,
  414110,
  1,
  'CPN_RS01865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883012.1',
  'macro domain-containing protein',
  414351,
  415565,
  1,
  'CPN_RS01870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883013.1',
  'macro domain-containing protein',
  415800,
  416915,
  1,
  'CPN_RS01875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883014.1',
  'hypothetical protein',
  417147,
  417506,
  1,
  'CPN_RS01880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883015.1',
  'hypothetical protein',
  417687,
  418004,
  1,
  'CPN_RS01885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883016.1',
  '4-hydroxy-3-methylbut-2-en-1-yl diphosphatesynthase',
  418380,
  420221,
  1,
  'CPN_RS01890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pgeF',
  'peptidoglycan editing factor PgeF',
  420218,
  420964,
  1,
  'CPN_RS01895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883018.1',
  'hypothetical protein',
  421121,
  421618,
  1,
  'CPN_RS01900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883019.1',
  'hypothetical protein',
  421854,
  422297,
  1,
  'CPN_RS01905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sucB',
  'dihydrolipoyllysine-residue succinyltransferase',
  422344,
  423438,
  -1,
  'CPN_RS01910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883021.1',
  '2-oxoglutarate dehydrogenase E1 component',
  423442,
  426168,
  -1,
  'CPN_RS01915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883022.1',
  'hypothetical protein',
  426322,
  426768,
  1,
  'CPN_RS01920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'hemW',
  'radical SAM family heme chaperone HemW',
  426758,
  427879,
  1,
  'CPN_RS01925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883024.1',
  'DUF687 domain-containing protein',
  428034,
  429809,
  -1,
  'CPN_RS01930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883025.1',
  'SAM-dependent methyltransferase',
  430033,
  430749,
  -1,
  'CPN_RS01935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883026.1',
  'DNA polymerase III subunit delta',
  430746,
  431693,
  -1,
  'CPN_RS01940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883027.1',
  'histone H1-like repetitive region-containingprotein',
  431859,
  432377,
  -1,
  'CPN_RS01945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883028.1',
  'leucyl aminopeptidase',
  432519,
  434018,
  -1,
  'CPN_RS01950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883029.1',
  'single-stranded DNA-binding protein',
  434043,
  434525,
  -1,
  'CPN_RS01955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883030.1',
  'type III secretion chaperone Slc1',
  434696,
  435196,
  -1,
  'CPN_RS01960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883031.1',
  'glycogen debranching protein',
  435329,
  437323,
  1,
  'CPN_RS01965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226990002.1',
  'SpoIID/LytB domain-containing protein',
  437316,
  438092,
  -1,
  'CPN_RS01970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ruvB',
  'Holliday junction branch migration DNA helicaseRuvB',
  438131,
  439144,
  -1,
  'CPN_RS01975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dcd',
  'dCTP deaminase',
  439814,
  440386,
  1,
  'CPN_RS01985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883036.1',
  'hypothetical protein',
  440379,
  440726,
  1,
  'CPN_RS01990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883037.1',
  'hemolysin family protein',
  440736,
  441971,
  1,
  'CPN_RS01995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS01995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883038.1',
  'CNNM domain-containing protein',
  441964,
  443178,
  1,
  'CPN_RS02000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883039.1',
  'cysteine desulfurase family protein',
  443238,
  444353,
  -1,
  'CPN_RS02005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883040.1',
  'PP2C family protein-serine/threoninephosphatase',
  444378,
  445115,
  -1,
  'CPN_RS02010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883041.1',
  'hypothetical protein',
  445533,
  445703,
  1,
  'CPN_RS05550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883042.1',
  'CT253 family lipoprotein',
  445879,
  446526,
  1,
  'CPN_RS02015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883043.1',
  'CPBP family intramembrane glutamicendopeptidase',
  446536,
  447309,
  1,
  'CPN_RS02020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ffs',
  '—',
  447319,
  447416,
  -1,
  'CPN_RS02025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883044.1',
  'MazG nucleotide pyrophosphohydrolasedomain-containing protein',
  447492,
  447884,
  -1,
  'CPN_RS02030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'mutY',
  'A/G-specific adenine glycosylase',
  447885,
  448994,
  -1,
  'CPN_RS02035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883046.1',
  'RluA family pseudouridine synthase',
  449015,
  449713,
  1,
  'CPN_RS02040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883047.1',
  'hypothetical protein',
  449868,
  450887,
  -1,
  'CPN_RS02045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126131.1',
  'hypothetical protein',
  450963,
  451709,
  -1,
  'CPN_RS02050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883049.1',
  'enoyl-[acyl-carrier-protein] reductase',
  451969,
  452868,
  1,
  'CPN_RS02055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883050.1',
  'HAD-IIB family hydrolase',
  452855,
  453742,
  -1,
  'CPN_RS02060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'fliO',
  'flagellar biosynthetic protein FliO',
  454105,
  454584,
  1,
  'CPN_RS02070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883052.1',
  'type III secretion system chaperone familyprotein',
  454645,
  455130,
  1,
  'CPN_RS02075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126135.1',
  'putative quorum-sensing-regulated virulencefactor',
  455138,
  455836,
  1,
  'CPN_RS02080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883054.1',
  '1,4-dihydroxy-6-naphtoate synthase',
  455833,
  456612,
  1,
  'CPN_RS02085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883055.1',
  'nucleoside phosphorylase-I family protein',
  456590,
  457249,
  1,
  'CPN_RS02090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883056.1',
  'ABC transporter ATP-binding protein',
  457224,
  459203,
  -1,
  'CPN_RS02095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883057.1',
  'acetyl-CoA carboxylase carboxyltransferasesubunit alpha',
  459169,
  460143,
  -1,
  'CPN_RS02100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892037.1',
  'hypothetical protein',
  460218,
  461432,
  -1,
  'CPN_RS02105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883059.1',
  'HU family DNA-binding protein',
  461554,
  461856,
  -1,
  'CPN_RS02110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  462141,
  462214,
  1,
  'CPN_RS02115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883060.1',
  'N-acetylmuramoyl-L-alanine amidase familyprotein',
  462241,
  463035,
  -1,
  'CPN_RS02120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883061.1',
  'UDP-N-acetylmuramoyl-L-alanyl-D-glutamate--2,6-diaminopimelate ligase',
  462950,
  464401,
  -1,
  'CPN_RS02125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883062.1',
  'peptidoglycan D,D-transpeptidase FtsI familyprotein',
  464873,
  466834,
  -1,
  'CPN_RS02130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883063.1',
  'hypothetical protein',
  466821,
  467108,
  -1,
  'CPN_RS02135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rsmH',
  '16S rRNA (cytosine(1402)-N(4))-methyltransferaseRsmH',
  467105,
  467998,
  -1,
  'CPN_RS02140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883065.1',
  'DUF5399 family protein',
  468242,
  468787,
  1,
  'CPN_RS02145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883066.1',
  'hypothetical protein',
  468791,
  469219,
  1,
  'CPN_RS02150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dnaA',
  'chromosomal replication initiator protein DnaA',
  469612,
  470964,
  1,
  'CPN_RS02155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883068.1',
  'bactofilin family protein',
  470980,
  471567,
  1,
  'CPN_RS02160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883069.1',
  'hypothetical protein',
  471533,
  472111,
  -1,
  'CPN_RS02165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883070.1',
  'Na(+)-transporting NADH-quinone reductasesubunit B',
  472207,
  473718,
  1,
  'CPN_RS02170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883071.1',
  'Na(+)-translocating NADH-quinone reductasesubunit C',
  473722,
  474684,
  1,
  'CPN_RS02175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'nqrD',
  'NADH:ubiquinone reductase (Na(+)-transporting)subunit D',
  474681,
  475322,
  1,
  'CPN_RS02180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'nqrE',
  'NADH:ubiquinone reductase (Na(+)-transporting)subunit E',
  475326,
  476096,
  1,
  'CPN_RS02185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883074.1',
  'hypothetical protein',
  476148,
  476483,
  -1,
  'CPN_RS02190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883075.1',
  'hypothetical protein',
  476511,
  476816,
  -1,
  'CPN_RS02195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883076.1',
  'glycine cleavage protein H-like protein',
  476926,
  477273,
  -1,
  'CPN_RS02200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_042254016.1',
  'membrane protein',
  477273,
  479351,
  -1,
  'CPN_RS02205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883078.1',
  'phospholipase D-like domain-containing protein',
  479472,
  480902,
  -1,
  'CPN_RS02210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883079.1',
  'lipoate--protein ligase family protein',
  480899,
  481618,
  -1,
  'CPN_RS02215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883080.1',
  'ATP-dependent Clp protease ATP-binding subunit',
  481816,
  484353,
  1,
  'CPN_RS02220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'mnmA',
  'tRNA 2-thiouridine(34) synthase MnmA',
  484331,
  485440,
  -1,
  'CPN_RS02225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883082.1',
  'cell division protein ZapA',
  485553,
  486080,
  1,
  'CPN_RS02230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883083.1',
  'hypothetical protein',
  486105,
  486743,
  1,
  'CPN_RS02235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883084.1',
  'hypothetical protein',
  486891,
  487841,
  1,
  'CPN_RS02240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883085.1',
  'DUF5422 family protein',
  488013,
  488531,
  1,
  'CPN_RS02245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883086.1',
  'IncV family inclusion membrane protein',
  488729,
  489982,
  1,
  'CPN_RS02250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883087.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  490287,
  494510,
  1,
  'CPN_RS02255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126141.1',
  'hypothetical protein',
  494526,
  494690,
  -1,
  'CPN_RS02260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883088.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  494772,
  497582,
  1,
  'CPN_RS02265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883089.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  497626,
  500418,
  1,
  'CPN_RS02270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883090.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  500568,
  503354,
  1,
  'CPN_RS02275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126142.1',
  'uroporphyrinogendecarboxylase/cobalamine-independent methonine synthasefamily protein',
  503695,
  504804,
  -1,
  'CPN_RS02280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'polymorphic outer membrane protein middledomain-containing protein',
  505327,
  508112,
  -1,
  'CPN_RS02285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883092.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  508275,
  511061,
  1,
  'CPN_RS02290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883093.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  511319,
  512863,
  1,
  'CPN_RS02295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883094.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  513234,
  516155,
  1,
  'CPN_RS02300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883095.1',
  'autotransporter domain-containing protein',
  516182,
  519118,
  1,
  'CPN_RS02305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883096.1',
  'DUF562 domain-containing protein',
  519455,
  520348,
  -1,
  'CPN_RS05650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883097.1',
  'DUF575 domain-containing protein',
  520324,
  521532,
  -1,
  'CPN_RS05655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892020.1',
  'hypothetical protein',
  521833,
  521955,
  -1,
  'CPN_RS05685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883098.1',
  'DUF562 domain-containing protein',
  522117,
  523865,
  -1,
  'CPN_RS02315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989995.1',
  'DUF562 domain-containing protein',
  524233,
  526287,
  -1,
  'CPN_RS02320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989996.1',
  'hypothetical protein',
  526616,
  526957,
  -1,
  'CPN_RS02325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883101.1',
  'DUF562 domain-containing protein',
  526989,
  527840,
  -1,
  'CPN_RS02330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883102.1',
  'DUF575 domain-containing protein',
  527841,
  528638,
  -1,
  'CPN_RS02335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010882880.1',
  'DUF562 domain-containing protein',
  529034,
  531052,
  -1,
  'CPN_RS02340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883103.1',
  'DUF562 domain-containing protein',
  531188,
  532357,
  -1,
  'CPN_RS02345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989997.1',
  'hypothetical protein',
  532363,
  532782,
  -1,
  'CPN_RS02350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989998.1',
  'DUF575 domain-containing protein',
  532868,
  533179,
  -1,
  'CPN_RS02355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_155395535.1',
  'hypothetical protein',
  533323,
  533469,
  1,
  'CPN_RS02360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883106.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  533724,
  536540,
  1,
  'CPN_RS02365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892015.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  536579,
  539437,
  1,
  'CPN_RS02370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126154.1',
  'hypothetical protein',
  539683,
  540435,
  1,
  'CPN_RS02375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126155.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  540540,
  541463,
  1,
  'CPN_RS02380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989999.1',
  'autotransporter outer membrane beta-barreldomain-containing protein',
  541405,
  542535,
  1,
  'CPN_RS02385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883109.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  542564,
  545404,
  1,
  'CPN_RS02390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883110.1',
  'FlxA-like family protein',
  545578,
  547905,
  -1,
  'CPN_RS02395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883111.1',
  'CPn0473 family adhesin',
  548067,
  549593,
  -1,
  'CPN_RS02400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883112.1',
  'hypothetical protein',
  549804,
  551573,
  -1,
  'CPN_RS02405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'glgB',
  '1,4-alpha-glucan branching protein GlgB',
  551682,
  553844,
  -1,
  'CPN_RS02410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883114.1',
  'hypothetical protein',
  553855,
  554844,
  -1,
  'CPN_RS02415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'mtaB',
  'tRNA(N(6)-L-threonylcarbamoyladenosine(37)-C(2))-methylthiotransferase MtaB',
  554841,
  556106,
  -1,
  'CPN_RS02420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'hflX',
  'GTPase HflX',
  556207,
  557625,
  -1,
  'CPN_RS02425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883117.1',
  'MBL fold metallo-hydrolase',
  557613,
  558425,
  -1,
  'CPN_RS02430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883118.1',
  'hypothetical protein',
  558647,
  559303,
  -1,
  'CPN_RS02435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883119.1',
  'hypothetical protein',
  559336,
  560946,
  -1,
  'CPN_RS02440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883120.1',
  'transporter substrate-binding domain-containingprotein',
  560958,
  561737,
  -1,
  'CPN_RS02445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883121.1',
  'OTU domain-containing protein',
  561836,
  564967,
  1,
  'CPN_RS02450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'aroF',
  '3-deoxy-7-phosphoheptulonate synthase',
  564970,
  565827,
  1,
  'CPN_RS02455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883123.1',
  'hypothetical protein',
  566038,
  566232,
  1,
  'CPN_RS02460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892007.1',
  'sodium:solute symporter family protein',
  566402,
  567736,
  -1,
  'CPN_RS02465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883125.1',
  'HEAT repeat domain-containing protein',
  568109,
  569740,
  -1,
  'CPN_RS02470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883126.1',
  'histidine triad nucleotide-binding protein',
  569764,
  570096,
  -1,
  'CPN_RS02475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883127.1',
  'MYG1 family protein',
  570093,
  570965,
  -1,
  'CPN_RS02480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883128.1',
  'LOG family protein',
  571279,
  573336,
  1,
  'CPN_RS02485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892004.1',
  'DUF1207 domain-containing protein',
  573333,
  574565,
  -1,
  'CPN_RS02490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883132.1',
  'hypothetical protein',
  575143,
  575364,
  -1,
  'CPN_RS02495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883133.1',
  'LL-diaminopimelate aminotransferase',
  575603,
  576796,
  1,
  'CPN_RS02500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883134.1',
  'ABC transporter substrate-binding protein',
  576793,
  577815,
  1,
  'CPN_RS02505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883135.1',
  'DUF167 domain-containing protein',
  577817,
  578089,
  -1,
  'CPN_RS02510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883136.1',
  'hypothetical protein',
  578082,
  579035,
  -1,
  'CPN_RS02515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883137.1',
  'CT392 family protein',
  579202,
  580359,
  -1,
  'CPN_RS02520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883138.1',
  'proline--tRNA ligase',
  580659,
  582365,
  1,
  'CPN_RS02525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'hrcA',
  'heat-inducible transcriptional repressor HrcA',
  582457,
  583653,
  1,
  'CPN_RS02530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883140.1',
  'nucleotide exchange factor GrpE',
  583650,
  584204,
  1,
  'CPN_RS02535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dnaK',
  'molecular chaperone DnaK',
  584234,
  586216,
  1,
  'CPN_RS02540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_404987433.1',
  'ribonuclease R family protein',
  586490,
  588517,
  1,
  'CPN_RS02545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883143.1',
  'DNA-3-methyladenine glycosylase',
  588519,
  589109,
  1,
  'CPN_RS02550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883144.1',
  'DUF502 domain-containing protein',
  589172,
  589843,
  1,
  'CPN_RS02555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883145.1',
  'hypothetical protein',
  589961,
  590125,
  1,
  'CPN_RS05660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883146.1',
  'small basic protein',
  590142,
  590303,
  1,
  'CPN_RS02560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ybeY',
  'rRNA maturation RNase YbeY',
  590335,
  590811,
  1,
  'CPN_RS02565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883148.1',
  'transporter associated domain-containingprotein',
  590813,
  591976,
  1,
  'CPN_RS02570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883149.1',
  'anti-sigma factor antagonist',
  592141,
  592491,
  1,
  'CPN_RS02575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883150.1',
  'DUF3604 domain-containing protein',
  592553,
  594415,
  1,
  'CPN_RS02580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010891998.1',
  'hypothetical protein',
  594442,
  594675,
  1,
  'CPN_RS02585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883151.1',
  'CofH family radical SAM protein',
  594647,
  595756,
  1,
  'CPN_RS02590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883152.1',
  'menaquinone biosynthesis protein',
  595729,
  596523,
  1,
  'CPN_RS02595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ubiE',
  'bifunctional demethylmenaquinonemethyltransferase/2-methoxy-6-polyprenyl-1,4-benzoquinolmethylase UbiE',
  596492,
  597184,
  1,
  'CPN_RS02600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883154.1',
  'hypothetical protein',
  597252,
  598814,
  -1,
  'CPN_RS02605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883155.1',
  'hypothetical protein',
  598792,
  599631,
  -1,
  'CPN_RS02610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883156.1',
  'UPF0158 family protein',
  599829,
  600803,
  -1,
  'CPN_RS02615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dapF',
  'bifunctional diaminopimelate epimerase/glutamateracemase',
  600901,
  601674,
  -1,
  'CPN_RS02620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883158.1',
  'ATP-dependent Clp protease proteolytic subunit',
  601643,
  602218,
  -1,
  'CPN_RS02625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010891994.1',
  'glycine hydroxymethyltransferase',
  602238,
  603731,
  -1,
  'CPN_RS02630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883160.1',
  'uroporphyrinogen-III synthase',
  603987,
  604658,
  1,
  'CPN_RS02635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883161.1',
  'hypothetical protein',
  604723,
  605055,
  1,
  'CPN_RS02640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883162.1',
  'macro domain-containing protein',
  605103,
  606182,
  1,
  'CPN_RS02645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'cdsZ',
  'zinc ribbon domain regulatory protein CdsZ',
  606522,
  607286,
  1,
  'CPN_RS02650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rnpB',
  '—',
  607294,
  607693,
  1,
  'CPN_RS02655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883164.1',
  'KpsF/GutQ family sugar-phosphate isomerase',
  607707,
  608696,
  -1,
  'CPN_RS02660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_046879185.1',
  'dihydrolipoamide acetyltransferase familyprotein',
  608723,
  609901,
  -1,
  'CPN_RS02665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883166.1',
  'dicarboxylate/amino acid:cation symporter',
  609918,
  611162,
  -1,
  'CPN_RS02670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lpxK',
  'tetraacyldisaccharide 4''-kinase',
  611162,
  612259,
  -1,
  'CPN_RS02675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883168.1',
  'TrmH family RNA methyltransferase',
  612457,
  613254,
  -1,
  'CPN_RS02680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883169.1',
  'RsmD family RNA methyltransferase',
  613242,
  614069,
  -1,
  'CPN_RS02685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883170.1',
  'riboflavin synthase subunit alpha',
  614072,
  614674,
  -1,
  'CPN_RS02690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'nrdR',
  'transcriptional regulator NrdR',
  614930,
  615388,
  1,
  'CPN_RS02695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883172.1',
  'TraR/DksA family transcriptional regulator',
  615413,
  615787,
  1,
  'CPN_RS02700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lspA',
  'signal peptidase II',
  615793,
  616299,
  1,
  'CPN_RS02705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883174.1',
  'amino acid carrier protein',
  616345,
  617694,
  1,
  'CPN_RS02710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883175.1',
  'hypothetical protein',
  617833,
  618192,
  1,
  'CPN_RS02715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883176.1',
  'YtxH domain-containing protein',
  618212,
  618514,
  1,
  'CPN_RS02720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883177.1',
  'polymorphic outer membrane protein middledomain-containing protein',
  618705,
  621548,
  1,
  'CPN_RS02725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883178.1',
  'autotransporter domain-containing protein',
  621694,
  626865,
  1,
  'CPN_RS02730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  626901,
  626987,
  -1,
  'CPN_RS02735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883179.1',
  'metal ABC transporter solute-binding protein,Zn/Mn family',
  627170,
  628006,
  1,
  'CPN_RS02740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883180.1',
  'ABC transporter ATP-binding protein',
  628003,
  628740,
  1,
  'CPN_RS02745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883181.1',
  'metal ABC transporter permease',
  628725,
  629606,
  1,
  'CPN_RS02750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'cgtA',
  'Obg family GTPase CgtA',
  629522,
  630529,
  -1,
  'CPN_RS02755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpmA',
  '50S ribosomal protein L27',
  630630,
  630884,
  -1,
  'CPN_RS02760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplU',
  '50S ribosomal protein L21',
  630909,
  631229,
  -1,
  'CPN_RS02765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  631373,
  631445,
  -1,
  'CPN_RS02770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ispF',
  '2-C-methyl-D-erythritol 2,4-cyclodiphosphatesynthase',
  631661,
  632191,
  1,
  'CPN_RS02775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883186.1',
  'ferredoxin reductase domain-containing protein',
  632188,
  633231,
  -1,
  'CPN_RS02780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsJ',
  '30S ribosomal protein S10',
  633252,
  633569,
  -1,
  'CPN_RS02785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'fusA',
  'elongation factor G',
  633577,
  635661,
  -1,
  'CPN_RS02790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsG',
  '30S ribosomal protein S7',
  635695,
  636168,
  -1,
  'CPN_RS02795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsL',
  '30S ribosomal protein S12',
  636216,
  636587,
  -1,
  'CPN_RS02800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883191.1',
  'carbohydrate kinase family protein',
  636809,
  637747,
  -1,
  'CPN_RS02805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989976.1',
  'hypothetical protein',
  637875,
  638144,
  1,
  'CPN_RS02810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tsp',
  'tail-specific protease Tsp',
  638307,
  640244,
  1,
  'CPN_RS02815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883194.1',
  'sulfur-rich protein',
  640322,
  640912,
  -1,
  'CPN_RS02820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'omcB',
  'outer membrane complex protein OmcB',
  641191,
  642861,
  -1,
  'CPN_RS02825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883196.1',
  'small cysteine-rich outer membrane protein',
  643028,
  643300,
  -1,
  'CPN_RS02830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883197.1',
  'hypothetical protein',
  643742,
  643930,
  1,
  'CPN_RS02835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'gltX',
  'glutamate--tRNA ligase',
  644095,
  645612,
  -1,
  'CPN_RS02840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883199.1',
  'helix-turn-helix domain-containing protein',
  645868,
  646404,
  -1,
  'CPN_RS02845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883200.1',
  'CPn0927/CPn0928 family alpha/beta hydrolase foldprotein',
  646915,
  648036,
  -1,
  'CPN_RS02850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'recJ',
  'single-stranded-DNA-specific exonuclease RecJ',
  648290,
  650056,
  -1,
  'CPN_RS02855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883202.1',
  'protein translocase subunit SecDF',
  650142,
  654350,
  -1,
  'CPN_RS02860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883203.1',
  'phage holin family protein',
  654530,
  655630,
  -1,
  'CPN_RS02865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883204.1',
  'isoprenyl transferase',
  656141,
  656893,
  1,
  'CPN_RS02870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883205.1',
  'phosphatidate cytidylyltransferase',
  656894,
  657820,
  1,
  'CPN_RS02875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'cmk',
  '(d)CMP kinase',
  657817,
  658467,
  1,
  'CPN_RS02880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883207.1',
  'lysophospholipid acyltransferase family protein',
  658464,
  659102,
  1,
  'CPN_RS02885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'argS',
  'arginine--tRNA ligase',
  659107,
  660792,
  1,
  'CPN_RS02890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'murA',
  'UDP-N-acetylglucosamine1-carboxyvinyltransferase',
  660746,
  662122,
  -1,
  'CPN_RS02895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tarP',
  'type III secretion system actin-recruitingeffector Tarp',
  662352,
  664619,
  1,
  'CPN_RS02900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883211.1',
  'YebC/PmpR family DNA-binding transcriptionalregulator',
  664688,
  665404,
  -1,
  'CPN_RS02905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883212.1',
  'SprT-like domain-containing protein',
  665391,
  665945,
  -1,
  'CPN_RS02910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883213.1',
  'GNAT family N-acetyltransferase',
  665979,
  666494,
  -1,
  'CPN_RS02915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'prfB',
  'peptide chain release factor 2',
  666491,
  667598,
  -1,
  'CPN_RS02920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883215.1',
  'SWIB complex protein',
  667895,
  668158,
  1,
  'CPN_RS02925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lpxG',
  'UDP-2,3-diacylglucosamine diphosphatase LpxG',
  668406,
  669368,
  1,
  'CPN_RS02930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ispD',
  '2-C-methyl-D-erythritol 4-phosphatecytidylyltransferase',
  669361,
  669996,
  1,
  'CPN_RS02935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'truA',
  'tRNA pseudouridine(38-40) synthase TruA',
  669993,
  670796,
  1,
  'CPN_RS02940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883219.1',
  'HAD family hydrolase',
  670742,
  671434,
  -1,
  'CPN_RS02945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883220.1',
  'hypothetical protein',
  671503,
  672180,
  1,
  'CPN_RS02950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  672236,
  672318,
  1,
  'CPN_RS02955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883221.1',
  'hypothetical protein',
  672400,
  672720,
  1,
  'CPN_RS02960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883222.1',
  'two-component system sensor histidine kinaseNtrB',
  672707,
  673801,
  1,
  'CPN_RS02965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883223.1',
  'coiled-coil domain-containing protein',
  673862,
  675817,
  -1,
  'CPN_RS02970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883224.1',
  'sigma-54-dependent transcriptional regulator',
  676026,
  677186,
  1,
  'CPN_RS02975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  677264,
  677337,
  1,
  'CPN_RS02980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883225.1',
  'HPF/RaiA family ribosome-associated protein',
  677441,
  678127,
  1,
  'CPN_RS02985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883226.1',
  'type I restriction enzyme HsdR N-terminaldomain-containing protein',
  678084,
  678629,
  1,
  'CPN_RS02990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'recO',
  'DNA repair protein RecO',
  678640,
  679398,
  1,
  'CPN_RS02995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS02995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883228.1',
  'hypothetical protein',
  679513,
  680112,
  -1,
  'CPN_RS03000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  680178,
  680259,
  -1,
  'CPN_RS03005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'RMD1 family protein',
  680373,
  681163,
  1,
  'CPN_RS03010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'yidD',
  'membrane protein insertion efficiency factorYidD',
  681153,
  681464,
  1,
  'CPN_RS03015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883231.1',
  'LysM peptidoglycan-binding domain-containingprotein',
  681388,
  682476,
  -1,
  'CPN_RS03020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pheT',
  'phenylalanine--tRNA ligase subunit beta',
  682583,
  684961,
  1,
  'CPN_RS03025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883233.1',
  'toxin-antitoxin system YwqK family antitoxin',
  684958,
  685929,
  1,
  'CPN_RS03030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883234.1',
  'MGMT family protein',
  685939,
  686460,
  1,
  'CPN_RS03035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883235.1',
  'ABC transporter permease subunit',
  686476,
  688215,
  -1,
  'CPN_RS03040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883236.1',
  'ABC transporter permease',
  688216,
  689697,
  -1,
  'CPN_RS03045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226990003.1',
  'peptide-binding protein',
  689679,
  691787,
  -1,
  'CPN_RS03050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010891974.1',
  'hypothetical protein',
  692373,
  692570,
  -1,
  'CPN_RS03060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883239.1',
  'hypothetical protein',
  692733,
  693053,
  -1,
  'CPN_RS03065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883240.1',
  'tetratricopeptide repeat protein',
  693101,
  694105,
  -1,
  'CPN_RS03070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'hemH',
  'ferrochelatase',
  694205,
  695188,
  1,
  'CPN_RS03075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_404987434.1',
  'transporter substrate-binding domain-containingprotein',
  695193,
  695939,
  -1,
  'CPN_RS03080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rsmD',
  '16S rRNA (guanine(966)-N(2))-methyltransferaseRsmD',
  696147,
  696707,
  -1,
  'CPN_RS03085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883244.1',
  'metallophosphoesterase',
  696704,
  697444,
  -1,
  'CPN_RS03090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'glgC',
  'glucose-1-phosphate adenylyltransferase',
  697570,
  698895,
  -1,
  'CPN_RS03095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883246.1',
  'orotate phosphoribosyltransferase',
  699013,
  699645,
  -1,
  'CPN_RS03100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883247.1',
  'hypothetical protein',
  699705,
  699989,
  1,
  'CPN_RS03105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rho',
  'transcription termination factor Rho',
  700026,
  701420,
  -1,
  'CPN_RS03110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'coaE',
  'dephospho-CoA kinase',
  701417,
  702025,
  -1,
  'CPN_RS03115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'polA',
  'DNA polymerase I',
  702019,
  704631,
  -1,
  'CPN_RS03120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883251.1',
  'S49 family peptidase',
  704655,
  705656,
  -1,
  'CPN_RS03125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'npt2',
  'NTP/H+ exchange transporter Npt2',
  705780,
  707402,
  -1,
  'CPN_RS03130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883253.1',
  'CDP-alcohol phosphatidyltransferase familyprotein',
  707631,
  708137,
  -1,
  'CPN_RS03135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  708354,
  708441,
  -1,
  'CPN_RS03140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dnaB',
  'replicative DNA helicase',
  708734,
  710140,
  1,
  'CPN_RS03145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_072054076.1',
  'AURKAIP1/COX24 domain-containing protein',
  710381,
  710470,
  1,
  'CPN_RS05705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'mnmG',
  'tRNA uridine-5-carboxymethylaminomethyl(34)synthesis enzyme MnmG',
  710484,
  712319,
  1,
  'CPN_RS03155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883256.1',
  'lipoate--protein ligase family protein',
  712306,
  713013,
  1,
  'CPN_RS03160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ndk',
  'nucleoside-diphosphate kinase',
  713010,
  713444,
  -1,
  'CPN_RS03165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ruvA',
  'Holliday junction branch migration protein RuvA',
  713516,
  714139,
  -1,
  'CPN_RS03170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ruvC',
  'crossover junction endodeoxyribonuclease RuvC',
  714141,
  714647,
  -1,
  'CPN_RS03175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989977.1',
  'hypothetical protein',
  714790,
  715659,
  -1,
  'CPN_RS03180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  715889,
  715971,
  -1,
  'CPN_RS03185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'grgA',
  'GrgA family transcription factor',
  716160,
  716993,
  -1,
  'CPN_RS03190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'gap',
  'type I glyceraldehyde-3-phosphate dehydrogenase',
  717008,
  718015,
  -1,
  'CPN_RS03195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplQ',
  '50S ribosomal protein L17',
  718057,
  718485,
  -1,
  'CPN_RS03200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883264.1',
  'DNA-directed RNA polymerase subunit alpha',
  718492,
  719616,
  -1,
  'CPN_RS03205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsK',
  '30S ribosomal protein S11',
  719637,
  720038,
  -1,
  'CPN_RS03210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsM',
  '30S ribosomal protein S13',
  720060,
  720428,
  -1,
  'CPN_RS03215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'secY',
  'preprotein translocase subunit SecY',
  720484,
  721857,
  -1,
  'CPN_RS03220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplO',
  '50S ribosomal protein L15',
  721882,
  722316,
  -1,
  'CPN_RS03225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsE',
  '30S ribosomal protein S5',
  722309,
  722806,
  -1,
  'CPN_RS03230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplR',
  '50S ribosomal protein L18',
  722824,
  723195,
  -1,
  'CPN_RS03235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplF',
  '50S ribosomal protein L6',
  723206,
  723757,
  -1,
  'CPN_RS03240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsH',
  '30S ribosomal protein S8',
  723784,
  724185,
  -1,
  'CPN_RS03245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplE',
  '50S ribosomal protein L5',
  724203,
  724745,
  -1,
  'CPN_RS03250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplX',
  '50S ribosomal protein L24',
  724747,
  725082,
  -1,
  'CPN_RS03255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplN',
  '50S ribosomal protein L14',
  725096,
  725464,
  -1,
  'CPN_RS03260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsQ',
  '30S ribosomal protein S17',
  725487,
  725747,
  -1,
  'CPN_RS03265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpmC',
  '50S ribosomal protein L29',
  725740,
  725958,
  -1,
  'CPN_RS03270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplP',
  '50S ribosomal protein L16',
  725961,
  726377,
  -1,
  'CPN_RS03275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsC',
  '30S ribosomal protein S3',
  726406,
  727077,
  -1,
  'CPN_RS03280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplV',
  '50S ribosomal protein L22',
  727093,
  727428,
  -1,
  'CPN_RS03285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsS',
  '30S ribosomal protein S19',
  727447,
  727713,
  -1,
  'CPN_RS03290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplB',
  '50S ribosomal protein L2',
  727719,
  728573,
  -1,
  'CPN_RS03295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883283.1',
  '50S ribosomal protein L23',
  728595,
  728930,
  -1,
  'CPN_RS03300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplD',
  '50S ribosomal protein L4',
  728947,
  729621,
  -1,
  'CPN_RS03305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplC',
  '50S ribosomal protein L3',
  729654,
  730313,
  -1,
  'CPN_RS03310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883286.1',
  'CT529 family inclusion membrane protein',
  730602,
  731603,
  -1,
  'CPN_RS03315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'fmt',
  'methionyl-tRNA formyltransferase',
  731707,
  732672,
  -1,
  'CPN_RS03320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lpxA',
  'acyl-ACP--UDP-N-acetylglucosamineO-acyltransferase',
  732662,
  733501,
  -1,
  'CPN_RS03325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'fabZ',
  '3-hydroxyacyl-ACP dehydratase FabZ',
  733514,
  733975,
  -1,
  'CPN_RS03330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lpxC',
  'UDP-3-O-acyl-N-acetylglucosamine deacetylase',
  733987,
  734835,
  -1,
  'CPN_RS03335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lnt',
  'apolipoprotein N-acyltransferase',
  734865,
  736490,
  -1,
  'CPN_RS03340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883292.1',
  'acyl-CoA thioesterase',
  736500,
  736967,
  -1,
  'CPN_RS03345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883293.1',
  'putative quorum-sensing-regulated virulencefactor',
  737098,
  737847,
  -1,
  'CPN_RS03350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tsaE',
  'tRNA(adenosine(37)-N6)-threonylcarbamoyltransferase complexATPase subunit type 1 TsaE',
  738048,
  738473,
  -1,
  'CPN_RS03360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883296.1',
  'DUF2709 domain-containing protein',
  738452,
  739168,
  -1,
  'CPN_RS03365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  739403,
  739486,
  1,
  'CPN_RS03370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'trxA',
  'thioredoxin',
  739533,
  739841,
  1,
  'CPN_RS03375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883298.1',
  'tRNA (cytidine(34)-2''-O)-methyltransferase',
  739857,
  740327,
  -1,
  'CPN_RS03380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883299.1',
  'FKBP-type peptidyl-prolyl cis-trans isomerase',
  740324,
  741100,
  -1,
  'CPN_RS03385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'aspS',
  'aspartate--tRNA ligase',
  741169,
  742923,
  -1,
  'CPN_RS03390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'hisS',
  'histidine--tRNA ligase',
  742898,
  744190,
  -1,
  'CPN_RS03395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883302.1',
  'hypothetical protein',
  744554,
  744757,
  -1,
  'CPN_RS03400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pgtP',
  'MFS transporter',
  745001,
  746368,
  1,
  'CPN_RS03405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dnaE',
  'DNA polymerase III subunit alpha',
  746388,
  750110,
  1,
  'CPN_RS03410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883305.1',
  'hypothetical protein',
  750174,
  751058,
  -1,
  'CPN_RS03415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883306.1',
  'tetratricopeptide repeat protein',
  751209,
  752165,
  1,
  'CPN_RS03420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883307.1',
  'LPS assembly lipoprotein LptE',
  752179,
  752778,
  1,
  'CPN_RS03425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883308.1',
  'ATP-binding protein',
  752765,
  753199,
  1,
  'CPN_RS03430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883309.1',
  'hypothetical protein',
  753202,
  753630,
  -1,
  'CPN_RS03435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883310.1',
  'D-alanyl-D-alanine carboxypeptidase familyprotein',
  753741,
  755051,
  1,
  'CPN_RS03440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883311.1',
  'hypothetical protein',
  755287,
  755466,
  1,
  'CPN_RS03445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883312.1',
  'RsmB/NOP family class I SAM-dependent RNAmethyltransferase',
  755574,
  756668,
  -1,
  'CPN_RS03450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883313.1',
  'hypothetical protein',
  756765,
  757919,
  -1,
  'CPN_RS03455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883314.1',
  'TmeB family type III secretion system effector',
  758048,
  759217,
  -1,
  'CPN_RS03460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'semD',
  'SemD/SinC family type III secretion systemeffector',
  759253,
  760401,
  -1,
  'CPN_RS03465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883316.1',
  'hypothetical protein',
  760679,
  761320,
  -1,
  'CPN_RS03470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883317.1',
  'phosphoglycerate kinase',
  761722,
  762930,
  -1,
  'CPN_RS03475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883318.1',
  'inorganic phosphate transporter',
  762968,
  764248,
  -1,
  'CPN_RS03480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883319.1',
  'TIGR00153 family protein',
  764255,
  764929,
  -1,
  'CPN_RS03485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883320.1',
  'ABC transporter ATP-binding protein',
  764984,
  765958,
  1,
  'CPN_RS03490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883321.1',
  'oligopeptide/dipeptide ABC transporterATP-binding protein',
  765948,
  766922,
  1,
  'CPN_RS03495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_014517517.1',
  'hypothetical protein',
  767009,
  767197,
  1,
  'CPN_RS03500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883322.1',
  'ParB/RepB/Spo0J family partition protein',
  767178,
  768038,
  -1,
  'CPN_RS03505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883325.1',
  'hypothetical protein',
  768564,
  769217,
  1,
  'CPN_RS03515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_014517516.1',
  'hypothetical protein',
  769235,
  769375,
  1,
  'CPN_RS03520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883326.1',
  'polysaccharide deacetylase family protein',
  769382,
  770140,
  1,
  'CPN_RS03525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883327.1',
  'cysteine desulfurase',
  770184,
  771404,
  -1,
  'CPN_RS03530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sufD',
  'Fe-S cluster assembly protein SufD',
  771433,
  772680,
  -1,
  'CPN_RS03535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sufC',
  'Fe-S cluster assembly ATPase SufC',
  772682,
  773452,
  -1,
  'CPN_RS03540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sufB',
  'Fe-S cluster assembly protein SufB',
  773458,
  774912,
  -1,
  'CPN_RS03545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883331.1',
  'tetratricopeptide repeat protein',
  775237,
  776256,
  -1,
  'CPN_RS03550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883332.1',
  'PBP2-transglycosylase/transpeptidase',
  776327,
  779599,
  -1,
  'CPN_RS03555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883333.1',
  'porin',
  780216,
  781385,
  1,
  'CPN_RS03560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  781610,
  781680,
  1,
  'CPN_RS03565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsB',
  '30S ribosomal protein S2',
  781769,
  782602,
  1,
  'CPN_RS03570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tsf',
  'translation elongation factor Ts',
  782602,
  783450,
  1,
  'CPN_RS03575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pyrH',
  'UMP kinase',
  783458,
  784204,
  1,
  'CPN_RS03580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'frr',
  'ribosome recycling factor',
  784182,
  784724,
  1,
  'CPN_RS03585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  784822,
  784896,
  1,
  'CPN_RS03590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  784922,
  784994,
  1,
  'CPN_RS03595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883338.1',
  'UvrB/UvrC motif-containing protein',
  785097,
  785612,
  1,
  'CPN_RS03600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883339.1',
  'protein arginine kinase',
  785599,
  786675,
  1,
  'CPN_RS03605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  786708,
  786780,
  -1,
  'CPN_RS03610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883340.1',
  'secretin N-terminal domain-containing protein',
  786926,
  789685,
  -1,
  'CPN_RS03615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883341.1',
  'serine/threonine protein kinase',
  789682,
  791190,
  -1,
  'CPN_RS03620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sctQ',
  'type III secretion system cytoplasmic ringprotein SctQ',
  791206,
  792321,
  -1,
  'CPN_RS03625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883343.1',
  'DUF5421 family protein',
  792331,
  793173,
  -1,
  'CPN_RS03630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883344.1',
  'flagellar FliJ family protein',
  793177,
  793683,
  -1,
  'CPN_RS03635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sctN',
  'type III secretion system ATPase SctN',
  793701,
  795029,
  -1,
  'CPN_RS03640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883346.1',
  'CT668 family type III secretion system protein',
  795031,
  795705,
  -1,
  'CPN_RS03645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883347.1',
  'CdsG family type III secretion system protein',
  795739,
  796188,
  -1,
  'CPN_RS03650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883348.1',
  'DUF5407 family protein',
  796207,
  796461,
  -1,
  'CPN_RS03655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883349.1',
  'DUF5398 family protein',
  796483,
  796731,
  -1,
  'CPN_RS03660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sctD',
  'type III secretion system inner membrane ringsubunit SctD',
  796778,
  799315,
  -1,
  'CPN_RS03665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883351.1',
  'type III secretion system chaperone',
  799329,
  799721,
  -1,
  'CPN_RS03670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883352.1',
  'glutamyl-tRNA reductase',
  800088,
  801107,
  -1,
  'CPN_RS03675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883353.1',
  'DNA topoisomerase IV subunit B',
  801657,
  803465,
  1,
  'CPN_RS03680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883354.1',
  'DNA gyrase subunit A',
  803469,
  804905,
  1,
  'CPN_RS03685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883355.1',
  'CT656 family putative T3SS effector',
  805010,
  805309,
  1,
  'CPN_RS03690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_404987419.1',
  'hypothetical protein',
  805351,
  805629,
  1,
  'CPN_RS03695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883357.1',
  'RluA family pseudouridine synthase',
  805916,
  806893,
  1,
  'CPN_RS03700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883358.1',
  'KH domain-containing protein',
  807003,
  807239,
  1,
  'CPN_RS03705',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03705'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  807341,
  807413,
  -1,
  'CPN_RS03710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'kdsA',
  '3-deoxy-8-phosphooctulonate synthase',
  807683,
  808492,
  1,
  'CPN_RS03715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883360.1',
  'DUF1137 domain-containing protein',
  808489,
  808977,
  1,
  'CPN_RS03720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lptB',
  'LPS export ABC transporter ATP-binding protein',
  808984,
  809706,
  1,
  'CPN_RS03725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883362.1',
  'hypothetical protein',
  809703,
  810527,
  -1,
  'CPN_RS03730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989978.1',
  'hypothetical protein',
  810584,
  810766,
  -1,
  'CPN_RS03735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883364.1',
  'CT620/CT621 family type III secretion systemeffector',
  810877,
  813372,
  -1,
  'CPN_RS03740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883365.1',
  'CT620/CT621 family type III secretion systemeffector',
  813577,
  816195,
  1,
  'CPN_RS03745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883366.1',
  'hypothetical protein',
  816522,
  818477,
  -1,
  'CPN_RS03750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883367.1',
  'hypothetical protein',
  818589,
  819857,
  -1,
  'CPN_RS03755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883368.1',
  'lipid II flippase MurJ',
  819960,
  821603,
  -1,
  'CPN_RS03760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883370.1',
  'deoxyribonuclease IV',
  822098,
  822979,
  1,
  'CPN_RS03765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsD',
  '30S ribosomal protein S4',
  823098,
  823727,
  -1,
  'CPN_RS03770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'trhO',
  'oxygen-dependent tRNA uridine(34) hydroxylaseTrhO',
  823944,
  824918,
  1,
  'CPN_RS03775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'udk',
  'uridine kinase',
  825000,
  825668,
  -1,
  'CPN_RS03780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883374.1',
  'MFS transporter',
  825989,
  827686,
  -1,
  'CPN_RS03785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883375.1',
  'exodeoxyribonuclease V subunit gamma',
  827685,
  830759,
  1,
  'CPN_RS03790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'recB',
  'exodeoxyribonuclease V subunit beta',
  830746,
  833898,
  1,
  'CPN_RS03795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883377.1',
  'rod shape-determining protein MreC',
  833858,
  834871,
  -1,
  'CPN_RS03800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883378.1',
  'amino acid aminotransferase',
  834861,
  836048,
  -1,
  'CPN_RS03805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  836119,
  836191,
  1,
  'CPN_RS03810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'greA',
  'transcription elongation factor GreA',
  836182,
  838350,
  -1,
  'CPN_RS03815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883380.1',
  'hypothetical protein',
  838463,
  838891,
  1,
  'CPN_RS03820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883381.1',
  'Na(+)-translocating NADH-quinone reductasesubunit A',
  838962,
  840365,
  1,
  'CPN_RS03825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'hemB',
  'porphobilinogen synthase',
  840386,
  841384,
  -1,
  'CPN_RS03830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883384.1',
  'FAD-dependent thymidylate synthase',
  841975,
  843570,
  1,
  'CPN_RS03835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'hypothetical protein',
  843675,
  843913,
  1,
  'CPN_RS03840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  843926,
  843999,
  1,
  'CPN_RS03845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883385.1',
  'polyprenyl synthetase family protein',
  844118,
  844987,
  -1,
  'CPN_RS03850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883386.1',
  'LbetaH domain-containing protein',
  845003,
  845629,
  -1,
  'CPN_RS03855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883387.1',
  'winged helix-turn-helix transcriptionalregulator',
  845704,
  846411,
  -1,
  'CPN_RS03860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883388.1',
  'DUF1347 family protein',
  846608,
  848437,
  1,
  'CPN_RS03865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'recD',
  'exodeoxyribonuclease V subunit alpha',
  848604,
  850085,
  1,
  'CPN_RS03870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883390.1',
  'hypothetical protein',
  850158,
  851006,
  -1,
  'CPN_RS03875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsT',
  '30S ribosomal protein S20',
  851037,
  851336,
  -1,
  'CPN_RS03880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883392.1',
  'hypothetical protein',
  851597,
  852802,
  1,
  'CPN_RS03885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_404987420.1',
  'RNA polymerase sigma factor',
  852967,
  854679,
  1,
  'CPN_RS03890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'folB',
  'dihydroneopterin aldolase',
  854733,
  855137,
  1,
  'CPN_RS03895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'folP',
  'dihydropteroate synthase',
  855110,
  856462,
  1,
  'CPN_RS03900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883396.1',
  'dihydrofolate reductase',
  856488,
  857000,
  1,
  'CPN_RS03905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883397.1',
  'putative folate metabolism gamma-glutamateligase',
  856957,
  857697,
  1,
  'CPN_RS03910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883398.1',
  'CADD family putative folate metabolism protein',
  857704,
  858378,
  1,
  'CPN_RS03915',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03915'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'recA',
  'recombinase RecA',
  858536,
  859597,
  -1,
  'CPN_RS03920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883400.1',
  '5-formyltetrahydrofolate cyclo-ligase',
  859969,
  860511,
  -1,
  'CPN_RS03925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883401.1',
  'toxin-antitoxin system YwqK family antitoxin',
  860521,
  861807,
  -1,
  'CPN_RS03930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883402.1',
  'hypothetical protein',
  861798,
  862382,
  -1,
  'CPN_RS03935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883403.1',
  'hypothetical protein',
  862391,
  863782,
  -1,
  'CPN_RS03940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883404.1',
  'YggT family protein',
  863884,
  864180,
  1,
  'CPN_RS03945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dusB',
  'tRNA dihydrouridine synthase DusB',
  864159,
  865166,
  1,
  'CPN_RS03950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'topA',
  'type I DNA topoisomerase',
  865118,
  867733,
  -1,
  'CPN_RS03955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883407.1',
  'hypothetical protein',
  868340,
  869134,
  1,
  'CPN_RS03960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpoN',
  'RNA polymerase factor sigma-54',
  869141,
  870463,
  -1,
  'CPN_RS03965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883409.1',
  'ATP-dependent helicase',
  870466,
  872385,
  -1,
  'CPN_RS03970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ung',
  'uracil-DNA glycosylase',
  872488,
  873198,
  1,
  'CPN_RS03975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883411.1',
  'hypothetical protein',
  873195,
  873428,
  1,
  'CPN_RS03980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rdgB',
  'RdgB/HAM1 family non-canonical purine NTPpyrophosphatase',
  873411,
  874031,
  -1,
  'CPN_RS03985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883413.1',
  'DUF1343 domain-containing protein',
  874246,
  875490,
  1,
  'CPN_RS03990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'groEL',
  'molecular chaperone GroEL',
  875601,
  877181,
  1,
  'CPN_RS03995',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS03995'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  877400,
  877473,
  1,
  'CPN_RS04000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883415.1',
  'peroxiredoxin',
  877505,
  878095,
  1,
  'CPN_RS04005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883416.1',
  'hypothetical protein',
  878092,
  878481,
  -1,
  'CPN_RS04010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883417.1',
  'LysM peptidoglycan-binding domain-containingprotein',
  878588,
  879205,
  -1,
  'CPN_RS04015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883418.1',
  'OmpA family protein',
  879195,
  879773,
  -1,
  'CPN_RS04020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tolB',
  'Tol-Pal system protein TolB',
  879770,
  881065,
  -1,
  'CPN_RS04025',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04025'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883420.1',
  'inclusion-associated protein',
  881097,
  881885,
  -1,
  'CPN_RS05570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883421.1',
  'ExbD/TolR family protein',
  881889,
  882296,
  -1,
  'CPN_RS04040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883422.1',
  'MotA/TolQ/ExbB proton channel family protein',
  882293,
  882991,
  -1,
  'CPN_RS04045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892265.1',
  'protein-disulfide reductase DsbD family protein',
  883152,
  885296,
  1,
  'CPN_RS04050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883424.1',
  'TatD family hydrolase',
  885619,
  886404,
  1,
  'CPN_RS04055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883425.1',
  'succinate dehydrogenase cytochrome b558 subunit',
  886542,
  887435,
  1,
  'CPN_RS04060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sdhA',
  'succinate dehydrogenase flavoprotein subunit',
  887439,
  889319,
  1,
  'CPN_RS04065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sdhB',
  'succinate dehydrogenase iron-sulfur subunit',
  889333,
  890106,
  1,
  'CPN_RS04070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_042254108.1',
  'hypothetical protein',
  890108,
  892999,
  -1,
  'CPN_RS04075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883429.1',
  'hypothetical protein',
  893105,
  894919,
  -1,
  'CPN_RS04080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883430.1',
  'SpoIIE family protein phosphatase',
  894916,
  896823,
  -1,
  'CPN_RS04085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883431.1',
  'hypothetical protein',
  897174,
  898007,
  1,
  'CPN_RS04090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'hypothetical protein',
  898047,
  898142,
  1,
  'CPN_RS05690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_264370740.1',
  'autotransporter outer membrane beta-barreldomain-containing protein',
  898356,
  899198,
  1,
  'CPN_RS04095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989979.1',
  'autotransporter domain-containing protein',
  899397,
  901343,
  1,
  'CPN_RS04100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883434.1',
  'HAF repeat-containing protein',
  901600,
  902697,
  1,
  'CPN_RS04105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883435.1',
  'HAF repeat-containing protein',
  902846,
  903859,
  1,
  'CPN_RS04110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883436.1',
  'HAF repeat-containing protein',
  903937,
  904986,
  -1,
  'CPN_RS04115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'eno',
  'phosphopyruvate hydratase',
  905246,
  906532,
  -1,
  'CPN_RS04120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'uvrB',
  'excinuclease ABC subunit UvrB',
  906724,
  908697,
  -1,
  'CPN_RS04125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'trpS',
  'tryptophan--tRNA ligase',
  908706,
  909740,
  -1,
  'CPN_RS04130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883440.1',
  'CT584 family type III secretion system tipprotein',
  909749,
  910303,
  -1,
  'CPN_RS04135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883441.1',
  'pGP6-D family virulence protein',
  910307,
  911059,
  -1,
  'CPN_RS04140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883442.1',
  'ParA family protein',
  911064,
  911831,
  -1,
  'CPN_RS04145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'thrS',
  'threonine--tRNA ligase',
  911864,
  913771,
  -1,
  'CPN_RS04150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883444.1',
  'DMT family transporter',
  913971,
  914882,
  1,
  'CPN_RS04155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'copD',
  'type III secretion system translocon subunitCopD',
  914953,
  916287,
  -1,
  'CPN_RS04160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'copB',
  'type III secretion system translocon subunitCopB',
  916304,
  917785,
  -1,
  'CPN_RS04165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883447.1',
  'hypothetical protein',
  917822,
  918184,
  -1,
  'CPN_RS04170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883448.1',
  'SycD/LcrH family type III secretion systemchaperone',
  918205,
  918900,
  -1,
  'CPN_RS04175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'mutL',
  'DNA mismatch repair endonuclease MutL',
  919123,
  920865,
  1,
  'CPN_RS04180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883450.1',
  'M24 family metallopeptidase',
  920870,
  921937,
  1,
  'CPN_RS04185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883451.1',
  'hypothetical protein',
  922107,
  923360,
  1,
  'CPN_RS04190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883452.1',
  'secretin N-terminal domain-containing protein',
  923361,
  925625,
  1,
  'CPN_RS04195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883453.1',
  'GspE/PulE family protein',
  925615,
  927105,
  1,
  'CPN_RS04200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883454.1',
  'type II secretion system F family protein',
  927115,
  928290,
  1,
  'CPN_RS04205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883455.1',
  'type II secretion system protein',
  928314,
  928685,
  1,
  'CPN_RS04210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892256.1',
  'hypothetical protein',
  928701,
  929135,
  1,
  'CPN_RS04215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883457.1',
  'DUF1494 domain-containing protein',
  929120,
  929662,
  1,
  'CPN_RS04220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883458.1',
  'hypothetical protein',
  929667,
  930671,
  1,
  'CPN_RS04225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883459.1',
  'hypothetical protein',
  930756,
  931232,
  1,
  'CPN_RS04230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883460.1',
  'EscT/YscT/HrcT family type III secretion systemexport apparatus protein',
  931498,
  932367,
  -1,
  'CPN_RS04235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sctS',
  'type III secretion system export apparatussubunit SctS',
  932375,
  932662,
  -1,
  'CPN_RS04240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sctR',
  'type III secretion system export apparatussubunit SctR',
  932674,
  933423,
  -1,
  'CPN_RS04245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883463.1',
  'HrpE/YscL family type III secretion apparatusprotein',
  933609,
  934310,
  -1,
  'CPN_RS04250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883464.1',
  'hypothetical protein',
  934431,
  935264,
  -1,
  'CPN_RS04255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sctJ',
  'type III secretion system inner membrane ringlipoprotein SctJ',
  935264,
  936271,
  -1,
  'CPN_RS04260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989980.1',
  'hypothetical protein',
  936882,
  937301,
  1,
  'CPN_RS04265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989981.1',
  'hypothetical protein',
  937651,
  937962,
  1,
  'CPN_RS05665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883468.1',
  'hypothetical protein',
  938267,
  938437,
  1,
  'CPN_RS05560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lipA',
  'lipoyl synthase',
  938824,
  939747,
  -1,
  'CPN_RS04275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lpdA',
  'dihydrolipoyl dehydrogenase',
  939744,
  941129,
  -1,
  'CPN_RS04280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883471.1',
  'hypothetical protein',
  941553,
  942017,
  1,
  'CPN_RS04285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883472.1',
  'DEAD/DEAH box helicase',
  942042,
  945689,
  -1,
  'CPN_RS04290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'brnQ',
  'branched-chain amino acid transport system IIcarrier protein',
  945719,
  946957,
  -1,
  'CPN_RS04295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883474.1',
  'endonuclease III domain-containing protein',
  947142,
  947771,
  -1,
  'CPN_RS04300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'mnmE',
  'tRNA uridine-5-carboxymethylaminomethyl(34)synthesis GTPase MnmE',
  947778,
  949106,
  -1,
  'CPN_RS04305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883476.1',
  'phosphatidylserine decarboxylase',
  949257,
  950162,
  1,
  'CPN_RS04310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883477.1',
  'tetratricopeptide repeat protein',
  950222,
  951547,
  1,
  'CPN_RS04315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'secA',
  'preprotein translocase subunit SecA',
  951731,
  954643,
  1,
  'CPN_RS04320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892250.1',
  'hypothetical protein',
  954737,
  954922,
  1,
  'CPN_RS05670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892249.1',
  'hypothetical protein',
  954991,
  955191,
  -1,
  'CPN_RS05675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'der',
  'ribosome biogenesis GTPase Der',
  955267,
  956730,
  -1,
  'CPN_RS04330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883480.1',
  'CCA tRNA nucleotidyltransferase',
  956847,
  958079,
  -1,
  'CPN_RS04335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'clpX',
  'ATP-dependent Clp protease ATP-binding subunitClpX',
  958109,
  959374,
  -1,
  'CPN_RS04340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883482.1',
  'ATP-dependent Clp protease proteolytic subunit',
  959384,
  959995,
  -1,
  'CPN_RS04345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tig',
  'trigger factor',
  960174,
  961502,
  -1,
  'CPN_RS04350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  961536,
  961607,
  -1,
  'CPN_RS04355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883484.1',
  'DEAD/DEAH box helicase',
  961788,
  965288,
  1,
  'CPN_RS04360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883485.1',
  'rod shape-determining protein',
  965293,
  966393,
  1,
  'CPN_RS04365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883486.1',
  'phosphoenolpyruvate carboxykinase (GTP)',
  966396,
  968198,
  1,
  'CPN_RS04370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883487.1',
  'CT620/CT621 family type III secretion systemeffector',
  968316,
  970616,
  1,
  'CPN_RS04375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883488.1',
  'CT620/CT621 family type III secretion systemeffector',
  970637,
  971806,
  1,
  'CPN_RS04380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883489.1',
  'outer membrane protein B',
  971803,
  972837,
  -1,
  'CPN_RS04385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883490.1',
  'NAD(P)H-dependent glycerol-3-phosphatedehydrogenase',
  972991,
  973995,
  -1,
  'CPN_RS04390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883491.1',
  'UTP--glucose-1-phosphate uridylyltransferase',
  973992,
  975377,
  -1,
  'CPN_RS04395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883492.1',
  'hypothetical protein',
  975389,
  975757,
  -1,
  'CPN_RS04400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883493.1',
  'FliI/YscN family ATPase',
  975754,
  977055,
  -1,
  'CPN_RS04405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883494.1',
  'FliH/SctL family protein',
  977052,
  977588,
  -1,
  'CPN_RS04410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883495.1',
  'type III secretion system protein',
  977605,
  978630,
  -1,
  'CPN_RS04415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883496.1',
  'iron-sulfur cluster assembly scaffold protein',
  978922,
  979722,
  -1,
  'CPN_RS04420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883497.1',
  'aminotransferase class V-fold PLP-dependentenzyme',
  979719,
  980873,
  -1,
  'CPN_RS04425',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04425'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883498.1',
  '2,3-bisphosphoglycerate-dependentphosphoglycerate mutase',
  980828,
  981514,
  -1,
  'CPN_RS04430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883499.1',
  'pseudouridine synthase',
  981670,
  982377,
  1,
  'CPN_RS04435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883500.1',
  'hypothetical protein',
  982418,
  982945,
  1,
  'CPN_RS04440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883501.1',
  'biotin--[acetyl-CoA-carboxylase] ligase',
  982913,
  983491,
  -1,
  'CPN_RS04445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892245.1',
  'FtsW/RodA/SpoVE family cell cycle protein',
  983531,
  984670,
  1,
  'CPN_RS04450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883503.1',
  'cation-translocating P-type ATPase',
  984667,
  986643,
  -1,
  'CPN_RS04455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883504.1',
  'VIT1/CCC1 transporter family protein',
  986655,
  987401,
  -1,
  'CPN_RS04460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'serS',
  'serine--tRNA ligase',
  987445,
  988728,
  -1,
  'CPN_RS04465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ribD',
  'bifunctionaldiaminohydroxyphosphoribosylaminopyrimidinedeaminase/5-amino-6-(5-phosphoribosylamino)uracilreductase RibD',
  988772,
  989902,
  1,
  'CPN_RS04470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883507.1',
  'bifunctional3,4-dihydroxy-2-butanone-4-phosphate synthase/GTPcyclohydrolase II',
  989963,
  991219,
  1,
  'CPN_RS04475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ribH',
  '6,7-dimethyl-8-ribityllumazine synthase',
  991233,
  991697,
  1,
  'CPN_RS04480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226990004.1',
  'hypothetical protein',
  991746,
  993056,
  -1,
  'CPN_RS04485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883510.1',
  'lipoprotein',
  993372,
  994025,
  1,
  'CPN_RS04490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883511.1',
  'alanine/glycine:cation symporter family protein',
  994144,
  995520,
  1,
  'CPN_RS04495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883512.1',
  'YbhB/YbcL family Raf kinase inhibitor-likeprotein',
  995533,
  995985,
  1,
  'CPN_RS04500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883513.1',
  'SET domain-containing protein',
  995989,
  996654,
  -1,
  'CPN_RS04505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883514.1',
  'MBL fold metallo-hydrolase',
  996642,
  997439,
  -1,
  'CPN_RS04510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883515.1',
  'DNA translocase FtsK',
  997441,
  999861,
  -1,
  'CPN_RS04515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  999949,
  1000022,
  -1,
  'CPN_RS04520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  1000560,
  1002113,
  1,
  'CPN_RS04525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  1002342,
  1005277,
  1,
  'CPN_RS04530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rrf',
  '—',
  1005393,
  1005507,
  1,
  'CPN_RS04540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04540'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883516.1',
  'DUF687 family protein',
  1005667,
  1006212,
  1,
  'CPN_RS05695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_080502222.1',
  'DUF687 family protein',
  1006193,
  1007407,
  1,
  'CPN_RS04545',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04545'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'DUF687 family protein',
  1007434,
  1007553,
  1,
  'CPN_RS05700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'nqrF',
  'NADH:ubiquinone reductase (Na(+)-transporting)subunit F',
  1007570,
  1008865,
  -1,
  'CPN_RS04550',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04550'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'yajC',
  'preprotein translocase subunit YajC',
  1009006,
  1009359,
  -1,
  'CPN_RS04555',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04555'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rlmD',
  '23S rRNA (uracil(1939)-C(5))-methyltransferaseRlmD',
  1009430,
  1010635,
  -1,
  'CPN_RS04560',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04560'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883521.1',
  'histone H1-like protein HctA',
  1010905,
  1011276,
  -1,
  'CPN_RS04565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883522.1',
  'tetratricopeptide repeat protein',
  1011692,
  1014160,
  1,
  'CPN_RS04570',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04570'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883523.1',
  'protoporphyrinogen oxidase',
  1014116,
  1015423,
  -1,
  'CPN_RS04575',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04575'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'hemN',
  'oxygen-independent coproporphyrinogen IIIoxidase',
  1015459,
  1016835,
  -1,
  'CPN_RS04580',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04580'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'hemE',
  'uroporphyrinogen decarboxylase',
  1016816,
  1017805,
  -1,
  'CPN_RS04585',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04585'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'mfd',
  'transcription-repair coupling factor',
  1017816,
  1021067,
  -1,
  'CPN_RS04590',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04590'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'alaS',
  'alanine--tRNA ligase',
  1021043,
  1023661,
  -1,
  'CPN_RS04595',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04595'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tkt',
  'transketolase',
  1023894,
  1025891,
  1,
  'CPN_RS04600',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04600'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_042254191.1',
  'AMP nucleosidase',
  1025885,
  1026727,
  -1,
  'CPN_RS04605',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04605'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'efp',
  'elongation factor P',
  1026988,
  1027560,
  1,
  'CPN_RS04610',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04610'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892234.1',
  'hypothetical protein',
  1027604,
  1027825,
  1,
  'CPN_RS04615',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04615'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883532.1',
  'metallophosphoesterase',
  1027850,
  1028737,
  -1,
  'CPN_RS04620',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04620'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'groEL3',
  'variant chaperonin GroEL3',
  1028901,
  1030460,
  -1,
  'CPN_RS04625',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04625'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  1030533,
  1030603,
  -1,
  'CPN_RS04630',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04630'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883534.1',
  'UDP-N-acetylmuramoyl-tripeptide--D-alanyl-D-alanine ligase',
  1030875,
  1032218,
  1,
  'CPN_RS04635',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04635'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'mraY',
  'phospho-N-acetylmuramoyl-pentapeptide-transferase',
  1032253,
  1033284,
  1,
  'CPN_RS04640',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04640'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'murD',
  'UDP-N-acetylmuramoyl-L-alanine--D-glutamateligase',
  1033287,
  1034540,
  1,
  'CPN_RS04645',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04645'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883537.1',
  'LysM peptidoglycan-binding domain-containingprotein',
  1034543,
  1035244,
  1,
  'CPN_RS04650',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04650'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ftsW',
  'putative lipid II flippase FtsW',
  1035263,
  1036420,
  1,
  'CPN_RS04655',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04655'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'murG',
  'undecaprenyldiphospho-muramoylpentapeptidebeta-N-acetylglucosaminyltransferase',
  1036326,
  1037399,
  1,
  'CPN_RS04660',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04660'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883540.1',
  'bifunctional UDP-N-acetylmuramate--L-alanineligase/D-alanine--D-alanine ligase',
  1037409,
  1039838,
  1,
  'CPN_RS04665',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04665'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883541.1',
  'KH domain-containing protein',
  1039912,
  1040340,
  -1,
  'CPN_RS04670',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04670'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'cutA',
  'divalent-cation tolerance protein CutA',
  1040442,
  1040780,
  -1,
  'CPN_RS04675',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04675'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892231.1',
  'hypothetical protein',
  1040777,
  1041562,
  -1,
  'CPN_RS04680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883544.1',
  'STAS domain-containing protein',
  1041637,
  1041969,
  1,
  'CPN_RS04685',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04685'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'miaA',
  'tRNA (adenosine(37)-N6)-dimethylallyltransferaseMiaA',
  1041979,
  1043007,
  1,
  'CPN_RS04690',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04690'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'mqnC',
  'cyclic dehypoxanthinyl futalosine synthase',
  1042982,
  1044043,
  -1,
  'CPN_RS04695',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04695'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883547.1',
  'coiled-coil domain-containing protein',
  1044129,
  1045763,
  1,
  'CPN_RS04700',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04700'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883549.1',
  'HAD family hydrolase',
  1045999,
  1046400,
  1,
  'CPN_RS04710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rsfS',
  'ribosome silencing factor',
  1046461,
  1046820,
  1,
  'CPN_RS04715',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04715'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'fabF',
  'beta-ketoacyl-ACP synthase II',
  1046837,
  1048087,
  1,
  'CPN_RS04720',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04720'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883552.1',
  'bis(5''-nucleosyl)-tetraphosphatase',
  1048090,
  1048542,
  1,
  'CPN_RS04725',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04725'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883553.1',
  'inorganic pyrophosphatase',
  1048576,
  1049223,
  -1,
  'CPN_RS04730',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04730'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883554.1',
  'Glu/Leu/Phe/Val dehydrogenase family protein',
  1049378,
  1050433,
  1,
  'CPN_RS04735',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04735'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883555.1',
  'inositol monophosphatase family protein',
  1050428,
  1051405,
  -1,
  'CPN_RS04740',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04740'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883556.1',
  'lysophospholipid acyltransferase family protein',
  1051535,
  1052296,
  1,
  'CPN_RS04745',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04745'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883557.1',
  'AMP-binding protein',
  1052314,
  1053930,
  1,
  'CPN_RS04750',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04750'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883558.1',
  'aminotransferase class I/II-fold pyridoxalphosphate-dependent enzyme',
  1053984,
  1055096,
  1,
  'CPN_RS04755',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04755'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'priA',
  'primosomal protein N''',
  1055025,
  1057274,
  -1,
  'CPN_RS04760',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04760'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883560.1',
  'hypothetical protein',
  1057223,
  1057900,
  -1,
  'CPN_RS04765',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04765'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dsbH',
  'disulfide reductase DsbH',
  1058060,
  1058560,
  1,
  'CPN_RS04770',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04770'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883562.1',
  'CPn0927/CPn0928 family alpha/beta hydrolase foldprotein',
  1058667,
  1059809,
  -1,
  'CPN_RS04775',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04775'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892228.1',
  'CPn0927/CPn0928 family alpha/beta hydrolase foldprotein',
  1059881,
  1060981,
  -1,
  'CPN_RS04780',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04780'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883564.1',
  'CPn0927/CPn0928 family alpha/beta hydrolase foldprotein',
  1061183,
  1062292,
  -1,
  'CPN_RS04785',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04785'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883565.1',
  'hypothetical protein',
  1062857,
  1063333,
  1,
  'CPN_RS04790',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04790'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lysS',
  'lysine--tRNA ligase',
  1064138,
  1065721,
  1,
  'CPN_RS04795',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04795'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'cysS',
  'cysteine--tRNA ligase',
  1065718,
  1067142,
  -1,
  'CPN_RS04800',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04800'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883568.1',
  'thioredoxin family protein',
  1067535,
  1068581,
  1,
  'CPN_RS04805',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04805'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rnpA',
  'ribonuclease P protein component',
  1068523,
  1068942,
  -1,
  'CPN_RS04810',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04810'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpmH',
  '50S ribosomal protein L34',
  1068954,
  1069091,
  -1,
  'CPN_RS04815',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04815'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpmJ',
  '50S ribosomal protein L36',
  1069336,
  1069473,
  1,
  'CPN_RS04820',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04820'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsN',
  '30S ribosomal protein S14',
  1069496,
  1069801,
  1,
  'CPN_RS04825',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04825'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883573.1',
  'DUF4339 domain-containing protein',
  1069846,
  1070322,
  -1,
  'CPN_RS04830',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04830'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883574.1',
  'Asp23/Gls24 family envelope stress responseprotein',
  1070728,
  1071198,
  1,
  'CPN_RS04835',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04835'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'uvrC',
  'excinuclease ABC subunit UvrC',
  1071201,
  1073012,
  -1,
  'CPN_RS04840',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04840'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'mutS',
  'DNA mismatch repair protein MutS',
  1073015,
  1075501,
  -1,
  'CPN_RS04845',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04845'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dnaG',
  'DNA primase',
  1075985,
  1077757,
  1,
  'CPN_RS04850',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04850'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883578.1',
  'hypothetical protein',
  1077978,
  1078241,
  1,
  'CPN_RS04855',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04855'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883579.1',
  'CT795 family Sec-dependent secreted effector',
  1078512,
  1079000,
  1,
  'CPN_RS04860',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04860'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883580.1',
  'CT795 family Sec-dependent secreted effector',
  1079070,
  1079663,
  1,
  'CPN_RS04865',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04865'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_072054074.1',
  'glycine--tRNA ligase',
  1079742,
  1082774,
  -1,
  'CPN_RS04870',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04870'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pgsA',
  'CDP-diacylglycerol--glycerol-3-phosphate3-phosphatidyltransferase',
  1083442,
  1084062,
  1,
  'CPN_RS04875',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04875'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'glgA',
  'glycogen synthase GlgA',
  1084044,
  1085474,
  -1,
  'CPN_RS04880',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04880'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  1085605,
  1085676,
  1,
  'CPN_RS04885',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04885'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883584.1',
  '50S ribosomal protein L25',
  1085929,
  1086486,
  1,
  'CPN_RS04890',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04890'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pth',
  'aminoacyl-tRNA hydrolase',
  1086488,
  1087030,
  1,
  'CPN_RS04895',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04895'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsF',
  '30S ribosomal protein S6',
  1087122,
  1087460,
  1,
  'CPN_RS04900',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04900'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsR',
  '30S ribosomal protein S18',
  1087478,
  1087726,
  1,
  'CPN_RS04905',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04905'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplI',
  '50S ribosomal protein L9',
  1087742,
  1088251,
  1,
  'CPN_RS04910',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04910'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010895392.1',
  '4-(cytidine5''-diphospho)-2-C-methyl-D-erythritol kinase',
  1088286,
  1088711,
  1,
  'CPN_RS05680',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05680'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rbp7',
  'reticulate body protein Rbp-7',
  1089132,
  1089350,
  -1,
  'CPN_RS04920',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04920'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883589.1',
  'putative Na+/H+ antiporter',
  1089560,
  1090912,
  1,
  'CPN_RS04925',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04925'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883590.1',
  'insulinase family protein',
  1090960,
  1093788,
  -1,
  'CPN_RS04930',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04930'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883591.1',
  '1-acyl-sn-glycerol-3-phosphate acyltransferase',
  1093790,
  1094785,
  -1,
  'CPN_RS04935',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04935'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883592.1',
  'Rne/Rng family ribonuclease',
  1094796,
  1096343,
  -1,
  'CPN_RS04940',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04940'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_046879182.1',
  'YceD family protein',
  1096644,
  1097105,
  1,
  'CPN_RS04945',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04945'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpmF',
  '50S ribosomal protein L32',
  1097118,
  1097300,
  1,
  'CPN_RS04950',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04950'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'plsX',
  'phosphate acyltransferase PlsX',
  1097316,
  1098278,
  1,
  'CPN_RS04955',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04955'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883596.1',
  'autotransporter domain-containing protein',
  1098398,
  1103227,
  1,
  'CPN_RS04960',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04960'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126263.1',
  'DUF1539 domain-containing protein',
  1103298,
  1104752,
  -1,
  'CPN_RS04965',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04965'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'lpxB',
  'lipid-A-disaccharide synthase',
  1104922,
  1106736,
  -1,
  'CPN_RS04970',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04970'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pcnB',
  'polynucleotide adenylyltransferase PcnB',
  1106745,
  1108037,
  -1,
  'CPN_RS04975',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04975'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'glmM',
  'phosphoglucosamine mutase',
  1108512,
  1109888,
  1,
  'CPN_RS04980',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04980'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'glmS',
  'glutamine--fructose-6-phosphate transaminase(isomerizing)',
  1109895,
  1111724,
  1,
  'CPN_RS04985',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04985'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883602.1',
  'aromatic amino acid transport family protein',
  1111812,
  1113002,
  1,
  'CPN_RS04990',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS04990'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'hypothetical protein',
  1113275,
  1113373,
  1,
  'CPN_RS05710',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05710'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883602.1',
  'aromatic amino acid transport family protein',
  1113461,
  1114651,
  1,
  'CPN_RS05000',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05000'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883604.1',
  'Bax inhibitor-1/YccA family protein',
  1114702,
  1115418,
  1,
  'CPN_RS05005',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05005'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ftsY',
  'signal recognition particle-docking proteinFtsY',
  1115427,
  1116299,
  -1,
  'CPN_RS05010',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05010'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sucC',
  'ADP-forming succinate--CoA ligase subunit beta',
  1116370,
  1117530,
  1,
  'CPN_RS05015',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05015'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'sucD',
  'succinate--CoA ligase subunit alpha',
  1117544,
  1118425,
  1,
  'CPN_RS05020',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05020'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'DUF648 domain-containing protein',
  1118903,
  1119640,
  1,
  'CPN_RS05030',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05030'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_046879184.1',
  'DUF648 domain-containing protein',
  1120085,
  1121188,
  1,
  'CPN_RS05035',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05035'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892206.1',
  'DUF648 domain-containing protein',
  1121374,
  1122405,
  1,
  'CPN_RS05040',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05040'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883611.1',
  'DUF648 domain-containing protein',
  1122665,
  1123696,
  1,
  'CPN_RS05045',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05045'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'htrA',
  'serine protease HtrA',
  1123980,
  1125446,
  1,
  'CPN_RS05050',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05050'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_041466982.1',
  'M20/M25/M40 family metallo-hydrolase',
  1125501,
  1126871,
  -1,
  'CPN_RS05055',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05055'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883614.1',
  'insulinase family protein',
  1127031,
  1129955,
  1,
  'CPN_RS05060',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05060'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883615.1',
  'DNA recombination protein RmuC',
  1129959,
  1131194,
  -1,
  'CPN_RS05065',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05065'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883616.1',
  'CDP-alcohol phosphatidyltransferase familyprotein',
  1131203,
  1132000,
  -1,
  'CPN_RS05070',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05070'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883617.1',
  'ribonucleoside-diphosphate reductase subunitalpha',
  1132379,
  1135513,
  1,
  'CPN_RS05075',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05075'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_264370741.1',
  'ribonucleotide-diphosphate reductase subunitbeta',
  1135510,
  1136574,
  1,
  'CPN_RS05080',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05080'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883619.1',
  'tRNA (guanine(46)-N(7))-methyltransferase TrmB',
  1136724,
  1137398,
  1,
  'CPN_RS05085',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05085'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  1137389,
  1137462,
  -1,
  'CPN_RS05090',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05090'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883620.1',
  'tRNA5-(aminomethyl)-2-thiouridylate-methyltransferase MnmM',
  1137516,
  1138118,
  1,
  'CPN_RS05095',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05095'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'murB',
  'UDP-N-acetylmuramate dehydrogenase',
  1138072,
  1138986,
  -1,
  'CPN_RS05100',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05100'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'nusB',
  'transcription antitermination factor NusB',
  1139013,
  1139495,
  -1,
  'CPN_RS05105',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05105'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'infC',
  'translation initiation factor IF-3',
  1139883,
  1140443,
  1,
  'CPN_RS05110',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05110'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpmI',
  '50S ribosomal protein L35',
  1140421,
  1140615,
  1,
  'CPN_RS05115',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05115'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rplT',
  '50S ribosomal protein L20',
  1140634,
  1140999,
  1,
  'CPN_RS05120',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05120'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883626.1',
  'phenylalanine--tRNA ligase subunit alpha',
  1141014,
  1142033,
  1,
  'CPN_RS05125',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05125'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  1142034,
  1142118,
  1,
  'CPN_RS05130',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05130'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883627.1',
  'hypothetical protein',
  1142398,
  1144443,
  1,
  'CPN_RS05135',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05135'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883628.1',
  'LptF/LptG family permease',
  1144412,
  1145512,
  -1,
  'CPN_RS05140',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05140'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883629.1',
  'LptF/LptG family permease',
  1145516,
  1146589,
  -1,
  'CPN_RS05145',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05145'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tilS',
  'tRNA lysidine(34) synthetase TilS',
  1146708,
  1147667,
  1,
  'CPN_RS05150',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05150'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ftsH',
  'ATP-dependent zinc metalloprotease FtsH',
  1147855,
  1150587,
  1,
  'CPN_RS05155',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05155'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'pnp',
  'polyribonucleotide nucleotidyltransferase',
  1150763,
  1152847,
  -1,
  'CPN_RS05160',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05160'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rpsO',
  '30S ribosomal protein S15',
  1152888,
  1153157,
  -1,
  'CPN_RS05165',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05165'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_041466983.1',
  'nucleoside deaminase',
  1153399,
  1153872,
  1,
  'CPN_RS05170',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05170'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883635.1',
  'hypothetical protein',
  1153862,
  1154092,
  1,
  'CPN_RS05175',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05175'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883636.1',
  'hypothetical protein',
  1154089,
  1154796,
  -1,
  'CPN_RS05180',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05180'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883637.1',
  'CT847 family type III secretion system effector',
  1154876,
  1155397,
  -1,
  'CPN_RS05185',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05185'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883638.1',
  'DUF720 domain-containing protein',
  1155412,
  1155933,
  -1,
  'CPN_RS05190',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05190'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883639.1',
  'DUF720 domain-containing protein',
  1155987,
  1156472,
  -1,
  'CPN_RS05195',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05195'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892199.1',
  'hypothetical protein',
  1156725,
  1156910,
  1,
  'CPN_RS05200',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05200'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892198.1',
  'hypothetical protein',
  1156940,
  1158226,
  1,
  'CPN_RS05205',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05205'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883642.1',
  'methionyl aminopeptidase',
  1158183,
  1159058,
  -1,
  'CPN_RS05210',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05210'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883643.1',
  'MarC family protein',
  1159064,
  1159672,
  -1,
  'CPN_RS05215',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05215'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  'MarC family protein',
  1159681,
  1160285,
  -1,
  'CPN_RS05220',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05220'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883645.1',
  'ABC transporter substrate-binding protein',
  1160418,
  1162193,
  -1,
  'CPN_RS05225',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05225'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'fumC',
  'class II fumarate hydratase',
  1162245,
  1163627,
  1,
  'CPN_RS05230',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05230'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_165438711.1',
  'SLC26/SulP family anion transporter',
  1163729,
  1165429,
  -1,
  'CPN_RS05235',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05235'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883648.1',
  'NhaD family Na+:H+ antiporter',
  1165634,
  1166896,
  1,
  'CPN_RS05240',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05240'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883649.1',
  'protease-like activity factor CPAF',
  1167042,
  1168901,
  1,
  'CPN_RS05245',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05245'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ispH',
  '4-hydroxy-3-methylbut-2-enyl diphosphatereductase',
  1169006,
  1169938,
  1,
  'CPN_RS05250',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05250'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883651.1',
  'class I SAM-dependent methyltransferase',
  1169898,
  1170632,
  1,
  'CPN_RS05255',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05255'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883652.1',
  'type III secretion system translocon subunitCopD2',
  1170635,
  1172128,
  -1,
  'CPN_RS05260',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05260'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883653.1',
  'type III secretion system translocon subunitCopB2',
  1172147,
  1173679,
  -1,
  'CPN_RS05265',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05265'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883654.1',
  'SycD/LcrH family type III secretion systemchaperone',
  1173695,
  1174213,
  -1,
  'CPN_RS05270',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05270'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883655.1',
  'hypothetical protein',
  1174213,
  1175673,
  -1,
  'CPN_RS05275',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05275'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  1175863,
  1175944,
  1,
  'CPN_RS05280',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05280'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883656.1',
  'hypothetical protein',
  1176035,
  1176334,
  1,
  'CPN_RS05285',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05285'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883657.1',
  'site-specific tyrosine recombinase',
  1176331,
  1177236,
  -1,
  'CPN_RS05290',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05290'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883658.1',
  'glucose-6-phosphate isomerase',
  1177302,
  1178882,
  1,
  'CPN_RS05295',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05295'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'ltuA',
  'late transcription unit protein LtuA',
  1178997,
  1179140,
  1,
  'CPN_RS05300',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05300'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883660.1',
  'hypothetical protein',
  1179175,
  1180758,
  1,
  'CPN_RS05305',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05305'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883661.1',
  'malate dehydrogenase',
  1181016,
  1182002,
  1,
  'CPN_RS05310',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05310'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892189.1',
  'hypothetical protein',
  1182026,
  1182847,
  1,
  'CPN_RS05315',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05315'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883663.1',
  'NAD(P)/FAD-dependent oxidoreductase',
  1182840,
  1183886,
  -1,
  'CPN_RS05320',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05320'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'aaxC',
  'arginine/agmatine antiporter AaxC',
  1184095,
  1185552,
  -1,
  'CPN_RS05325',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05325'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'aaxB',
  'pyruvoyl-dependent arginine decarboxylase AaxB',
  1185563,
  1186150,
  -1,
  'CPN_RS05330',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05330'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'aaxA',
  'porin AaxA',
  1186184,
  1187500,
  -1,
  'CPN_RS05335',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05335'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883667.1',
  'DUF2608 domain-containing protein',
  1187729,
  1188517,
  -1,
  'CPN_RS05340',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05340'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883668.1',
  'bifunctional 3-dehydroquinatedehydratase/shikimate dehydrogenase',
  1188567,
  1190000,
  -1,
  'CPN_RS05345',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05345'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'aroB',
  '3-dehydroquinate synthase',
  1189981,
  1191135,
  -1,
  'CPN_RS05350',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05350'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'aroC',
  'chorismate synthase',
  1191120,
  1192199,
  -1,
  'CPN_RS05355',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05355'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883671.1',
  'shikimate kinase',
  1192196,
  1192726,
  -1,
  'CPN_RS05360',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05360'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'aroA',
  '3-phosphoshikimate 1-carboxyvinyltransferase',
  1192662,
  1193999,
  -1,
  'CPN_RS05365',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05365'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883673.1',
  'hypothetical protein',
  1194070,
  1194741,
  -1,
  'CPN_RS05370',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05370'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'bioA',
  'adenosylmethionine--8-amino-7-oxononanoatetransaminase',
  1194723,
  1195994,
  -1,
  'CPN_RS05375',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05375'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'bioD',
  'dethiobiotin synthase',
  1195931,
  1196590,
  -1,
  'CPN_RS05380',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05380'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883676.1',
  'aminotransferase class I/II-fold pyridoxalphosphate-dependent enzyme',
  1196569,
  1197717,
  -1,
  'CPN_RS05385',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05385'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'bioB',
  'biotin synthase BioB',
  1197696,
  1198691,
  -1,
  'CPN_RS05390',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05390'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883678.1',
  'queuosine precursor transporter',
  1198898,
  1199590,
  -1,
  'CPN_RS05395',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05395'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883679.1',
  'aromatic amino acid hydroxylase',
  1199587,
  1200675,
  -1,
  'CPN_RS05400',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05400'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dapB',
  '4-hydroxy-tetrahydrodipicolinate reductase',
  1200564,
  1201346,
  1,
  'CPN_RS05405',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05405'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'asd',
  'aspartate-semialdehyde dehydrogenase',
  1201606,
  1202607,
  1,
  'CPN_RS05410',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05410'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883682.1',
  'aspartate kinase',
  1202595,
  1203917,
  1,
  'CPN_RS05415',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05415'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'dapA',
  '4-hydroxy-tetrahydrodipicolinate synthase',
  1203926,
  1204801,
  1,
  'CPN_RS05420',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05420'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_226989983.1',
  'hypothetical protein',
  1205630,
  1206172,
  1,
  'CPN_RS05430',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05430'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883686.1',
  'hypothetical protein',
  1206153,
  1206704,
  1,
  'CPN_RS05435',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05435'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_041466974.1',
  'DUF1978 domain-containing protein',
  1207145,
  1209469,
  1,
  'CPN_RS05440',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05440'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883688.1',
  'IncA family protein',
  1209694,
  1210524,
  1,
  'CPN_RS05445',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05445'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883689.1',
  'hypothetical protein',
  1210527,
  1211231,
  1,
  'CPN_RS05450',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05450'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883690.1',
  'thioredoxin domain-containing protein',
  1211497,
  1213599,
  1,
  'CPN_RS05455',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05455'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883691.1',
  'hypothetical protein',
  1213748,
  1214839,
  1,
  'CPN_RS05460',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05460'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rsmA',
  '16S rRNA(adenine(1518)-N(6)/adenine(1519)-N(6))-dimethyltransferase RsmA',
  1214848,
  1215681,
  1,
  'CPN_RS05465',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05465'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883693.1',
  '1-deoxy-D-xylulose-5-phosphate synthase',
  1215724,
  1217658,
  -1,
  'CPN_RS05470',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05470'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883694.1',
  'hypothetical protein',
  1217663,
  1217920,
  -1,
  'CPN_RS05475',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05475'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010892181.1',
  'exodeoxyribonuclease VII small subunit',
  1217925,
  1218152,
  -1,
  'CPN_RS05480',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05480'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'xseA',
  'exodeoxyribonuclease VII large subunit',
  1218156,
  1219820,
  -1,
  'CPN_RS05485',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05485'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'tpiA',
  'triose-phosphate isomerase',
  1219951,
  1220715,
  1,
  'CPN_RS05490',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05490'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_011126293.1',
  'hypothetical protein',
  1220728,
  1220898,
  1,
  'CPN_RS05565',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05565'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'secG',
  'preprotein translocase subunit SecG',
  1221159,
  1221491,
  1,
  'CPN_RS05495',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05495'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'def',
  'peptide deformylase',
  1221735,
  1222295,
  1,
  'CPN_RS05500',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05500'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'rnhC',
  'ribonuclease HIII',
  1222362,
  1223258,
  -1,
  'CPN_RS05505',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05505'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883702.1',
  'helix-turn-helix domain-containing protein',
  1223513,
  1223944,
  1,
  'CPN_RS05510',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05510'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_123838458.1',
  'hypothetical protein',
  1223996,
  1224214,
  -1,
  'CPN_RS05515',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05515'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883703.1',
  'hypothetical protein',
  1224141,
  1225511,
  -1,
  'CPN_RS05520',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05520'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883704.1',
  'hypothetical protein',
  1225882,
  1227324,
  -1,
  'CPN_RS05525',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05525'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883705.1',
  'DUF2608 domain-containing protein',
  1227969,
  1228838,
  1,
  'CPN_RS05530',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05530'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  'WP_010883706.1',
  'DUF2608 domain-containing protein',
  1229011,
  1229835,
  1,
  'CPN_RS05535',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05535'
);

INSERT INTO core_gene (genome_id, name, description, start, end, strand, locus_tag, gene_type)
SELECT
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  '—',
  '—',
  1229942,
  1230028,
  -1,
  'CPN_RS05540',
  'CDS'
WHERE NOT EXISTS (
  SELECT 1 FROM core_gene
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1) AND locus_tag='CPN_RS05540'
);

INSERT INTO core_taxonomy (taxonomy_id, rank, name, parent_id)
SELECT
  '115713',
  'strain',
  'Chlamydia pneumoniae CWL029',
  NULL
WHERE NOT EXISTS (
  SELECT 1 FROM core_taxonomy WHERE taxonomy_id='115713'
);

UPDATE core_taxonomy
SET
  rank = COALESCE(NULLIF(rank,''), 'strain'),
  name = COALESCE(NULLIF(name,''), 'Chlamydia pneumoniae CWL029'),
  parent_id = COALESCE(parent_id, NULL)
WHERE taxonomy_id='115713';

UPDATE core_genome
SET taxonomy_id = (
  SELECT id FROM core_taxonomy WHERE taxonomy_id='115713' LIMIT 1
)
WHERE genome_accession='NC_000922.1';

INSERT INTO core_experimentaltechnique (name, description, preset_function, EO_term)
SELECT 'Cya fusion reporter', 'Cya fusion reporter', NULL, 'ECO:0006002'
WHERE NOT EXISTS (
  SELECT 1 FROM core_experimentaltechnique WHERE EO_term='ECO:0006002'
);

INSERT INTO core_siteinstance (_seq, genome_id, start, end, strand)
SELECT
  'AAAAATTTTTGG',
  (SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1),
  366682,
  366693,
  1
WHERE NOT EXISTS (
  SELECT 1 FROM core_siteinstance
  WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
    AND start=366682 AND end=366693 AND strand=1
    AND _seq='AAAAATTTTTGG'
);

INSERT INTO core_curation_siteinstance
  (curation_id, site_instance_id, annotated_seq, quantitative_value, site_type, TF_function, TF_type)
VALUES
  ((SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42146179' LIMIT 1) ORDER BY curation_id DESC LIMIT 1),
   (SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
          AND start=366682 AND end=366693 AND strand=1
          AND _seq='AAAAATTTTTGG'
        ORDER BY site_id DESC LIMIT 1),
   'AAAAATTTTTGG',
   0,
   'variable',
   'dual',
   'monomer');

INSERT INTO core_curation_siteinstance_experimental_techniques
  (curation_siteinstance_id, experimentaltechnique_id)
SELECT (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42146179' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
          AND start=366682 AND end=366693 AND strand=1
          AND _seq='AAAAATTTTTGG'
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
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42146179' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
          AND start=366682 AND end=366693 AND strand=1
          AND _seq='AAAAATTTTTGG'
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
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42146179' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
          AND start=366682 AND end=366693 AND strand=1
          AND _seq='AAAAATTTTTGG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='CPN_RS01650' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='CPN_RS01650' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42146179' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
          AND start=366682 AND end=366693 AND strand=1
          AND _seq='AAAAATTTTTGG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='CPN_RS01655' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='CPN_RS01655' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

INSERT INTO core_regulation (curation_site_instance_id, gene_id, evidence_type, meta_site_id)
SELECT
  (SELECT id FROM core_curation_siteinstance
        WHERE curation_id=(SELECT curation_id FROM core_curation WHERE publication_id=(SELECT publication_id FROM core_publication WHERE pmid='42146179' LIMIT 1) ORDER BY curation_id DESC LIMIT 1)
          AND site_instance_id=(SELECT site_id FROM core_siteinstance
        WHERE genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
          AND start=366682 AND end=366693 AND strand=1
          AND _seq='AAAAATTTTTGG'
        ORDER BY site_id DESC LIMIT 1)
        ORDER BY id DESC LIMIT 1),
  (SELECT gene_id FROM core_gene
            WHERE locus_tag='CPN_RS01660' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1),
  'exp_verified',
  NULL
WHERE (SELECT gene_id FROM core_gene
            WHERE locus_tag='CPN_RS01660' AND genome_id=(SELECT genome_id FROM core_genome WHERE genome_accession='NC_000922.1' LIMIT 1)
            ORDER BY gene_id DESC LIMIT 1) IS NOT NULL;

COMMIT;