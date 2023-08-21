
<!DOCTYPE html>
<g:applyLayout name="dashboard">
    <asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>
<div id="panel-11" class="panel">
    <div class="panel-hdr">
        <h2>
           vista demo <span class="fw-300"><i></i></span>
        </h2>
        <div class="panel-toolbar">
            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
        </div>
    </div>
    <div class="panel-container show">
        <div class="panel-content row"></div>
    </div>

    <div class="panel-container show">
        <div class="panel-content">
            <!--     PASO UNO: SELECCIONAR LA FECHA
                     PASO DOS: SELECCIONAR EL AMBIENTE
                     PASO TRES: LISTAR LAS MESAS


-->

            <div class="form-group">
                <label class="form-label" for="comision">Selecciona el Ambiente</label>
                <div class="input-group">
                    <g:select name="comision" id="comision" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${comisionList}" noSelection="['':'- Seleccione Ambiente -']"
                              value=""/>
                </div>
            </div>

             <div class="frame-wrap">
                 <div class="demo">
                     <a href="javascript:void(0);" class="btn btn-secondary btn-icon">
                         <i class="fal fa-ban"></i>
                     </a>
                     <a href="javascript:void(0);" class="btn btn-success btn-icon">
                         <i class="fal fa-wheelchair"></i>
                     </a>
                     <a href="javascript:void(0);" class="btn btn-info btn-icon">
                         1
                     </a>

                 </div>
             </div>
        </div>
    </div>
</div>
    <asset:javascript src="/formplugins/select2/select2.bundle.js"/>
    <script>
        $('.select2').select2();
    </script>
</g:applyLayout>
