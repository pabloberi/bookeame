
<!DOCTYPE html>
<g:applyLayout name="dashboard">
<div id="panel-11" class="panel">
    <div class="panel-hdr">
        <h2>
            ${empresa} <span class="fw-300"><i></i></span>
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
        <div class="panel-content"id="divEspacios">

            %{--            <div class="card-deck" >--}%
            <g:render template="/espacio/cardEspacioList" model="[espacioList: espacioList]" />
            %{--            </div>--}%
        </div>
    </div>
</div>
</g:applyLayout>