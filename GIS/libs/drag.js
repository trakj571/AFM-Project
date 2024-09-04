
// this is simply a shortcut for the eyes and fingers
function $$(id) {
    return document.getElementById(id);
}

var _startX = 0; 		// mouse starting positions
var _startY = 0;
var _offsetX = 0; 		// current element offset
var _offsetY = 0;
var _dragElement; 		// needs to be passed from OnMouseDown to OnMouseMove
var _oldZIndex = 0; 		// we temporarily increase the z-index during drag

function InitDragDrop() {
    document.getElementById('info_title').onmousedown = OnMouseDown;
    document.onmouseup = OnMouseUp;
  
    //document.onmouseout = OnMouseUp;
}

function OnMouseDown(e) {
    // IE is retarded and doesn't pass the event object
    if (e == null)
        e = window.event;

    // IE uses srcElement, others use target
    var target = document.getElementById('info');

    //$("#posbar").html(target.id == 'info' ? 'draggable element clicked' : 'NON-draggable element clicked');

    // for IE, left click == 1
    // for Firefox, left click == 0
    if ((e.button == 1 && window.event != null ||
		e.button == 0) &&
		target.id == 'info') {
        
        // grab the mouse position
        _startX = e.clientX;
        _startY = e.clientY;

        // grab the clicked element's position
        _offsetX = ExtractNumber(target.style.left);
        _offsetY = ExtractNumber(target.style.top);

        // bring the clicked element to the front while it is being dragged
        _oldZIndex = target.style.zIndex;
        target.style.zIndex = 10000;

        // we need to access the element in OnMouseMove
        _dragElement = target;

        // tell our code to start moving the element with the mouse
        document.onmousemove = OnMouseMove;

        // cancel out any text selections
        document.body.focus();

        // prevent text selection in IE
        document.onselectstart = function () { return false; };
        // prevent IE from trying to drag an image
        target.ondragstart = function () { return false; };

        // prevent text selection (except IE)
        return false;
    }
}

function ExtractNumber(value) {
    var n = parseInt(value);

    return n == null || isNaN(n) ? 0 : n;
}

function OnMouseMove(e) {
    if (e == null)
        var e = window.event;

    var scrwd = 1000 - 5;
    if (window.screen.width > 1000)
        scrwd = window.screen.width - 5;
    var h = $(window).height();
    var w = scrwd ? scrwd : $(window).width();

    var x = _offsetX + e.clientX - _startX;
    var y = _offsetY + e.clientY - _startY;
    if (x < 2) x = 2;
    if (x > w - $("#info").width()-3)
        x = w - $("#info").width() - 3;
    if (y < 110) y=110;
    if (y > h - $("#info").height() - 3)
        y = h - $("#info").height() - 3;
            
    _dragElement.style.top = (y) + 'px';
    _dragElement.style.left = (x) + 'px';
}

function OnMouseUp(e) {
    
    if (_dragElement != null) {
        //_dragElement.style.zIndex = _oldZIndex;

        // we're done with these events until the next OnMouseDown
        document.onmousemove = null;
        document.onselectstart = null;
        _dragElement.ondragstart = null;

        // this is how we know we're not dragging
        _dragElement = null;

    }
}
//-->
