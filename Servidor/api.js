// imports
let fs = require('fs');
let db = require("./database.js");

const generateRandomString = (strLength) => {
    const chars = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
    const randomArray = Array.from(
      { length: strLength },
      (_, __) => chars[Math.floor(Math.random() * chars.length)]
    );

    return randomArray.join("");
};

module.exports.login = function login(username, password) {
    let sql = "SELECT token FROM Users WHERE user=? AND password=?";
    let params = [username, password];

    return new Promise((resolve, _) => {
        db.get(sql, params, (err, token) => {
            // make sure the user is valid
            if (err || !token) { resolve(false); return; }

            if (token["token"] === "") {
                sql = "UPDATE Users SET token=? WHERE user=? AND password=?;";
                const newToken = generateRandomString(64);
                params = [newToken, username, password];

                db.run(sql, params, (err) => {
                    // make sure nothing went wrong and send the new token back to the user
                    resolve(err ? false : newToken);
                });
            } else {
                resolve(token["token"]);
            }

            /*if (err) {
                resolve(false);
            } else if (row) {
                if (row["token"] === "") {
                    sql = "UPDATE Users SET token=? WHERE user=? AND password=?;";
                    const token = generateRandomString(64);
                    params = [token, username, password];
    
                    db.run(sql, params, (err, _) => {
                        resolve(err ? false : token);
                    });
                    resolve(token);
                }
                resolve(row["token"]);
            }
            resolve(false);*/
        });
    });
}

module.exports.logout = function logout(authToken) {
    let sql = "SELECT user FROM Users WHERE token=?;";
    let params = [authToken];

    return new Promise((resolve, _) => {
        db.get(sql, params, (err, username) => {
            // make sure the user is valid and loged in
            if (err || !username) { resolve(false); return; }

            sql = 'UPDATE Users SET token="" WHERE user=?;';
            params = [username];
            db.run(sql, params, (err) => {
                // make sure nothing went wrong
                resolve(err ? false : true);
            });
        });
    });
}

module.exports.register = function register(username, password) {
    let sql = "SELECT id FROM Users WHERE user=?;";
    let params = [username];

    return new Promise((resolve, _) => {
        db.get(sql, params, (err, id) => {
            // make sure there is no user with the same username already present in the db
            if (err) { resolve(false); return; }
            if (id)  { resolve("User already exists."); return; }

            // ----- generate all the needed data to create a new user -----
            const newToken = generateRandomString(64);

            // generate random payment cards
            let newCards = [];
            let availableCardNames = ["CREDIT CARD", "PAYPAL", "MB WAY", "VISA"];
            // determine how many cards the user will have
            const numberOfCards = 1 + Math.floor(Math.random() * availableCardNames.length);

            for (let i = 0; i < numberOfCards; i++) {
                // select a name index from the available card names
                let newCardindex = Math.floor(Math.random() * availableCardNames.length);
                // generate a random number from 1000 to 9999 (inclusive)
                const newCardNumber =  1000 + Math.floor(Math.random() * 9000);
                newCards.push(availableCardNames[newCardindex] + ",XXXX - XXXX - XXXX - " + newCardNumber.toString());
                // remove chosen card anme to avoid repetition
                availableCardNames.splice(newCardindex, 1);
            }
            // transform the array into the desired string in the right format
            newCards = newCards.join(";");

            sql = "INSERT INTO Users(user,password,token,paymentCards) VALUES(?,?,?,?);";
            params = [username, password, newToken, newCards];

            db.run(sql, params, (err) => {
                // check if something went wrong and send the new token back to the user
                resolve(err ? false : newToken);
            });
        });
    });

    /*let params = [username, password, newToken];

    return new Promise((resolve, _) => {
        db.run(sql, params, function(err, _) {
            resolve(err ? false : token);
        });
    });*/
}

module.exports.checkToken = function checkToken(token) {
    const sql = "SELECT id FROM Users WHERE token=?";
    const params = [token];

    return new Promise((resolve, _) => {
        db.get(sql, params, function(err, id) {
            // make sure the token is valid and present in the db and return the result
            resolve((err || !id) ? false : true);
        });
    });
}

