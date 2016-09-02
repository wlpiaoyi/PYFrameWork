var  hybird_call_navigation = function (callbackId, message, params){
    var result = {
    value: undefined,
        error : undefined
    };
    var _params_ = {
        params : params,
        callbackId : callbackId
    }
    try {
        var objName = message.split("_")[0];
        var methodName = message.substring(objName.length + 1, message.length);
        var returnType =  eval(objName + "_method." + methodName + ".returnType");
        if(returnType == "Void" || returnType == undefined){
            window.webkit.messageHandlers[message].postMessage(_params_);
        }else{
            alert(JSON.stringify({"callbackId":callbackId,"methodName":message,"params":params}));
        }
        result.value = window.hybird.callbackResults[callbackId];
        result.error = undefined;
        window.hybird.callbackResults[callbackId] = undefined;
    } catch(err) {
        alert("Error name: " + err.name + "\n" + "Error message: " + err.message);
        result.error = err;
        result.value = undefined;
    }
    alert(b + "[sdfsdfsdfsdf]");
    return result.value;
};
//var  hybird_call_navigation = function (instanceObj, methodName, params, callbackId){
//    
//}
//var hybird_merge_instanceObj = function (instanceObj, id){
//    instanceObj.id = id;
//    window.instanceObj.push(instanceObj);
//}
//var hybird_remove_instaceObj = function (id){
//    for (var i = 0; i < window.hybird.instanceObjs.length; i++) {
//        var instanceObj = window.hybird.instanceObjs[i];
//        if(instanceObj.id != id){
//            continue;
//        }
//        window.hybird.instanceObjs.remove(instanceObj);
//        break;
//    }
//}

window.hybird = {
    call : hybird_call_navigation,
    instanceObjs : [],
    callbackResults : {}
};