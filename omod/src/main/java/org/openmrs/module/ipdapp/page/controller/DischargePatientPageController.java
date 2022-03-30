package org.openmrs.module.ipdapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.Patient;
import org.openmrs.Role;
import org.openmrs.User;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.IpdPatientVitalStatistics;
import org.openmrs.module.hospitalcore.util.ConceptAnswerComparator;
import org.openmrs.module.ipdapp.utils.IpdConstants;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

/**
 *
 */
@AppPage(IpdConstants.APP_IPD_APP)
public class DischargePatientPageController {
    public void get(@RequestParam("patientId") Patient patient,
                    PageModel model) {

        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        PatientService patientService = Context.getService(PatientService.class);;

        List<Patient> patientList = patientService.getPatients(null, patient.getPatientIdentifier().toString(), null, true, null,null);
        IpdPatientAdmitted patientInformation = ipdService.getAdmittedByPatientId(patientList.get(0).getPatientId());

        model.addAttribute("patient", patient);
        model.addAttribute("patientInformation",patientInformation );

        //gets list of doctors
        Concept ipdConcept = Context.getConceptService().getConceptByUuid("5fc29316-0869-4b3b-ae2f-cc37c6014eb7");
        List<ConceptAnswer> list = (ipdConcept != null ? new ArrayList<ConceptAnswer>(ipdConcept.getAnswers()) : null);
        if (CollectionUtils.isNotEmpty(list)) {
            Collections.sort(list, new ConceptAnswerComparator());
        }
        model.addAttribute("listIpd", list);

        //displays the list of doctors
        Role doctorRole = Context.getUserService().getRole("Doctor");
        if (doctorRole != null) {
            List<User> listDoctor = Context.getUserService().getUsersByRole(doctorRole);
            model.addAttribute("listDoctor", listDoctor);
        }

        //vital statistics
        //diet list
        List<Concept> dietConcept= ipdService.getDiet();
        model.addAttribute("dietList", dietConcept);

        //existing vital statistics
        List<IpdPatientVitalStatistics> ipdPatientVitalStatistics=ipdService.getIpdPatientVitalStatistics(patient.getPatientId(), patientInformation.getPatientAdmissionLog().getId());
        model.addAttribute("ipdPatientVitalStatistics", ipdPatientVitalStatistics);

        //list of discharge outcomes
        Concept outComeList = Context.getConceptService().getConceptByUuid("0c760f02-df3d-4280-b8b3-ea51aab94a69");

        model.addAttribute("listOutCome", outComeList.getAnswers());

        Collection<ConceptAnswer> answer = outComeList.getAnswers();
        model.addAttribute("answer",answer);

        //fetch drug frequencies
        InventoryCommonService inventoryCommonService = Context
                .getService(InventoryCommonService.class);
        List<Concept> drugFrequencyConcept = inventoryCommonService
                .getDrugFrequency();
        model.addAttribute("drugFrequencyList", drugFrequencyConcept);


    }
}
