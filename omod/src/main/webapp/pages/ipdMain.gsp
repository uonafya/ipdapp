<%
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeJavascript("ehrconfigs", "jquery-1.12.4.min.js")
    ui.includeJavascript("ehrconfigs", "jquery-ui-1.9.2.custom.min.js")
    ui.includeJavascript("ehrconfigs", "underscore-min.js")
    ui.includeJavascript("ehrconfigs", "knockout-3.4.0.js")
    ui.includeJavascript("ehrconfigs", "emr.js")
    ui.includeCss("ehrconfigs", "jquery-ui-1.9.2.custom.min.css")
    // toastmessage plugin: https://github.com/akquinet/jquery-toastmessage-plugin/wiki
    ui.includeJavascript("ehrconfigs", "jquery.toastmessage.js")
    ui.includeCss("ehrconfigs", "jquery.toastmessage.css")
    // simplemodal plugin: http://www.ericmmartin.com/projects/simplemodal/
    ui.includeJavascript("ehrconfigs", "jquery.simplemodal.1.4.4.min.js")
    ui.includeCss("ehrconfigs", "referenceapplication.css")
%>
<form method="get"  id="IpdMainForm">
    <input type="hidden" name="tab" id="tab" value="">
    <table>
        <tr valign="top">
            <td><${ui.message("ipd.patient.search")}></td>
            <td>
                <input type="text" name="searchPatient" id="searchPatient" value=""placeholder="${ui.message("ipd.patient.search")}" />
            </td>
            <td><${ui.message("ipd.ipdWard.name")}></td>

            <td>
                <select id="doctor"  name="doctor"  >
                    <option value="">Select Doctor On Call</option>
                    <% if (listDoctor!=null && listDoctor!=""){ %>
                        <% listDoctor.each { doct -> %>
                            <option title="${doct.givenName}"   value="${doct.id}">
                                ${doct.givenName}
                            </option>
                        <% } %>
                    <% } %>
                </select>
            </td>
            </tr>
        <tr valign="top">
            <td>
                <label>Date From:</label>
                <input name="dateFrom"  placeholder="mm/dd/yyyy" type="date">
            </td>
            <td>
                <label>Date To:</label>
                <input name="dateTo" placeholder="mm/dd/yyyy" type="date">
            </td>

        </tr>

    </table>
</form>

