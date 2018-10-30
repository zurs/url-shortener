import jester, strformat

import shorterApi

discard """proc match(request: Request): Future[ResponseData] {.async.} =
  block route:
    case request.pathInfo
    of "/":
      redirect "/index.html"
    of "/short":
      if(request.reqMethod == HttpPost):
        resp shorterApi.shortUrl(request.body)
      else:
        resp Http400
    of "/@hash?":
      echo("Redirecting")
      if(request.reqMethod == HttpGet and @"hash" != ""):
        let realUrl = shorterApi.getUrl(@"hash")
        redirect realUrl
      else:
        resp Http400
let mySettings = newSettings(Port(8080))
mySettings.staticDir = "public"

var server = initJester(match, mySettings)
server.serve()
"""

proc createRedirectHTML(url: string): string =
  result = fmt"""
    <html>
      <head>
        <meta http-equiv="refresh" content="0; URL={url}" />
      </head>
    </html>
  """


routes:
  get "/":
    request.setStaticDir("public")
    redirect "/index.html"
  post "/short":
    if(request.reqMethod == HttpPost):
      resp shorterApi.shortUrl(request.body)
    else:
      resp Http400
  get "/re/@hash":
    echo("Redirecting")
    if(request.reqMethod == HttpGet and @"hash" != ""):
      echo(@"hash")
      let realUrl = shorterApi.getUrl(@"hash")
      let response = createRedirectHTML(realUrl)
      resp response
    else:
      resp Http401



