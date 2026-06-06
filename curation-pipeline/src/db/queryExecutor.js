//import { dbWorkerPromise } from "./dbClient";
import { dbWorkerPromise } from "../../../src/db/dbClient";

export async function runQuery(sql, params = []) {
  const worker = await dbWorkerPromise;
  return worker.db.query(sql, params);
}
