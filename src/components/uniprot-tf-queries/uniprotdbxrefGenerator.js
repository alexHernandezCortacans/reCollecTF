// generateUniprotDbxref.js
import fs from "fs";
import path from "path";
import { expressionIdFromTfInstanceId } from "../../utils/tfIdConverterToExpressionId.js";
import { getTFInstanceUniprot } from "../../db/queries/uniprotQueries.js";

export async function generateUniprotDbXRef(successfulIds = null) {
  const outputDir = path.resolve(process.cwd(), "public", "static");
  const outputPath = path.join(outputDir, "uniprot_dbxref.txt");
  if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });

  fs.writeFileSync(outputPath, "", "utf-8");

  const rows = await getTFInstanceUniprot();

  const lines = rows
    .map((row) => {
      const expressionId = expressionIdFromTfInstanceId(row.TF_instance_id);
      return { expressionId, uniprot_accession: row.uniprot_accession };
    })
    .filter(({ expressionId }) =>
      successfulIds === null || successfulIds.has(expressionId)
    )
    .map(({ uniprot_accession, expressionId }) =>
      `${uniprot_accession}\t${expressionId}`
    );

  fs.writeFileSync(outputPath, lines.join("\n") + "\n", "utf-8");
  console.log(`✅ Escrito ${lines.length} entradas en ${outputPath}`);
}