'use strict';
var path = require('path');
var _ = require('lodash');

var env = process.env.NODE_ENV = process.env.NODE_ENV || 'development';
var production = env == 'production' ? true : false;

var base = {
    app: {
        root: path.normalize(__dirname + '/../..'),
        env: env,
        isProduction: production,
        proxy: true
    }
};

var specific = {
    development: {
        app: {
            port: 3000,
            name: 'Hyena - Dev',
            keys: ['ISwearByMyPrettyFloralBonnetIWillEndYou']
        },
        mongo: {
            url: 'mongodb://mongodbtestuser:kJUMWqmMFs9Hk9z3bAYUtwR@127.0.0.1:27017/nodejs_templatev1',
        }
    },
    test: {
        app: {
            port: 3001,
            name: 'Hyena - Test realm',
            keys: ['ISwearByMyPrettyFloralBonnetIWillEndYou']
        },
        mongo: {
            url: 'mongodb://mongodbtestuser:kJUMWqmMFs9Hk9z3bAYUtwR@127.0.0.1:27017/nodejs_templatev1',
        }
    },
    production: {
        app: {
            port: process.env.PORT || 3000,
            name: 'Hyena',
            keys: ['ISwearByMyPrettyFloralBonnetIWillEndYou']
        },
        mongo: {
            url: 'mongodb://mongodbtestuser:kJUMWqmMFs9Hk9z3bAYUtwR@127.0.0.1:27017/nodejs_templatev1',
        }
    }
};

module.exports = _.merge(base, specific[env]);
