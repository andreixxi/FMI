var slideIndex = 1;
showSlides(slideIndex);

function plusSlides(n) {
  showSlides(slideIndex += n);
}

function showSlides(n) {
  var i;
  var slides = document.getElementsByClassName("mySlides");
  if (n > slides.length) {slideIndex = 1}    
    if (n < 1) {slideIndex = slides.length}
      for (i = 0; i < slides.length; i++) {
        slides[i].style.display = "none";  
      }
      slides[slideIndex-1].style.display = "block";  
    }

//top button
//Get the button
var mybutton = document.getElementById("myBtn");

// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function() {scrollFunction()};

function scrollFunction() {
  if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
    mybutton.style.display = "block";
  } else {
    mybutton.style.display = "none";
  }
}

// When the user clicks on the button, scroll to the top of the document
function topFunction() {
  document.body.scrollTop = 0;
  document.documentElement.scrollTop = 0;
}



// galerie imagini
let galleryImages = document.querySelectorAll(".gallery-img"); //colectie-all elements with "gallery-img" class
let getLatestOpenedImg;
let windowWidth = window.innerWidth;//current frame's width

//check if there are imgs
if(galleryImages) {
  //for each element inside do sth
  galleryImages.forEach(function(image, index) {
    image.onclick = function() {
      //get the image in full view(not the thumbnail)
      let getElementsCss = window.getComputedStyle(image);//it gets all the style inside the css
      let getFullImgUrl = getElementsCss.getPropertyValue("background-image");//it gets a specific property(background-image, the acutal url of the img)
      let getImgUrlPos = getFullImgUrl.split("/thumbs/");//it takes the value and splits it, for ex getImgUrlPos[1] = img1.jpg")
      let setNewImgUrl = getImgUrlPos[1].replace('")', '');//it replaces )" with null, for ex setNewImgUrl = img1

      getLatestOpenedImg = index + 1;

      //the popup window
      let container = document.body;
      let newImgWindow = document.createElement("div");
      container.appendChild(newImgWindow);//applies the div to the body
      newImgWindow.setAttribute("class", "img-window");//we create a class(img-window) for the element
      newImgWindow.setAttribute("onclick", "closeImg()");//when we click on it we close the image with the function
      
      //the image
      let newImg = document.createElement("img"); 
      newImgWindow.appendChild(newImg);
      newImg.setAttribute("src","file://C:/Users/andrei/Desktop/tehniciweb/images/3/gallery/" + setNewImgUrl);//setNewImgUrl este chiar numele imaginii
      newImg.setAttribute("id", "current-img");

      //wait for the image to load before running the following code
      newImg.onload = function() {
      let imgWidth = this.width; //img's width
      let calcImgToEdge = ((windowWidth - imgWidth) / 2) - 80;//distance from the img to the browser's border

      //pt butoane
      let newNextBtn = document.createElement("a"); //ancora
      let btnNextText = document.createTextNode("Next");//text pt buton
      newNextBtn.appendChild(btnNextText);
      container.appendChild(newNextBtn);
      newNextBtn.setAttribute("class","img-btn-next");
      newNextBtn.setAttribute("onclick", "changeImg(1)");
      newNextBtn.style.cssText = "right: " + calcImgToEdge + "px;"; //pt a pozitiona butonul de next

      let newPrevBtn = document.createElement("a"); //ancora
      let btnPrevText = document.createTextNode("Prev");//text pt buton
      newPrevBtn.appendChild(btnPrevText);
      container.appendChild(newPrevBtn);
      newPrevBtn.setAttribute("class","img-btn-prev");
      newPrevBtn.setAttribute("onclick", "changeImg(0)");
      newPrevBtn.style.cssText = "left: " + calcImgToEdge + "px;";
    }
  } 
}); 
}


function closeImg() {
  //it removes the popup window inside the website and the buttons
  document.querySelector(".img-window").remove();
  document.querySelector(".img-btn-next").remove();
  document.querySelector(".img-btn-prev").remove();
}

function changeImg(changeDirection) {
  document.querySelector("#current-img").remove();

  let getImgWindow = document.querySelector(".img-window");
  let newImg = document.createElement("img");
  getImgWindow.appendChild(newImg);

  let calcNewImg; 
  //next
  if(changeDirection == 1) {
    calcNewImg = getLatestOpenedImg + 1;
    if(calcNewImg > galleryImages.length) {
      calcNewImg = 1;
    }
  }
  //prev
  else if (changeDirection == 0) {
    calcNewImg = getLatestOpenedImg - 1;
    if(calcNewImg < 1) {
      calcNewImg = galleryImages.length;
    }
  }

  newImg.setAttribute("src", "file://C:/Users/andrei/Desktop/tehniciweb/images/3/gallery/img" + calcNewImg + ".jpg");
  newImg.setAttribute("id", "current-img");

  //update the img
  getLatestOpenedImg = calcNewImg;

  //adjust the buttons' position
  newImg.onload = function() {
    let imgWidth = this.width;
    let calcImgToEdge = ((windowWidth - imgWidth) / 2) - 80;

    let nextBtn = document.querySelector(".img-btn-next");
    nextBtn.style.cssText = "right: " + calcImgToEdge + "px;";

    let prevBtn = document.querySelector(".img-btn-prev");
    prevBtn.style.cssText = "left: " + calcImgToEdge + "px;";
  }
}