Bookmark = require '../models/bookmark'


module.exports =

    all: (req, res) ->
        Bookmark.all (err, bookmarks) ->
            return next err if err

            res.send bookmarks


    create: (req, res) ->
        bookmark = req.body

        if not bookmark? or not bookmark.link?
            res.status(400).send msg: 'Bookmark malformed.'

        else
            Bookmark.create bookmark, (err, bookmarkModel) ->

                if err
                    console.log err
                    res.status(500).send msg: err

                else
                    res.send bookmarkModel


    delete: (req, res, next) ->

        Bookmark.find req.params.id, (err, bookmark) ->

            if err
                console.log err
                res.status(500).send msg: err

            else if not bookmark?
                res.status(404).send msg: 'Bookmark does not exist.'

            else
                # Suppression du bookmarkument.
                bookmark.destroy (err) ->
                    if err
                        console.log err
                        res.status(500).send msg: err
                    else
                        res.sendStatus 204

