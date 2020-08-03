function handleElement(element)
{
    //check for visibility while always include the current activeElement 
    return element.offsetWidth > 0 || element.offsetHeight > 0 || element === document.activeElement;
}

function focusNextElement() {
    //add all elements we want to include in our selection
    var focussableElements = 'a:not([disabled]), button:not([disabled]), input[type=text]:not([disabled]), [tabindex]:not([disabled]):not([tabindex="-1"])';
    if (document.activeElement && document.activeElement.form) {
        var focussable = Array.prototype.filter.call(document.activeElement.form.querySelectorAll(focussableElements), handleElement);
        var index = focussable.indexOf(document.activeElement);
        if(index > -1) {
            var nextElement = focussable[index + 1] || focussable[0];
            nextElement.focus();
            try{nextElement.select();}catch(err){}
        }
    }
}

function handleEvent(e) {
    if (e.keyCode === 47)
    {
        document.getElementById("target_x").select();
    }
    else if (e.keyCode === 42)
    {
        document.getElementById("dial_x").select();
    }
    else if (e.keyCode === 43)
    {
        focusNextElement();
    }
    else
    {
        return false;
    }
    e.stopPropagation();
    e.preventDefault();  
    e.returnValue = false;
    e.cancelBubble = true;
    return false;
}

document.addEventListener("keypress", handleEvent);