cozydb = require 'cozy-db-pouchdb'


module.exports = Bookmark = cozydb.getModel 'Event',
    title: type: String
    link: type: String
