%{--{{#if appFooter}}--}%
<!-- BEGIN Page Footer -->

<footer class="page-footer hidden-sm-down" role="contentinfo">
    <div class="d-flex align-items-center flex-1 text-muted">
        <span class="hidden-md-down fw-700">%{--{{{copyright}}}--}%</span>
    </div>
    <div>
        <ul class="list-table m-0">
%{--            <li><a href="https://bookeame.cl/" class="text-secondary fw-700">Nosotros</a></li>--}%
            <li class="pl-3"><a href="https://bookeame.cl/privacidad.php" class="text-secondary fw-700" target="_blank">Politicas de Privacidad</a></li>
            <sec:ifAnyGranted roles="ROLE_ADMIN">
                <li class="pl-3"><a href="https://bookeame.cl/" class="text-secondary fw-700" target="_blank">Manual</a></li>
            </sec:ifAnyGranted>
            <li class="pl-3 fs-xl"><a href="https://bookeame.cl/#contactanos" class="text-secondary" target="_blank"><i class="fal fa-question-circle" aria-hidden="true"></i></a></li>
        </ul>
    </div>
</footer>
<!-- END Page Footer -->
%{--{{/if}}--}%
