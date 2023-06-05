// imports
let express = require("express");
let app = express();
let db = require("./database.js");
let api = require("./api.js")

// config json parsing for body json data
app.use(express.json({'limit': '50mb'}));

// config static file serving
app.use(express.static('public'))

// server config
const HTTP_PORT = 8000;
app.listen(HTTP_PORT, () => {
    console.log("Server running on port PORT.".replace("PORT", HTTP_PORT));
});

app.post("/api/login", async function(req, res, _) {
    // make sure we have a valid data
    if ("username" in req.body && "password" in req.body) {
        if (typeof(req.body["username"]) !== "string" || typeof(req.body["password"]) !== "string") {
            res.json({"message": "Something went wrong."});
            return;
        }

        if (req.body["username"] === "" || req.body["password"] === "") {
            res.json({"message": "Please fill in all the boxes."});
            return;
        }

        const result = await api.login(req.body["username"], req.body["password"]);
        res.json({"message": (result ? result : "Invalid credentials.")});
        return;
    }

    res.json({"message": "Something went wrong."});
});

app.post("/api/logout", async function(req, res, _) {
    // make sure we have a valid token
    if ("token" in req.body) {
        if (typeof(req.body["token"]) !== "string") {
            res.json({"message": "Something went wrong."});
            return;
        }

        if (req.body["token"] === "") {
            res.json({"message": "Something went wrong."});
            return;
        }

        const result = await api.logout(req.body["token"]);
        res.json({"message": (result ? "ok" : "Something went wrong.")});
        return;
    }

    res.json({"message": "Something went wrong."});
});

app.post("/api/register", async function(req, res, _) {
    // make sure we have a valid data
    if ("username" in req.body && "password" in req.body && "cmfPassword" in req.body) {
        if (typeof(req.body["username"]) !== "string" || typeof(req.body["password"]) !== "string" || typeof(req.body["cmfPassword"]) !== "string") {
            res.json({"message": "Something went wrong."});
            return;
        }

        if (req.body["username"].trim() === "" || req.body["password"].trim() === "" || req.body["cmfPassword"].trim() === "") {
            res.json({"message": "Please fill in all the boxes."});
            return;
        }

        if (req.body["password"] !== req.body["cmfPassword"]) {
            res.json({"message": "Passwords do not match."});
            return;
        }

        const result = await api.register(req.body["username"].trim(), req.body["password"].trim());
        res.json({"message": result ? result : "Something went wrong."});
        return;
    }

    res.json({"message": "Something went wrong."});
});

app.post("/api/checkToken", async function(req, res, _) {
    // make sure the user sent all the needed data
    if ("token" in req.body) {
        if (typeof(req.body["token"]) !== "string") {
            res.json({"message": "error"});
            return;
        }

        if (req.body["token"] === "") {
            res.json({"message": "error"});
            return;
        }

        const result = await api.checkToken(req.body["token"]);
        res.json({"message": (result ? "ok" : "error")});
        return;
    }

    res.json({"message": "error"});
});

app.post("/api/getPaymentInfo", async function(req, res, _) {
    if ("token" in req.body) {
        if (typeof(req.body["token"]) === "string" && req.body["token"] !== "") {
            const data = await api.getPaymentInfo(req.body["token"]);
            res.json({"message": (data ? data : "error")});
            return;
        }
    }

    res.json({"message": "error"});
});

app.post("/api/buyProduct", async function(req, res, _) {
    // make sure we have valid data to use
    if ("token" in req.body && "itemId" in req.body && "city" in req.body && "street" in req.body && "postalCode" in req.body) {
        // basic data checks
        if (typeof(req.body["token"]) !== "string" || typeof(req.body["itemId"]) !== "number" || typeof(req.body["city"]) !== "string" || typeof(req.body["street"]) !== "string" || typeof(req.body["postalCode"]) !== "string") {
            res.json({"message": "Something went wrong."});
            return;
        }

        if (req.body["token"] === "" || req.body["city"] === "" || req.body["street"] === "" || req.body["postalCode"] === "") {
            res.json({"message": "Please fill in all the boxes."});
            return;
        }

        // basic itemId check
        if (req.body["itemId"] < 1) { res.json({"message": "Something went wrong."}); return; }

        // get data response and return
        const data = await api.buyProduct(req.body["token"], req.body["itemId"], req.body["city"], req.body["street"]);
        res.json({"message": (data ? "ok" : "Something went wrong.")});
        return;
    }

    res.json({"message": "Something went wrong."});
});

app.post("/api/getHomePageData", async function(req, res, _) {
    // make sure we have a valid token
    if ("token" in req.body) {
        if (typeof(req.body["token"]) !== "string") {
            res.json({"message": "Something went wrong."});
            return;
        }

        if (req.body["token"] === "") {
            res.json({"message": "Something went wrong."});
            return;
        }

        const result = await api.getHomePageData(req.body["token"]);
        res.json({"message": (result ? result : "Could not get items.")});
        return;
    }

    res.json({"message": "Something went wrong."});
});

app.post("/api/getUsername", async function(req, res, _) {
    // make sure we have valid data to use
    if ("token" in req.body) {
        if (typeof(req.body["token"]) !== "string") {
            res.json({"message": "Could not get username."});
            return;
        }

        if (req.body["token"] === "") {
            res.json({"message": "Could not get username."});
            return;
        }

        const username = await api.getUsername(req.body["token"]);
        res.json({"message": (username ? username : "Could not get username.")});
        return;
    }

    res.json({"message": "Could not get username."});
});

