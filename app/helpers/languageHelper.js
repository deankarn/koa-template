module.exports = function(options)
{
    return {

        JSONArray : function(){

            return [
            {
                'text': 'English (UK)',
                'value': 'en-GB',
                'flag': 'gb flag'
            },
            {
                'text': 'English (US)',
                'value': 'en',
                'flag': 'us flag'
            },
            {
                'text': 'Français (France)',
                'value': 'fr',
                'flag': 'fr flag'
            },
            {
                'text': '中国 (简体)',
                'value': 'zh-Hant',
                'flag': 'cn flag'
            }];
        }
    };
}
