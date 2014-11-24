define "user", ["main", "fullscreen-form"], (main, FullscreenForm) ->

    initializeAdd = () ->

        #doubles as the .ff-ct
        ct = $('#user-ct')

        rules = {
            "email": (fieldCt, callback) ->
                email = document.getElementsByName('email')[0];
                console.log email.value.length

                results = {}

                if not email.value.length
                    results.error = true
                    results.message = "Email is required."
                    email.focus()

                callback results
        }

        # ct.find('form.ui.form').form()
        ct.find('div.ui.selection.dropdown').dropdown();

        func = (callback) ->
            results = {}
            # results.error = true
            results.success = true
            # results.message = 'what a super save'
            results.message = '<p>Test</p></script><script type="text/javascript">alert("evaluated!");</script>'
            callback results,successCallback
            true

        new FullscreenForm( ct[0], { ctrlNavProgress: false, ctrlContinueText: 'Move Along', ctrlContinueSubtext: 'or NOT it\'s your choice', onComplete: func, validators: rules})

        true

    successCallback = ()->
        # similar behavior as an HTTP redirect
        window.location.replace "/"

        # similar behavior as clicking on a link
        # window.location.href = "http://stackoverflow.com"

    self = {
        initializeAdd: initializeAdd
    }
