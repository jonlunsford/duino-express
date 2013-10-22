$ ->
  UI.init()
  DoorDuino.init()
  KeysDuino.init()

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
    # todo replace with socket.io
    # @initPusher()

  initPusher: -> 
    pusher = new Pusher "64df34f71aa202a8ec63"
    channel = pusher.subscribe "notification"
    channel.bind "notify", (data) -> 
      DoorDuino.sendMessage data.message, data.type

  sendMessage: (message, type) ->
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