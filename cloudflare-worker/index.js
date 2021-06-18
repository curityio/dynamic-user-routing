import querystring from 'querystring'

addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request))
})

const zonesMap = {
    default: 'idsvr-eu.ngrok.io', // domain for the default region
    eu: 'idsvr-eu.ngrok.io',
    us: 'idsvr-us.ngrok.io'
}

const config = {
    cookieName: 'zone',
    claimName: 'zone'
}

/**
 * Route user to proper zone
 * @param {Request} request
 */
async function handleRequest(request) {
    const zone = await getZoneValue(request)
    const targetHostname = zonesMap[zone] || zonesMap["default"]
    const zonedTargetURL = new URL(request.url)
    zonedTargetURL.hostname = targetHostname

    return await fetch(zonedTargetURL.toString(), request)
}

/**
 * Try to read the zone value from an OAuth request
 */
async function getZoneValue(request) {
    const method = request.method.toLowerCase()

    if (method === 'options' || method === 'head') {
        return null
    }

    // First try to find a value in the zone cookie
    let zone = getZoneFromCookie(request)
    // Otherwise, for POST messages look for a JWT in the form body
    if (zone === null && method === 'post') {
        zone = await getZoneFromForm(request)
    }

    return zone
}

/**
 * Read the zone from a front channel cookie
 */
function getZoneFromCookie(request) {
    if (!request.headers) {
        return null
    }

    const cookies = parseCookieHeader(request.headers.get('Cookie'))
    const zone = cookies[config.cookieName]

    return zone || null
}

function parseCookieHeader(cookies) {
    const parsed = {}
    if (!cookies) {
        return parsed;
    }

    cookies.split(";").forEach(cookie => {
        const splitCookie = cookie.split("=");
        if (splitCookie.length !== 2) { // Skip things which do not look like a proper cookie
            return;
        }

        parsed[splitCookie[0].trim()] = splitCookie[1].trim();
    });

    return parsed;
}

/**
 * Read a token field from a form URL encoded request body
 */
async function getZoneFromForm(request) {
    const body = await request.clone().text()
    const args = querystring.parse(body)
    const wrappedTokenField = getWrappedTokenFieldName(args)

    if (wrappedTokenField !== null) {
        const jwt = args[wrappedTokenField]
        if (jwt) {
            return await getZoneClaimValue(jwt)
        }
    }

    return null
}

/**
 * Try to get the name of the field containing the wrapped token
 */
function getWrappedTokenFieldName(args) {
    if (args['grant_type'] === 'authorization_code') {
        // The authorization code field is a wrapped token
        return 'code'
    } else if (args['grant_type'] === 'refresh_token') {
        // The refresh token field is a wrapped token
        return 'refresh_token'
    } else if (args['token'] && !args['state']) {
        // This includes user info requests and excludes authorize requests
        return 'token'
    }

    return null
}

/**
 * Load the wrapped token / JWT and look for a claim in the payload
 */
async function getZoneClaimValue(wrappedToken) {
    try {
        const jwt = decodeJWT(wrappedToken)
        return jwt[config.claimName] || null
    } catch (err) {
        // Log error
    }

    return null
}

function decodeJWT(jwt) {
    // FIXME - token should verified, at least if it is a well-formed JWT.
    return JSON.parse(Buffer.from(jwt.split(".")[1], 'base64').toString('binary'))
}
