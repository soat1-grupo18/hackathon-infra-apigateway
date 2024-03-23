import crypto from 'node:crypto';

const { TOKEN_SECRET } = process.env;

export const handler = async (event) => {
    try {
        console.info('event: %o', event);

        const response = await internalHandler(event);

        console.info('response: %o', response);

        return response;
    }
    catch (e) {
        console.error(e);

        return {
            'statusCode': 500
        };
    }
};

function internalHandler(event) {
    const { cpf } = JSON.parse(event.body);

    const firstPart = Buffer.from(JSON.stringify({ "alg": "HS256", "typ": "JWT" })).toString('base64url');
    const secondPart = Buffer.from(JSON.stringify({ "cpf": cpf })).toString('base64url');
    const thirdPart = crypto.createHmac('sha256', TOKEN_SECRET).update(`${firstPart}.${secondPart}`).digest('base64url');

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'isBase64Encoded': false,
        'body': JSON.stringify({
            'access_token': `${firstPart}.${secondPart}.${thirdPart}`,
            'type': 'Bearer'
        })
    }; 
}