app.post("/api/getBoughtItems", async function(req, res, _) {
    // make sure we have valid data to use
    if ("token" in req.body) {
        if (typeof(req.body["token"]) !== "string") {
            res.json({"message": "Could not get shipped items."});
            return;
        }

        if (req.body["token"] === "") {
            res.json({"message": "Could not get shipped items."});
            return;
        }

        const boughtItems = await api.getBoughtItems(req.body["token"]);
        if (boughtItems.length === 0) {
            res.json({"message": "No items available."});
        } else {
            res.json({"message": (boughtItems ? boughtItems : "Could not get shipped items.")});
        }
        return;
    }

    res.json({"message": "Could not get shipped items."});
});

app.post("/api/uploadItem", async function(req, res, _) {
    // make sure we have received all the needed data
    if ("token" in req.body && "name" in req.body && "description" in req.body && "price" in req.body && "needsVerification" in req.body && "mainMaterial" in req.body && "condition" in req.body && "originDate" in req.body && "image" in req.body) {
        if (typeof(req.body["token"]) !== "string" || typeof(req.body["name"]) !== "string" || typeof(req.body["description"]) !== "string" || typeof(req.body["price"]) !== "number" || typeof(req.body["needsVerification"]) !== "boolean") {
            res.json({"message": "Something went wrong."});
            return;
        }

        if (typeof(req.body["mainMaterial"]) !== "string" || typeof(req.body["condition"]) !== "string" || typeof(req.body["originDate"]) !== "string" || typeof(req.body["image"]) !== "string") {
            res.json({"message": "Something went wrong."});
            return;
        }

        if (req.body["token"] === "" || req.body["name"] === "" || req.body["description"] === "" || req.body["price"] <= 0 || req.body["mainMaterial"] === "" || req.body["condition"] === "" || req.body["originDate"] === "" || req.body["image"] === "") {
            res.json({"message": "Please provide all the information."});
            return;
        }

        // get the result
        const result = await api.uploadItem(req.body["token"], req.body["name"], req.body["description"], req.body["price"], req.body["needsVerification"], req.body["mainMaterial"], req.body["condition"], req.body["originDate"], req.body["image"]);

        if (!result)  {
            res.json({"message": "Something went wrong."});
            return;
        }

        if (typeof(result) === "string") {
            // send message error to user
            res.json({"message": result});
            return;
        }

        res.json({"message": (result ? "ok" : "Something went wrong.")});
        return;
    }

    res.json({"message": "Something went wrong."});
});

app.post("/api/scheduleAuction", async function(req, res, _) {
    // make sure we have received all the needed data
    if ("token" in req.body && "name" in req.body && "description" in req.body && "needsVerification" in req.body && "mainMaterial" in req.body && "condition" in req.body && "originDate" in req.body && "image" in req.body && "email" in req.body && "message" in req.body && "startDate" in req.body && "endDate" in req.body && "initialPrice" in req.body) {
        if (typeof(req.body["token"]) !== "string" || typeof(req.body["name"]) !== "string" || typeof(req.body["description"]) !== "string" || typeof(req.body["initialPrice"]) !== "number" || typeof(req.body["needsVerification"]) !== "boolean" || typeof(req.body["email"]) !== "string" || typeof(req.body["message"]) !== "string" || typeof(req.body["startDate"]) !== "string") {
            res.json({"message": "Something went wrong."});
            return;
        }
    
        if (typeof(req.body["mainMaterial"]) !== "string" || typeof(req.body["condition"]) !== "string" || typeof(req.body["originDate"]) !== "string" || typeof(req.body["image"]) !== "string" || typeof(req.body["endDate"]) !== "string") {
            res.json({"message": "Something went wrong."});
            return;
        }

        if (req.body["token"] === "" || req.body["name"] === "" || req.body["description"] === "" || req.body["price"] <= 0 || req.body["mainMaterial"] === "" || req.body["condition"] === "" || req.body["originDate"] === "" || req.body["image"] === "") {
            res.json({"message": "Please provide all the information."});
            return;
        }

        const result = await api.scheduleAuction(req.body["token"], req.body["name"], req.body["image"], req.body["startDate"], req.body["endDate"], req.body["initialPrice"]);
        
        if (!result)  {
            res.json({"message": "Something went wrong."});
            return;
        }

        if (typeof(result) === "string") {
            // send message error to user
            res.json({"message": result});
            return;
        }

        res.json({"message": (result ? "ok" : "Something went wrong.")});

        return;
    }
    
    res.json({"message": "Something went wrong."});
});

app.post("/api/getUserData", async function(req, res, _) {
    // make sure the user sent all the needed data
    if ("token" in req.body) {
        if (typeof(req.body["token"]) !== "string") {
            res.json({"message": "error"});
            return;
        }

        if (req.body["token"] === "") {
            res.json({"message": "error"});
            return;
        }

        const result = await api.getUserData(req.body["token"]);
        res.json({"message": (result ? result : "Could not get user data.")});
        return;
    }

    res.json({"message": "Could not get user data."});
});
