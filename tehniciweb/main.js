function showDate() {
            var count = 1;
            setInterval(function(param1) {
                if (count < 2) {
                    count++;
                    var d = Date(Date.now()); // Use of Date.now() function 
                    var a = d.toString() // Converting the number of millisecond in date string 
                    alert("The current date is: " + a + param1); // Alert the current date
                } else {
                    clearInterval(this);
                }
            }, 3000, " SO WHAT NOW?");
        }
        showDate();

        var slideIndex = 0;
        var slideIndex2 = 0;
        var slideIndex3 = 0;
        carousel();

        function carousel() {
            var i;
            var x = document.getElementsByClassName("mySlides1");
            for (i = 0; i < x.length; i++) {
                x[i].style.display = "none";
            }
            slideIndex++;
            if (slideIndex > x.length) {
                slideIndex = 1
            }
            x[slideIndex - 1].style.display = "block";

            var y = document.getElementsByClassName("mySlides2");
            for (i = 0; i < y.length; i++) {
                y[i].style.display = "none";
            }
            slideIndex2++;
            if (slideIndex2 > y.length) {
                slideIndex2 = 1
            }
            y[slideIndex2 - 1].style.display = "block";

            var z = document.getElementsByClassName("mySlides3");
            for (i = 0; i < z.length; i++) {
                z[i].style.display = "none";
            }
            slideIndex3++;
            if (slideIndex3 > z.length) {
                slideIndex3 = 1
            }
            z[slideIndex3 - 1].style.display = "block";

            setTimeout(carousel, 3000); // Change image every 3 seconds
        }

        function toggleClass(el) {
            if (el.className == "title") {
                el.className = "newTitle";
            } else {
                el.className = "title";
            }
        }

        function changeInfo(el) {
            if (el.classList.contains("c1")) {
                el.classList.add('c2');
                el.classList.remove("c1");
            } else {
                el.classList.add('c1');
                el.classList.remove('c2');
            }

            var info = document.getElementById("info");
            var myString = info.textContent;
            //var obj = JSON.parse(myString);
            if (myString == 'Made by: Andrei Lungu') {
                info.innerHTML = 'email: andreixxi@yahoo.com';
            } else if (myString == 'email: andreixxi@yahoo.com') {
                info.innerHTML = 'Made by: Andrei Lungu';
            }
        }

        function getInputValue() {
            // Selecting the input element and get its value 
            var inputVal = document.getElementById("myInput").value;
            if (inputVal == "yes" || inputVal == "YES") {
                show();
            } else if (inputVal == "no" || inputVal == "NO") {
                hide();
            }
        }

        function hide() {
            document.getElementById('div1').style.display = 'none';
        }

        function show() {
            document.getElementById('div1').style.display = 'block';
        }

        function watch(e) {
            var inputVal = document.getElementById("myInput2").value;
            var radios = document.getElementsByName('kdrama');
            if (inputVal == "yes" || inputVal == "YES") {
                for (r of radios) {
                    if (r.checked) {
                        //window.open(url); //it opens in a new window
                        if (r.value == 'Children of nobody') {
                            window.open('https://en.wikipedia.org/wiki/Children_of_Nobody');
                        } else if (r.value == 'Moon Lovers: Scarlet Heart Ryeo') {
                            window.open('https://en.wikipedia.org/wiki/Moon_Lovers:_Scarlet_Heart_Ryeo');
                        } else {
                            window.open('https://en.wikipedia.org/wiki/My_Father_is_Strange');
                        }
                    }
                }
            }
            //input =="no"
            for (r of radios) {
                if (r.checked) {
                    localStorage.setItem("radio", r.value);
                }
            }
            let R = localStorage.getItem("radio");
        }

        function ceva() {
            //serialul ales inainte de refresh
            var R = localStorage.getItem("radio");
            return R;
        }

        const ul = document.getElementsByTagName('ul')[0];
        for (let i = 0; i < ul.children.length; i++) {
            ul.children[i].style.display = "table"; //pt a colora doar cat este scris 
            ul.children[i].style.background = getRandomColor();
        }
        ul.parentElement.style.background = "snow";

        function getRandomColor() {
            var letters = '0123456789ABCDEF';
            var color = '#';
            for (var i = 0; i < 6; i++) {
                color += letters[Math.floor(Math.random() * 16)]; //int in [0,16]
            }
            return color;
        }

        var str = '{"n1":"🧒"}';
        var obj = JSON.parse(str);
        document.getElementById("caption1").innerHTML += obj.n1;

        if (typeof(Storage) !== "undefined") {
            //store
            localStorage.setItem("n2", "🌑");
            //retrieve
            document.getElementById("caption2").innerHTML += localStorage.getItem("n2");
        } else {
            var str = '{"n2":"🌑"}';
            var obj = JSON.parse(str);
            document.getElementById("caption2").innerHTML += obj.n2;
        }

        var ob = {
            n: "👪"
        };
        var txt = JSON.stringify(ob);
        localStorage.setItem("n", txt.substring(7, 8));
        // alert(localStorage.getItem("n"));
        document.getElementById("caption3").innerHTML += ob.n;

        // localStorage.setItem("n", txt.substring(7, 8));
        // document.getElementById("caption3").innerHTML += localStorage.getItem("n");

        /*addEventListener("click", myFunction(), true); true: the event handler is executed in the capturing phase(the event is first captured by the outermost element(ancestors) and propagated to the inner elements(children).)exterior->interior */

        document.getElementById("myimg").addEventListener("click", function() {
            alert("You clicked the img element!");
        }, true);

        document.getElementById("myDiv").addEventListener("click", function() {
            alert("You clicked the DIV element!");
        }, true);

        function allowDrop(ev) {
            ev.preventDefault();
        }

        function drag(ev) {
            //the data type is "text" and the value is the id of the draggable element ("drag1").
            ev.dataTransfer.setData("text", ev.target.id);
            // ev.target.id="img2";
        }

        function drop(ev) {
            ev.preventDefault();
            var data = ev.dataTransfer.getData("text");
            // var res = data.replace(data, "img2");
            // alert(typeof data);
            ev.target.appendChild(document.getElementById(data)); //target -> Returns the element that triggered the event
        }