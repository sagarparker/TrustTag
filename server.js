const express   = require('express');
const app       = express();
var QRCode = require('qrcode')

const {
    Client,
    PrivateKey,
    AccountId,
    TopicMessageQuery,
    TopicCreateTransaction,
    TopicMessageSubmitTransaction,
} = require("@hashgraph/sdk");


require("dotenv").config();




//EXPRESS PRESET

app.use(express.json());

app.use(express.urlencoded({
    extended: true
}));

app.use(express.text({ limit: '200mb' }));


// Creating a Hedera client

let client;

async function main() {

    //Grab your Hedera testnet account ID and private key from your .env file
    const myAccountId = process.env.MY_ACCOUNT_ID;
    const myPrivateKey = process.env.MY_PRIVATE_KEY;

    // If we weren't able to grab it, we should throw a new error
    if (myAccountId == null ||
        myPrivateKey == null ) {
        throw new Error("Environment variables myAccountId and myPrivateKey must be present");
    }

    // Create our connection to the Hedera network
    // The Hedera JS SDK makes this really easy!
    client = Client.forTestnet();

    client.setOperator(myAccountId, myPrivateKey);
}
main();



// Create a new tag

app.post('/api/createTag',async(req,res)=>{
    try{

        //Create the transaction
        const transaction = new TopicCreateTransaction();

        //Sign with the client operator private key and submit the transaction to a Hedera network
        const txResponse = await transaction.execute(client);

        //Request the receipt of the transaction
        const receipt = await txResponse.getReceipt(client);

        //Get the topic ID
        const newTopicId = receipt.topicId;

        console.log("The TrustTag created with id " + newTopicId);

        QRCode.toDataURL(newTopicId.toString(), function (err, url) {
            res.send(`<img width=300 height=300  src=${url} />`);
        })

    }
    catch(err){
        console.log(err);
        res.status(500).json({
            msg:"There was an error creating a new tag",
            result:false
        })
    }
});

// 0.0.2893354


// Add Data to the tag

app.post('/api/addDataToTag',async(req,res)=>{
    try{

        let message = req.body.message;
        let topicId = req.body.topicId;

        await (
            await new TopicMessageSubmitTransaction()
                .setTopicId(topicId)
                .setMessage(message)
                .execute(client)
        ).getReceipt(client);
        

        //Get the transaction message
        return res.status(200).json({
            result:true,
            msg:"New data added to the tag"
        })

    }
    catch(err){
        console.log(err);
        res.status(500).json({
            msg:"There was an error sending the message",
            result:false
        })
    }
});


// Add Data to the tag

app.get('/api/getTagData/:id',async(req,res)=>{
    try{
        let topicId = req.params.id;


        const query = new TopicMessageQuery().setTopicId(topicId).setStartTime(0);

        const data = new Promise((resolve,reject)=>{
            let dataLedger = {};
            query.subscribe(
                client,
                (message) => {
                    dataLedger[message.consensusTimestamp.toDate()] = Buffer.from(message.contents).toString("utf8");
            });
            setTimeout(() => {
                resolve(dataLedger);
            }, 2000);
           
        });

        data.then((msgs)=>{
            return res.status(200).json({
                result:true,
                msg:"Messages fetched",
                msgs
            });
        }).catch((err)=>{
            return res.status(500).json({
                result:false,
                msg:"There was a problem fetching the messages",
                err
            });
        })
        


    }
    catch(err){
        console.log(err);
        res.status(500).json({
            msg:"There was an error fetching data",
            result:false
        })
    }
});







app.listen(8888,()=>{
    console.log("TrustTag Server running on port 8888");
});