/**
 * @file https://www.jsdelivr.com/package/npm/ping.js
 * @copyright 2021 Alfred Gutierrez
 * @license MIT
 */

/**
 * Creates a Ping instance.
 * @returns {Ping}
 * @constructor
 */
export class Ping {
  constructor(opt) {
    this.opt = opt || {};
    this.favicon = this.opt.favicon || '/favicon.ico';
    this.timeout = this.opt.timeout || 5000;
    this.logError = this.opt.logError || false;
  }
  /**
   * Pings source and triggers a callback when completed.
   * @param source Source of the website or server, including protocol and port.
   * @param callback Callback function to trigger when completed. Returns error and ping value.
   * @param timeout Optional number of milliseconds to wait before aborting.
   */
  ping(source, callback) {
    let self = this;
    self.wasSuccess = false;
    self.img = new Image();
    self.img.onload = onload;
    self.img.onerror = onerror;

    let timer;
    let start = new Date();

    const onload = function (e) {
      self.wasSuccess = true;
      pingCheck.call(self, e);
    };

    const onerror = function (e) {
      self.wasSuccess = false;
      pingCheck.call(self, e);
    };

    if (self.timeout) {
      timer = setTimeout(() => {
        pingCheck.call(self, undefined);
      }, self.timeout);
    }

    /**
     * Times ping and triggers callback.
     */
    const pingCheck = function () {
      if (timer) {
        clearTimeout(timer);
      }
      let pong = new Date() - start;

      if (typeof callback === 'function') {
        // When operating in timeout mode, the timeout callback doesn't pass [event] as e.
        // Notice [this] instead of [self], since .call() was used with context
        if (!this.wasSuccess) {
          if (self.logError) {
            console.error('error loading resource');
          }
          return callback('error', pong);
        }
        return callback(null, pong);
      } else {
        throw new Error('Callback is not a function.');
      }
    };

    self.img.src = source + self.favicon + '?' + +new Date(); // Trigger image load with cache buster
  }
}
