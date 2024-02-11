    <div class="panel-content">
%{--        <div class="panel-tag">--}%
%{--            We take the flot chart from previous example (above) and add tooltips--}%
%{--        </div>--}%
        <div id="flot-line-curves-alt" style="width:100%; height:300px;"></div>
    </div>
<script>
    /* flot lines curved tooltip */
    var flotLineCurvesAlt = $.plot($('#flot-line-curves-alt'), [
            {
                data: dataSet3,
                label: 'New Customer',
                color: color.danger._500
            },
            {
                data: dataSet4,
                label: 'Returning Customer',
                color: color.success._500
            }],
        {
            series:
                {
                    lines:
                        {
                            show: false
                        },
                    splines:
                        {
                            show: true,
                            tension: 0.4,
                            lineWidth: 1,
                            //fill: 0.4
                        },
                    shadowSize: 0
                },
            points:
                {
                    show: true,
                },
            legend:
                {
                    noColumns: 1,
                    position: 'nw'
                },
            tooltip: true,
            tooltipOpts:
                {
                    cssClass: 'tooltip-inner',
                    defaultTheme: false,
                    shifts:
                        {
                            x: 10,
                            y: -40
                        }
                },
            grid:
                {
                    hoverable: true,
                    clickable: true,
                    borderColor: '#ddd',
                    borderWidth: 0,
                    labelMargin: 5,
                    backgroundColor: '#fff'
                },
            yaxis:
                {
                    min: 0,
                    max: 15,
                    color: '#eee',
                    font:
                        {
                            size: 10,
                            color: '#999'
                        }
                },
            xaxis:
                {
                    color: '#eee',
                    font:
                        {
                            size: 10,
                            color: '#999'
                        }
                }
        });
    /* flot lines curved tooltip -- end */
</script>
