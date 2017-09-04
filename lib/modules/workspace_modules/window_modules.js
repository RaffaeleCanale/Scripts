'use strict'

const exec = require('child_process').exec;

function WindowModule() {}

WindowModule.prototype.init = function (callback) {
    let env = process.env.SCRIPT_LIB

    if (!env) return callback('$SCRIPT_LIB not found')

    this.modulesPath = env + '/modules/window_modules/'
    return callback()
}

WindowModule.prototype.execute = function (cmd, callback) {
    if (!this.modulesPath) return callback('Must init first')
    exec(this.modulesPath + cmd, (err, stdout, stderr) => {
        if (err) return callback(err)
        return callback(null, stdout)
    });
}


const instance = new WindowModule()

module.exports = instance
