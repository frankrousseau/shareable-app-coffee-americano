React = require 'react'
request = require 'superagent'
slug = require 'slug'
{div, p, button, input, label} = React.DOM


# Utilitaires pour requêter notre serveur.
data =

    # On récupère les bookmarks.
    getBookmarks: (callback) ->
        request
            .get('/api/bookmarks')
            .set('Accept', 'application/json')
            .end (err, res) ->
                callback err, res.body


    # On crée une bookmark.
    createBookmark: (bookmark, callback) ->
        request
            .post('/api/bookmarks')
            .send(bookmark)
            .end (err, res) ->
                callback err, res.body

    # On supprimme une bookmark (on trouve son identifiant à partir du lien).
    deleteBookmark: (bookmark, callback) ->
        request
            .del('/api/bookmarks/' + slug(bookmark.link))
            .end callback


# C'est le composant principal de l'application.
App = React.createClass
    render: ->
        div null,
            div null, 'My Single Page Application2'
            #BookmarkList
            #    bookmarks: @props.bookmarks


# Le composant liste de bookmark.
BookmarkList = React.createClass

    # On définit l'état du composant bookmarks cela est utile pour le rendu
    # dynamique.
    getInitialState: ->
        return bookmarks: @props.bookmarks

    # Quand le bouton ajout est cliqué, on récupère les valeurs des
    # différents champs.
    # Puis on met à jour la liste des composants. Enfin on provoque un nouveau
    # rendu en changeant l'état et on envoie une requête de création au serveur.
    onAddClicked: ->
        bookmarks = @state.bookmarks
        title = @refs.titleInput.getDOMNode().value
        link = @refs.linkInput.getDOMNode().value

        bookmark = title: title, link: link
        bookmarks.push bookmark

        # Changement d'état.
        @setState bookmarks: bookmarks
        # Requête au server.
        data.createBookmark bookmark, ->

    # Quand on supprime une ligne, on met à jour la liste des lignes. Puis on
    # provoque le rendu du composant en changeant l'état. Pour enfin envoyer une
    # requête de suppression au serveur.
    removeLine: (line) ->
        bookmarks = @state.bookmarks
        index = 0

        while (index < bookmarks.length and bookmarks[index].link isnt line.link)
            index++

        if (index < bookmarks.length)
            bookmark = bookmarks.splice(index, 1)[0]

            # Changement d'état.
            @setState bookmarks: bookmarks
            # Requête au serveur.
            data.deleteBookmark bookmark, ->

    # Rendu du composant.
    render: ->
        removeLine = @removeLine

        # Ici on prépare la liste à partir des proprités.
        div null,
            div null,
                label null, title
                input
                    ref: "titleInput"
                    type: "text"
            div null,
                label null, url
                input
                    ref: "linkInput"
                    type: "text"
            div null,
                button
                    onClick: @onAddClicked
                , "+"
            div null,
                @state.bookmarks.map (bookmark) ->
                    Bookmark
                        title: bookmark.title
                        link: bookmark.link
                        removeLine: removeLine


# Le composant qui va définir une ligne de bookmark.
Bookmark = React.createClass

    # On supprime la ligne courante du parent quand le bouton supprimé est
    # cliqué.
    onDeleteClicked: ->
        @props.removeLine @props

    # Le rendu se fait grâce à un format de template spécifique à base de
    # composant reacts.
    render: ->
        div null,
            p
                className: "title", @props.title
            p
                className: 'link'
            ,
                a
                    href: @props.link
                ,
                    @props.link
            p
                button onClick: @onDeleteClicked, X


# Ici on démarre !
data.getBookmarks (err, bookmarks) ->

    if not bookmarks?
        alert "Je n'ai pas réussi à récupérer les bookmarks"

    else
        # Attention le premier élément de react ne doit pas être attaché
        # directement à l'élément body.
        React.render(React.createElement(App , bookmarks: bookmarks.rows),
                     document.getElementById('app'))

