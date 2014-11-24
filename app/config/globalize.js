var Globalize = require('globalize');
var wrench = require('wrench');

module.exports = function (config)
{
    // var globalize = {};
	// var globalize = function(config){
	var cldrDir = config.app.root + '/node_modules/cldr-data/json';
	var translationDir = config.app.root + '/app/translations';

	// Before we can use Globalize, we need to feed it on the appropriate I18n content (Unicode CLDR). Read Requirements on Getting Started on the root's README.md for more information.
	Globalize.load(require(cldrDir + '/main/en-GB/ca-gregorian.json'));
	Globalize.load(require(cldrDir + '/main/en-GB/numbers.json'));
	Globalize.load(require(cldrDir + '/main/en/ca-gregorian.json'));
	Globalize.load(require(cldrDir + '/main/en/numbers.json'));
	Globalize.load(require(cldrDir + '/main/fr/ca-gregorian.json'));
	Globalize.load(require(cldrDir + '/main/fr/numbers.json'));
	Globalize.load(require(cldrDir + '/main/zh-Hant/ca-gregorian.json'));
	Globalize.load(require(cldrDir + '/main/zh-Hant/numbers.json'));
	Globalize.load(require(cldrDir + '/supplemental/likelySubtags.json'));
	Globalize.load(require(cldrDir + '/supplemental/timeData.json'));
	Globalize.load(require(cldrDir + '/supplemental/weekData.json'));

	// Load all translations in the translations directory
	wrench.readdirRecursive(translationDir, function (err, files)
	{

		if (!files) return;

		files.forEach(function (fn)
		{
			if (!/\.json$/.test(fn)) return;
			Globalize.loadTranslations(require(translationDir + '/' + fn));
		});
	});

	// Set "en" as our default locale.
	Globalize.locale('en-GB');
// };

	// export globalize middleware, import real function...
	this.middleware = function()
	{
		return function* (next)
	{
		var req = this.request,
			params = this.request.query;

		if (params.locale)
		{
			console.log('getting locale from input param:' + params.locale);

			this.localeString = params.locale;
			this.locale = new Globalize(this.localeString);
		}
		else
		{
			if (this.isAuthenticated())
			{
				console.log('getting locale from session:' + this.session.localeString);

				this.localeString = this.session.localeString;
				this.locale = new Globalize(this.localeString);
			}
			else
			{
				var cookie = this.cookies.get('locale');

				if (cookie)
				{
					console.log('getting locale from cookie:' + cookie);

					this.localeString = cookie;
					this.locale = new Globalize(this.localeString);
				}
				else
				{
					// check for Accept-Language headerto try and determine locale
					var languages = this.acceptsLanguages();
					var languageDetermined = false;

					if (languages && languages.length > 0)
					{
						for (i = 0, len = languages.length; i < len; i++)
						{
							var lang = languages[i].toLowerCase();

							console.log('language:' + lang);

							switch (lang)
							{
							case 'en':
							case 'en-us':
								this.localeString = 'en';
								languageDetermined = true;
								break;
							case 'en-gb':
							case 'en-ca':
								this.localeString = 'en-GB';
								languageDetermined = true;
								break;
							case 'fr-CA':
							case 'fr-fr':
							case 'fr':
								this.localeString = 'fr';
								languageDetermined = true;
								break;
							case 'zh-hant':
							case 'zh':
							case 'zh-hans-cn':
								this.localeString = 'zh-Hant';
								languageDetermined = true;
								break;
							}

							if (languageDetermined)
							{
								console.log('language determined from Accept-Language header:' + this.localeString);

								this.locale = new Globalize(this.localeString);
								break;
							}
						}
					}

					if (!languageDetermined)
					{
						console.log('setting default locale:en-GB as language coult not be determined');

						this.localeString = 'en-GB';
						this.locale = new Globalize(this.localeString);

						if (!req.url.match(/^\/language(?:.+)?$/))
						{
							return this.redirect('/language');
						}
					}
				}
			}
		}

		yield next; // go to next function, probably routes.
	};
	};

	// return globalize;
};
// module.exports = globalize;
