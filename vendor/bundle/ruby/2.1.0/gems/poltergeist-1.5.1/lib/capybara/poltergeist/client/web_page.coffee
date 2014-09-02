class Poltergeist.WebPage
  @CALLBACKS = ['onAlert', 'onConsoleMessage', 'onLoadFinished', 'onInitialized',
                'onLoadStarted', 'onResourceRequested', 'onResourceReceived',
                'onError', 'onNavigationRequested', 'onUrlChanged', 'onPageCreated']

  @DELEGATES = ['open', 'sendEvent', 'uploadFile', 'release', 'render', 'renderBase64', 'goBack', 'goForward']

  @COMMANDS  = ['currentUrl', 'find', 'nodeCall', 'documentSize', 'beforeUpload', 'afterUpload']

  @EXTENSIONS = []

  constructor: (@native) ->
    @native or= require('webpage').create()

    @_source         = null
    @_errors         = []
    @_networkTraffic = {}
    @_temp_headers   = {}
    @frames          = []

    for callback in WebPage.CALLBACKS
      this.bindCallback(callback)

  for command in @COMMANDS
    do (command) =>
      this.prototype[command] =
        (args...) -> this.runCommand(command, args)

  for delegate in @DELEGATES
    do (delegate) =>
      this.prototype[delegate] =
        -> @native[delegate].apply(@native, arguments)

  onInitializedNative: ->
    @_source = null
    @injectAgent()
    this.removeTempHeaders()
    this.setScrollPosition(left: 0, top: 0)

  injectAgent: ->
    if @native.evaluate(-> typeof __poltergeist) == "undefined"
      @native.injectJs "#{phantom.libraryPath}/agent.js"
      for extension in WebPage.EXTENSIONS
        @native.injectJs extension

  injectExtension: (file) ->
    WebPage.EXTENSIONS.push file
    @native.injectJs file

  onConsoleMessageNative: (message) ->
    if message == '__DOMContentLoaded'
      @_source = @native.content
      false

  onLoadStartedNative: ->
    @requestId = @lastRequestId

  onLoadFinishedNative: ->
    @_source or= @native.content

  onConsoleMessage: (message) ->
    console.log(message)

  onErrorNative: (message, stack) ->
    stackString = message

    stack.forEach (frame) ->
      stackString += "\n"
      stackString += "    at #{frame.file}:#{frame.line}"
      stackString += " in #{frame.function}" if frame.function && frame.function != ''

    @_errors.push(message: message, stack: stackString)

  onResourceRequestedNative: (request) ->
    @lastRequestId = request.id

    if request.url == @redirectURL
      @redirectURL = null
      @requestId   = request.id

    @_networkTraffic[request.id] = {
      request:       request,
      responseParts: []
    }

  onResourceReceivedNative: (response) ->
    @_networkTraffic[response.id]?.responseParts.push(response)

    if @requestId == response.id
      if response.redirectURL
        @redirectURL = response.redirectURL
      else
        @_statusCode      = response.status
        @_responseHeaders = response.headers

  setHttpAuth: (user, password) ->
    @native.settings.userName = user
    @native.settings.password = password

  networkTraffic: ->
    @_networkTraffic

  clearNetworkTraffic: ->
    @_networkTraffic = {}

  content: ->
    @native.frameContent

  source: ->
    @_source

  title: ->
    @native.frameTitle

  errors: ->
    @_errors

  clearErrors: ->
    @_errors = []

  statusCode: ->
    @_statusCode

  responseHeaders: ->
    headers = {}
    @_responseHeaders.forEach (item) ->
      headers[item.name] = item.value
    headers

  cookies: ->
    @native.cookies

  deleteCookie: (name) ->
    @native.deleteCookie(name)

  viewportSize: ->
    @native.viewportSize

  setViewportSize: (size) ->
    @native.viewportSize = size

  setPaperSize: (size) ->
    @native.paperSize = size

  scrollPosition: ->
    @native.scrollPosition

  setScrollPosition: (pos) ->
    @native.scrollPosition = pos

  clipRect: ->
    @native.clipRect

  setClipRect: (rect) ->
    @native.clipRect = rect

  elementBounds: (selector) ->
    @native.evaluate(
      (selector) -> document.querySelector(selector).getBoundingClientRect(),
      selector
    )

  setUserAgent: (userAgent) ->
    @native.settings.userAgent = userAgent

  getCustomHeaders: ->
    @native.customHeaders

  setCustomHeaders: (headers) ->
    @native.customHeaders = headers

  addTempHeader: (header) ->
    for name, value of header
      @_temp_headers[name] = value

  removeTempHeaders: ->
    allHeaders = this.getCustomHeaders()
    for name, value of @_temp_headers
      delete allHeaders[name]
    this.setCustomHeaders(allHeaders)

  pushFrame: (name) ->
    if @native.switchToFrame(name)
      @frames.push(name)
      true
    else
      false

  pages: ->
    @native.pagesWindowName

  popFrame: ->
    @frames.pop()
    @native.switchToParentFrame()

  getPage: (name) ->
    page = @native.getPage(name)
    new Poltergeist.WebPage(page) if page

  dimensions: ->
    scroll   = this.scrollPosition()
    viewport = this.viewportSize()

    top:    scroll.top,  bottom: scroll.top  + viewport.height,
    left:   scroll.left, right:  scroll.left + viewport.width,
    viewport: viewport
    document: this.documentSize()

  # A work around for http://code.google.com/p/phantomjs/issues/detail?id=277
  validatedDimensions: ->
    dimensions = this.dimensions()
    document   = dimensions.document

    if dimensions.right > document.width
      dimensions.left  = Math.max(0, dimensions.left - (dimensions.right - document.width))
      dimensions.right = document.width

    if dimensions.bottom > document.height
      dimensions.top    = Math.max(0, dimensions.top - (dimensions.bottom - document.height))
      dimensions.bottom = document.height

    this.setScrollPosition(left: dimensions.left, top: dimensions.top)

    dimensions

  get: (id) ->
    new Poltergeist.Node(this, id)

  # Before each mouse event we make sure that the mouse is moved to where the
  # event will take place. This deals with e.g. :hover changes.
  mouseEvent: (name, x, y) ->
    this.sendEvent('mousemove', x, y)
    this.sendEvent(name, x, y)

  evaluate: (fn, args...) ->
    this.injectAgent()
    JSON.parse @native.evaluate("function() { return PoltergeistAgent.stringify(#{this.stringifyCall(fn, args)}) }")

  execute: (fn, args...) ->
    @native.evaluate("function() { #{this.stringifyCall(fn, args)} }")

  stringifyCall: (fn, args) ->
    if args.length == 0
      "(#{fn.toString()})()"
    else
      # The JSON.stringify happens twice because the second time we are essentially
      # escaping the string.
      "(#{fn.toString()}).apply(this, JSON.parse(#{JSON.stringify(JSON.stringify(args))}))"

  # For some reason phantomjs seems to have trouble with doing 'fat arrow' binding here,
  # hence the 'that' closure.
  bindCallback: (name) ->
    that = this
    @native[name] = ->
      if that[name + 'Native']? # For internal callbacks
        result = that[name + 'Native'].apply(that, arguments)

      if result != false && that[name]? # For externally set callbacks
        that[name].apply(that, arguments)

  # Any error raised here or inside the evaluate will get reported to
  # phantom.onError. If result is null, that means there was an error
  # inside the agent.
  runCommand: (name, args) ->
    result = this.evaluate(
      (name, args) -> __poltergeist.externalCall(name, args),
      name, args
    )

    if result.error?
      switch result.error.message
        when 'PoltergeistAgent.ObsoleteNode'
          throw new Poltergeist.ObsoleteNode
        when 'PoltergeistAgent.InvalidSelector'
          [method, selector] = args
          throw new Poltergeist.InvalidSelector(method, selector)
        else
          throw new Poltergeist.BrowserError(result.error.message, result.error.stack)
    else
      result.value

  canGoBack: ->
    @native.canGoBack

  canGoForward: ->
    @native.canGoForward
