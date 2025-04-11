/**
 * Returns the arguments of a function F as an array.
 */
// prettier-ignore
export type ArgumentsOf<F extends Function>
  = F extends (...args: infer A) => unknown ? A : never;

type ByondStorage = {
  clear: () => void;
  fill: (data: object) => void;
  getItem: (item: string) => object;
  hasitem: (item: string) => boolean;
  removeItem: (item: string) => void;
  setItem: (item: string, value: any) => void;
  sync: () => void;
};

export type ByondWindow = Window &
  typeof globalThis & {
    hubStorage?: ByondStorage;
    serverStorage?: ByondStorage;
    domainStorage?: ByondStorage;
  };
