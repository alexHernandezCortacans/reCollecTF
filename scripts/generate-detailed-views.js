import fs from "fs";
import path from "path";
import { generateDetailedViewHTML } from "../src/components/uniprod-tf-queries/GenerateDetailedView.js";
import { getAllTfInstanceIds } from "../src/db/queries/uniprodQueries.js";
import { generateUniprotDbXRef } from "../src/components/uniprod-tf-queries/uniprodbxrefGenerator.js";

const publicDir = path.resolve("public");

function expressionIdFromTfInstanceId(tfInstanceId) {
  const hex = tfInstanceId
    .toString(16)
    .toUpperCase()
    .padStart(8, "0");

  return `EXPREG_${hex}0`;
}

async function main() {
  const tfIds = await getAllTfInstanceIds();
  let count = 0;

  for (const tfId of tfIds) {
    const expressionId = expressionIdFromTfInstanceId(tfId);
    try {
      const html = await generateDetailedViewHTML(expressionId);
      const expressionDir = path.join(publicDir, expressionId);
      if (!fs.existsSync(expressionDir)) fs.mkdirSync(expressionDir, { recursive: true });
      fs.writeFileSync(path.join(expressionDir, "index.html"), html, "utf-8");
      count++;
      console.log(`✅ ${expressionId}`);
    } catch (error) {
      console.log(`⚠️  ${expressionId}: ${error.message}`);
    }
  }

  try {
    await generateUniprotDbXRef();
  } catch(error) {
    console.log("Fallada generación de página de referencia Uniprod")
  }

  console.log(`\n ${count} páginas generadas en ${publicDir}`);
}

main().catch((error) => { console.error(error); process.exit(1); });