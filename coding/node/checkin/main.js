require('dotenv').config();

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
    
    console.log(`apiurl ${apiurl}`);
    console.log(`cookie ${cookie}`);
    console.log(`body ${body}`);

    const checkin_result = await fetch(apiurl, {
        method: 'POST',
        headers: {
            'authorization': authorization,
            'cookie': cookie,
            'referer': referer,
            'user-agent': 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)',
            'content-type': 'application/json'},
        body: body,
    }).then((r) => r.json());

    console.log(`checkin result: ${checkin_result.message}`);
}

const main = async () => {
    await checkin();
}

main();

