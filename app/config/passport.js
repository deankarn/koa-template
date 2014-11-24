var LocalStrategy = require('passport-local').Strategy;
var User = require('mongoose').model('User');
var co = require('co');

var serialize = function (user, done)
{
	console.log('serializing user:' + user);
	done(null, user._id);
	console.log('serializing user done');
};

var deserialize = function (id, done)
{
	console.log('deserializing user');
	User.findById(id, done);
	console.log('deserializing user done');
};

// Basic function that calls our model static function to
// check if the password we got matches the existing one
function AuthLocalUser(req, email, password, done) {
	co(function* ()
	{
		try
		{
			var user =
			yield User.findOne(
				{
					'local.email': email.toLowerCase()
				})
				.exec();

				if (!user) throw new Error('Username or Password is incorrect.');

				var valid =
				yield user.validPassword(password);

				if (valid)
					{
						req.session.localeString = user.locale;
						req.session.utcOffset = req.body['utc-offset'];

						return user;
					}

					// password does not match, but don't want to say that.
					throw new Error('Username or Password is incorrect.');
				}
		catch (ex)
		{
			console.log('Error:' + ex)
			return null;
		}
	})
	.then(function(user){
		return done(null, user);
	});
};

module.exports = function (passport, config)
{
	passport.serializeUser(serialize);
	passport.deserializeUser(deserialize);
	passport.use('local-login', new LocalStrategy(
		{
			// by default, local strategy uses username and password, we will override with email
			usernameField: 'email',
			passwordField: 'password',
			passReqToCallback: true // allows us to pass back the entire request to the callback
		},
		AuthLocalUser));
};
