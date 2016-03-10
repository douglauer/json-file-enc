# json-file-enc

# install

using [npm](https://npmjs.org)

```
npm i json-file-enc --save
```

# example

``` coffeescript
Data = require 'json-file-enc'
db = new Data './test.dat'

log /reading when noexists/
json = db.read()
log json

log /write/
db.write {
  name: 'John Smith'
  age: 30
  ctime: new Date().getTime()
}

log /reading again/
log db.read()

log /writing again/
json = db.read()
json.name = 'Dave Smith'
db.write json

log /reading last/
log db.read()

process.exit 0

###
/test/
/reading when noexists/
{}
/write/
/reading again/
{ name: 'John Smith', age: 30, ctime: 1457638376684 }
/writing again/
/reading last/
{ name: 'Dave Smith', age: 30, ctime: 1457638376684 }
###
```

