import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { SignJWT, importPKCS8 } from "jose";
import { OAUTH_STATE_COOKIE, sessionCookieOptions } from "@/lib/session";
import { resolveOrigin } from "@/lib/security";

/** Sign in with Apple — client secret is minted server-side from the private key. */
export async function makeClientSecret(clientId: string): Promise<string> {
  const key = await importPKCS8(process.env.APPLE_PRIVATE_KEY!.replace(/\\n/g, "\n"), "ES256");
  return new SignJWT({})
    .setProtectedHeader({ alg: "ES256", kid: process.env.APPLE_KEY_ID! })
    .setIssuer(process.env.APPLE_TEAM_ID!)
    .setIssuedAt()
    .setExpirationTime("10m")
    .setAudience("https://appleid.apple.com")
    .setSubject(clientId)
    .sign(key);
}

export async function GET(req: Request) {
  const clientId = process.env.APPLE_CLIENT_ID;
  const ready = clientId && process.env.APPLE_TEAM_ID && process.env.APPLE_KEY_ID && process.env.APPLE_PRIVATE_KEY;
  const origin = resolveOrigin(req);
  if (!ready) return NextResponse.redirect(`${origin}/login?social=unconfigured`);

  const state = crypto.randomUUID();
  const params = new URLSearchParams({
    client_id: clientId!,
    redirect_uri: `${origin}/api/auth/apple/callback`,
    response_type: "code id_token",
    response_mode: "form_post",
    scope: "name email",
    state,
  });

  const res = NextResponse.redirect(`https://appleid.apple.com/auth/authorize?${params.toString()}`);
  const store = await cookies();
  store.set(OAUTH_STATE_COOKIE, state, { ...sessionCookieOptions(600), maxAge: 600 });
  return res;
}
