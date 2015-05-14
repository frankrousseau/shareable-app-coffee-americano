
### Environnement de développement


Prérequis NPM et Git :

```
sudo apt-get install npm
sudo apt-get install nodejs
```

Récupérer les sources :

```
git clone https://github.com/frankrousseau/shareable-app-coffee-americano
cd shareable-app-coffee-americano
```

Pour le serveur :

```
npm install

# On démarre l'application
coffee server.coffee
```

Pour le client : 

```
cd client
npm install

# On démarre l'outil qui va regénérer le client après chaque modification.
npm start
```


### Publication

S'inscrire à NPM :

```
npm set init.author.name "Brent Ertz"
npm set init.author.email "brent.ertz@gmail.com"
npm set init.author.url "http://brentertz.com"

npm adduser
```

Publier : 

```
npm version patch
npm publish
```


### Installation et utilisation


```
sudo npm install monapp -g
monapp
```


### Démonisation


On utilse Supervisor:

```
sudo apt-get install supervisor
```

Ajouter le fichier `/etc/supervisor/conf.d/monapp.conf` :

```
[program:monapp]
autorestart=false
command=monapp
redirect_stderr=true
user=nonuser
```

On met à jour Supervisor :

```
supervisorctl update
```
