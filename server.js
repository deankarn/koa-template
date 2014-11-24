'use strict';

// Force UTC DateTime to ensure dates are not parsed in the servers locale
// we will do the converting to the users locale
process.env.TZ = 'UTC';

/**
* Dependencies
*/
var fs = require('fs');
var koa = require('koa');
var mongoose = require('mongoose');
var passport = require('koa-passport');
var globalize = require('./app/config/globalize');

/**
* Config
*/
var config = require('./app/config/config');

/**
* Connect to database
*/
mongoose.connect(config.mongo.url);
mongoose.connection.on('error', function (err) {
    console.log(err);
});

/**
* Load the models
*/
var modelsPath = config.app.root + '/app/models';
fs.readdirSync(modelsPath).forEach(function (file) {
    if (~file.indexOf('js')) {
        require(modelsPath + '/' + file);
    }
});

/**
* Load Globalization Data
*/
var i10n = new globalize(config);

/**
* Server
*/
var app = module.exports  = koa();

require('./app/config/passport')(passport, config);
// require('./app/config/passport');

require('./app/config/koa')(app, config, passport);

// Routes
require('./app/config/routes')(app, config, i10n);

// Start app
if (!module.parent) {
    app.listen(config.app.port);
    console.log('Server started, listening on port: ' + config.app.port);
}
console.log('Environment: ' + config.app.env);
