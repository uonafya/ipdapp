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
                <span id="surname">${admission.patient.familyName},<em>surname</em></span>
                <span id="othname">${admission.patient.givenName} ${admission.patient.middleName?admission.patient.middleName:''}&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<em>other names</em></span>

                <span>
                    <% if (admission.patient.gender == "F") { %>
                    Female
                    <% } else { %>
                    Male
                    <% } %>
                    <em>gender</em>
                </span>
                <span id="agename">${admission.patient.age} years (${ui.formatDatePretty(admission.patient.birthdate)})
                    <em>age</em>
                </span>

            </h1>

            <br/>
            <div id="stacont" class="status-container">
                <span class="status active"></span>
                Visit Status
            </div>
            <div class="tag">Admitted</div>
        </div>

        <div class="identifiers">
            <em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Patient ID</em>
            <span>${admission.patient.getPatientIdentifier()}</span>
            <br>

            <div class="catg" style="margin-top: 10px; margin-right: 10px;">
                <i class="icon-tags small" style="font-size: 16px"></i><small>Category:</small> ${admission.patient.getAttribute(14)}
            </div>
        </div>
        <div class="clear"></div>
    </div>
</div>


<ul style=" margin-top: 10px;" class="grid"></ul>
<div class="patient-header new-patient-header">
    <div>

        <form method="post" action = "admissionForm.page?ipdWard=100126282">
            <div style="float: left;">
                <div>
                    <div>
                        <input type="hidden" name="id" value="39">
                        Admitted Ward:<br/>
                        <span class="select-arrow">
                            <select required  name="admittedWard" id="admittedWard"  style="width: 250px;">
                                <option value="">Select Ward</option>


                                <option title="CHILD WARD"   value="100126282">
                                    CHILD WARD
                                </option>

                                <option title="FEMALE MEDICAL WARD"   value="5327">
                                    FEMALE MEDICAL WARD
                                </option>

                                <option title="FEMALE SURGICAL WARD"   value="5329">
                                    FEMALE SURGICAL WARD
                                </option>

                                <option title="MALE MEDICAL WARD"   value="5328">
                                    MALE MEDICAL WARD
                                </option>

                                <option title="MALE SURGICAL WARD"   value="5330">
                                    MALE SURGICAL WARD
                                </option>

                                <option title="MATERNITY WARD"   value="100126264">
                                    MATERNITY WARD
                                </option>

                                <option title="PSYCHIATRIC WARD"   value="5331">
                                    PSYCHIATRIC WARD
                                </option>


                            </select>
                        </span>
                    </div>
                    <div style="margin-right: 100px; ">
                        <ul ></ul>
                        Doctor on Call: <br/>
                        <span class="select-arrow">
                            <select required name="treatingDoctor" id="treatingDoctor"  style="width: 250px; >
                            <option value="please select ...">Select Doctor On Call</option>


                            <option title="Testing"   value="75">
                                Testing
                            </option>

                            <option title="Kitioko"   value="74">
                                Kitioko
                            </option>

                            <option title="Cognitive"   value="73">
                                Cognitive
                            </option>

                            <option title="Blablala"   value="72">
                                Blablala
                            </option>

                            <option title="WageBill"   value="70">
                                WageBill
                            </option>

                            <option title="Bomber"   value="42">
                                Bomber
                            </option>

                            <option title="Gasoline"   value="59">
                                Gasoline
                            </option>

                            <option title="Bomber"   value="64">
                                Bomber
                            </option>

                            <option title="Matatu"   value="37">
                                Matatu
                            </option>

                            <option title="Testing"   value="61">
                                Testing
                            </option>

                            <option title="Wenger"   value="62">
                                Wenger
                            </option>

                            <option title="Gasoline"   value="63">
                                Gasoline
                            </option>

                            <option title="Testing"   value="65">
                                Testing
                            </option>

                            <option title="Kichaka"   value="47">
                                Kichaka
                            </option>

                            <option title="WageBill"   value="48">
                                WageBill
                            </option>

                            <option title="Wenger"   value="68">
                                Wenger
                            </option>

                            <option title="Bomber"   value="53">
                                Bomber
                            </option>

                            <option title="Wenger"   value="66">
                                Wenger
                            </option>

                            <option title="Matatu"   value="51">
                                Matatu
                            </option>

                            <option title="Kitioko"   value="55">
                                Kitioko
                            </option>

                            <option title="Blablala"   value="67">
                                Blablala
                            </option>


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

            <div><ul style="margin-top: 10px;"></ul>
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