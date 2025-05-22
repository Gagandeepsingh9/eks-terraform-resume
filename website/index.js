const count = document.querySelector(".count-number");

async function updateCount() {
    let response = await fetch("https://pjodhvi32ifo6ljb5idwbybbay0dwsfv.lambda-url.ca-central-1.on.aws/");
    let data = await response.json();
    count.innerHTML = `${data}`;
}

updateCount();
