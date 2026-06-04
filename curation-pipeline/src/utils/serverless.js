// src/utils/serverless.js

const dispatchUrl = "https://recollectf.vercel.app/api/functions/send-form.ts";
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

// htmlContent - index.html content / tf_instance_id - TF_instance id from DB 
// uniprotAccession - uniprot code for that gene / expressionInfo - bool that defines if curation contains experimentally verified data
export async function createUniprodAccessionFile(htmlContent, tf_instance_id, uniprotAccession, expressionInfo) {
  const expressionId = expressionIdFromTfInstanceId(tf_instance_id); //+1 to generate the next tfId

  const res = await fetch("https://recollectf.vercel.app/api/functions/create-expression-page", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    credentials: "include",
    body: JSON.stringify({ expressionId, htmlContent,expressionInfo, uniprotAccession }),
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
