({
    echo : function(component, event, helper) {
   
        var recordid_is = component.get("v.recordId");   
        var action = component.get("c.VerifyBenifits");
        action.setParams({ RecordId :recordid_is});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                setTimeout(location.reload(), 10000);
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors)
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            console.log("Error message: " + errors[0].message);
                        }
                    } 
                    else 
                    {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);  
        //setTimeout(location.reload.bind(location), 1000);
    }
})