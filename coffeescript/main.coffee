$ ->
  UI.init()
  DoorDuino.init()
  KeysDuino.init()

Global =
  appUrl: "http://localhost:3000"

UI =
  init: ->
    @initNavigation()

  initNavigation: ->
    $body = $(".main-wrap")
    $nav = $(".main-nav")
    $trigger = $(".icon-nav")
    $trigger.on "click", ->
      console.log $nav
      $body.toggleClass "nav-active"
      $nav.toggleClass "active"

DoorDuino =
  messageDisplay: "#main-alert"

  init: ->
    @initIo()

  initIo: -> 
    socket = io.connect(Global.appUrl)
    socket.on "connect", (data) ->
      $(".module-connect").remove()
    socket.on "notify", (data) ->
      console.log data
      DoorDuino.setMessage(data.message, data.type)

  setMessage: (message, type) ->
    $display = $(DoorDuino.messageDisplay)
    $display.text message
    $display.prop "class", type

KeysDuino =
  init: ->
    @initKeyboard()

  initKeyboard: ->
    $notes = $(".key")
    $notes.on "click", this, (e) ->
      $this = $(this)
      note = $this.data "note"
      length = $this.data "length"
      console.log "note=#{note}&length=#{length}"

      $.ajax
        type: "POST",
        url: "/play",
        data: "note=#{note}&length=#{length}",
        success: -> console.log "Note #{note} played"