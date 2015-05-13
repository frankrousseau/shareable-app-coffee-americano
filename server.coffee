americano = require 'americano'

port = process.env.PORT or 3000
options =
    name: 'my-bookmarks'
    dbName: 'my-bookmarks-db'
    port: process.env.PORT or 9240
    host: process.env.HOST or '127.0.0.1'

americano.start options, (err, app, server) ->
    console.log "server is listening on #{options.port}..."

