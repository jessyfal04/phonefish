

local = false
function fetchData(url, elementId) {
    const Http = new XMLHttpRequest();

    Http.open("GET", url);
    Http.send();

    Http.onreadystatechange = (e) => {
        document.getElementById(elementId).innerHTML = "";
        const data = JSON.parse(Http.responseText);
        for (let index = 0; index < Math.min(3, data.length); index++) {
            document.getElementById(elementId).innerHTML += 
                `<div class="box">
                    ${data[index].pseudo}<i>#${data[index].identifier}</i>
                    <span class="tag is-medium is-rounded">${data[index].score}</span>
                </div>`;
        }
    };
}

function chargerScores() {
    const allUrl = local ? 'http://localhost:5000/scores/all' : 'https://jessyfal04.dev/api/phonefish/scores/all';
    fetchData(allUrl, "score-all-list");

    const recentUrl = local ? 'http://localhost:5000/scores/recent' : 'https://jessyfal04.dev/api/phonefish/scores/recent';
    fetchData(recentUrl, "score-recent-list");
}


chargerScores();