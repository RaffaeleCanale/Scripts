const fs         = require('fs')
const csv        = require('csv-streamify')
const _          = require('lodash')
const argv       = require('yargs').argv
const matcher    = require('./matcher')
const StreamSkip = require("stream-skip")

function readCsv(file) {
    return new Promise((resolve, reject) => {
        const parser = csv({
            delimiter: ',',
            newline: '\n',
            quote: '"',
            empty: '',
            // if true, emit arrays instead of stringified arrays or buffers
            objectMode: true,
            // if set to true, uses first row as keys -> [ { column1: value1, column2: value2 }, ...]
            columns: true
        }, (err, result) => {
            if (err) return reject(err)

            return resolve(result)
        })

        let stream
        if (file === null) {
            stream = process.stdin.pipe(new StreamSkip({
                skip: 1
            }))
        } else {
            stream = fs.createReadStream(file)
        }

        stream.pipe(parser)
    })
}

if (argv._.length > 1) {
    return console.error('Usage: node query_csv.js [--stdin|<file>] --query <query> --field-[field] <field-query> ')
}

const stdin = argv.stdin
const file = argv._.length > 0 ? argv._[0] : null

if (stdin && file) {
    return console.error('Usage: node query_csv.js [--stdin|<file>] --query <query> --field-[field] <field-query> ')
}

const query = {}

if (argv.query) {
    query._ = _.split(argv.query, ' ')
}

for (let [k, v] of _.entries(argv)) {
    if (k.startsWith('field-')) {
        query[k.slice(6)] = _.split(v, ' ')
    }
}

readCsv(file)
    .then((data) => {
        const queryFilter = matcher.bind(null, query)

        const result = data.filter(queryFilter)

        console.log(JSON.stringify(result));
    })
    .catch((err) => console.error(err))
