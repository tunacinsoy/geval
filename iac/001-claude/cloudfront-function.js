// CloudFront Function to handle directory index redirects
// Redirects requests to /path/ to /path/index.html
// Redirects requests to /path to /path/index.html if directory exists

function handler(event) {
  var request = event.request;
  var uri = request.uri;

  // If the URI ends with a slash, append index.html
  if (uri.endsWith('/')) {
    request.uri += 'index.html';
  }
  // If the URI doesn't have a file extension and doesn't end with slash,
  // try appending index.html (for directory-like URLs)
  else if (!uri.includes('.') && !uri.endsWith('/')) {
    request.uri += '/index.html';
  }

  return request;
}
