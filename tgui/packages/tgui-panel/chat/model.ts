/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createUuid } from 'common/uuid';

import { MESSAGE_TYPE_INTERNAL, MESSAGE_TYPES } from './constants';
import type { message, Page } from './types';

export const canPageAcceptType = (page: Page, type: string): string | boolean =>
  type.startsWith(MESSAGE_TYPE_INTERNAL) || page.acceptedTypes[type];

export const createPage = (obj?: Object): Page => {
  let acceptedTypes = {};

  for (let typeDef of MESSAGE_TYPES) {
    acceptedTypes[typeDef.type] = !!typeDef.important;
  }

  return {
    isMain: false,
    id: createUuid(),
    name: 'New Tab',
    acceptedTypes: acceptedTypes,
    unreadCount: 0,
    hideUnreadCount: false,
    createdAt: Date.now(),
    ...obj,
  };
};

export const createMainPage = (): Page => {
  const acceptedTypes = {};
  for (let typeDef of MESSAGE_TYPES) {
    acceptedTypes[typeDef.type] = true;
  }
  return createPage({
    isMain: true,
    name: 'Main',
    acceptedTypes,
  });
};

export const createMessage = (payload: { type: string }): message => ({
  createdAt: Date.now(),
  ...payload,
});

export const serializeMessage = (
  message: message,
  archive = false,
): message => ({
  type: message.type,
  text: message.text,
  html: message.html,
  times: message.times,
  createdAt: message.createdAt,
});

export const isSameMessage = (a: message, b: message): boolean =>
  (typeof a.text === 'string' && a.text === b.text) ||
  (typeof a.html === 'string' && a.html === b.html);
