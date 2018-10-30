var root = document.body

const baseURL = "http://localhost:5000/"
var shortedURL = null;

var shortUrl = function(urlToShort){
    console.log("Sending request with: ");
    console.log({ url: urlToShort });
    console.log("To: " + baseURL + "short")
    m.request({
        method: "POST",
        url: baseURL + "short",
        data: { url: urlToShort }
    })
    .then(function(response){
        shortedURL = response.shortUrl;
    });
}

var Shorter = {
    view: function(){
        let basicSetup = [
            m("h1", "Short a URL!"),
            m("input", {type: "text", id: "urlToShort"}),
            m("button", {
                onclick: function(){
                    shortUrl(document.getElementById("urlToShort").value)
                }
            }, "SHORT ME!")
        ];
        if(shortedURL !== null){
            basicSetup.push(
                m("p", [
                    m("span", "Your URL: "),
                    m("a", {href: shortedURL}, shortedURL)
                ])
            );
        }
        return m("main", basicSetup);
    }
};

m.mount(root, Shorter)