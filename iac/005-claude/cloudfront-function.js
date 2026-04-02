// CloudFront Function: Add Security Headers
// Executes on viewer requests to add security headers

function handler(event) {
    var request = event.request;
    var headers = request.headers;

    // Add security headers
    headers['x-content-type-options'] = { value: 'nosniff' };
    headers['x-frame-options'] = { value: 'SAMEORIGIN' };
    headers['x-xss-protection'] = { value: '1; mode=block' };
    headers['referrer-policy'] = { value: 'no-referrer-when-downgrade' };
    headers['permissions-policy'] = { value: 'geolocation=(), microphone=(), camera=()' };

    return request;
}
