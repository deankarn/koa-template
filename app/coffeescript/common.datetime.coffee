define "common.datetime", ["common"], (common) ->

    initialize = () ->
        # here for future stuff like gathering holidays for your region etc...
        true

    getStdTimezoneOffset = () ->
        dt = new Date()
        fullYear = dt.getFullYear()
        jan = new Date(fullYear, 0, 1)
        jul = new Date(fullYear, 6, 1)

        return Math.max(jan.getTimezoneOffset(), jul.getTimezoneOffset())

    isTodayDst = () ->
        return getTimezoneOffset() < getStdTimezoneOffset()

    getTimezoneOffset = () ->
        return new Date().getTimezoneOffset()

    getUtcOffsetInSpiteOfDstInSeconds = () ->

        dst = 0
        offset = getTimezoneOffset()

        if isTodayDst
            dst = 60;

            if offset < 0
                dst = dst * - 1;

        return (offset + dst) * 60 * - 1;

    getUtcTimezoneOffsetInSeconds = () ->
        return getTimezoneOffset() * 60 * - 1;

    self = {
        initialize: initialize,
        getUtcOffsetInSpiteOfDstInSeconds: getUtcOffsetInSpiteOfDstInSeconds,
        getUtcTimezoneOffsetInSeconds: getUtcTimezoneOffsetInSeconds
    } ;
