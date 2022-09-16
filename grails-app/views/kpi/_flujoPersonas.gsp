<div class="col-xl-12">
    <div id="panel-2" class="panel">
        <div class="panel-hdr">
            <h2>
                Concurrencia<span class="fw-300"><i></i></span>
            </h2>
            <div class="panel-toolbar">
                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
            </div>
        </div>
        <div class="panel-container show">
            <div class="panel-content">
                <div class="panel-tag">
                    Este gráfico muestra los horarios más concurridos.
                    <small>Sólo se consideran las reservas en las cuales se evaluó al usuario.</small>
                </div>
                <div id="flot-bar" style="width:100%; height:300px;"></div>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function() {

        $.plot('#flot-bar', [
                {
                    data: [
                        <g:each in="${topFlujo}" status="i" var="flujo" >
                            [ ${ flujo[0]} , ${ flujo[1] } ],
                        </g:each>
                    ],
                    bars:
                        {
                            show: true,
                            lineWidth: 0,
                            fillColor: color.success._500,
                            barWidth: .3,
                            align: 'center'
                        }
                }],
            {
                grid:
                    {
                        borderWidth: 0,
                    },
                yaxis:
                    {
                        ticks: {
                            display: false
                        }
                    },
                xaxis:
                    {
                        mode: 'categories',
                        tickColor: 'rgba(0,0,0,0.05)',
                        ticks: [
                            [0, '00am'],
                            [1, '01am'],
                            [2, '02am'],
                            [3, '03am'],
                            [4, '04am'],
                            [5, '05am'],
                            [6, '06am'],
                            [7, '07am'],
                            [8, '08am'],
                            [9, '09am'],
                            [10, '10am'],
                            [11, '11am'],
                            [12, '12pm'],
                            [13, '13pm'],
                            [14, '14pm'],
                            [15, '15pm'],
                            [16, '16pm'],
                            [17, '17pm'],
                            [18, '18pm'],
                            [19, '19pm'],
                            [20, '20pm'],
                            [21, '21pm'],
                            [22, '22pm'],
                            [23, '23pm'],
                        ],
                        font:
                            {
                                color: '#999',
                                size: 9
                            }
                    }
            });

    });
</script>