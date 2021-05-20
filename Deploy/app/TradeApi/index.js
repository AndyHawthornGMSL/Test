exports.handler = ProcessRequest;

async function ProcessRequest() {
  return GetResponse(500, "Invalid method");
}
