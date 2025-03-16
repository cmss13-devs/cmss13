export type AudioState = {
  visible: boolean;
  playing: boolean;
  track: null | string;
  meta?: {
    title: string;
    link: string;
    duration: number;
    artist?: string;
    upload_date?: string;
    album?: string;
  };
};
