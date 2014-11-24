module.exports = function(config, public, secured)
{
    secured.get('root', '/', function* root(next)
    {
        yield this.render('root/test',
        {
            csrf: this.csrf,
            title: "Test Partial Content",
        });
    });

    secured.get('partials-test', '/partials/test', function* partial(next)
    {
        yield this.render('partials/test',
        {
            csrf: this.csrf,
            title: "Test Partial Content",
        });
    });
};
