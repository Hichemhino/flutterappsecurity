// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

const fcm = admin.messaging();

const db = admin.database();

export const sendToDevice = functions.database.ref('input_output/{id}')
 .onUpdate(( change,context) => {
    var request = change.after.key;
    console.log('ici fichier json  : ====> requet = ' , request);
    const payload = {
        notification:{
            title:"Alerte Trés Urgente",
            body : "Veuillez voir l'état de voiture est activé",
            badge : '1',
            sound : 'default',
        }
    };
    return fcm.sendToDevice(request, payload);
    /*admin.messaging().sendToDevice(request , payload)
    .then(function(response){
        console.log("Successfully sent message: ",response);
    })
    .catch(function(error){
        console.log("Error sending message: ", error);
    })*/
 })
