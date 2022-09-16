package jsqrcode

class JsqrcodeTagLib {
    //static defaultEncodeAs = 'html'
    //static encodeAsForTags = [tagName: 'raw']
    
    static namespace = 'jsqr'
    
    def scanCanvas = {attrs ->
        out << createScanCanvas()
    }
    
    def scanButton = {attrs ->
        def fieldId = attrs['fieldId'] == null ? 'null' : "'" + attrs['fieldId'] + "'"
		def formId = attrs['formId'] == null ? 'null' : "'" + attrs['formId'] + "'"
		
        out << createScanButton(fieldId, formId)
    }
    
    def scanOnLoad = {attrs ->
        def fieldId = attrs['fieldId'] == null ? 'null' : "'" + attrs['fieldId'] + "'"
		def formId = attrs['formId'] == null ? 'null' : "'" + attrs['formId'] + "'"
		
        out << createScanOnLoad(fieldId, formId)
    }
    
    def createScanCanvas() {
        StringBuilder sb = new StringBuilder()
        sb << """
<video id="jsqr_source" hidden autoplay></video>
<canvas id="qr-canvas" width="640" height="480" hidden></canvas>
<img id="jsqr_display" src="" width="320" height="240" hidden>

<script>
var localMediaStream = null;
var video = document.getElementById("jsqr_source");
var canvas = document.getElementById("qr-canvas");
var display = document.getElementById("jsqr_display");
var canvasContext = canvas.getContext('2d');

function showDisplay() {
    display.hidden = false;
}

function hideDisplay() {
    display.hidden = true;
}

function captureToCanvas() {
    if(localMediaStream) {
        canvasContext.drawImage(video, 0, 0);
        display.src = canvas.toDataURL('image/webp');

        try {
            qrcode.decode();
            canvasContext.clearRect (0, 0, 640, 480);
//            localMediaStream.stop();
            localMediaStream.getTracks().forEach(track => track.stop())
            localMediaStream = null;
            hideDisplay();
            consultarQr('urlQr');
        }
        catch(e) {       
            console.log(e);
            setTimeout(captureToCanvas, 500);
        };
    }
}

function startScan(fieldId, formId) {
    navigator.getUserMedia  = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;
    if (navigator.getUserMedia) {
        qrcode.callback = function(text) {document.getElementById(fieldId).value=text; if (formId != null) document.forms[formId].submit();};
        navigator.getUserMedia({video: true}, function(stream) {
            this.video.srcObject = stream;
            localMediaStream = stream;
            showDisplay();
            captureToCanvas();
        }, function(e) {console.log('Reeeejected!', e);});
    }
}
</script>
"""
        sb.toString()
    }
    //             video.src = window.URL.createObjectURL(stream);  ESTO VA EN LA LINEA 73

    def createScanButton(fieldId, formId) {
        StringBuilder sb = new StringBuilder()
        sb << """<button type='button' onClick="startScan(${fieldId}, ${formId})">Scan</button>"""
        sb.toString()
    }
    
    def createScanOnLoad(fieldId, formId) {
        StringBuilder sb = new StringBuilder()
        sb << """
<script>
window.addEventListener ?
window.addEventListener("load", function(){startScan(${fieldId}, ${formId});}, false) :
window.attachEvent && window.attachEvent("onload", function(){startScan(${fieldId}, ${formId});});
</script>"""
        sb.toString()
    }
}
