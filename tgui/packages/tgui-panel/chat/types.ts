export type message = {
  node?: HTMLElement | string;
  type: string;
  text?: string;
  html?: string;
  times?: number;
  createdAt: number;
  avoidHighlighting?: boolean;
};

export type Page = {
  isMain: boolean;
  id: string;
  name: string;
  acceptedTypes: Record<string, boolean>;
  unreadCount: number;
  hideUnreadCount: boolean;
  createdAt: number;
};
