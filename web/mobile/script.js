function vibrer(duree) {
    navigator.vibrate([duree]);
}

/*
 * Author: Alex Gibson
 * https://github.com/alexgibson/shake.js
 * License: MIT license
 */


let webSocket = null;
let local = false;

let pseudo;
let identifier;
let code;

var myShakeEvent = new Shake({
    threshold: 15, // optional shake strength threshold
    timeout: 1000 // optional, determines the frequency of event generation
});

function shakeEventDidOccur () {
    vibrer(250);
    webSocket.send(JSON.stringify({"ACTION":"VIBRATE", "ARGS":{"pseudo":pseudo, "identifier":identifier, "code":code}}));
}

window.addEventListener('shake', shakeEventDidOccur);

function connect() {
    if (local)
        webSocket = new WebSocket("ws://localhost:50001");
    else
        webSocket = new WebSocket("wss://jessyfallavier.dev:50001");
    
    webSocket.addEventListener("open", connect_next);
    webSocket.addEventListener("close", connect_next);
}


function connect_next() {
    webSocket.removeEventListener("open", connect_next);
    webSocket.removeEventListener("close", connect_next);

    if (webSocket.readyState == 1) {
        pseudo = document.getElementById("pseudo").value;
        identifier = document.getElementById("identifier").value;
        code = document.getElementById("code").value;

        myShakeEvent.start();
        
        changeCompo(true);
        
        webSocket.send(JSON.stringify({"ACTION":"OPEN", "ARGS":{"pseudo":pseudo, "identifier":identifier, "code":code}}));
    } else {
        plusNotification("danger", "Serveur inaccessible !");
        disconnect();
    }
}


function disconnect() {
    webSocket.close(4200, "Button Disconnect");

    myShakeEvent.stop();
    changeCompo(false);
}

function changeCompo(toConnect) {
    document.getElementById("connect").style.display = toConnect ? "none" : "initial";
    document.getElementById("disconnect").style.display = toConnect ? "initial" : "none";

    document.getElementById("pseudo").disabled = toConnect;
    document.getElementById("identifier").disabled = toConnect;
    document.getElementById("code").disabled = toConnect;
}

function plusNotification(danger, text) {
    var notification = `
    <div class="notification is-${danger}">
      <button class="delete"></button>
      ${text}
    </div>`;
    document.getElementById("notification-list").innerHTML = notification + document.getElementById("notification-list").innerHTML;

    (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
        const $notification = $delete.parentNode;
    
        $delete.addEventListener('click', () => {
          $notification.parentNode.removeChild($notification);
        });
      });
}