module.exports.getHomePageData = function getHomePageData(authToken) {
    let sql = "SELECT id FROM Users WHERE token=?;";
    let params = [authToken];

    return new Promise((resolve, _) => {
        db.get(sql, params, (err, id) => {
            // make sure the token is valid
            if (err || !id) { resolve(false); return; }

            sql = 'SELECT * FROM Items WHERE highlighted="yes";';
            params = [];

            db.all(sql, params, (err, highlightedItems) => {
                // make sure we got something back
                if (err || !highlightedItems) { resolve(false); return; }

                sql = 'SELECT * FROM Items WHERE highlighted="no";';
                db.all(sql, params, (err, nonHighlightedItems) => {
                    // make sure we got something back
                    if (err || !nonHighlightedItems) { resolve(false); return; }
                    resolve({"highlighted": highlightedItems, "nonHighlighted": nonHighlightedItems});
                });
            });

            /*if (row) {
                sql = 'SELECT * FROM Items WHERE highlighted="yes";';
                params = [];

                db.all(sql, params, (err, highlightedItems) => {
                    // make sure we got something back
                    if (err || !highlightedItems) { resolve(false); return; }

                    sql = 'SELECT * FROM Items WHERE highlighted="no";';
                    db.all(sql, params, (err, nonHighlightedItems) => {
                        // make sure we got something back
                        if (err || !nonHighlightedItems) { resolve(false); return; }
                        resolve({"highlighted": highlightedItems, "nonHighlighted": nonHighlightedItems});
                    });
                });

                db.all(sql, [], (err, highlightedRows) => {
                    if (err) {
                        resolve(false);
                    } else {
                        sql = 'SELECT * FROM Items WHERE highlighted="no";';

                        db.all(sql, [], (err, nonHighlightedRows) => {
                            if(err) {
                                resolve(false);
                            } else {
                                resolve({"highlighted": highlightedRows, "nonHighlighted": nonHighlightedRows});
                            }
                        });
                    }
                });
            } else {
                resolve(false);
            }*/
        });
    });
}

module.exports.getPaymentInfo = function getPaymentInfo(authToken) {
    let sql = "SELECT user,paymentCards FROM Users WHERE token=?;";
    let params = [authToken];

    return new Promise((resolve, _) => {
        db.get(sql, params, (err, row) => {
            // parse payment data
            // eample data --> "CREDIT CARD,XXXX - XXXX - XXXX - 4958;PAYPAL,XXXX - XXXX - XXXX - 0264"
            // result --> [
            //              { username: 'vipervault' },
            //              { cardNumber: [ 'CREDIT CARD', 'XXXX - XXXX - XXXX - 4958' ] },
            //              { cardNumber: [ 'PAYPAL', 'XXXX - XXXX - XXXX - 0264' ] }
            //            ]

            let data = [{"username": row["user"]}];

            const cardsData = row["paymentCards"].split(";");
            cardsData.forEach(element => {
                let card = {};
                card["cardName"], card["cardNumber"] = element.split(",");
                data.push(card);
            });

            resolve(err ? "error" : data);
        });
    });
}

module.exports.buyProduct = function buyProduct(authToken, itemId, city, street) {
    let sql = "SELECT id FROM Users WHERE token=?;";
    let params = [authToken];

    return new Promise((resolve, _) => {
        // check user authentication and get its id
        db.get(sql, params, (err, userId) => {
            if (err || !userId) { resolve(false); return; }

            // get item name
            sql = "SELECT name FROM Items WHERE id=?"
            params = [itemId];

            db.get(sql, params, (err, name) => {
                if (err || !name) { resolve(false); return; }

                // delete item from items table
                sql = "DELETE FROM Items WHERE id=?;"
                params = [itemId];

                db.run(sql, params, (err) => {
                    if (err) { resolve(false); return; };

                    sql = "INSERT INTO SoldItems(userId,name,cities,currentCity) VALUES(?,?,?,?);"

                    // generate random location data for tracking page
                    let availableCityNames = ["Kolkata Facility", "Chennai Facility", "Kerala Facility", "Huntington Facility"];
                    const numberOfCities = 1 + Math.floor(Math.random() * 4); // max 4 cities

                    // 0 1 2 3
                    // 1 + 0 = 1
                    // 1 + 1 = 2
                    // 1 + 2 = 3
                    // 1 + 3 = 4

                    let citiesNames = [];
                    for (let i = 0; i < numberOfCities; i++) {
                        let cityIndex = Math.floor(Math.random() * availableCityNames.length);
                        citiesNames.push(availableCityNames[cityIndex]);
                        availableCityNames.splice(cityIndex, 1); // remove chosen item to avoid repetition
                    }
                    citiesNames.push(city + " " + street);
                    params = [userId["id"], name["name"], citiesNames.join(';'), Math.floor(Math.random() * numberOfCities)];

                    db.run(sql, params, (err) => {
                        resolve(err ? false : true);
                    });
                });
            });
        });
    });
}

module.exports.getUsername = function getUsername(authToken) {
    const sql = "SELECT user FROM Users WHERE token=?";
    const params = [authToken];

    return new Promise((resolve, _) => {
        db.get(sql, params, (err, row) => {
            // make sure nothing went wrong and sed data to user
            if (err || !row) { resolve(false); return; }
            resolve(row["user"]);
        });
    });
}

module.exports.getBoughtItems = function getBoughtItems(authToken) {
    let sql = "SELECT id FROM Users WHERE token=?";
    let params = [authToken];

    return new Promise((resolve, _) => {
        db.get(sql, params, (err, id) => {
            // make sure nothing is wrong
            if (err || !id) { resolve(false); return; }

            sql = "SELECT name,cities,currentCity FROM SoldItems WHERE userId=?";
            params = [id["id"]];
            db.all(sql, params, (err, items) => {
                // make sure nothing is wrong and return the requested data to the user
                if (err || !items) { resolve(false); return; }
                if (items.length === 0 ) { resolve(items); return; }

                // parse cities list
                items.forEach(element => {
                    element["cities"] = element["cities"].split(";");
                });
                resolve(items);
            });
        });
    });
}

