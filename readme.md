# Water Cooler

A ExpressJs Blog Application

This application is a blog application written in coffeescript, express, node using couchdb as the data store.  It is also using Authur for the authentication solution.

## Install

```
git clone https://github.com/twilson63/water-cooler.git
```

# Setup ENV Variables
COUCHDB=http://localhost
PORT=5984
USERNAME=admin
PASSWORD=admin
# See Authur [](https://twilson63@github.com/twilson63/authur)
AUTHUR=http://[admin]:[admin]@authur.wilbur.io/auth/[app]
REGISTER=http://[admin]:[admin]@authur.wilbur.io/users

```
cd water-cooler
npm install
node server.js
```

## Deploy to Wilbur Cloud

```
vmc target api.wilbur.io
vmc push water-cooler --no-start
vmc env-add water-cooler COUCHDB=...
vmc env-add water-cooler PORT=...
vmc env-add water-cooler USERNAME=...
vmc env-add water-cooler PASSWORD=...
vmc env-add water-cooler AUTHUR=...
vmc env-add water-cooler REGISTER=...
vmc start water-cooler
```

## Contribute

[Request a Feature](/twilson63/water-cooler/issues)
[Submit a Change](/twilson63/water-cooler/pulls)
[contributors](/twilson63/water-cooler/contributors)



## License

See LICENSE
