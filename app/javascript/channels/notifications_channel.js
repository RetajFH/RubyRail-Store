import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("✅ Connected to NotificationsChannel")
  },

  received(data) {
    console.log("📩 Received data:", data)
    const container = document.getElementById("live-notifications")
    if (!container) return

    const toast = document.createElement("div")
    toast.className = "live-toast"
    toast.textContent = `${data.product.name} is back in stock — $${data.product.price}`
    container.prepend(toast)

    setTimeout(() => toast.remove(), 6000)
  }
});