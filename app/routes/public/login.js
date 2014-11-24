var passport = require('koa-passport');

module.exports = function (config, public, secured)
{
	public.get('login', '/login', function* login(next)
	{
		// render the page and pass in any flash data if it exists
		yield this.render('root/login.jade',
		{
			csrf: this.csrf,
			title: this.locale.translate('login/title'),
			email: this.locale.translate('login/email'),
			password: this.locale.translate('login/password'),
			forgot: this.locale.translate('login/forgot'),
			language: this.locale.translate('login/language')
		});
	});

	public.post('/login', function* (next)
	{
		var ctx = this

		yield passport.authenticate('local-login',
		{
			successRedirect: secured.url('root'),
			failureRedirect: public.url('login')
		});
	});

	// public.post('/login', passport.authenticate('local-login', {
	// 	successRedirect: secured.url('root'),
	// 	failureRedirect: public.url('login')
	// }));

	public.get('logout', '/logout', function* (next)
	{
		this.logout();
		this.redirect(public.url('login'));
	});
};
