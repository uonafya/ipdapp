<%
    ui.decorateWith("appui", "standardEmrPage")
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

