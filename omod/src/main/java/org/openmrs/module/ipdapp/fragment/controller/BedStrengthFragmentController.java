package org.openmrs.module.ipdapp.fragment.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.WardBedStrength;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by USER on 1/28/2016.
 */
public class BedStrengthFragmentController {
    public SimpleObject getBedStrength(@RequestParam(value="wardId",required=false) Integer wardId,
                                             UiUtils uiUtils,PageModel model) {


        //System.out.println("in getBedStrength: wardId = "+wardId);
        IpdService ipdService = (IpdService) Context
                .getService(IpdService.class);
        Map<Long,Integer> bedStrengthMap = new HashMap<Long, Integer>();
        WardBedStrength wardBedStrength = ipdService.getWardBedStrengthByWardId(wardId);
        //System.out.println("ward bed strength = " +wardBedStrength + "<<<wardId" + wardId);
        if (wardBedStrength!=null){
            Integer bedStrength = wardBedStrength.getBedStrength();
            List<IpdPatientAdmitted> allAdmittedPatients = ipdService.getAllIpdPatientAdmitted();
            //populate all bed numbers with 0;
            //System.out.println("maxBedStrength=" + wardBedStrength.getBedStrength());
            for (Long i =1L ;i<=bedStrength;i++){
                bedStrengthMap.put(i, 0);

            }






            for (IpdPatientAdmitted ipdAdmittedPatient: allAdmittedPatients)
            {
                int conceID = ipdAdmittedPatient.getAdmittedWard().getConceptId();


                if (conceID==wardId)
                {


                    Long bedNo = new Long(0);
                    try {
                        bedNo = Long.parseLong(ipdAdmittedPatient.getBed());
                    } catch (NumberFormatException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                    //	System.out.println("bedno="+bedNo+"ward=" + wardId);
                    Integer bedCount = bedStrengthMap.get(bedNo);
                    if (bedCount==null){
                        bedCount = 1;
                    }else {
                        bedCount = bedCount + 1;
                    }
                    bedStrengthMap.put(bedNo, bedCount);
                }
            }
        }else{
//            model.addAttribute("bedStrengthValueAvailable", "false");
        }

        for (Long key : bedStrengthMap.keySet()){
            //System.out.println("bedno=" + key + "bedcount=" + bedStrengthMap.get(key));
        }


       // model.addAttribute("bedStrengthMap", bedStrengthMap);
       // model.addAttribute("size", Math.round(Math.sqrt(bedStrengthMap.size())) + 1 );
        //ghanshyam 7-august-2013 code review bug
        float bedStrengthSize= bedStrengthMap.size();
        //model.addAttribute("bedMax", Math.round(bedStrengthSize));
        List<Integer> integers= new ArrayList<Integer>();

         return SimpleObject.create("bedStrength",bedStrengthMap);

    }

}
