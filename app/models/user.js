/**
 * Dependencies
 */
var mongoose = require('mongoose');
var co = require('co');
var bcrypt = require('co-bcrypt');

/**
 * Constants
 */
// const SALT_WORK_FACTOR = 10;

var userSchema = mongoose.Schema(
{

	local:
	{
		email: { type: String, required: true, unique: true, lowercase: true },
		password: { type: String, required: true }
	},
	facebook:
	{
		id: String,
		token: String,
		email: String,
		name: String
	},
	twitter:
	{
		id: String,
		token: String,
		displayName: String,
		username: String
	},
	google:
	{
		id: String,
		token: String,
		email: String,
		name: String
	},
	locale: { type: String, required: true },
	updated_at:
	{
		type: Date,
		default: Date.now
	},
	created_at:
	{
		type: Date,
		default: Date.now
	}
},
{
	toJSON:
	{
		transform: function (doc, ret, options)
		{
			delete ret.local.password;
		}
	}
});

/**
 * Middlewares
 */
userSchema.pre('save', function (done)
{
	// only hash the password if it has been modified (or is new)
	if (!this.isModified('local.password'))
	{
		return done();
	}

    // This will probably fail with the new co 4.0, but until we get
	// the add screen working will leave as is.
	co(function* ()
	{
		try
		{
			var salt =
				yield bcrypt.genSalt(10);
			var hash =
				yield bcrypt.hash(this.local.password, salt, null);
			this.local.password = hash;
			done();
		}
		catch (err)
		{
			done(err);
		}
	}).call(this, done);
});

/**
 * Methods
 */
userSchema.methods.validPassword = function* (password)
{
	return yield bcrypt.compare(password, this.local.password);
};

// Model creation
mongoose.model('User', userSchema);
