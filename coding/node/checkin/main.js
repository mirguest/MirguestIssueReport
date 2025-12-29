require('dotenv').config();

const { ProxyAgent } = require('undici');


let fetch;
if (typeof globalThis.fetch === 'function') {
    fetch = globalThis.fetch;
} else {
    fetch = require('node-fetch');
}


const checkin = async() => {
    const apiurl = process.env.APIURL;
    if (!apiurl) return;

    const referer = process.env.REFERER;
    if (!referer) return;

    const cookie = process.env.COOKIE;
    if (!cookie) return;

    const body = process.env.BODY;
    if (!body) return;

    const authorization = process.env.AUTHORIZATION;
    if (!authorization) return;

    const proxyUrl = process.env.HTTPS_PROXY || process.env.HTTP_PROXY;

    
    console.log(`apiurl ${apiurl}`);
    console.log(`cookie ${cookie}`);
    console.log(`body ${body}`);
    if (proxyUrl) {
        console.log(`proxy ${proxyUrl}`);
    }

    let fetchOptions = {
        method: 'POST',
        headers: {
            'authorization': authorization,
            'cookie': cookie,
            'referer': referer,
            'user-agent': 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)',
            'content-type': 'application/json'},
        body: body,
    }

    if (proxyUrl) {
        fetchOptions.dispatcher = new ProxyAgent(proxyUrl);
    }

    const checkin_result = await fetch(apiurl, fetchOptions).then((r) => r.json());

    console.log(`checkin result: ${checkin_result.message}`);
}

const main = async () => {
    await checkin();
}

main();

