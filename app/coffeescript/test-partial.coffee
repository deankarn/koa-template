define "test-partial", ["main"], (main) ->

    initialize = () ->

        # alert $('#test-partial').find('.ui.dropdown')[0]
        # console.log($);
        # $('#test-partial').find('.ui.dropdown').dropdown()
        dd = $('#test-partial').find('.ui.dropdown');
        console.log(dd);
        dd.dropdown()
        # $('.ui.dropdown').dropdown()
        true

    self = {
        initialize: initialize,
    };
