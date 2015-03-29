// Dépendances
var path = require('path');
var slug = require('slug');

var express = require('express')

var morgan = require('morgan');
var bodyParser = require('body-parser');
var methodOverride = require('method-override');

var PouchDB = require('pouchdb');

// On génère la base de données.
var db = PouchDB('db');
// On génère le serveur Express.
var app = express();


// Configuration du serveur Express.
app.use(express.static(path.join(__dirname, 'client', 'public')));
app.use(methodOverride()); // Pour gérer autre chose que du GET et du POST.
app.use(bodyParser.json()); // Parser de JSON vers un objet JS.
app.use(morgan('dev')); // Logging.


// On définit les contrôleurs.
var controllers = {

  // Contrôleur d'introduction.
  base: {
    index: function (req, res) {
      res.send('My Bookmarks API');
    }
  },

  bookmarks: {

    // Contrôleur renvoyant toutes les bookmarks.
    all: function (req, res) {

      // Filtre pour récupérer les documents de type bookmark.
      var allBookmarks = function (doc) {
        if (doc.type === 'bookmark') {
          // Quand le document satisfait les conditions, on l'émet, il est
          // ajouté aux résultat de la requête.
          emit(doc._id, null);
        };
      };

      // Ici on demande de récupérer tous les éléments satisfaisants notre
      // filtre.
      db.query(allBookmarks, {include_docs: true}, function (err, data) {

        if (err) {
          console.log(err);
          res.status(500).send({msg: err});

        } else {
          var result = {
            rows: []
          };
          // data contient une liste de couple clé/document. Où la clé est
          // l'identifiant dans notre cas et le document est la bookmark qui
          // nous intéresse.
          // Le formalisme de retour de pouchdb, ne nous convient pas,
          // on le simplifie un peu.
          data.rows.forEach(function (row) {
            result.rows.push(row.doc);
          });
          res.send(result);
        }
      });
    },


    // Contrôleur de création de documents.
    create: function (req, res) {
      var bookmark = req.body;

      if (bookmark === undefined || bookmark.link === undefined) {
        res.status(400).send({msg: 'Bookmark malformed.'});

      } else {
        var id = slug(bookmark.link);

        // On récupère le document pour voir s'il n'existe pas déjà.
        db.get(id, function (err, doc) {

          if (err && !(err.status === 404)) {
            console.log(err);
            res.status(500).send({msg: err});

          } else if (doc !== undefined) {
            res.status(400).send({msg: 'Bookmark already exists.'});

          } else {

            // On crée le document en forçant l'identifiant et le type.
            bookmark.type = 'bookmark';
            bookmark._id = id;
            db.put(bookmark, function (err, bookmark) {

              if (err) {
                console.log(err);
                res.status(500).send({msg: err});

              } else {
                res.send(bookmark);

              }
            });
          }
        });
      }
    },


    // Contrôleur de suppression du document.
    delete: function (req, res) {
      var id = req.params.id;

      // On vérifie que le document existe bien.
      db.get(id, function (err, doc) {

        if (err) {
          console.log(err);
          res.status(500).send({msg: err});

        } else if (doc === null) {
          res.status(404).send({msg: 'Bookmark does not exist.'});

        } else {

          // Suppression du document.
          db.remove(doc, function (err) {
            if (err) {
              console.log(err);
              res.status(500).send({msg: err});

            } else {
              res.sendStatus(204);
            };

          });
        }
      });
    }
  }

};


// On associe à chaque contrôleur un chemin.
app.get('/api', controllers.base.index);
app.get('/api/bookmarks', controllers.bookmarks.all);
app.post('/api/bookmarks', controllers.bookmarks.create);
app.delete('/api/bookmarks/:id', controllers.bookmarks.delete);


// On démarre le serveur et on affiche un message d'information.
//
var port = process.env.PORT || 9125;
var host = process.env.HOST || '0.0.0.0';
var server = app.listen(port, host, function () {
  console.log('Example app listening at http://%s:%s', host, port)
});