module.exports.uploadItem = function uploadItem(authToken, name, description, price, needsVerification, mainMaterial, condition, originDate, image) {
    let sql = "SELECT id FROM Users WHERE token=?;";
    let params = [authToken];

    return new Promise((resolve, _) => {
        // check if the user is valid
        db.get(sql, params, (err, id) => {
            // make sure nothing went wrong
            if (err || !id) { resolve(false); return; }

            sql = "SELECT id FROM Items WHERE name=?";
            params = [name];

            db.get(sql, params, (err, itemId) => {
                // make sure there wont be two items with the same name
                if (err || itemId) { resolve("Name already being used."); return; }

                // save image
                const imageName = generateRandomString(16); // generate random 16 chars long name
                fs.writeFile("public/images/" + imageName + ".png", image, {"encoding": "base64"}, (err) => {
                    // check for errors
                    if (err) { resolve(false); return; }

                    sql = "INSERT INTO Items(name,imgName,description,price,verified,mainMaterial,condition,originDate,highlighted,sellerId) VALUES(?,?,?,?,?,?,?,?,?,?);";
                    params = [name, imageName + ".png", description, price, (needsVerification ? "yes" : "no"), mainMaterial, condition, originDate, "no", id["id"]];

                    // add item and return to user
                    db.run(sql, params, (err) => {
                        resolve(err ? false : true);
                    });
                });
            });
        });
    });

    /*return new Promise((resolve, _) => {
        // save image
        const imageName = generateRandomString(16); // generate random 16 chars long name
        fs.writeFile("public/images/" + imageName + ".png", image, {"encoding": "base64"}, (err) => {
            if (err) { resolve(false); return; }

            // check if the user is valid
            db.get(sql, params, (err, id) => {
                // make sure nothing went wrong
                if (err || !id) { resolve(false); return; }

                sql = "SELECT id FROM Items WHERE name=?";
                params = [name];

                db.get(sql, params, (err, itemId) => {
                    // make sure there wont be two items with the same name
                    if (err || itemId) { resolve("Name already being used."); return; }

                    sql = "INSERT INTO Items(name,imgName,description,price,verified,mainMaterial,condition,originDate,highlighted,sellerId) VALUES(?,?,?,?,?,?,?,?,?,?);";
                    params = [name, imageName + ".png", description, price, (needsVerification ? "yes" : "no"), mainMaterial, condition, originDate, "no", id["id"]];

                    // add item and return to user
                    db.run(sql, params, (err) => {
                        resolve(err ? false : true);
                    });
                });
            });
        });
    });*/
}

module.exports.scheduleAuction = function scheduleAuction(authToken, name, image, startDate, endDate, initialPrice) {
    let sql = "SELECT id FROM Users WHERE token=?;";
    let params = [authToken];

    return new Promise((resolve, _) => {
        db.get(sql, params, (err, id) => {
            // check for errors
            if (err || !id) { resolve(false); return; }

            sql = "SELECT image FROM Auctions WHERE name=?";
            params = [name];

            db.get(sql, params, (err, itemImage) => {
                // make sure there wont be two auctions with the same name
                if (err || itemImage) { resolve("Name already being used."); return; }

                // save image
                const imageName = generateRandomString(16); // generate random 16 chars long name
                fs.writeFile("public/images/" + imageName + ".png", image, {"encoding": "base64"}, (err) => {
                    // check for errors
                    if (err) { resolve(false); return; }

                    sql = "INSERT INTO Auctions(name,image,startDate,endDate,initialPrice,userId) VALUES(?,?,?,?,?,?);";
                    params = [name, imageName + ".png", startDate, endDate, initialPrice, id["id"]];
                    db.run(sql, params, (err) => {
                        // make sure nothing is wrong
                        resolve(err ? false : true);
                    });
                });
            });
        });
    });
}

module.exports.getUserData = function getUserData(authToken) {
    let sql = "SELECT id FROM Users WHERE token=?;";
    let params = [authToken];

    return new Promise((resolve, _) => {
        db.get(sql, params, (err, id) => {
            // check if user is valid
            if (err || !id) { resolve(false); return; }

            sql = "SELECT name,imgName,price FROM Items WHERE sellerId=?;";
            params = [id["id"]];

            db.all(sql, params, (err, itemsData) => {
                // check if return value is valid
                if (err || !itemsData) { resolve(false); return; }

                sql = "SELECT name,image,startDate,endDate,initialPrice FROM Auctions WHERE userId=?;";
                params = [id["id"]];
                db.all(sql, params, (err, auctionsData) => {
                    // check for errors
                    if (err || ! auctionsData) { resolve(false); return; }

                    resolve({"items": itemsData, "auctions": auctionsData});
                });
            });
        });
    });
}
