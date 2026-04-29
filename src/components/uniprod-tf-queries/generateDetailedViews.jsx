import path from "path";
import { Writable } from "stream";
import { fileURLToPath } from "url";
import React from "react";
import { renderToPipeableStream } from "react-dom/server";

const fs = require('fs');

// ─── Mock de react-router-dom ─────────────────────────────────────────────────
import { createRequire } from "module";
const require = createRequire(import.meta.url);

require.cache[require.resolve("react-router-dom")] = {
  id: "react-router-dom",
  filename: "react-router-dom",
  loaded: true,
  exports: {
    useNavigate: () => () => {},
    Link: ({ to, className, children }) =>
      React.createElement("a", { href: to, className }, children),
  },
};

// ─── Importa tus componentes y queries reales ─────────────────────────────────
// ✏️  Ajusta estas rutas a la estructura de tu proyecto.
import DetailedView from "./detail/DetailedView.jsx";
import { getSearchResult } from "../../db/queries/search.js";
import { getQuerySplitView } from "./db/queries/uniprodQueries.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// ─── IDs a generar ─────────────────────────────────────────────────────────────
// ✏️  Edita este array con los expressionIds que necesites.
const EXPRESSION_IDS = [
  "EXPREG_000014f0",
  "EXPREG_000015f0",
  "EXPREG_000016f0",
];

// ─── Shell HTML ────────────────────────────────────────────────────────────────
function wrapInPage(bodyHtml, expressionId) {
  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>CollecTFs — ${expressionId}</title>
</head>
  ${bodyHtml}
</html>`;
}

// ─── Renderiza el componente al completo y devuelve el HTML como string ────────
function renderToString(element) {
  return new Promise((resolve, reject) => {
    let html = "";

    const writable = new Writable({
      write(chunk, _encoding, callback) {
        html += chunk.toString();
        callback();
      },
    });

    const { pipe } = renderToPipeableStream(element, {
      onAllReady() {
        // Todo el HTML está listo, incluido el contenido dentro de Suspense
        pipe(writable);
      },
      onError(error) {
        reject(error);
      },
    });

    writable.on("finish", () => resolve(html));
    writable.on("error", reject);
  });
}

// ─── Función principal ─────────────────────────────────────────────────────────
export async function generateDetailedViews() {
  fs.mkdirSync(outputDir, { recursive: true });

  for (const expressionId of EXPRESSION_IDS) {
    if (!/^EXPREG_[a-f0-9A-F]+$/.test(expressionId)) {
      console.warn(`⚠️  ID inválido, omitido: ${expressionId}`);
      continue;
    }

    const tf_id_raw    = expressionId.replace("EXPREG_", "");
    const tf_id_parsed = parseInt(tf_id_raw.slice(2, -1), 16);

    let data, dataSV;
    try {
      [data, dataSV] = await Promise.all([
        getSearchResult(tf_id_parsed),
        getQuerySplitView(tf_id_parsed),
      ]);
    } catch (e) {
      console.error(`❌  Error obteniendo datos para ${expressionId}:`, e.message);
      continue;
    }

    // Inyectamos los datos mockeando useState para que el componente
    // los reciba como si el fetch ya hubiera terminado.
    // El componente declara useState en este orden:
    // 1. data → null   2. dataSV → null   3. error → null   4. loading → true
    let callCount = 0;
    React.useState = (initial) => {
      callCount++;
      if (callCount === 1) return [data,   () => {}]; // data
      if (callCount === 2) return [dataSV, () => {}]; // dataSV
      if (callCount === 3) return [null,   () => {}]; // error
      if (callCount === 4) return [false,  () => {}]; // loading = false
      return [initial, () => {}];
    };

    React.useEffect = () => {};

    const element  = React.createElement(DetailedView, { expressionId });
    const bodyHtml = await renderToString(element);
    const fullHtml = wrapInPage(bodyHtml, expressionId);

    const filePath = path.join('..\..\..\public\static\' , `${expressionId}.html`);
    fs.writeFileSync(filePath, fullHtml, "utf-8");
    console.log(`✅  ${filePath}`);

    callCount = 0;
  }

  console.log("\n✔ Generación completada. Archivos en ./output/");
}