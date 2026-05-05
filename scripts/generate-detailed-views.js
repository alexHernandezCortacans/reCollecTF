import fs from "fs";
import path from "path";
import initSqlJs from "sql.js";

const publicDir = path.resolve("public");
const dbPath = path.resolve("public/CollecTF.db.gz");

function expressionIdFromTfInstanceId(tfInstanceId) {
  const hex = tfInstanceId.toString(16).padStart(8, "0");
  return `EXPREG_${hex}0`;
}

function runQuery(db, sql, params = []) {
  const stmt = db.prepare(sql);
  stmt.bind(params);
  const rows = [];
  while (stmt.step()) {
    rows.push(stmt.getAsObject());
  }
  stmt.free();
  return rows;
}

function getSearchResult(db, tfId) {
  const query = `
    SELECT
      TF.name AS TF_name,
      TFI.uniprot_accession,
      CUR.TF_species,
      CUR.curation_id,
      PUB.publication_type,
      PUB.pmid,
      CURSI.annotated_seq,
      CURSI.TF_type,
      CURSI.TF_function,
      REG.evidence_type,
      ET.name AS tech_name,
      ET.technique_id,
      ET.EO_term,
      SI.start,
      SI.end,
      SI.strand,
      GENOME.genome_accession,
      GENE.name AS gene_name,
      GENE.locus_tag
    FROM core_tf TF
    JOIN core_tfinstance TFI ON TF.TF_id = TFI.TF_id
    JOIN core_curation_TF_instances CURTF ON TFI.TF_instance_id = CURTF.tfinstance_id
    JOIN core_curation CUR ON CURTF.curation_id = CUR.curation_id
    JOIN core_publication PUB ON CUR.publication_id = PUB.publication_id
    JOIN core_curation_siteinstance CURSI ON CUR.curation_id = CURSI.curation_id
    JOIN core_curation_siteinstance_experimental_techniques CURSIET ON CURSI.id = CURSIET.curation_siteinstance_id
    JOIN core_experimentaltechnique ET ON CURSIET.experimentaltechnique_id = ET.technique_id
    JOIN core_siteinstance SI ON CURSI.site_instance_id = SI.site_id
    JOIN core_genome GENOME ON SI.genome_id = GENOME.genome_id
    JOIN core_gene GENE ON GENOME.genome_id = GENE.genome_id
    JOIN core_taxonomy TAX ON GENOME.taxonomy_id = TAX.id
    JOIN core_regulation REG ON CURSI.id = REG.curation_site_instance_id AND GENE.gene_id = REG.gene_id
    WHERE TFI.TF_instance_id = ?;
  `;
  return runQuery(db, query, [tfId]);
}

function getQuerySplitView(db, tfId) {
  const query = `
    SELECT
      ctf.name AS name,
      ctfi.uniprot_accession AS accession,
      cc.TF_species AS species
    FROM core_tfinstance ctfi
    LEFT JOIN core_curation_TF_instances ccti ON ccti.tfinstance_id = ctfi.TF_instance_id
    LEFT JOIN core_curation cc ON ccti.curation_id = cc.curation_id
    LEFT JOIN core_tf ctf ON ctfi.TF_id = ctf.TF_id
    WHERE ctfi.TF_instance_id = ?;
  `;
  return runQuery(db, query, [tfId]);
}

const regColors = {
  ACT: "#4CAF50",
  REP: "#F44336",
  DUAL: "#FFEB3B",
  "N/A": "#2196F3",
};

function buildTableRows(result) {
  if (!result || result.length === 0) return "";

  const TF_NAME = result[0].uniprot_accession;
  const tableMap = new Map();

  result.forEach((row) => {
    const rowKey = `${row.annotated_seq}-${row.curation_id}-${row.start}-${row.end}`;
    if (!tableMap.has(rowKey)) {
      tableMap.set(rowKey, {
        genome_accession: row.genome_accession,
        TF_type: row.TF_type,
        annotated_seq: row.annotated_seq,
        start: row.start,
        end: row.end,
        strand: row.strand,
        pmid: row.pmid,
        curation_id: row.curation_id,
        techniques: [],
        gene_regulation: [],
      });
    }
    const data = tableMap.get(rowKey);

    if (!data.techniques.some((t) => t.technique_id === row.technique_id)) {
      data.techniques.push({
        technique_id: row.technique_id,
        tech_name: row.tech_name,
        EO_term: row.EO_term,
      });
    }

    if (
      !data.gene_regulation.some(
        (g) => g.locus_tag === row.locus_tag && g.TF_function === row.TF_function
      )
    ) {
      data.gene_regulation.push({
        gene_name: row.gene_name,
        locus_tag: row.locus_tag,
        TF_function: row.TF_function,
        evidence_type: row.evidence_type,
      });
    }
  });

  let rows = "";
  for (const [, data] of tableMap.entries()) {
    const techniquesStr = data.techniques
      .map((t) => (t.EO_term ? `${t.tech_name} (${t.EO_term})` : t.tech_name))
      .join(", ");
    const geneRegStr = data.gene_regulation
      .map((g, index) => {
        if (!g.gene_name || !g.locus_tag) return "";
        const key = g.evidence_type === "exp_verified" ? g.TF_function : null;
        const color = regColors[key] || "#ffffff";
        const comma = index < data.gene_regulation.length - 1 ? ", " : "";
        return `<span><span style="color: ${color};">${g.gene_name} (${g.locus_tag})</span>${comma}</span>`;
      })
      .join("");
    const strandSymbol = data.strand === "-1" ? "- " : "+ ";
    const pmidLink = data.pmid
      ? `<a class="text-accent hover:underline" href="https://pubmed.ncbi.nlm.nih.gov/${data.pmid}" target="_blank" rel="noopener noreferrer">${data.pmid}</a>`
      : "";

    rows += `
      <tr>
        <td class="border p-2">
          <a class="text-accent hover:underline" href="https://www.ncbi.nlm.nih.gov/nuccore/${data.genome_accession}" target="_blank" rel="noopener noreferrer">${data.genome_accession}</a>
        </td>
        <td class="border p-2">
          <a class="text-accent hover:underline" href="http://uniprot.org/uniprot/${TF_NAME}" target="_blank" rel="noopener noreferrer">${TF_NAME}</a>
        </td>
        <td class="border p-2">${data.TF_type}</td>
        <td class="border p-2 break-words">${data.annotated_seq}</td>
        <td class="border p-2">${strandSymbol} [${data.start}, ${data.end}]</td>
        <td class="border p-2">${techniquesStr}</td>
        <td class="border p-2">${geneRegStr}</td>
        <td class="border p-2">${data.curation_id}</td>
        <td class="border p-2">${pmidLink}</td>
      </tr>`;
  }
  return rows;
}

