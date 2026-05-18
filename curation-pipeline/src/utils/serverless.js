// src/utils/serverless.js
// Canviar a original en acabar
//const dispatchUrl = "https://recollectf.vercel.app/api/functions/send-form.ts";
const dispatchUrl = "https://recollectf2.vercel.app/api/functions/send-form.ts";
import { getMaxTfInstanceId } from "../../../src/db/queries/uniprodQueries";
import { expressionIdFromTfInstanceId } from "../../../src/utils/tfIdConverterToExpressionId";

export async function dispatchWorkflow(data) {
  console.log("Data to dispatch:", data);

  const res = await fetch(dispatchUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    credentials: "include",
    body: JSON.stringify(data),
  });

  const text = await res.text();
  let payload;
  try {
    payload = text ? JSON.parse(text) : null;
  } catch {
    payload = text;
  }

  if (!res.ok) {
    const err = new Error(`Dispatch failed (${res.status})`);
    err.payload = payload;
    throw err;
  }

  return payload;
}

export async function createUniprodAccessionFile(htmlContent, tf_instance_id, uniprodAccession) {
  const expressionId = expressionIdFromTfInstanceId(tf_instance_id); //+1 to generate the next tfId

  const res = await fetch("https://recollectf2.vercel.app/api/functions/create-expression-page", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    credentials: "include",
    body: JSON.stringify({ expressionId, htmlContent, uniprotAccession }),
  });

  const text = await res.text();
  let payload;
  try {
    payload = text ? JSON.parse(text) : null;
  } catch {
    payload = text;
  }

  if (!res.ok) {
    const err = new Error(`Create expression page failed (${res.status})`);
    err.payload = payload;
    throw err;
  }

  return payload;
}
