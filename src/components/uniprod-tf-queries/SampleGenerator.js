// generateAllReports.js
import {generateDetailedViewHTML} from "./GenerateDetailedView.js"

const expressionIds = [
  "EXPREG_000016f0",
  // ... más IDs
];

export async function generator() {
  for (const id of expressionIds) {
    try {
      const html = await generateDetailedViewHTML(id);
      console.log(`${html}`);
    } catch (e) {
      console.error(`❌ ${id}: ${e.message}`);
    }
  }
}

generator().catch(console.error);