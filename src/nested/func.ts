export function squer(str: string): string {
  return str
    .split("")
    .map((l, i) => (i % 2 === 0 ? l : l.toUpperCase()))
    .join("");
}
