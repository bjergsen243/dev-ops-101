function handler(event) {
    var request = event.request;
    var headers = request.headers;
    
    var authUser = '${basic_auth_username}';
    var authPass = '${basic_auth_password}'
    
    // Construct the Basic Auth string
    var authString = 'Basic ' + (authUser + ':' + authPass).toString('base64');
    
    if (
        typeof headers.authorization === "undefined" ||
        headers.authorization.value !== authString
    ) {
        return {
            statusCode: 401,
            statusDescription: "Unauthorized",
            headers: { "www-authenticate": { value: "Basic" } }
        };
    }
    
    return request;
}