function buildHTML(dataSV, result) {
  const tableRows = buildTableRows(result);

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>${dataSV[0].name} - CollecTF</title>

  <!-- Tailwind CDN -->
  <script src="https://cdn.tailwindcss.com"></script>

  <style>
    body {
      min-height: 100vh;
      background-color: rgb(30, 30, 30);
      font-family: Segoe UI, sans-serif;
      color: rgb(245, 245, 245);
    }

    .btn {
      cursor: pointer;
      border-radius: 8px;
      border: 1px solid #444;
      background-color: rgb(51, 65, 85);
      padding: 0.5rem 1rem;
      color: rgb(245, 245, 245);
      transition: 0.2s;
    }

    .btn:hover {
      background-color: rgb(30, 41, 59);
    }

    .text-accent {
      color: rgb(79, 195, 247);
    }

    .bg-surface {
      background-color: rgb(42, 42, 42);
    }

    .border-border {
      border-color: rgb(68, 68, 68);
    }
  </style>
</head>

<body>

  <!-- HEADER -->
  <header class="flex justify-between items-center bg-surface px-8 py-4 border-b border-border">
    <a href="https://erilllab.github.io/reCollecTF/" 
    class="text-5xl font-bold text-accent cursor-pointer hover:text-white no-underline">
    CollecTF
    </a>
  </header>

  <!-- MAIN -->
  <main class="max-w-screen-xl mx-auto px-4 mt-6">

    <div class="mb-6">
      <b class="text-lg">${dataSV[0].name}</b>

      <p class="mt-2 text-sm text-gray-300">
        <a class="text-accent hover:underline"
           href="https://www.uniprot.org/uniprotkb/${dataSV[0].accession}/entry">
          UniProtKB: ${dataSV[0].accession}
        </a>
        regulon and binding site collection of ${dataSV[0].species}
      </p>
    </div>

    <!-- TABLE -->
    <div class="overflow-x-auto">
      <table class="w-full text-sm table-fixed border-collapse">

        <thead>
          <tr class="bg-surface">
            <th class="border border-gray-700 p-2">Genome</th>
            <th class="border border-gray-700 p-2">TF</th>
            <th class="border border-gray-700 p-2">TF conformation</th>
            <th class="border border-gray-700 p-2">Site Sequence</th>
            <th class="border border-gray-700 p-2">Site Location</th>
            <th class="border border-gray-700 p-2">Experimental Techniques</th>
            <th class="border border-gray-700 p-2">Gene Regulation</th>
            <th class="border border-gray-700 p-2">Curation</th>
            <th class="border border-gray-700 p-2">PMID</th>
          </tr>
        </thead>

        <tbody>
          ${tableRows}
        </tbody>

      </table>
    </div>

  </main>

</body>
</html>`;
}

async function openDatabase() {
  const raw = fs.readFileSync(dbPath);
  const header = raw.slice(0, 15).toString("utf8");
  const dbBuffer = header.startsWith("SQLite format 3") ? raw : raw;
  const SQL = await initSqlJs({ locateFile: (file) => path.resolve("node_modules/sql.js/dist", file) });
  return new SQL.Database(new Uint8Array(dbBuffer));
}

function getAllTfInstanceIds(db) {
  const query = `SELECT DISTINCT TF_instance_id FROM core_tfinstance ORDER BY TF_instance_id`;
  return runQuery(db, query).map((row) => row.TF_instance_id);
}

async function generateReport(db, tfId) {
  const data = getSearchResult(db, tfId);
  const dataSV = getQuerySplitView(db, tfId);
  if (!dataSV || dataSV.length === 0) {
    console.warn(`Skipping TF_instance_id=${tfId} because no summary metadata was found.`);
    return null;
  }
  const html = buildHTML(dataSV, data);
  const expressionId = expressionIdFromTfInstanceId(tfId);
  const expressionDir = path.join(publicDir, expressionId);
  if (!fs.existsSync(expressionDir)) {
    fs.mkdirSync(expressionDir, { recursive: true });
  }
  const filePath = path.join(expressionDir, "index.html");
  fs.writeFileSync(filePath, html, "utf-8");
  return expressionId;
}

async function main() {
  const db = await openDatabase();
  const tfIds = getAllTfInstanceIds(db);
  const generatedFolders = [];
  for (const tfId of tfIds) {
    try {
      const expressionId = await generateReport(db, tfId);
      if (expressionId) generatedFolders.push(expressionId);
    } catch (error) {
      console.error(`Failed for TF_instance_id=${tfId}: ${error.message}`);
    }
  }
  console.log(`Finished: ${generatedFolders.length} expression folders created in ${publicDir}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});