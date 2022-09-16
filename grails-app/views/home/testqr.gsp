<%@ page import="gestion.General" %>
<!DOCTYPE html>
<g:applyLayout name="dashboard">


    <div style="width: 100px">
        <jsqr:scanCanvas/>
    </div>
    <div style="width: 100px">
        <jsqr:scanButton fieldId='urlQr'/>
    </div>

%{--    <g:hiddenField name="urlQr" id="urlQr" onchange="imprimirLink();" />--}%
    <input id="urlQr" />


    <asset:javascript src="jsqrcode/jsqrcode.js"/>

    <asset:javascript src="jsqrcode/grid.js" />
    <asset:javascript src="jsqrcode/version.js" />
    <asset:javascript src="jsqrcode/detector.js" />
    <asset:javascript src="jsqrcode/formatinf.js" />
    <asset:javascript src="jsqrcode/errorlevel.js" />
    <asset:javascript src="jsqrcode/bitmat.js" />
    <asset:javascript src="jsqrcode/datablock.js" />
    <asset:javascript src="jsqrcode/bmparser.js" />
    <asset:javascript src="jsqrcode/datamask.js" />
    <asset:javascript src="jsqrcode/rsdecoder.js" />
    <asset:javascript src="jsqrcode/gf256poly.js" />
    <asset:javascript src="jsqrcode/gf256.js" />
    <asset:javascript src="jsqrcode/decoder.js" />
    <asset:javascript src="jsqrcode/qrcode.js" />
    <asset:javascript src="jsqrcode/findpat.js" />
    <asset:javascript src="jsqrcode/alignpat.js" />
    <asset:javascript src="jsqrcode/databr.js" />
    <script>
        function consultarQr(id) {
            console.log( document.getElementById(id).value );
        }
    </script>

</g:applyLayout>
