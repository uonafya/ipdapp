<script>
    jq(function(){
        jq("#drug-left-menu").on("click", ".drug-summary", function(){
            //jq("#drug-detail").html('<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i> <span style="float: left; margin-top: 12px;">Loading...</span>');
            jq("#drug-administrations-detail").html("");
            var drugSummary = jq(this);
            jq(".drug-summary").removeClass("selected");
            jq(drugSummary).addClass("selected");

            jq("option[class='selectedDrugVal']").remove();
            jq('#selectedDrug').append('<option class="selectedDrugVal" value="' + jq(drugSummary).find(".drug-id").val() + '">' + jq(drugSummary).find(".drug-name").val() + '</option>');

            var drugOrderId = jq(drugSummary).find(".drug-id").val();

            jq.getJSON('${ ui.actionLink("ipdapp", "drugsAdministration" ,"getDrugAdministrationDetails") }',
                { 'patientId' : drugOrderId, 'drugOrderId' :  drugOrderId}
            ).success(function (data) {
                if (data.length > 0) {
                    var drugsTemplate =  _.template(jq("#drug-template").html());
                    jq("#drug-administrations-detail").html(drugsTemplate(data));
               }
               else {
                    var drugsTemplate =  _.template(jq("#drug-empty-template").html());
                    jq("#drug-administrations-detail").html(drugsTemplate(data));
                }                
            })
        });



        var drugSummaries = jq(".drug-summary");

        if (drugSummaries.length > 0) {
            drugSummaries[0].click();
            jq('#cs').show();
        }else{
            jq('#cs').hide();
        }

        jq('#drug-left-menu').slimScroll({
            allowPageScroll: false,
            height		   : '426px',
            distance	   : '11px',
            color		   : '#363463'
        });

        jq('#drug-left-menu').scrollTop(0);
        jq('#slimScrollDiv').scrollTop(0);


        var quantity = jq( "#drugQuantity" );
        var remarks = jq( "#drugRemarks" );
        var allFields = jq( [] ).add( quantity ).add( remarks );

        var tips = jq( ".validateTips" );

        function updateTips( t ) {
              tips
                .text( t )
                .addClass( "ui-state-highlight" );
              setTimeout(function() {
                tips.removeClass( "ui-state-highlight", 1500 );
              }, 500 );
        }


        function addDrugAdministration() {
              var formData = {
                'drugAdministrationId': 0,
                'drugOrderId': 21,
                'quantity': 1,
                'remarks': 'Testing',
              };

              jq.getJSON('${ ui.actionLink("ipdapp", "DrugsAdministration", "saveDrugAdministration") }', formData)
                .success(function(data) {
                    kenyaui.notifySuccess("Success! Drug Administration Details have been recorded");
                    location.reload();
                })
                    .error(function(xhr, status, err) {
                        jq().toastmessage('showErrorToast', "Error:" + err);
                   });

              dialog.dialog( "close" );
        }


        var dialog = jq( "#dialog-form" ).dialog({
              autoOpen: false,
              height: 400,
              width: 550,
              modal: true,
              buttons: {
                "Save": addDrugAdministration,
                Cancel: function() {
                  dialog.dialog( "close" );
                }
              },
              close: function() {
                form[ 0 ].reset();
                allFields.removeClass( "ui-state-error" );
              }
            });

        var form = dialog.find( "form" ).on( "submit", function( event ) {
            event.preventDefault();
            addDrugAdministration();
        });

        jq( "#create-drug-administration" ).button().on( "click", function() {
            dialog.dialog( "open" );
        });
    });
</script>

<style>
#drug-left-menu {
    border-top: medium none #fff;
    border-right: 	medium none #fff;
}
#drug-left-menu li:nth-child(1) {
    border-top: 	1px solid #ccc;
}
#drug-left-menu li:last-child {
    border-bottom:	1px solid #ccc;
    border-right:	1px solid #ccc;
}
.drug-summary{

}

    label, input { display:block; }
    input.text { margin-bottom:12px; width:95%; padding: .4em; }
    input.select { margin-bottom:12px; width:95%; padding: .4em; }
    fieldset { padding:0; border:0; margin-top:15px; }
    h1 { font-size: 1.2em; margin: .6em 0; }
    .ui-dialog .ui-state-error { padding: .3em; }
    .validateTips { border: 1px solid transparent; padding: 0.3em; }
