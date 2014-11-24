// var koaStatic = require('koa-static');
// var session = require('koa-generic-session');
// var Globalize = require('globalize');
var session = require('koa-session-store');
var responseTime = require('koa-response-time');
var logger = require('koa-logger');
// var views = require('co-views');
var jade = require('koa-jade');
// var compress = require('koa-compress');
var errorHandler = require('koa-error');
var koaBody = require('koa-better-body');
var csrf = require('koa-csrf');
var mongooseStore = require('koa-session-mongoose');
// var bodyParser = require('koa-bodyparser');

module.exports = function (app, config, passport)
{
	if (!config.app.keys) throw new Error('Please add session secret key in the config file!');

	app.proxy = config.app.proxy;
	app.keys = config.app.keys;

	if (config.app.env != 'test')
		app.use(logger());

	app.use(errorHandler());
	// app.use(koaStatic(config.app.root + '/public'));
	csrf(app);

	// app.use(session(
	// {
	// 	key: 'koareactfullexample.sid',
	// }));
	app.use(session(
	{
		store: mongooseStore.create(
		{
			collection: 'sessions',
			// connection: db,
			expires: 60 * 60 * 24 * 14, // 2 weeks is the default
			// model: 'KoaSession'
		})
	}));

	app.use(koaBody(
	{
		fieldsKey: false,
		multipart: true,
		// formLimit: 20,
		formidable:
		{
			maxFields: 20,
			multiples: true
				// uploadDir: __dirname + '/uploads' OS Temp Dir by default
		}
	}));

	app.use(passport.initialize());
	app.use(passport.session());

	// app.use(function* (next)
	// {
	// 	this.render = views('src/views',
	// 	{
	// 		map:
	// 		{
	// 			html: 'whiskers'
	// 		},
	// 	});
	// 	yield next;
	// });

	app.use(jade.middleware(
	{
		viewPath: config.app.root + '/views',
		debug: !config.app.isProduction,
		pretty: !config.app.isProduction,
		compileDebug: !config.app.isProduction,
		noCache: !config.app.isProduction,
		basedir: config.app.root + '/views'
	}));

	// app.use(compress());
	app.use(responseTime());
};
