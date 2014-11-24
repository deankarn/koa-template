module.exports = function (config, public, secured)
{
	var languageHelper = require(config.app.root + '/app/helpers/languageHelper')(null);

	public.get('language', '/language', function* (next)
	{
		// render the page and pass in any flash data if it exists
		yield this.render('root/language.jade',
		{
			title: this.locale.translate('language/title'),
			selectLangMsg: this.locale.translate('language/selectLangMsg'),
			setLangMsg: this.locale.translate('language/setLangMsg'),
			localeString: this.localeString,
			languages : languageHelper.JSONArray()
		});
	});

	public.post('/language', function* (next)
	{
		// set long lived cookie, 10 years if it's not found by cookie monster in the mean time....
		this.cookies.set('locale', this.localeString,
		{
			path: '/',
			secure: false,
			maxAge: 60 * 60 * 24 * 365 * 10,
			httpOnly: false
		});
		// res.cookie('locale', req.localeString, { path: '/', secure: false, maxAge: 60 * 60 * 24 * 365 * 10, httpOnly: false });

		// console.log(this.session.returnUrl);
		if (this.session.returnUrl)
		{
			this.redirect(this.session.returnUrl);
		}
		else
		{
			this.redirect(public.url('login'));
		}
	});
};
