var router = require('koa-router');
var wrench = require('wrench');

var public = new router();
var secured = new router();

module.exports = function (app, config, globalize)
{
	app.use(globalize.middleware());

	var publicDir = config.app.root + '/app/routes/public';
	wrench.readdirRecursive(publicDir, function (err, files)
	{
		if (!files) return;

		files.forEach(function (fn)
		{
			if (!/\.js$/.test(fn)) return;
			require(publicDir + '/' + fn)(config, public, secured);
		});
	});

	app.use(public.middleware());

	// Require authentication for now
	app.use(function* ensureAuthenticated(next)
	{
		if (this.isAuthenticated())
		{
			yield next
		}
		else
		{
			// use router get url instead of hard coding
			this.redirect(public.url('login'))
		}
	});

	var securedDir = config.app.root + '/app/routes/secured';
	wrench.readdirRecursive(securedDir, function (err, files)
	{
		if (!files) return;

		files.forEach(function (fn)
		{
			// console.log(fn);
			if (!/\.js$/.test(fn)) return;
			require(securedDir + '/' + fn)(config, public, secured);
		});
	});

	app.use(secured.middleware());
};
