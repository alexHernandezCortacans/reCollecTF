import runQuery from "../queryExecutor";


export async function getQueryDataSummary(tf_instance) {

    const query = `
    SELECT 
        ctf.name as tf_name, ctfi.uniprot_accession as uniprot_accession, cc.curation_id as curation_id
    FROM core_tfinstance ctfi 
    LEFT JOIN core_curation_TF_instances ccti ON ccti.tfinstance_id = ctfi.TF_instance_id
    LEFT JOIN core_curation cc ON ccti.curation_id = cc.curation_id
    LEFT JOIN core_tf ctf ON ctfi.TF_id = ctf.TF_id
    LEFT JOIN core_curation_siteinstance ccsi ON ccsi.curation_id = cc.curation_id
    LEFT JOIN core_siteinstance csi ON csi.site_id = ccsi.site_instance_id 
    LEFT JOIN core_genome cg ON cg.genome_id = csi.genome_id
    WHERE ctfi.TF_instance_id = "${tf_instance}"
    `

    return runQuery(query)
}

export async function getQueryDataSummaryGenome(curation_id) {

    const query = `
    SELECT 
    cc.site_species,
    MIN(cg.genome_accession) as ncbi_accession
    FROM core_curation cc 
    LEFT JOIN core_curation_siteinstance ccsi ON ccsi.curation_id = cc.curation_id
    LEFT JOIN core_siteinstance csi ON csi.site_id = ccsi.site_instance_id 
    LEFT JOIN core_genome cg ON cg.genome_id = csi.genome_id
    WHERE cc.curation_id = ${curation_id}
    GROUP BY cc.site_species
    `

    return runQuery(query)
}

export async function getQuerySplitView(tf_instance) {

    const query = `
    SELECT 
        ctf.name as name, ctfi.uniprot_accession as accession, cc.TF_species as species
    FROM core_tfinstance ctfi 
    LEFT JOIN core_curation_TF_instances ccti ON ccti.tfinstance_id = ctfi.TF_instance_id
    LEFT JOIN core_curation cc ON ccti.curation_id = cc.curation_id
    LEFT JOIN core_tf ctf ON ctfi.TF_id = ctf.TF_id
    WHERE ctfi.TF_instance_id = "${tf_instance}"
    `

    return runQuery(query)
}

export async function getQuerySequence(tf_instance) {

    const query = `
    SELECT 
    ccs.site_instance_id,
    MIN(ccs.annotated_seq) AS sequence
    FROM core_tfinstance ct 
    LEFT JOIN core_curation_TF_instances ccti 
    ON ccti.tfinstance_id = ct.TF_instance_id 
    LEFT JOIN core_curation_siteinstance ccs  
    ON ccs.curation_id = ccti.curation_id 
    WHERE ct.TF_instance_id = "${tf_instance}"
    GROUP BY ccs.site_instance_id;
    `

    return runQuery(query)
}


    