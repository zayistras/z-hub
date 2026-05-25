const KEY_URL =
"https://gist.githubusercontent.com/whoareyou78373/93b844c4ac3614ab16934e5be84a8fff/raw";
const GITHUB_USR = ""; 
const XOR_KEY = "dyzduodzag";

// XOR decode function
function xorDecode(input, key) {
    const inputBytes = Uint8Array.from(atob(input), c => c.charCodeAt(0));
    const keyBytes = new TextEncoder().encode(key);

    const output = inputBytes.map((byte, i) => {
        return byte ^ keyBytes[i % keyBytes.length];
    });

    return new TextDecoder().decode(new Uint8Array(output));
}

export async function onRequestPost({ request }) {
    try {
        const body = await request.json();

        const key = body.key;
        const encodedId = body.id;

        if (!key || !encodedId) {
            return Response.json({ success: false, code: "" });
        }

        // fetch expected key
        const realKey = await fetch(KEY_URL).then(r => r.text());

        if (key !== realKey.trim()) {
            return Response.json({ success: false, code: "" });
        }

        // XOR decode the ID
        let decodedId;
        try {
            decodedId = xorDecode(encodedId, XOR_KEY);
        } catch (e) {
            return Response.json({ success: false, code: "" });
        }

        // fetch gist using decoded id
        const gistURL =
            `https://gist.githubusercontent.com/${GITHUB_USR}/${decodedId}/raw`;

        const gist = await fetch(gistURL);

        if (!gist.ok) {
            return Response.json({ success: false, code: "" });
        }

        const code = await gist.text();

        return Response.json({
            success: true,
            code
        });

    } catch (e) {
        return Response.json({
            success: false,
            code: ""
        });
    }
}