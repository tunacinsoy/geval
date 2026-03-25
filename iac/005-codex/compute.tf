resource "aws_cloudfront_function" "image_optimizer" {
  name    = "image-optimizer-function"
  runtime = "cloudfront-js-1.0"

  comment = "Normalize image URLs and set cache tags."

  function_code = <<EOT
function handler(event) {
  var request = event.request;
  var headers = request.headers;
  var deviceWidth = headers["cloudfront-viewer-device-width"];
  var width = deviceWidth ? parseInt(deviceWidth.value, 10) : 768;
  var query = request.querystring || "";
  if (width <= 480 && !query.includes("width=")) {
    request.uri = request.uri + "?width=480";
  }
  request.headers["cache-control"] = { value: "max-age=1800" };
  return request;
}
EOT
}
