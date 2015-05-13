cozydb = require 'cozy-db-pouchdb'

module.exports =
    bookmark:
        all: cozydb.defaultRequests.all
