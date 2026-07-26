export function replaceRegexChars(string_to_clean) {
  const SEARCH_REGEX = /[+)*([\\]/g;
  // '[', '\', '(', ')', '*', '+' can/will cause Regex .match to break and TGUI crashes
  return string_to_clean.replaceAll(SEARCH_REGEX, '');
}
