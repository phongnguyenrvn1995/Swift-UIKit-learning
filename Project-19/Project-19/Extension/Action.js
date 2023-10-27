var Action = function() {
    
}

Action.prototype = {
run: function(parameters) {
    parameters.completionFunction({"URL": document.URL, "title": document.title})
},
    
finalize: function(parameters) {
    var script = parameters["customJavaScript"]
    eval(script)
}
};

var ExtensionPreprocessingJS = new Action
