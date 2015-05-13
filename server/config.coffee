path = require 'path'
americano = require 'americano'
path = require 'path'
staticPath = path.resolve(path.join __dirname, '..', 'client', 'public')

config =
    common:
        use: [
            americano.bodyParser()
            americano.methodOverride()
            americano.static staticPath,
                maxAge: 86400000
        ]
        useAfter: [
            americano.errorHandler
                dumpExceptions: true
                showStack: true
        ]

    development: [
        americano.logger 'dev'
    ]

    production: [
        americano.logger 'short'
    ]

    plugins: [
        'cozy-db-pouchdb'
    ]

module.exports = config
