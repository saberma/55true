server = false
if exports?
  Backbone = require('backbone')
  _ = require('underscore')._

  models = exports
  server = true
else
  models = this.models = {}

# models

models.Chat = Backbone.Model.extend({})

# Collections

models.Chats = Backbone.Collection.extend
  model: models.Chat
