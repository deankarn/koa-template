define "fullscreen-form", ["main", "common"], (main, common) ->

    ###
        Data Attributes - on field list li tag
        data-hide-continue - hides the continue button on this field, one of the controls on the screen triggers the continue,
                             forcing an option to be selected and most likely used with data-input-trigger.
        data-input-trigger - it tries to subscribe any elements such as a radio button group to fire the continue upon selection.
        data-dependant - indicates that this field is dependant upon a previous field in the list, affects whether the navdot are disabled or not.
        data-validation-id - this is the id that the validation logic will try and match your validation rule.
    ###
    class FullscreenForm

        'use strict';

        animEndEventName = common.animationEndEventName()
        support = { animations : if animEndEventName == null then false else true }

        constructor: (@el, options) ->
            this.extend(this.options, options)
            this._init()

        extend: (a, b) ->
            for key of b
                a[key] = b[key] if b.hasOwnProperty key
            a

        options:
            # show progress bar
            ctrlNavProgress : true,
            # show navigation dots
            ctrlNavDots : true,
            # show [current field]/[total fields] status
            ctrlNavNumbers : true,
            # back button text, for internationalization
            ctrlBackText : 'Back',
            # next button text, for internationalization
            ctrlNextText : 'Next',
            # continue text, for internationalization
            ctrlContinueText : 'Continue',
            # continue subtext, for internationalization
            ctrlContinueSubtext : 'or press ENTER',
            # busy function to do whatever during bust aperations i.e. a saving indicator
            onBusy : null,
            #busy completed function
            onBusyComplete : null,
            # reached end, do you want to call a function for submitting or something...
            onCompete : null,
            # validation field identifiers and functions
            validators : {},
            # example usage
            # rules = {
            #     "email": (fieldCt, callback) ->
            #         email = document.getElementsByName('email')[0];
            #         console.log email.value.length
            #
            #         results = {}
            #
            #         if not email.value.length
            #             results.error = true
            #             results.message = "Email is required."
            #             email.focus()
            #
            #         callback results
            # }

        _init: () ->
            # the form element
            this.formEl = this.el.querySelector( 'form.ff-form' )

            # list of fields
            this.fieldsList = this.formEl.querySelector( 'ol.ff-field-list' )

            # current field position
            # this.current = 0
            this.currentIdx = 0

            # all fields
            this.fields = [].slice.call( this.fieldsList.children )

            # total fields
            this.fieldsCount = this.fields.length

            this.currentField = this.fields[this.currentIdx]
            # show first field
            common.addClass(this.currentField, 'ff-current-field')

            # create/add controls
            this._registerControls()

            # init events
            this._initEvents()

            # focus on first field
            this._focusOnCurrentFieldInput()

            true

        _registerControls: () ->

            # This should be redone so that nothing is added to the DOM until controls finished
            # main controls wrapper
            this.ctrls = common.createElement( 'div', { cName : 'ff-controls', appendTo : this.el } )

            # continue button (jump to next field)
            this.ctrlContinue = common.createElement( 'button', { cName : 'ff-continue', inner : this.options.ctrlContinueText, appendTo : this.ctrls } )
            this.ctrlContinue.setAttribute('data-subtext', this.options.ctrlContinueSubtext);
            this._showCtrl this.ctrlContinue

            # final error or success buttons
            this.ctrlBack = common.createElement( 'button', { cName : 'ff-back', inner : this.options.ctrlBackText, appendTo : this.ctrls } )
            this.ctrlNext = common.createElement( 'button', { cName : 'ff-next', inner : this.options.ctrlNextText, appendTo : this.ctrls } )

            # navigation dots
            if this.options.ctrlNavDots
                this.ctrlNav = common.createElement( 'nav', { cName : 'ff-nav-dots', appendTo : this.ctrls } )
                dots = ''
                for i in [0...this.fieldsCount] by 1
                    dots += if i == this.currentIdx then '<button class="ff-dot-current"></button>' else '<button disabled></button>'
                    # if i == this.currentIdx
                    #     this.currentNavDot = common.createElement 'button', { cName : 'ff-dot-current', appendTo : this.ctrlNav}
                    # else
                    #     common.createElement 'button', { disabled : true, appendTo : this.ctrlNav}

                this.ctrlNav.innerHTML = dots
                this._showCtrl this.ctrlNav
                this.ctrlNavDots = [].slice.call( this.ctrlNav.children )
                this.currentNavDot = this.ctrlNavDots[0]

            # field number status
            if this.options.ctrlNavNumbers
                this.ctrlNavNumberCt = common.createElement( 'span', { cName : 'ff-numbers', appendTo : this.ctrls } )

                # current field placeholder
                this.currentNavNumber = common.createElement( 'span', { cName : 'ff-number-current', inner : Number( this.currentIdx + 1 ), appendTo : this.ctrlNavNumberCt } )

                # total fields placeholder
                this.totalNavNumber = common.createElement( 'span', { cName : 'ff-number-total', inner : this.fieldsCount, appendTo : this.ctrlNavNumberCt } )

                this._showCtrl( this.ctrlNavNumberCt )

            # progress bar
            if this.options.ctrlNavProgress
                this.ctrlProgress = common.createElement( 'div', { cName : 'ff-progress', appendTo : this.ctrls } )
                this._showCtrl( this.ctrlProgress )

            this.msgError = common.createElement( 'span', { cName : 'ff-message-error', appendTo : this.el } )
            this.msgSuccess = common.createElement( 'span', { cName : 'ff-message-success', appendTo : this.el } )

            true

        _showCtrl: (ctrl) ->
            common.addClass(ctrl, 'ff-show')
            true

        _hideCtrl: (ctrl) ->
            common.removeClass( ctrl, 'ff-show')
            true

        _initEvents: () ->
            self = this

            # show next field
            this.ctrlContinue.addEventListener 'click', (e) ->
                console.log 'clicked continue'
                self._nextField()
                true

            if this.options.ctrlNavDots
                this.ctrlNavDots.forEach ( dot, pos ) ->
                    dot.addEventListener 'click', (e)->
                        self._showField( pos )
                        true
                    true

            # Need to split out the input types somehow for custom dropdowns i.e. semanticui dropdown
            this.fields.forEach (fld) ->
                if not fld.hasAttribute "data-input-trigger"
                    return

                input = fld.querySelector( 'input' ) || fld.querySelector( 'select' )|| fld.querySelector( 'textarea' )

                switch input.tagName.toLowerCase()
                    when 'select'
                        input.addEventListener 'change', () ->
                             self._nextField()
                             true
                    when "input"
                        type = input.type.toLowerCase()
                        switch type
                            when 'radio', 'checkbox'
                                [].slice.call( fld.querySelectorAll "input[type='#{type}']").forEach (inp) ->
                                    inp.addEventListener 'change', (ev) ->
                                        self._nextField()
                                        true
                                    true
                            when 'text', 'password' #, 'hidden' hidden does not fire onchange event so...
                                input.addEventListener 'change', () ->
                                    self._nextField()
                                    true
                            when 'button'
                                input.addEventListener 'click', () ->
                                    self._nextField()
                                    true
                    when 'textarea'
                        input.addEventListener 'change', () ->
                            self._nextField()
                            true
                true

            # keyboard navigation events - jump to next field when pressing enter
            document.addEventListener 'keydown', (e) ->

                if not self.isLastStep and not (e.target.tagName.toLowerCase() == 'textarea')
                    keyCode = e.keyCode || e.which
                    if keyCode == 13
                        e.preventDefault()
                        self._nextField()
                        false
                true

            true

        _nextField: (pos) ->

            if this.isBusy || this.isAnimating
                return

            this.isBusy = this.isAnimating = true
            this.nextIdx = pos
            this.isMovingBack = this.nextIdx != undefined
            this.isLastStep = if this.currentIdx == this.fieldsCount - 1 and not this.isMovingBack then true else false

            if this.nextIdx == undefined
                this.nextIdx = this.currentIdx + 1

            this._clearError()
            this._clearSuccess()

            self = this

            # Validate this.currentField to ensure we can proceeed to the next
            this._validate (success) ->
                if not success
                    self.isBusy = self.isAnimating = false
                    return

                self._hideCtrl self.ctrlBack
                self._hideCtrl self.ctrlNext

                innerself = self

                if self.isLastStep
                    # show the complete form and hide the controls
                    self._hideCtrl self.ctrlNav
                    self._hideCtrl self.ctrlProgress
                    self._hideCtrl self.ctrlContinue
                    self._hideCtrl self.ctrlNavNumberCt
                    common.removeClass self.currentField, 'ff-current-field'

                    # fire busy indicator function
                    if self.options.onBusy
                        self.options.onBusy()

                    #fire onComplete, wait for results object
                    if self.options.onComplete
                        self.options.onComplete (results, extra) ->

                            if results.error
                                if extra
                                    innerself.ctrlBack.onclick = extra
                                else
                                    self.ctrlBack.onclick = () ->
                                        innerself._nextField 0
                                        innerself._showCtrl innerself.ctrlNav
                                        innerself._showCtrl innerself.ctrlProgress
                                        innerself._showCtrl innerself.ctrlContinue
                                        innerself._showCtrl innerself.ctrlNavNumberCt
                                        true

                                innerself._showError results.message
                                innerself._showCtrl innerself.ctrlBack
                            else
                                if extra
                                    innerself.ctrlNext.onclick = extra

                                innerself._showSuccess results.message
                                innerself._showCtrl innerself.ctrlNext

                            # fire busy complete indicator function
                            if innerself.options.onBusyComplete
                                innerself.options.onBusyComplete()

                            innerself.isBusy = innerself.isAnimating = false
                            true
                    true
                else
                    common.removeClass self.currentField, 'ff-current-field'
                    common.addClass self.currentField, 'ff-hide'

                    self.nextField = self.fields[self.nextIdx]
                    self.nextNavDot = self.ctrlNavDots[self.nextIdx]

                    self._updateNav()
                    self._updateFieldNumber()
                    self._progress()

                    common.addClasses self.nextField, [ 'ff-current-field', 'ff-show']

                    if self.nextField.hasAttribute 'data-hide-continue'
                        common.removeClass self.ctrlContinue, 'ff-show'
                    else
                        common.addClass self.ctrlContinue, 'ff-show'

                    if self.isMovingBack
                        common.addClass self.el, 'ff-show-prev'
                    else
                        common.addClass self.el, 'ff-show-next'

                    onEndAnimationFn = (e)->
                        # console.log 'end animation'
                        if support.animations
                            this.removeEventListener animEndEventName, onEndAnimationFn

                        common.removeClass innerself.currentField, 'ff-hide'
                        common.removeClass innerself.nextField, 'ff-show'

                        if innerself.isMovingBack
                            common.removeClass innerself.el, 'ff-show-prev'
                        else
                            common.removeClass innerself.el, 'ff-show-next'

                        if innerself.options.ctrlNavNumbers
                            innerself.currentNavNumber.innerHTML = innerself.nextNavNumber.innerHTML
                            innerself.ctrlNavNumberCt.removeChild innerself.nextNavNumber

                        innerself.currentIdx = innerself.nextIdx
                        innerself.currentField = innerself.nextField
                        innerself.currentNavDot = innerself.nextNavDot

                        innerself._focusOnCurrentFieldInput()

                        innerself.isBusy = innerself.isAnimating = false
                        true

                    # console.log animEndEventName
                    if support.animations
                        self.nextField.addEventListener animEndEventName, onEndAnimationFn
                    else
                        onEndAnimationFn()

                    true
            true

        _focusOnCurrentFieldInput: (el) ->
            # console.log this.currentField
            if el == undefined
                #explicitly selecting type to ensure a hidden input isn't selected
                el = this.currentField.querySelector('input[type="text"]') || this.currentField.querySelector('input[type="password"]') || this.currentField.querySelector('input[type="radio"]') || this.currentField.querySelector('input[type="checkbox"]') || this.currentField.querySelector('select') || this.currentField.querySelector('textarea')

            # if not element to focus in on
            if not el
                return

            switch el.tagName.toLowerCase()
                when 'select'
                    el.focus()
                when "input"
                    type = el.type.toLowerCase()
                    switch type
                        when 'radio', 'checkbox', 'button'
                            el.focus()
                        when 'text', 'textarea', 'password'
                            el.select()
            true

        _showField: (pos)->
            if pos == this.current or pos < 0 or pos > this.fieldsCount - 1
                return false
            this._nextField pos
            true

        _updateFieldNumber: ()->
            if this.options.ctrlNavNumbers

                this.nextNavNumber = document.createElement 'span'
                this.nextNavNumber.className = 'ff-number-new'
                this.nextNavNumber.innerHTML = Number this.nextIdx + 1

                # insert it in the DOM
                this.ctrlNavNumberCt.appendChild this.nextNavNumber
            true

        _progress: ()->
            if this.options.ctrlNavProgress
                this.ctrlProgress.style.width = this.nextIdx * ( 100 / this.fieldsCount ) + '%'
            true

        _updateNav: ()->
            if this.options.ctrlNavDots
                common.removeClass this.currentNavDot, 'ff-dot-current'
                common.addClass this.nextNavDot, 'ff-dot-current'
                this.nextNavDot.disabled = false

                lastDataDependantIdx = undefined
                # Find any data-dependant markers
                if this.isMovingBack
                    for i in [this.fieldsCount - 1...this.nextIdx] by -1
                        if this.fields[i].hasAttribute 'data-dependant'
                            lastDataDependantIdx = i

                    if lastDataDependantIdx != undefined
                        for i in [this.fieldsCount - 1...lastDataDependantIdx] by -1
                            this.ctrlNavDots[i].disabled = true
            true

        _showCtrl: (ctrl)->
            if ctrl and ctrl != undefined
                common.addClass ctrl, 'ff-show'
            true

        _hideCtrl: (ctrl)->
            if ctrl and ctrl != undefined
                common.removeClass ctrl, 'ff-show'
            true

        _validate: (callback)->

            if not this.currentField or this.currentField == undefined
                callback false

            # we will try to match up the validation rule based onthe field:
            # name, then id
            id = this.currentField.getAttribute "data-validation-id"

            # if no id then no validation on field
            if not id or id == undefined
                callback true

            validator = this.options.validators[id]

            # if field has a validation id but no rule/function then return false
            # erroring on the side of caution that it should be validated
            if validator == undefined
                this._showError 'Field contains a validation ID but no validator was passed to the form!!!'
                callback false

            self = this
            results = validator this.currentField, (results) ->
                if results.error
                    self._showError results.message
                    callback(false)
                    false
                else
                    callback(true)
                    true

            true

        _showSuccess: (message)->

            this.msgSuccess.innerHTML = message
            common.evalInnerHtmlJavascript this.msgSuccess
            this._showCtrl this.msgSuccess
            true

        _showError: (message)->

            this.msgError.innerHTML = message
            common.evalInnerHtmlJavascript this.msgError
            this._showCtrl this.msgError
            true

        _clearError: ()->
            this._hideCtrl this.msgError
            true

        _clearSuccess: ()->
            this._hideCtrl this.msgSuccess
            true
