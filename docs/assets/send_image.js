import { set_image_data } from "./rainbow_filter.js";

function loadImage(e) {
    let file = e.target.files[0];

    let reader = new FileReader();

    reader.onload = e => {
        let img = document.createElement("img");

        img.onload = () => {
            if (img.width >= 2048 || img.height >= 2048) {
                alert("Please upload a smaller image. (This is a browser limitation!)");
                return;
            }

            let canvas = document.createElement("canvas");
            canvas.width = img.width;
            canvas.height = img.height;

            let context = canvas.getContext("2d");
            context.drawImage(img, 0, 0);


            let data = context.getImageData(0, 0, img.width, img.height);
            set_image_data(data);
        }

        img.onerror = () => {
            alert("Could not load image.");
        }

        img.src = e.target.result;
    }

    reader.readAsDataURL(file);
}

window.addEventListener("load", () => {
    document.getElementById("image").oninput = loadImage;
});