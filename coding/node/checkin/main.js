require('dotenv').config();

const checkin = async() => {
    const apiurl = process.env.APIURL;
    if (!apiurl) return;

    const cookie = process.env.COOKIE;
    if (!cookie) return;
    

    console.log(`apiurl ${apiurl}`);
    console.log(`cookie ${cookie}`);

    
}

const main = async () => {
    await checkin();
}

main();

