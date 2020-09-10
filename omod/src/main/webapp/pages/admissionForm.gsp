<% ui.decorateWith("appui", "standardEmrPage", [title: "admit"]) %>

<body></body>
<header>
</header>
<script>
    var jq = jQuery;
    var pasteBed = '';
    //treatment: send post information
    var getJSON = function (dataToParse) {
        if (typeof dataToParse === "string") {
            return JSON.parse(dataToParse);
        }
        return dataToParse;
    }

    jq(function() {

        jq("#admittedWard").on("change",function () {
            var currentID = jq(this).val();

                jq.getJSON('${ ui.actionLink("ipdapp", "BedStrength", "getBedStrength")  }',{
                    wardId: currentID
                })
                        .success(function(data) {

                            jq('#dump-bed').html('');

                            dta = JSON.stringify(data);

                            for (var key in data) {
                                if (data.hasOwnProperty(key)) {
                                    var val = data[key];

                                 for(var i in val){
                                     if(val.hasOwnProperty(i)){
                                         var j = val[i];

                                         pasteBed += ' Bed No. ' + i + ' People: ' + j;
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
        var adddrugdialog = emr.setupConfirmationDialog({
            selector: '#addDrugDialog',
            actions: {
                confirm: function() {

                },
                cancel: function() {
                    adddrugdialog.close();
                }
            }
        });
        jq("#bedButton").on("click", function(e) {
            adddrugdialog.show();
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
            <span>${address}</span>
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
<div class="patient-header new-patient-header">
    <div>

        <form method="post" action = "admissionForm.page?ipdWard=${ipdWard}">
            <input type="hidden" name="id" value="${admission.id}">
            Admitted Ward:<br/>
            <span class="select-arrow" style="width: 250px;">
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


            <div>
                <ul style=" margin-top: 10px;"></ul>
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

            <ul style=" margin-top: 10px;"></ul>

            <div style="width: 100px; display: inline-block;">
                <label for="FileNo" >File Number:</label>
            </div>

            <input id="FileNo" type="text" name="fileNumber" style="min-width: 200px;" placeholder="Enter File Number">
            <br/>

            <li>
                <label for="BedNo" style="width: 400px;">Bed Number:</label>
                <input id="BedNo" type="text" name="bedNumber" style="min-width: 200px;" placeholder="Select Bed number">
            </li>

            <ul style=" margin-top: 10px;"></ul>
            <a class="button" id="bedButton"> bed</a>

            <div><ul style=" margin-top: 10px;"></ul>
                Comments:
                <textarea placeholder="Enter Comments" name="comments" style="min-width: 450px; min-height: 100px;"></textarea>
            </div>
            <ul style=" margin-top: 30px; margin-bottom: 30px;"></ul>
            <div style="width: 100%" align="center">
                <div style="width: 50%">
                    <input type="reset" class="button cancel" style="float: left" value="Reset">
                    <input id="testdubmit" type="submit" value="submit" class="button confirm" style="float: right">

                </div>
            </div>
        </form>

        <div id="addDrugDialog" class="dialog">
            <div class="dialog-header">
                <i class="icon-folder-open"></i>
                <h3>bednumber</h3>
            </div>
            <div class="dialog-content">
                <ul>
                    <div id="dump-bed"></div>

                </ul>
                <span class="button confirm right" > Confirm </span>
                <span class="button cancel"> Cancel </span>
            </div>
        </div>
    </div>


</div>

