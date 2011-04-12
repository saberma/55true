var Backbone, models, server, _;
server = false;
if (typeof exports != "undefined" && exports !== null) {
  Backbone = require('backbone');
  _ = require('underscore')._;
  models = exports;
  server = true;
} else {
  models = this.models = {};
}
models.Chat = Backbone.Model.extend({});
models.Chats = Backbone.Collection.extend({
  model: models.Chat
});