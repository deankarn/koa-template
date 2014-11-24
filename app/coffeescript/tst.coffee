define "tst", ["jquery", "semanticui", "common", "common.datetime"], ($, s, c, dt) ->
    console.log $
    console.log s
    console.log c
    console.log dt
    initialize = () ->
        true

    self = {
        initialize: initialize
    }
