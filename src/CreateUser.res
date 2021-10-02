open Belt
open ApiGateway

let handler = (event: awsAPIGatewayEvent): Js.Promise.t<awsAPIGatewayResponse> => {
  Js.log2("body", Option.isNone(event.body))
  // Convert body to a UTF-8 string if base64-encoded
  let body =
    event.body
    ->Option.map(body =>
      event.isBase64Encoded
        ? body->Buffer.from(~encoding=#base64)->Buffer.toString(~encoding=#utf8)
        : body
    )
    ->Option.flatMap(body => body != "" ? Some(body) : None)

  let response = switch body {
  | Some(body) => {
      let responseBody =
        body
        // Parse the event body with the typesafe RegisterUserRequest decoder
        ->Funicular.Decode.parse(Schema.RegisterUserRequest.decode)
        // Construct the response body
        ->Result.map(message =>
          Schema.RegisterUserResponse.encode({
            user: {
              id: "id",
              name: message.name,
              email: message.email,
              age: message.age,
            },
          })
        )
      switch responseBody {
      | Ok(body) => apiGatewayJsonResponse(200, body)
      | Error(error) => {
        let message = Funicular.Decode.jsonParseErrorToString(error)
        let code = "ParseError"
        apiGatewayJsonResponse(400, Schema.Error.encode({ code, message }));
      }
      }
    }
  | None =>
    apiGatewayJsonResponse(
      400,
      Schema.Error.encode({code: "MissingBody", message: "No request body found"}),
    )
  }
  Js.Promise.resolve(response)
}
