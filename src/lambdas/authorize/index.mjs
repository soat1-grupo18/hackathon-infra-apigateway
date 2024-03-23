import crypto from 'node:crypto';

const { TOKEN_SECRET } = process.env;

export const handler = async (event) => {
    console.info('event: %o', event);

    const { type, methodArn, authorizationToken } = event;

    const authorizationTokenWithoutBearerWord = authorizationToken.replace(/^Bearer /, '');
    const [firstPart, secondPart, thirdPart] = authorizationTokenWithoutBearerWord.split('.');
    const thirdPartConfirmation = crypto.createHmac('sha256', TOKEN_SECRET).update(`${firstPart}.${secondPart}`).digest('base64url')

    const response = {
        policyDocument: {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": "execute-api:Invoke",
                    "Effect": thirdPart == thirdPartConfirmation ? "Allow" : "Deny",
                    "Resource": methodArn
                }
            ]
        }
    };

    console.info('response: %o', response);

    return response;
};
