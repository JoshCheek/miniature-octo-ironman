var codeToEditor = function(codeDiv) {
  var editor      = ace.edit(codeDiv);
  var code        = editor.getValue(codeDiv);
  editor.setTheme("ace/theme/monokai");
  editor.setOptions({maxLines: 15});
  editor.getSession().setMode("ace/mode/ruby");
  return editor;
};

var makeRunButton = function() {
  var button   = document.createElement('input');
  button.type  = 'button';
  button.value = 'Run';
  button.setAttribute('class', 'small secondary button');
  return button;
};

var makeResultDisplay = function() {
  var resultDisplay = document.createElement('pre');
  resultDisplay.setAttribute('class', 'result-display');
  return resultDisplay;
}

lastResult = null; // intentionally don't namespace, so I can get at it from console
var codeDivs = document.querySelectorAll('.interactive-code');
for(var index=0; index < codeDivs.length; ++index) {
  (function() { // <-- do this function thing b/c the vars get shared otherwise
    var codeDiv       = codeDivs[index];
    var editor        = codeToEditor(codeDiv);
    var button        = makeRunButton();
    var resultDisplay = makeResultDisplay();
    codeDiv.parentNode.insertBefore(button, codeDiv.nextSibling);
    button.parentNode.insertBefore(resultDisplay, button.nextSibling);

    button.onclick = function(e) {
      var code = editor.getValue();
      console.log("Sending:", code);
      jQuery.getJSON("/run", {code: code})
      .done(function(result) {
        lastResult = result;
        console.log("Success:", result);
         resultDisplay.textContent   = result.output;
          resultDisplay.setAttribute('class', 'result-display example-output');
        // resultDisplay.setAttribute('class', 'result-display success');
      })
      .fail(function(jqXHR, textStatus, errorThrown) {
        console.error("Failure:", jqXHR, textStatus, errorThrown);
        // resultDisplay.setAttribute('class', 'result-display failure');
      });
    }
  })();
};
