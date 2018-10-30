import tables, db_sqlite

const DB_NAME = "shorter.db"

type
    ShortUrlStorage* = ref object
        dbConn: db_sqlite.DbConn

proc newShortStorage*(): ShortUrlStorage  =
    result = ShortUrlStorage(dbConn: open(DB_NAME, "", "", ""))

proc storeNew*(storage: ShortUrlStorage, hash: string, url: string) =
    echo("Storing: ", hash, " => ", url)
    storage.dbConn.exec(sql"INSERT INTO urls (hash, url) VALUES (?, ?)",
        hash, url)

proc getUrl*(storage: ShortUrlStorage, hash: string): string =
    result = storage.dbConn.getValue(sql"SELECT url FROM urls WHERE hash = ?", hash)

proc hashIsFree*(storage: ShortUrlStorage, hash: string): bool =
    result = (storage.getUrl(hash) == "")


when isMainModule:
    let conn = db_sqlite.open(DB_NAME, "", "", "")
    conn.exec(sql"""
        CREATE TABLE urls (
            hash VARCHAR(255) PRIMARY KEY,
            url VARCHAR(1024) NOT NULL
        )    
    """)

