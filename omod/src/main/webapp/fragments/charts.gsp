<script>
    jq(function(){
        jq("#chart-left-menu").on("click", ".chart-summary", function(){
            //jq("#chart-detail").html('<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i> <span style="float: left; margin-top: 12px;">Loading...</span>');

            var chartSummary = jq(this);
            jq(".chart-summary").removeClass("selected");
            jq(chartSummary).addClass("selected");
            jq.getJSON('${ ui.actionLink("ipdapp", "charts" ,"getChartDetails") }',
                { 'patientId' : ${patient.patientId}, 'chart' : jq(chartSummary).find(".chart-id").val() }
            ).success(function (data) {

                var ctx = jq("#myChart");
                    var myChart = new Chart(ctx, {
                        type: 'line',
                        data: data,
                        options: {
                            responsive: true,
                            scales: {
                                y: {
                                    beginAtZero: false
                                }
                            }
                        }
                    });

            })
        });



        var chartSummaries = jq(".chart-summary");

        if (chartSummaries.length > 0) {
            chartSummaries[0].click();
            jq('#cs').show();
        }else{
            jq('#cs').hide();
        }

        jq('#chart-left-menu').slimScroll({
            allowPageScroll: false,
            height		   : '426px',
            distance	   : '11px',
            color		   : '#363463'
        });

        jq('#chart-left-menu').scrollTop(0);
        jq('#slimScrollDiv').scrollTop(0);
    });
</script>

<style>
#chart-left-menu {
    border-top: medium none #fff;
    border-right: 	medium none #fff;
}
#chart-left-menu li:nth-child(1) {
    border-top: 	1px solid #ccc;
}
#chart-left-menu li:last-child {
    border-bottom:	1px solid #ccc;
    border-right:	1px solid #ccc;
}
.chart-summary{

}
</style>

<div class="onerow">
    <div id="div-left-menu" style="padding-top: 15px;" class="col15 clear">
        <ul id="chart-left-menu" class="left-menu">
            <li class="menu-item chart-summary" style="border-right:1px solid #ccc; margin-right: 15px; width: 168px; height: 18px;">
                <input type="hidden" class="chart-id" value="morningAndEveningTemperatureChart" >
                <span class="menu-date">
                    <i class="icon-chart"></i>
                    <span id="morningAndEveningTemperatureChart">Temperature Chart</span>
                </span>
                <span class="menu-title">
                    <i class="icon-chart"></i>
                    <span>Morning & Evening</span>
                </span>
                <span class="arrow-border"></span>
                <span class="arrow"></span>
            </li>

            <li class="menu-item chart-summary" style="border-right:1px solid #ccc; margin-right: 15px; width: 168px; height: 18px;">
                <input type="hidden" class="chart-id" value="fourHourTemperatureChart" >
                <span class="menu-date">
                    <i class="icon-chart"></i>
                    <span id="fourHourTemperatureChart">Temperature Chart</span>
                </span>
                <span class="menu-title">
                    <i class="icon-chart"></i>
                    <span>Four Hour</span>
                </span>
                <span class="arrow-border"></span>
                <span class="arrow"></span>
            </li>

            <li style="height: 30px; margin-right: 15px; width: 168px;" class="menu-item"></li>
        </ul>
    </div>

    <div class="col16 dashboard chartsPrintDiv" style="min-width: 78%">

        <div id="printSection">
            <div class="info-section info-body" style="display: flex; flex-direction: column;" id="chart-detail">
                <canvas id="myChart" width="600" height="300"></canvas>
            </div>
        </div>

    </div>
</div>

<div class="main-content" style="border-top: 1px none #ccc;">
    <div id=""></div>
</div>


<div></div>
<div style="clear: both;"></div>
<div style="clear: both;"></div>