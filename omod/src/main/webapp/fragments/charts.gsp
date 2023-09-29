<script>
    jq(function(){
        jq("#ul-left-menu").on("click", ".visit-summary", function(){
            jq("#visit-detail").html('<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i> <span style="float: left; margin-top: 12px;">Loading...</span>');
            jq("#drugs-detail").html("");
            jq("#opdRecordsPrintButton").hide();

            var visitSummary = jq(this);
            jq(".visit-summary").removeClass("selected");
            jq(visitSummary).addClass("selected");
            jq.getJSON('${ ui.actionLink("ipdapp", "visitSummary" ,"getVisitSummaryDetails") }',
                { 'encounterId' : jq(visitSummary).find(".encounter-id").val() }
            ).success(function (data) {
                // console.log(data.notes);

                if (data.drugs.length > 0) {
                    var drugsTemplate =  _.template(jq("#drugs-template").html());
                    jq("#drugs-detail").html(drugsTemplate(data));
                }
                else {
                    var drugsTemplate =  _.template(jq("#empty-template").html());
                    jq("#drugs-detail").html(drugsTemplate(data));
                }

                jq("#opdRecordsPrintButton").show(100);

                var cd_html = ''
                Object.keys(data.notes).map(function (kd) {
                    cd_html += '<div style="display: flex;flex-direction: row;">'
                    cd_html += '<label style="display: inline-block; font-weight: bold; width: 190px; text-transform: capitalize;"><span class="status active"></span>'+kd+'</label>'
                    cd_html+= '<span>'+data.notes[kd]+'</span>'
                    cd_html += '</div>'
                })
                jq("#visit-detail").html(cd_html)

            })
        });

        jq('#opdRecordsPrintButton').click(function(){
            jq("#printSection").print({
                globalStyles: 	false,
                mediaPrint: 	false,
                stylesheet: 	'${ui.resourceLink("patientdashboardapp", "styles/printout.css")}',
                iframe: 		false,
                width: 			600,
                height:			700
            });
        });

        var visitSummaries = jq(".visit-summary");

        if (visitSummaries.length > 0) {
            visitSummaries[0].click();
            jq('#cs').show();
        }else{
            jq('#cs').hide();
        }

        jq('#ul-left-menu').slimScroll({
            allowPageScroll: false,
            height		   : '426px',
            distance	   : '11px',
            color		   : '#363463'
        });

        jq('#ul-left-menu').scrollTop(0);
        jq('#slimScrollDiv').scrollTop(0);
    });
</script>

<style>
#ul-left-menu {
    border-top: medium none #fff;
    border-right: 	medium none #fff;
}
#ul-left-menu li:nth-child(1) {
    border-top: 	1px solid #ccc;
}
#ul-left-menu li:last-child {
    border-bottom:	1px solid #ccc;
    border-right:	1px solid #ccc;
}
.visit-summary{

}
</style>

<div class="onerow">
    <div id="div-left-menu" style="padding-top: 15px;" class="col15 clear">
        <ul id="ul-left-menu" class="left-menu">
            <li class="menu-item visit-summary" style="border-right:1px solid #ccc; margin-right: 15px; width: 168px; height: 18px;">
                <input type="hidden" class="encounter-id" value="morningAndEveningTemperatureChart" >
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

            <li class="menu-item visit-summary" style="border-right:1px solid #ccc; margin-right: 15px; width: 168px; height: 18px;">
                <input type="hidden" class="encounter-id" value="fourHourTemperatureChart" >
                <span class="menu-date">
                    <i class="icon-chart"></i>
                    <span id="fourHourTemperatureChart">Temperature</span>
                </span>
                <span class="menu-title">
                    <i class="icon-chart"></i>
                    <span>Four Hour Chart</span>
                </span>
                <span class="arrow-border"></span>
                <span class="arrow"></span>
            </li>

            <li style="height: 30px; margin-right: 15px; width: 168px;" class="menu-item"></li>
        </ul>
    </div>

    <div class="col16 dashboard opdRecordsPrintDiv" style="min-width: 78%">

    </div>
</div>

<div class="main-content" style="border-top: 1px none #ccc;">
    <div id=""></div>
</div>


<div></div>
<div style="clear: both;"></div>
<div style="clear: both;"></div>