export function expressionIdFromTfInstanceId(tfInstanceId) {
  const hex = tfInstanceId
    .toString(16)
    .toUpperCase()
    .padStart(8, "0");

  return `EXPREG_${hex}0`;
}