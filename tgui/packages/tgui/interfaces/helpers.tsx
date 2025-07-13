// '[', '\', '(', ')', '*', '+' can/will cause Regex .match to break and TGUI crashes
export const SEARCH_REGEX = /[+)*([\\]/;
