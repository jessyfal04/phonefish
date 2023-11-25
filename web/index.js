


function chargerScores() {
    const Http = new XMLHttpRequest();
    const url='http://localhost:5000/scores/all';
    Http.open("GET", url);
    Http.send();

    Http.onreadystatechange = (e) => {
        document.getElementById("score-list").innerHTML = "";
        data = JSON.parse(Http.responseText)
        for (let index = 0; index < Math.min(3, data.length); index++) {
            document.getElementById("score-list").innerHTML += 
            `<div class="box">
                ${data[index].pseudo}<i>#${data[index].identifier}</i>
                <span class="tag is-medium is-rounded">${data[index].score}</span>
            </div>`
        }
    }
}   

chargerScores();