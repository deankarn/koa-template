var User = require('mongoose').model('User');

module.exports = function (config, public, secured)
{
	var languageHelper = require(config.app.root + '/app/helpers/languageHelper')(null);

	secured.get('user/add', '/user/add', function* (next)
	{
		yield this.render('user/add.jade',
		{
			csrf: this.csrf,
			localeString: this.session.localeString,
			title: this.locale.translate('user/add/title'),
			email: this.locale.translate('user/add/email'),
			password: this.locale.translate('user/add/password'),
			language: this.locale.translate('user/add/language'),
			languages: languageHelper.JSONArray()
		});
	});

	secured.post('/user/add', function* (next)
	{
		var email = this.request.body['email'].toLowerCase(),
			locale = this.request.body['locale'],
			password = this.request.body['password'];

		try
		{
			var user =
				yield User.findOne(
				{
					'local.email': email
				})
				.exec();

			if (user)
			{
				this.response.body = 'User Already Exists';
				return;
			}

			user = new User();
			user.local.email = email;
			user.local.password = password; //hashed within model itself during saving
			user.locale = locale;

			yield user.save();

			this.response.body = 'User Saved';
			return;
		}
		catch (ex)
		{
			console.log('Error:' + ex)
			this.response.body = 'Error:' + ex;
			return;
		}
	});
};
