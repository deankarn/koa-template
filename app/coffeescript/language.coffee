###
    Postback on language selection to update the screen with the selected language.

    Cookie must be set so that login page doesn't redirect here in an endless loop
###

define ["main", "common.datetime"], (main, dt) ->

    initialize = () ->
        select = document.getElementById('select-lang')

        rules = {
            'select-lang': {
              identifier : 'select-lang',
              rules: [
                {
                  type : 'empty',
                  prompt : 'Please select a Language'
                }
              ]
            }
        }

        $('#language-ct').find('form.ui.form').form(rules, {
            inline : true,
            on : 'submit'
          } )
        true

        document.getElementById('submit-lang').onclick = submitOverride;
        select.onchange = languageChanged;

    languageChanged = (e) ->
        lang = this.options[this.selectedIndex].value;
        window.location.href = window.location.protocol + '//' + window.location.hostname + ':' + window.location.port + window.location.pathname + '?locale=' + lang;

    submitOverride = (e) ->
        e.preventDefault()

        select = document.getElementById('select-lang')
        form = document.querySelector('#language-ct form.ui.form')
        lang = select.options[select.selectedIndex].value

        form.action = form.action + '?locale=' + lang
        form.submit()

    self = {
        initialize: initialize
    }
