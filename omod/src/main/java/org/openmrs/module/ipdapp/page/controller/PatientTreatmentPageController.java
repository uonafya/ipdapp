package org.openmrs.module.ipdapp.page.controller;

import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * Created by Dennys Henry on 9/25/2016.
 */
public class PatientTreatmentPageController {
    public void get(@RequestParam("patientId") Patient patient,
                    PageModel model) {
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        IpdPatientAdmitted patientInformation = ipdService.getAdmittedByPatientId(patient.getPatientId());

        model.addAttribute("patient", patient);
        model.addAttribute("patientInformation", patientInformation);

        //fetch drug frequencies
        InventoryCommonService inventoryCommonService = Context.getService(InventoryCommonService.class);
        List<Concept> drugFrequencyConcept = inventoryCommonService.getDrugFrequency();
        model.addAttribute("drugFrequencyList", drugFrequencyConcept);

    }
}
