# Rescript on AWS Lambda with JSON validation example

An example of using ReScript to write and deploy a simple AWS Lambda application running on API Gateway, using [funicular](https://github.com/chris-armstrong/funicular) for self-validating JSON parsing.

[This blog article](https://www.chrisarmstrong.dev/posts/type-safe-apis-with-rescript) explains it in more detail.

## Prerequisites

* [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html) setup with your AWS credentials
* [NodeJS](https://www.nodejs.org/)

## Build and Deployment

```bash

npm run build

sam package --resolve-s3 --output-template-file template.deploy.yaml

sam deploy --template-file template.deploy.yaml --resolve-s3 --stack-name rescript-example --capabilities CAPABILITY_IAM
```

OR 

Use `npm run develop` for a watchable build server, with `sam local start-api` for a local version of the running API.

## License

Copyright (C) Chris Armstrong 2021

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
