import { useEffect, useRef } from 'react';

import { type BoxProps, computeBoxProps } from './Box';

type Props = Partial<{
  /** True is default, this fixes DM icon rendering issues */
  fixBlur: boolean;
  /**
   * False by default. Good if you're fetching images on UIs that do not auto
   * update. This will attempt to fix the 'x' icon 5 times.
   */
  fixErrors: boolean;
  /** Fill is default. */
  objectFit: 'contain' | 'cover';
  /**
   * The image source.
   *
   * Use transparent base64 pixel if there is no src so we don't get a broken
   * image icon when using assets.
   */
  src: string;
}> &
  BoxProps;

const maxAttempts = 5;

const transparentImg =
  'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=';

/**
 * ## Image
 *
 * A wrapper for the `<img>` element.
 *
 * It can attempt to fix broken images by fetching them again with `fixErrors`.
 *
 * It will also try to fix blurry images by rendering them pixelated.
 */
export function Image(props: Props) {
  const {
    fixBlur = true,
    fixErrors,
    objectFit = 'fill',
    src = transparentImg,
    ...rest
  } = props;
  const attempts = useRef(0);
  const timer = useRef<NodeJS.Timeout>();

  const computedProps = computeBoxProps(rest);
  computedProps.style = {
    ...computedProps.style,
    imageRendering: fixBlur ? 'pixelated' : 'auto',
    objectFit,
  };

  function handleError(event: React.SyntheticEvent<HTMLImageElement>): void {
    if (!fixErrors || attempts.current >= maxAttempts) {
      if (timer.current) clearTimeout(timer.current);
      return;
    }

    const imgElement = event.currentTarget;

    timer.current = setTimeout(() => {
      imgElement.src = `${src}?attempt=${attempts.current}`;
      attempts.current++;
    }, 1000);
  }

  /** Cleans up any stray timers */
  useEffect(() => {
    return () => {
      if (timer.current) clearTimeout(timer.current);
    };
  }, []);

  return (
    <img alt="dm icon" onError={handleError} src={src} {...computedProps} />
  );
}
