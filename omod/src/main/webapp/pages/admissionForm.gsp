<%
    ui.decorateWith("appui", "standardEmrPage", [title: "admit"])

    ui.includeCss("ehrconfigs", "referenceapplication.css")
    ui.includeCss("ehrconfigs", "onepcssgrid.css")

    ui.includeJavascript("ehrconfigs", "moment.js")
    ui.includeJavascript("ehrconfigs", "jquery.dataTables.min.js")
    ui.includeJavascript("ehrconfigs", "jq.browser.select.js")
    ui.includeJavascript("ehrconfigs", "knockout-3.4.0.js")
    ui.includeJavascript("ehrconfigs", "jquery-ui-1.9.2.custom.min.js")
    ui.includeJavascript("ehrconfigs", "underscore-min.js")
    ui.includeJavascript("ehrconfigs", "emr.js")
%>



<body></body>
<header>
    <style>
    .adm-frm{
        display: flex;
        flex-direction: row;
        padding: 5px;
        margin-left: 8px;
    }
    @media screen and (max-width: 900px){
        .adm-frm{
            flex-direction: column;
        }
    }
    #dump-bed{
        width: 100%;
        display: grid;
        grid-template-columns: repeat(6, auto);
        gap: 7px;
        padding-bottom: 14px;
    }
    .bp-container{
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        padding: 2px;
    }
    .bp-span{
        padding: 3px;
    }
    .bp-container{
        padding: 3px;
        background-color: firebrick;
        color: white;
        cursor: pointer;
    }
    .bp-container[data-people="0"]{
        background-color: #34bf6e;
    }
    .ke-page-container{
        min-height: 100vh;
    }
    body{
        min-height: 100vh;
    }
    .page-content{
        height: 100%;
        min-height: 700px;
    }
    #addDrugDialog{
        position: absolute;
        top: 0%;
        z-index: 3000;
        left: 25%;
        width: 60%;
        overflow: auto;
        height: 90%;
    }
    .hidden{
        display: none;
    }
    </style>
</header>
<script>
    var jq = jQuery;
    //treatment: send post information
    var getJSON = function (dataToParse) {
        if (typeof dataToParse === "string") {
            return JSON.parse(dataToParse);
        }
        return dataToParse;
    }

    function setBedNo(bedNum){
        jq('#BedNo').val(bedNum)
        jq('#addDrugDialog').addClass('hidden')
    }

    jq(function() {


        jq("#admittedWard").on("change",function () {
            var currentID = jq(this).val();


            jq.getJSON('${ ui.actionLink("ipdapp", "BedStrength", "getBedStrength")  }',{
                wardId: currentID
            })
                .success(function(data) {

                    var pasteBed = '';
                    jq('#dump-bed').html('');

                    for (var key in data) {
                        if (data.hasOwnProperty(key)) {
                            var val = data[key];

                            for(var i in val){
                                if(val.hasOwnProperty(i)){
                                    var j = val[i];


                                    pasteBed += '<div class="bp-container" onclick="setBedNo('+i+')" data-bednum="'+i+'" data-people="'+j+'"> <span class="bp-span bno">Bed <b>#' + i + '</b></span> <span class="bp-span bpl" >Patients: <b>' + j+'</b></span></div>';
                                }
                            }

                        }
                    }


                    jq('#dump-bed').html(pasteBed);

                })
                .error(function(xhr, status, err) {
                    jq().toastmessage('showErrorToast', "Error:" + err);
                })
        });

        jq("#BedNo").on("click", function(e) {
            jq('#addDrugDialog').removeClass('hidden')
        });

    });


