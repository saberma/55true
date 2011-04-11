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
models.ChatEntry = Backbone.Model.extend({});
models.ClientCountModel = Backbone.Model.extend({
  defaults: {
    "clients": 0
  },
  updateClients: function(clients) {
    return this.set({
      clients: clients
    });
  }
});
models.NodeChatModel = Backbone.Model.extend({
  defaults: {
    "clientId": 0
  },
  initialize: function() {
    return this.chats = new models.ChatCollection();
  }
});
models.ChatCollection = Backbone.Collection.extend({
  model: models.ChatEntry
});
Backbone.Model.prototype.xport = function(opt) {
  var process, result, settings;
  result = {};
  settings = _({
    recurse: true
  }).extend(opt || {});
  process = function(targetObj, source) {
    targetObj.id = source.id || null;
    targetObj.cid = source.cid || null;
    targetObj.attrs = source.toJSON();
    return _.each(source, function(value, key) {
      if (settings.recurse) {
        if (key !== 'collection' && source[key] instanceof Backbone.Collection) {
          targetObj.collections = targetObj.collections || {};
          targetObj.collections[key] = {};
          targetObj.collections[key].models = [];
          targetObj.collections[key].id = source[key].id || null;
          return _.each(source[key].models, function(value, index) {
            return process(targetObj.collections[key].models[index] = {}, value);
          });
        } else if (source[key] instanceof Backbone.Model) {
          targetObj.models = targetObj.models || {};
          return process(targetObj.models[key] = {}, value);
        }
      }
    });
  };
  process(result, this);
  return JSON.stringify(result);
};
Backbone.Model.prototype.mport = function(data, silent) {
  var process;
  process = function(targetObj, data) {
    targetObj.id = data.id || null;
    targetObj.set(data.attrs, {
      silent: silent
    });
    if (data.collections) {
      _.each(data.collections, function(collection, name) {
        targetObj[name].id = collection.id;
        return _.each(collection.models, function(modelData, index) {
          var newObj;
          newObj = targetObj[name]._add({}, {
            silent: silent
          });
          return process(newObj, modelData);
        });
      });
    }
    if (data.models) {
      return _.each(data.models, function(modelData, name) {
        return process(targetObj[name], modelData);
      });
    }
  };
  process(this, JSON.parse(data));
  return this;
};