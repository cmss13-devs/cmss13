/**
 * Adapted pinging library based on:
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
    this.timeout = this.opt.timeout || 10000;
    this.logError = this.opt.logError || false;
    this.abort = false;
  }

  /**
   * Pings source after a delay and triggers a callback when completed.
   * @param source Source of the website or server, including protocol and port.
   * @param callback Callback function to trigger when completed. Returns error and ping value.
   * @param delay Optional number of milliseconds to wait before starting.
   */
  ping(source, callback, delay = 1000) {
    this.abort = false;
    let timer;
    if (delay > 0) {
      timer = setTimeout(() => {
        if (this.abort) {
          return;
        }
        this.pingNow(source, callback);
      }, delay);
      return;
    }
    this.pingNow(source, callback);
  }

  /**
   * Pings source immediately and triggers a callback when completed.
   * @param source Source of the website or server, including protocol and port.
   * @param callback Callback function to trigger when completed. Returns error and ping value.
   */
  pingNow(source, callback) {
    let self = this;
    self.abort = false;
    self.wasSuccess = false;
    self.img = new Image();
    self.img.onload = (e) => {
      self.wasSuccess = true;
      pingCheck.call(self, e);
    };
    self.img.onerror = (e) => {
      self.wasSuccess = false;
      pingCheck.call(self, e);
    };

    let timer;
    let start = new Date();

    if (self.timeout) {
      timer = setTimeout(() => {
        self.wasSuccess = false;
        pingCheck.call(self, undefined);
      }, self.timeout);
    }

    /**
     * Times ping and triggers callback.
     */
    const pingCheck = function (e) {
      if (timer) {
        clearTimeout(timer);
      }
      if (this.abort) {
        return;
      }
      let pong = new Date() - start;

      if (typeof callback === 'function') {
        // When operating in timeout mode, the timeout callback doesn't pass [event] as e.
        // Notice [this] instead of [self], since .call() was used with context
        if (!this.wasSuccess) {
          if (self.logError) {
            console.error('error loading resource: ' + e.error);
          }
          return callback(e ? 'Error' : 'Timed Out', pong);
        }
        return callback(null, pong);
      } else {
        throw new Error('Callback is not a function.');
      }
    };

    self.img.src = source + self.favicon + '?' + new Date(); // Trigger image load with cache buster
  }

  /**
   * Aborts any pending ping request.
   */
  cancel() {
    this.abort = true;
  }
}