</script>
<div class="clear"></div>
<div class="container">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="#">
                    <i class="icon-home small"></i></a>
            </li>
            <li>
                <i class="icon-chevron-right link"></i>
                <a href="#">Patient Admission</a>
            </li>
            <li>
            </li>
        </ul>
    </div>
    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name">
                <span>${admission.patientName}<em>name</em></span>

            </h1>
            <div class="gender-age">
                <span>${admission.gender}<em>gender</em></span>
                <span>${admission.birthDate}<em>date of birth</em></span>
            </div>
            <div class="status-container">
                <span class="status active"></span>
                Marital Status:
                <div class="tag">${maritalStatus}</div>
            </div>
            <div class="gender-age">
                <span><b>Address:</b></span>
                <span>&nbsp;</span>
            </div>
            <div class="gender-age">
                <span><b>Relative Name:</b></span>
                <span>${relative}</span>
            </div>



            <br>
        </div>
        <div class="identifiers">
            <em>Patient ID</em>
            <span>${admission.patientIdentifier}</span>
        </div>
        <div class="identifiers">
            <em>Admission Date:</em>
            <span>${admission.admissionDate}</span>
        </div>
    </div>
</div>
<ul style=" margin-top: 10px;" class="grid"></ul>
<div class="page-content" style="min-height: 700px;">
    <div style="width: 100%;height: 100%;">

        <form method="post" action = "admissionForm.page?ipdWard=${ipdWard}" style="display: flex; flex-direction: column; width: 100%">
            <div class="adm-frm">
                <div style="float: left;">
                    <div>
                        <div>
                            <input type="hidden" name="id" value="${admission.id}">
                            Admitted Ward:<br/>
                            <span class="select-arrow">
                                <select required  name="admittedWard" id="admittedWard"  style="width: 250px;">
                                    <option value="">Select Ward</option>
                                    <% if (listIpd!=null && listIpd!="") { %>
                                    <% listIpd.each { ipd -> %>
                                    <option title="${ipd.answerConcept.name}"   value="${ipd.answerConcept.id}">
                                        ${ipd.answerConcept.name}
                                    </option>
                                    <%}%>
                                    <%}%>
                                </select>
                            </span>
                        </div>
                        <div style="margin-right: 100px; ">
                            <ul ></ul>
                            Doctor on Call: <br/>
                            <span class="select-arrow">
                                <select required name="treatingDoctor" id="treatingDoctor"  style="width: 250px; >
                                <option value="please select ...">Select Doctor On Call</option>
                                <% if (listDoctor!=null && listDoctor!=""){ %>
                                <% listDoctor.each { doct -> %>
                                <option title="${doct.givenName}"   value="${doct.id}">
                                    ${doct.givenName}
                                </option>
                                <% } %>
                                <% } %>
                            </select>
                            </span>

                        </div>
                    </div>
                    <div>
                        <div style="width: 250px;">
                            <label for="FileNo" >File Number:</label>
                            <input id="FileNo" type="text" name="fileNumber" style="min-width: 250px;" placeholder="Enter File Number">
                        </div>
                        <div style="width: 250px;">
                            <label for="BedNo" style="width: 100px; display: inline-block;">Bed Number:</label>
                            <input id="BedNo" type="text" name="bedNumber" style="min-width: 250px;" placeholder="Select Bed number">
                        </div>
                    </div>
                    <a style="display: none" class="button" id="bedButton"> bed</a>
                </div>

                <div style="margin-left: 14px; padding: 4px">
                    Comments:
                    <textarea placeholder="Enter Comments" name="comments" style="min-width: 450px; min-height: 100px;"></textarea>
                </div>
            </div>


            <ul style=" margin-top: 30px; margin-bottom: 30px;"></ul>
            <div style="width: 100%" align="center">
                <div style="width: 50%">
                    <input type="reset" class="button cancel" style="float: left" value="Reset">
                    <input id="testsubmit" type="submit" value="submit" class="button confirm" style="float: right">

                </div>
            </div>
        </form>

        <div id="addDrugDialog" class="dialog hidden">
            <div class="dialog-header">
                <i class="icon-folder-open"></i>
                <h3>Bed occupancy map</h3>
            </div>
            <div class="dialog-content">
                <div id="dump-bed"></div>
            </div>
        </div>
    </div>
</div>
