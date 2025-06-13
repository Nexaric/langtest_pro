import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Step 1: Decode Firebase service account
const serviceAccount = JSON.parse(atob(Deno.env.get("GOOGLE_CREDENTIALS_BASE64")!));

// Step 2: Supabase client
const supabase = createClient(
  Deno.env.get("SB_URL")!,
  Deno.env.get("SB_SERVICE_ROLE_KEY")!,
);

// Step 3: Helper to get Firebase access token
async function getAccessToken(serviceAccount: any): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: "RS256", typ: "JWT" };
  const payload = {
    iss: serviceAccount.client_email,
    sub: serviceAccount.client_email,
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
  };

  const encoder = new TextEncoder();
  const jwtHeader = btoa(JSON.stringify(header));
  const jwtPayload = btoa(JSON.stringify(payload));
  const unsignedJwt = `${jwtHeader}.${jwtPayload}`;

  const cryptoKey = await crypto.subtle.importKey(
    "pkcs8",
    str2ab(serviceAccount.private_key),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );

  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    cryptoKey,
    encoder.encode(unsignedJwt),
  );

  const signedJwt = `${unsignedJwt}.${btoa(String.fromCharCode(...new Uint8Array(signature)))}`;

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: signedJwt,
    }),
  });

  const data = await res.json();
  return data.access_token;
}

// Step 4: Utility to convert PEM to ArrayBuffer
function str2ab(pem: string): ArrayBuffer {
  const b64 = pem.replace(/-----[^-]+-----/g, "").replace(/\n/g, "");
  const binary = atob(b64);
  const buffer = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) buffer[i] = binary.charCodeAt(i);
  return buffer.buffer;
}

// Step 5: Main function
serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method Not Allowed", { status: 405 });
  }

  try {
    const { title, message, imageUrl, apiKey } = await req.json();
    const expectedKey = Deno.env.get("NOTI_API_KEY")!;

    if (apiKey !== expectedKey) {
      return new Response(JSON.stringify({ error: "Invalid or missing API key" }), {
        status: 401,
      });
    }

    const { data: users, error } = await supabase
      .from("users")
      .select("fcmToken");

    if (error) {
      console.error("❌ Supabase error:", error.message);
      return new Response(JSON.stringify({ error: error.message }), { status: 500 });
    }

    const tokens = (users ?? [])
      .map((u: any) => u.fcmToken)
      .filter((t: string | null) => !!t);

    if (tokens.length === 0) {
      return new Response(JSON.stringify({ message: "No FCM tokens found" }), { status: 200 });
    }

    const accessToken = await getAccessToken(serviceAccount);

    const response = await fetch(
      `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
      {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          message: {
            notification: {
              title: title ?? "Notification",
              body: message ?? "",
              image: imageUrl ?? undefined,
            },
            tokens,
          },
        }),
      },
    );

    const result = await response.json();
    return new Response(JSON.stringify({ message: "Notification sent", result }), {
      status: 200,
    });
  } catch (err) {
    console.error("🔥 Error:", err);
    return new Response(JSON.stringify({ error: "Internal Server Error" }), { status: 500 });
  }
});
