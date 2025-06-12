const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationToAll = functions.https.onRequest(async (req, res) => {
  try {
    const {title, message, imageUrl} = req.body;

    const usersSnapshot = await admin.firestore().collection("users").get();
    const tokens = [];

    usersSnapshot.forEach((doc) => {
      const token = doc.data().fcmToken;
      if (token) tokens.push(token);
    });

    if (tokens.length === 0) {
      return res.status(200).json({message: "No tokens found"});
    }

    const payload = {
      notification: {
        title: title || "Notification",
        body: message || "",
        imageUrl: imageUrl || undefined,
      },
    };

    // Break into batches of 500 tokens
    const BATCH_SIZE = 500;
    const batches = [];

    for (let i = 0; i < tokens.length; i += BATCH_SIZE) {
      const batchTokens = tokens.slice(i, i + BATCH_SIZE);
      batches.push(
          admin.messaging().sendEachForMulticast({
            tokens: batchTokens,
            ...payload,
          }),
      );
    }

    const responses = await Promise.all(batches);
    res.status(200).json({message: "Notifications sent", responses});
  } catch (err) {
    console.error("❌ Error sending notifications:", err);
    res.status(500).json({error: err.message});
  }
});