</style>

<div class="onerow">
    <div id="div-left-menu" style="padding-top: 15px;" class="col15 clear">
        <ul id="drug-left-menu" class="left-menu">

            <% drugs.each { drug -> %>
                <li class="menu-item drug-summary" drugId="${drug.opdDrugOrderId}" style="border-right:1px solid #ccc; margin-right: 15px; width: 218px; height: 18px;">
                    <input type="hidden" class="drug-id" value="${drug.opdDrugOrderId}" >
                    <input type="hidden" class="drug-name" value="${drug.inventoryDrug.name}" >
                    <span class="menu-date">
                                <i class="icon-time"></i>
                                <span id="drug-order">
                                    ${drug.dosage} ${drug.inventoryDrugFormulation.dozage} ${drug.inventoryDrugFormulation.name}
                                </span>
                    </span>
                    <span class="menu-title">
                        <i class="icon-stethoscope"></i>
                        ${ drug.inventoryDrug.name }
                    </span>
                    <span class="arrow-border"></span>
                    <span class="arrow"></span>
                </li>

            <% } %>

            <li style="height: 30px; margin-right: 15px; width: 218px;" class="menu-item"></li>
        </ul>
    </div>

    <div class="col16 dashboard drugsPrintDiv" style="min-width: 68%">

        <div id="printSection">
            <div style="float: right; padding-top: 10px; padding-right:5px;">
                <button id="create-drug-administration">Add Drug Administration</button>
            </div>
            <div class="info-section info-body" id="drug-administrations-detail"  style="display: flex; flex-direction: column;" id="drug-detail">

            </div>
        </div>

        <div id="dialog-form" title="Add Drug Administration Record">
          <p class="validateTips">All form fields are required.</p>

          <form>
            <fieldset>
              <label for="name">Drug</label>
              <input type="hidden" id="drugAdministrationId" value="0" >
              <select required name="selectedDrug" id="selectedDrug">
                <option class="selectedDrugVal" value=""></option>
              </select>
              <label for="quantity">Quantity</label>
              <input type="text" name="drugQuantity" id="drugQuantity" value="" class="text ui-widget-content ui-corner-all">
              <label for="remarks">Remarks</label>
              <input type="text" name="drugRemarks" id="drugRemarks" value="" class="text ui-widget-content ui-corner-all">

              <!-- Allow form submission with keyboard without duplicating the dialog button -->
              <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
            </fieldset>
          </form>
        </div>

    </div>
</div>

<div class="main-content" style="border-top: 1px none #ccc;">
    <div id=""></div>
</div>


<script id="drug-template" type="text/template">
<div class="info-header">
    <i class="icon-medicine"></i>
    <h3>DRUG ADMINISTRATION SUMMARY</h3>
</div>

<table id="drugList">
    <thead>
    <tr style="border-bottom: 1px solid #eee;">
        <th>#</th>
        <th>DATE</th>
        <th>DOSAGE</th>
        <th>ADMINISTERED BY</th>
        <th>REMARKS</th>
    </tr>
    </thead>
    <tbody>

    {{ _.each(data, function(drug, index) { }}
    	<tr style="border: 1px solid #eee;">
    		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{=index+1}}</td>
    		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.drugAdministrationDate}}</td>
    		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.amount}}</td>
    		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.createdBy.username}}</td>
    		<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.status}}</td>
    	</tr>
    {{ }); }}

    </tbody>
</table>
</script>

<script id="drug-empty-template" type="text/template">
<div class="info-header">
    <i class="icon-medicine"></i>
    <h3>DRUG ADMINISTRATION SUMMARY</h3>
</div>

<div><br/></div>

<table id="drugList">
    <thead>
    <tr>
        <th>#</th>
        <th>DATE</th>
        <th>DOSAGE</th>
        <th>ADMINISTERED BY</th>
        <th>REMARKS</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td style="text-align: center;" colspan="5">Drug Not Yet Administered</td>
    </tr>
    </tbody>
</table>
</script>

<div></div>
<div style="clear: both;"></div>
<div style="clear: both;"></div>

