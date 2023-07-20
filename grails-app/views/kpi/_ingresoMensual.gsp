<div class="col-xl-12">
    <div id="panel-1" class="panel">
        <div class="panel-hdr">
            <h2>
                Ingresos <span class="fw-300"><i>Mensuales</i></span>
            </h2>
            <div class="panel-toolbar">
                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
            </div>
        </div>
        <div class="panel-container show">
            <div class="panel-content">
%{--                <div class="panel-tag">--}%
%{--                   Sólo se consideran las reservas en las cuales se evaluó al usuario.--}%
%{--                </div>--}%
                <div id="js-checkbox-toggles" class="d-flex mb-3">
                    <div class="custom-control custom-switch mr-2">
                        <input type="checkbox" class="custom-control-input" name="gra-0" id="gra-0" checked="">
                        <label class="custom-control-label" for="gra-0">Total</label>
                    </div>
                    <div class="custom-control custom-switch mr-2">
                        <input type="checkbox" class="custom-control-input" name="gra-1" id="gra-1" checked="">
                        <label class="custom-control-label" for="gra-1">Online</label>
                    </div>
                    <div class="custom-control custom-switch mr-2">
                        <input type="checkbox" class="custom-control-input" name="gra-2" id="gra-2" checked="">
                        <label class="custom-control-label" for="gra-2">Manual, Pospago</label>
                    </div>
                </div>
                <div id="flot-toggles" class="w-100 mt-4" style="height: 300px"></div>
            </div>
        </div>
    </div>
</div>

<script>
    /* defined datas */
    var dataTargetProfit = [
        <g:each in="${ingresoTotal}" status="i" var="total">
            [${total[0]}, ${total[1]}],
        </g:each>
    ]
    var dataProfit = [
        <g:each in="${ingresoOnline}" status="j" var="online">
            [${online[0]}, ${online[1]}],
        </g:each>
    ]
    var dataSignups = [
        <g:each in="${ingresoOtros}" status="k" var="otros">
            [${otros[0]}, ${otros[1]}],
        </g:each>
    ]

    var data = [],
        totalPoints = 50;

    $(document).ready(function() {
        /* flot toggle example */
        var flot_toggle = function() {

            var data = [
                {
                    label: "Total",
                    data: dataTargetProfit,
                    color: color.danger._500,
                    bars:
                        {
                            show: true,
                            align: "center",
                            barWidth: 30 * 30 * 30 * 1000 * 40,
                            lineWidth: 0,
                            fillColor:
                                {
                                    colors: [color.danger._900, color.danger._100]
                                }
                        },
                    highlightColor: 'rgba(255,255,255,0.3)',
                    shadowSize: 0
                },
                {
                    label: "Online",
                    data: dataProfit,
                    color: color.info._500,
                    lines:
                        {
                            show: true,
                            lineWidth: 5
                        },
                    shadowSize: 0,
                    points:
                        {
                            show: true
                        }
                },
                {
                    label: "Otros",
                    data: dataSignups,
                    color: color.success._500,
                    lines:
                        {
                            show: true,
                            lineWidth: 2
                        },
                    shadowSize: 0,
                    points:
                        {
                            show: true
                        }
                }]

            var options = {
                grid:
                    {
                        hoverable: true,
                        clickable: true,
                        tickColor: '#f2f2f2',
                        borderWidth: 1,
                        borderColor: '#f2f2f2'
                    },
                tooltip: true,
                tooltipOpts:
                    {
                        cssClass: 'tooltip-inner',
                        defaultTheme: false
                    },
                xaxis:
                    {
                        mode: "time"
                    },
                yaxes:
                    {
                        tickFormatter: function(val, axis)
                        {
                            return "$" + val;
                        },
                        max: 1200
                    }

            };

            var plot2 = null;

            function plotNow() {
                var d = [];
                $("#js-checkbox-toggles").find(':checkbox').each(function()
                {
                    if ($(this).is(':checked'))
                    {
                        d.push(data[$(this).attr("name").substr(4, 1)]);
                    }
                });
                if (d.length > 0)
                {
                    if (plot2)
                    {
                        plot2.setData(d);
                        plot2.draw();
                    }
                    else
                    {
                        plot2 = $.plot($("#flot-toggles"), d, options);
                    }
                }

            };

            $("#js-checkbox-toggles").find(':checkbox').on('change', function() {
                plotNow();
            });
            plotNow()
        }
        flot_toggle();
        /* flot toggle example -- end*/

    });
</script>

