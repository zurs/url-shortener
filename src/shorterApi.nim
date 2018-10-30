import json, std/sha1

import shortStorage

const baseURL = "http://localhost:5000/"
const redirectPrefix = "re/"

proc shortUrl*(body: string): JsonNode =
    var selectedHash = ""
    let storage = newShortStorage()
    let node = parseJson(body)
    let urlToHash = node["url"].getStr()
    var hashIsFree = false
    var hashLength = 4
    while not hashIsFree:
        hashLength += 1
        if hashLength <= 20:
            let currentHash = ($secureHash(urlToHash))[0..<hashLength]
            if storage.hashIsFree(currentHash):
                storage.storeNew(currentHash, urlToHash)
                selectedHash = currentHash
                break
    return %*
        {
            "shortUrl": baseURL & redirectPrefix & selectedHash
        }

proc getUrl*(hash: string): string =
    let storage = newShortStorage()
    result = storage.getUrl(hash)
    


    