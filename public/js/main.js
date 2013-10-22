(function() {
  var DoorDuino, KeysDuino, UI;

  $(function() {
    UI.init();
    DoorDuino.init();
    return KeysDuino.init();
  });

  UI = {
    init: function() {
      return this.initNavigation();
    },
    initNavigation: function() {
      var $body, $nav, $trigger;
      $body = $(".main-wrap");
      $nav = $(".main-nav");
      $trigger = $(".icon-nav");
      return $trigger.on("click", function() {
        console.log($nav);
        $body.toggleClass("nav-active");
        return $nav.toggleClass("active");
      });
    }
  };

  DoorDuino = {
    messageDisplay: "#main-alert",
    init: function() {},
    initPusher: function() {
      var channel, pusher;
      pusher = new Pusher("64df34f71aa202a8ec63");
      channel = pusher.subscribe("notification");
      return channel.bind("notify", function(data) {
        return DoorDuino.sendMessage(data.message, data.type);
      });
    },
    sendMessage: function(message, type) {
      var $display;
      $display = $(DoorDuino.messageDisplay);
      $display.text(message);
      return $display.prop("class", type);
    }
  };

  KeysDuino = {
    init: function() {
      return this.initKeyboard();
    },
    initKeyboard: function() {
      var $notes;
      $notes = $(".key");
      return $notes.on("click", this, function(e) {
        var $this, length, note;
        $this = $(this);
        note = $this.data("note");
        length = $this.data("length");
        console.log("note=" + note + "&length=" + length);
        return $.ajax({
          type: "POST",
          url: "/play",
          data: "note=" + note + "&length=" + length,
          success: function() {
            return console.log("Note " + note + " played");
          }
        });
      });
    }
  };

}).call(this);
