var mousePressed = false;
var webSocket;
var lastX, lastY;
var ctx;

function openSocket(){
    // Ensures only one connection is open at a time
    if(webSocket !== undefined && webSocket.readyState !== WebSocket.CLOSED){
      // writeResponse("WebSocket is already opened.");
        return;
    }
    // Create a new instance of the websocket
    webSocket = new WebSocket("ws://192.168.200.186:8080/ws/echo");
     //-----------------------------------------------------------------
    webSocket.onopen = function(event){
        if(event.data === undefined)
            return;

       // writeResponse(event.data);
    };

    webSocket.onmessage = function(event){
        
    	//console.log(event.data);
    	var input=event.data.split(",");
    	//console.log(input.length+"mouse"+mousePressed);
    	if(input[0]=="set"){
    		if(input[1]=="1")mousePressed=true;
    		else mousePressed=false;
    		
    	console.log(mousePressed);
    	}
    	else{
    		Draw(input[0],input[1],input[2],input[3],input[4]);
    	
    	}
    	
    };
    
    //function toggleMp(text){mousePressed=text;console.log(mousePressed);}

    webSocket.onclose = function(event){
       console.log("connection closed");
    };
}

function closeSocket(){
    webSocket.close();
}

function InitThis(){
	
	
	ctx=document.getElementById('myCanvas').getContext("2d");

//mousepressed,true/false
//x,y,isDown,color,width,shape
	
	
	/////////////////////////
	
	
////////////////////////


    $('#myCanvas').mousedown(function (e) {
    
        webSocket.send("set,1");
        
        if(e.offsetX) {
           var mouseX = e.offsetX;
            var mouseY = e.offsetY;
        }
        else if(event.layerX) {
         var   mouseX = e.layerX;
           var  mouseY = e.layerY;
        }   
      var coor = mouseX + "," + mouseY;
      webSocket.send(coor+",0,"+$('#selColor').val()+","+$('#selWidth').val());
        
        //webSocket.send(e.pageX - $(this).offset().left+","+e.pageY - $(this).offset().top+",false,"+$('#selColor').val()+","+$('#selWidth').val());
       // Draw(e.pageX - $(this).offset().left, e.pageY - $(this).offset().top, false);
    });

    $('#myCanvas').mousemove(function (e) {
    	console.log(mousePressed);
        if (mousePressed) {
        	

            if(e.offsetX) {
               var mouseX = e.offsetX;
                var mouseY = e.offsetY;
            }
            else if(event.layerX) {
             var   mouseX = e.layerX;
               var  mouseY = e.layerY;
            }   
          var coor = mouseX + "," + mouseY;
          webSocket.send(coor+",1,"+$('#selColor').val()+","+$('#selWidth').val());
        	
        	// webSocket.send(e.pageX - $(this).offset().left+","+e.pageY - $(this).offset().top+",true,"+$('#selColor').val()+","+$('#selWidth').val());
          //  Draw(e.pageX - $(this).offset().left, e.pageY - $(this).offset().top, true);
        }
    });

    $('#myCanvas').mouseup(function (e) {
    	  webSocket.send("set,0");
    //	console.log("inside mouse up"+mousePressed);
       // mousePressed = false;
    	
      
    });
	    $('#myCanvas').mouseleave(function (e) {
        //mousePressed = false;
	    	
        webSocket.send("set,0");
    });

}
function Draw(x, y,isDown,color,width) {
    if (isDown=="1") {
        ctx.beginPath();
        ctx.strokeStyle = color;
        ctx.lineWidth = width;
        ctx.lineJoin = "round";
        ctx.moveTo(lastX, lastY);
        ctx.lineTo(x, y);
        ctx.closePath();
        ctx.stroke();
    }
    lastX = x; lastY = y;
}
