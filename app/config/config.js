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
            name: 'koa-Dev',
            keys: ['ISwearByMyPrettyFloralBonnetIWillEndYou']
        },
        mongo: {
            url: 'mongodb://anthony:root@127.0.0.1:27017/koa-Dev',
        }
    },
    test: {
        app: {
            port: 3001,
            name: 'koa-Test',
            keys: ['ISwearByMyPrettyFloralBonnetIWillEndYou']
        },
        mongo: {
            url: 'mongodb://mongodbtestuser:kJUMWqmMFs9Hk9z3bAYUtwR@127.0.0.1:27017/koa-Test',
        }
    },
    production: {
        app: {
            port: process.env.PORT || 3000,
            name: 'koa-Prod',
            keys: ['ISwearByMyPrettyFloralBonnetIWillEndYou']
        },
        mongo: {
            url: 'mongodb://mongodbtestuser:kJUMWqmMFs9Hk9z3bAYUtwR@127.0.0.1:27017/koa-Prod',
        }
    }
};

module.exports = _.merge(base, specific[env]);
