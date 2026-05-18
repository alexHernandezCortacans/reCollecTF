// generateUniprotDbxref.js
import fs from "fs";
import path from "path";
import initSqlJs from "sql.js";
import { expressionIdFromTfInstanceId } from "../../utils/tfIdConverterToExpressionId";
import { getTFInstanceUniprot } from "../../db/queries/uniprodQueries";

export async function generateUniprotDbXRef() {
    const outputPath = "../../../public/static/uniprot_dbxref.txt";
    const rows = await getTFInstanceUniprot();

    const lines = rows.map((row) => {
        const expressionId = expressionIdFromTfInstanceId(row.TF_instance_id);
        return `${row.uniprot_accession}\t${expressionId}`;
    });

    fs.writeFileSync(outputPath, lines.join("\n") + "\n", "utf-8");
    console.log(`✅ Escrito ${lines.length} entradas en ${outputPath}`);

    db.close();
}