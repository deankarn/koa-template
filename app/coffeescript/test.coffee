define "test", ["main"], (main) ->

    initialize = () ->
        button = document.getElementById('load-partials')
        button.onclick = loadPartialView

        # $('.ui.dropdown').dropdown()
        dd = $('.ui.dropdown')

        console.log dd
        dd.dropdown()

        true

    loadPartialView = (e) ->
        e.preventDefault()

        self = this;

        $(self).addClass('loading')
        # Common.addClass(self, 'loading'); # jsperf this vs jquery add class on click and select logic too

        xhr = new XMLHttpRequest()

        xhr.addEventListener("error", (e) ->
            alert "error"
        , false) ;

        xhr.addEventListener("timeout", (e) ->
            alert "timed out"
        , false) ;

        xhr.addEventListener("abort", (e) ->
            alert "abort"
        , false) ;

        xhr.addEventListener("readystatechange", () ->

            if this.readyState == 4
                if this.status == 200
                    results = this.responseText

                    div = document.getElementById('partial-content')

                    $(div).html(results)

                    $(self).removeClass('loading')
                    true
        , false) ;

        url = '/partials/test'

        xhr.open("get", url, true)
        xhr.send(null)

    self = {
        initialize: initialize,
        loadPartialView: loadPartialView
    }
