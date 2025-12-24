import {Auth0Client} from '@auth0/auth0-spa-js';
import {Ok, Error} from "./gleam.mjs";
import {AUTH0_DOMAIN, AUTH0_CLIENT_ID, AUTH0_APP_CALLBACK_URL} from "./dev_auth0_config.mjs"

const client = new Auth0Client({
    domain: AUTH0_DOMAIN,
    clientId: AUTH0_CLIENT_ID,
    authorizationParams: {redirect_uri: AUTH0_APP_CALLBACK_URL}
});

export async function init() {
    console.log("auth0_domain:" + AUTH0_DOMAIN)
    console.log("auth0_client_id:" + AUTH0_CLIENT_ID)
    console.log("auth0_redirect_uri:" + AUTH0_APP_CALLBACK_URL)
    return await client.getTokenSilently().then(
        () => new Ok("get tokens succeeded, already logged in"),
        () => {
            return client.loginWithPopup().then(
                () => new Ok("login succeeded"),
                () => new Error("login failed")
            )
        }
    );
}

export async function logout() {
    console.log("logout...")
    return await client.logout().then(
        () => new Ok("logout succeeded"),
        () => new Error("logout failed")
    )
}