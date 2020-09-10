package org.openmrs.module.ipdapp.page.controller;

import org.openmrs.Concept;
import org.openmrs.PersonAddress;
import org.openmrs.PersonAttribute;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.ui.framework.Model;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ngarivictor,francisgithae on 1/6/2016.
 */
public class PatientsAdmissionPageController {

    //@RequestMapping(value = "/module/ipd/patientsForAdmission.htm", method = RequestMethod.GET)
    public void get(@RequestParam("ipdWard") Concept ipdWard,
                    Model model) {
        model.addAttribute("ipdWard", ipdWard);

        IpdService ipdService = (IpdService) Context.getService(IpdService.class);

        List<IpdPatientAdmission> listPatientAdmission = ipdService.searchIpdPatientAdmission(null, null, null, null, ipdWard.getId().toString(), "");
        List<IpdPatientAdmitted> listPatientAdmitted = ipdService.searchIpdPatientAdmitted(null, null, null, null, ipdWard.getId().toString(), "");

        model.addAttribute("listPatientAdmission", listPatientAdmission);
        model.addAttribute("listPatientAdmitted", listPatientAdmitted);

        Map<Integer, String> mapRelationName = new HashMap<Integer, String>();
        Map<Integer, String> mapRelationType = new HashMap<Integer, String>();
        for (IpdPatientAdmitted admit : listPatientAdmitted) {
            PersonAttribute relationNameattr = admit.getPatient().getAttribute("Father/Husband Name");
            PersonAddress add = admit.getPatient().getPersonAddress();
            String address1 = add.getAddress1();
            if(address1!=null){
                String address = " " + add.getAddress1() +" " + add.getCountyDistrict() + " " + add.getCityVillage();
                model.addAttribute("address", address);
            }
            else{
                String address = " " + add.getCountyDistrict() + " " + add.getCityVillage();
                model.addAttribute("address", address);
            }
            PersonAttribute relationTypeattr = admit.getPatient().getAttribute("Relative Name Type");
            //ghanshyam 30/07/2012 this code modified under feedback of 'New Requirement #313'
            if(relationTypeattr!=null){
                mapRelationType.put(admit.getId(), relationTypeattr.getValue());
            }
            else{
                mapRelationType.put(admit.getId(), "Relative Name");
            }
            //added condition 18-7-2016 (Throws bug since person attribute is null
            if(relationNameattr!=null) {
                mapRelationName.put(admit.getId(), relationNameattr.getValue());
            }
        }
        model.addAttribute("mapRelationName", mapRelationName);
        model.addAttribute("mapRelationType", mapRelationType);
        model.addAttribute("dateTime", new Date().toString());
    }
}
