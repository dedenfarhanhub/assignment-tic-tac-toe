import consumer from "channels/consumer"

consumer.subscriptions.create("GamesChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log('masuk sini')
    console.log(data)
    // Called when there's incoming data on the websocket for this channel
  }
});
