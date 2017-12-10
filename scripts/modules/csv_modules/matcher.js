const _ = require('lodash')

function matches(query, entry) {
    for (let [field, q] of _.entries(query)) {
        let match

        if (field === '_') {
            match = anyFieldMatches(q, entry)
        } else {
            match = fieldMatches(q, field, entry)
        }

        if (!match) {
            return false
        }
    }

    return true
}

function fieldMatches(q, field, entry) {
    return valueMatch(q, entry[field])
}

function anyFieldMatches(q, entry) {
    const valueMatchQuery = valueMatch.bind(null, q)

    return _.values(entry).some(valueMatchQuery)
}

function valueMatch(q, value) {
    for (let word of q) {
        if (!_.includes(_.toString(value).toLowerCase(), word.toLowerCase())) {
            return false
        }
    }

    return true
}


module.exports = matches;
