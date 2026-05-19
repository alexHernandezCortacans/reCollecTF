// generateUniprotDbxref.js
import fs from "fs";
import path from "path";
import { expressionIdFromTfInstanceId } from "../../utils/tfIdConverterToExpressionId.js";
import { getTFInstanceUniprot } from "../../db/queries/uniprodQueries.js";

export async function generateUniprotDbXRef() {
    const outputDir = path.resolve(process.cwd(), "public", "static");
    const outputPath = path.join(outputDir, "uniprot_dbxref.txt");
    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });
    const rows = await getTFInstanceUniprot();

    const lines = rows.map((row) => {
        const expressionId = expressionIdFromTfInstanceId(row.TF_instance_id);
        return `${row.uniprot_accession}\t${expressionId}`;
    });

    fs.writeFileSync(outputPath, lines.join("\n") + "\n", "utf-8");
    console.log(`✅ Escrito ${lines.length} entradas en ${outputPath}`);
}