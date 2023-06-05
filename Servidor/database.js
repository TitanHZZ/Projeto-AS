// imports
let sqlite3 = require("sqlite3").verbose();

// db config
const DBSOURCE = "database.db";

let db = new sqlite3.Database(DBSOURCE, (err) => {
    if (err) {
        // something went wrong
        console.log(err.message);
        throw err;
    } else {
        console.log('Connected to the SQLite database.');

        db.run(`CREATE TABLE Users(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    user TEXT,
                    password TEXT,
                    token TEXT,
                    soldItemsIds TEXT,
                    purchasedItemsIds TEXT,
                    paymentCards TEXT
                );`,
        (err) => {
            if (err) {
                // table already created
                console.log("Users table already present in database.");
            }else{
                // adding default user to database
                console.log("Found database with no Users table. Creating now.");
                let insert = 'INSERT INTO Users (user,password,token,soldItemsIds,purchasedItemsIds,paymentCards) VALUES (?,?,?,?,?,?)'
                db.run(insert, ["vipervault", "vipervault", "", "", "", "CREDIT CARD,XXXX - XXXX - XXXX - 4958;PAYPAL,XXXX - XXXX - XXXX - 0264"])
            }
        });

        console.log("Checking for Items table...");

        // create items table
        db.run(`CREATE TABLE Items(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT,
                    imgName TEXT,
                    description TEXT,
                    price REAL,
                    verified TEXT,
                    mainMaterial TEXT,
                    condition TEXT,
                    originDate TEXT,
                    highlighted TEXT,
                    sellerId INTEGER
                );`,
        (err) => {
            if (err) {
                console.log("Items table already existant!");
            } else {
                console.log("Found no Items table, creating now.");

                // add predefined items to database
                insert = "INSERT INTO Items(name,imgName,description,price,verified,mainMaterial,condition,originDate,highlighted,sellerId) VALUES(?,?,?,?,?,?,?,?,?,?)",
                db.run(insert, ["Camera 1923", "camera1923.png", "An amazing product for everyone interested in antiques.", 10, "no", "Glass", "New", "1923", "no", 1]);
                db.run(insert, ["Car", "car1967.png", "An amazing product for everyone interested in antiques.", 56, "yes", "Steel", "Used", "1967", "no", 1]);
                db.run(insert, ["Card", "card2000.png", "An amazing product for everyone interested in antiques.", 2, "no", "Blue Core", "New", "2000", "no", 1]);

                db.run(insert, ["Necklace", "necklace1807.png", "An amazing product for everyone interested in antiques.", 1, "yes", "Gold", "Used", "1807", "yes", 1]);
                db.run(insert, ["Vase", "vase.png", "An amazing product for everyone interested in antiques.", 2, "no", "Pottery", "New", "1945", "yes", 1]);
                db.run(insert, ["Watch", "watch.png", "An amazing product for everyone interested in antiques.", 6, "yes", "Glass", "Used", "1920", "yes", 1]);
            }
        });

        // create table for sold items
        db.run(`CREATE TABLE SoldItems(
                    userId INTEGER,
                    name TEXT,
                    cities TEXT,
                    currentCity INTEGER
                );`,
        (err) => {
            if (err) {
                // table already created
                console.log("SoldItems table already created!");
            } else {
                console.log("Found no SoldItems table, creating now.");
            }
        });

        // create auctions table
        db.run(`CREATE TABLE Auctions(
                    name TEXT,
                    image TEXT,
                    startDate TEXT,
                    endDate TEXT,
                    initialPrice REAL,
                    userId INTEGER
                );`,
        (err) => {
            if (err) {
                console.log("Auctions table already exists.");
            } else {
                console.log("Found no Auctions table, creating now.");
            }
        });
    }
});

module.exports = db;
