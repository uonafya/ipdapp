<div class="dashboard">
    <div class="info-section" style="width: 99%;">
        <div class="info-header">
            <i class="icon-random"></i>
            <h3>Admit Patient</h3>
        </div>

        <div class="info-body">
            <form method="post" id="transferForm" action="admissionForm.page?ipdWard=100126282">
                <div style="float: left">
                    <img src="${ui.resourceLink('ipdapp', 'images/patient-admit.png')}" style="border-right: 1px solid #eee; height: 185px; margin-right: 10px; padding: 5px 15px 0 5px;" />
                </div>

                <div style="display: block; overflow:hidden">
                    <div class="daily-vitals">
                        <label>Select Ward: </label>
                        <span>
                            <select required  name="admittedWard" id="admittedWard">
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

                        <label>Select Doctor: </label>
                        <span>
                            <select required name="treatingDoctor" id="treatingDoctor">
                                <option value="">Select Doctor On Call</option>
                                <% if (listDoctor!=null && listDoctor!=""){ %>
                                <% listDoctor.each { doct -> %>
                                <option title="${doct.givenName}"   value="${doct.id}">
                                    ${doct.givenName}
                                </option>
                                <% } %>
                                <% } %>
                            </select>
                        </span>

                        <label>Bed Number</label>
                        <span>
                            <input required name="bedNumber" id="bedNumber" type="number"/>
                        </span>
                        <label>File Number</label>
                        <span>
                            <input required name="fileNumber" id="fileNumber" type="number"/>
                        </span>

                        <label>Comments</label>
                        <span>
                            <textarea name="comment" id="comment"></textarea>
                        </span>


                        <label></label>
                        <span style="margin-top: 5px">
                            <a type="submit" class="button confirm right" id="admitButton" style="margin-right: 0px !important;">
                                <i class="icon-hospital"></i>
                                Admit
                            </a>
                            <a type="submit" class="button cancel">
                                <i class="icon-remove "></i>
                                Cancel
                            </a>
                        </span>

                    </div>
                </div>
            </form>
            <div class="clear"></div>
        </div>
    </div>

</div>
<div class="clear"></div>

<div id="selectBedDialog" class="dialog" style="display: none">
    <div class="dialog-header">
        <i class="icon-folder-open"></i>
        <h3>Select Bed</h3>
    </div>
    <div class="dialog-content">
        <ul>
            <li>
                <span>Ward Layout</span>

            </li>
        </ul>

        <span class="button confirm right" style="margin-right: 1px"> Confirm </span>
        <span class="button cancel"> Cancel </span>
    </div>
</div>