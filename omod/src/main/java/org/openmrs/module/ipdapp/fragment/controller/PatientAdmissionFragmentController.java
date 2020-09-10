package org.openmrs.module.ipdapp.fragment.controller;

import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmissionLog;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.OpdPatientQueueLog;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.ipdapp.utils.IpdConstants;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;

import org.springframework.web.bind.annotation.RequestParam;
import java.util.Date;
import java.util.List;

/**
 * Created by USER on 1/30/2016.
 */

public class PatientAdmissionFragmentController {
    IpdService ipdService = (IpdService) Context.getService(IpdService.class);

    public void removeOrNoBed(@RequestParam(value = "admissionId", required = false) Integer admissionId, //If that tab is active we will set that tab active when page load.
                              @RequestParam(value = "action", required = false) Integer action, PageModel model) {

        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        PatientQueueService queueService = Context.getService(PatientQueueService.class);
        IpdPatientAdmission admission = ipdService.getIpdPatientAdmission(admissionId);
        IpdPatientAdmissionLog patientAdmissionLog = new IpdPatientAdmissionLog();
        User user = Context.getAuthenticatedUser();
        EncounterType encounterType = Context.getService(HospitalCoreService.class).insertEncounterTypeByKey(
                HospitalCoreConstants.PROPERTY_IPDENCOUNTER);

        if (admission != null && (action == 1 || action == 2)) {

            //remove
            Date date = new Date();
            //copy admission to log

            patientAdmissionLog.setAdmissionDate(date);
            patientAdmissionLog.setAdmissionWard(admission.getAdmissionWard());
            patientAdmissionLog.setBirthDate(admission.getBirthDate());
            patientAdmissionLog.setGender(admission.getGender());
            patientAdmissionLog.setOpdAmittedUser(user);
            patientAdmissionLog.setOpdLog(admission.getOpdLog());
            patientAdmissionLog.setPatient(admission.getPatient());
            patientAdmissionLog.setPatientIdentifier(admission.getPatientIdentifier());
            patientAdmissionLog.setPatientName(admission.getPatientName());
            patientAdmissionLog.setStatus(IpdConstants.STATUS[action]);
            patientAdmissionLog.setIndoorStatus(1);


            //save ipd encounter

            Encounter encounter = new Encounter();
            Location location = new Location(1);
            encounter.setPatient(admission.getPatient());
            encounter.setCreator(user);
            encounter.setProvider(user);
            encounter.setEncounterDatetime(date);
            encounter.setEncounterType(encounterType);
            encounter.setLocation(location);
            encounter = Context.getEncounterService().saveEncounter(encounter);
            //done save ipd encounter
            patientAdmissionLog.setIpdEncounter(encounter);
            //Get Opd Obs Group
            Obs obsGroup = Context.getService(HospitalCoreService.class).getObsGroup(admission.getPatient());
            patientAdmissionLog.setOpdObsGroup(obsGroup);

            patientAdmissionLog = ipdService.saveIpdPatientAdmissionLog(patientAdmissionLog);

            if (patientAdmissionLog != null && patientAdmissionLog.getId() != null) {
                ipdService.removeIpdPatientAdmission(admission);
            }

            OpdPatientQueueLog opdPatientQueueLog = patientAdmissionLog.getOpdLog();
            if (opdPatientQueueLog != null){
                opdPatientQueueLog.setVisitOutCome("no bed");
                queueService.saveOpdPatientQueueLog(opdPatientQueueLog);
            }
        }
    }

    public List<SimpleObject> listAdmissionQueuePatients(@RequestParam("ipdWard") String ipdWard,
                                                         @RequestParam(value = "fromDate", required = false) String fromDate,
                                                         @RequestParam(value = "toDate", required = false) String toDate,
                                                         UiUtils uiUtils) {

        List<IpdPatientAdmission> admissionQueue = ipdService.searchIpdPatientAdmission(null, null, fromDate, toDate, ipdWard, "");
        return SimpleObject.fromCollection(admissionQueue, uiUtils, "id", "admissionDate", "patient", "patientName", "patientIdentifier", "birthDate", "gender", "admissionWard", "status", "opdAmittedUser", "opdLog", "acceptStatus", "ipdEncounter");
    }

    public List<SimpleObject> listAdmittedIpdPatients(@RequestParam("ipdWard") String ipdWard,
                                                      @RequestParam(value = "fromDate", required = false) String fromDate,
                                                      @RequestParam(value = "toDate", required = false) String toDate,
                                                      UiUtils uiUtils) {
        List<IpdPatientAdmitted> admittedPatients = ipdService.searchIpdPatientAdmitted(null, null, fromDate, toDate, ipdWard, "");
        return SimpleObject.fromCollection(admittedPatients, uiUtils, "id", "admissionDate", "patient", "patientName", "patientIdentifier", "birthDate", "gender", "admittedWard", "status");
    }
}
