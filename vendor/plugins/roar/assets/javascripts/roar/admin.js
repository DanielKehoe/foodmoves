function callInProgress (xmlhttp) { 
	switch (xmlhttp.readyState) { 
		case 1: case 2: case 3: return true; break; 
		// Case 4 and 0 
		default: return false; break; 
	} 
} 
	
// Register global responders that will occur on all AJAX requests
Ajax.Responders.register({ 
	onCreate: function(request) { 
		request['timeoutId'] = window.setTimeout( function() { 
			// If we have hit the timeout and the AJAX request is active, abort it and let the user know 
			if (callInProgress(request.transport)) { 
				request.transport.abort(); 
				generalFailure("Request timeout");
				 // Run the onFailure method if	we set one up when creating the AJAX object 
				if (request.options['onFailure']) {
					request.options['onFailure'](request.transport, request.json); 
				} 
			}
		}, 5000); // Five seconds 
	}, 
	
	onComplete:	function(request) { 
		// Clear the timeout, the request completed ok 
		window.clearTimeout(request['timeoutId']); 
	} 
});

Ajax.Responders.register({
	onFailure: function() {
		//console.log("general failure");
		generalFailure();
	},
	onException: function(requester, exception) {
		//console.log("exception", requester, exception);
	}
});

var generalFailure = function(message) {
   Progress.removeAll();
   Flash.errors(message || "Something bad happened.");
};

var Progress = {
  removeAll: function() {
		Progress.removeLoadingLine();
    $$('.progress-edit').each(function(element) {
      $(element).remove();
    });
  },
  addAfter: function(element) {
		Progress.addLoadingLine();
    $(element).addAfter($img({'src' : '/images/roar/progress.gif', "class" : "progress-edit"}));    
  },
  addChild: function(element) {
		Progress.addLoadingLine();
    $(element).appendChild($img({'src' : '/images/roar/progress.gif', "class" : "progress-edit"}));    
  },

	addLoadingLine: function() {
	  var loading = $('loading_liferay_static');
	  if (loading) {
			loading.addAfter($img({'src' : '/images/roar/loading_animation_liferay.gif', "id": "rloading", "class" : "progress-edit"}));
			loading.hide();
		};		
	},
	
	removeLoadingLine: function() {
		var rspinner = $('rloading');
		if (rspinner) { 
			rspinner.remove();
    	$('loading_liferay_static').show();
    };
	}
};

var RoarMatch = {
	model: function(idstring) {
		return idstring.match(/([\w]*)([-0-9]*)$/)[1];  		
	},
	
	id: function(idstring) {
		return idstring.match(/([0-9]*)$/)[1];		
	},
	
	model_and_id: function(idstring) {
		return idstring.match(/([\w]*([-0-9]*))$/)[1];		
	}
};


var RoarRepeatingTable = {
	copyRow: function(id) {
	  var content = $('new_row-'+id).cloneNode(true);
	  content.style['display'] = 'block';
		content.id = "";
		var autocomplete = content.down('.rautocomplete');
		if (autocomplete) {
			RoarAutoComplete.attach(autocomplete);
		};
	  $(id).appendChild(content);  		
		Event.addBehavior.unload(); Event.addBehavior.load(Event.addBehavior.rules);
	}
};


/* Enables an element to be sortable */
var RoarSortable = {
	create: function(element, path) {
		Sortable.create(element, {
			onUpdate:function() {
				var params = Sortable.serialize(element).gsub(element, 'sortable');
				new Ajax.Request(path, {asynchronous:true, evalScripts:true,
					onComplete:function(request) { 
						new Effect.Highlight(element,{});
					},
					parameters:params});
			}
		});
		
	},
	
	destroy: function(element) {
		Sortable.destroy(element);
	},
	
	toggle: function(link, element, path) {
		var sortable = $(element);
		if (sortable.hasClassName('sortable')) {
			sortable.removeClassName('sortable');
			link.innerHTML = "Sort";
			RoarSortable.destroy(element, path);
		} else {
			sortable.addClassName('sortable');
			link.innerHTML = "Finished Sorting";
			RoarSortable.create(element, path);
		};
		
	}
};

var RoarAutoComplete = Behavior.create({
	initialize: function() {
		
	},
	
	onblur: function() {
		if (!this.element.hasClassName('rautocompleted')) {
			this.setupAutoComplete(this.element);
		}
	},
	
	onfocus: function() {
		if (!this.element.hasClassName('rautocompleted')) {
			this.setupAutoComplete(this.element);
		}
	},
	
	setupAutoComplete: function(element) {
		/* Generate a unique id, in case we are generating autocomplete fields via javascript */
		var model_id = element.id.match(/([0-9]*)$/)[1];
		if (!model_id) {
			var rnd = Math.floor(Math.random()*10000);
			element.id = element.id+'-'+rnd;
			var hidden = element.next();
			hidden.id = hidden.id+'-'+rnd;
		}
    
		element.addAfter($img({'id': 'progress-'+element.id, 'src' : '/images/roar/progress.gif', 
			"class" : "progress-edit", "style": "display: none;" }));
		element.addAfter($div({'class': 'auto_complete', 'id': 'auto_complete-'+element.id}));
		  
		var destination = element.getAttribute('autocomplete_href');
		var progress_id = 'progress-'+element.id;
		var hidden_id = 'hidden-'+element.id;
		var autocomplete_id = 'auto_complete-'+element.id;
	  new Ajax.Autocompleter(element, autocomplete_id, destination, 
			{	'indicator': progress_id,
	 			'afterUpdateElement':
		     function(input,li) {
		       model_id = li.id.match(/([0-9]*)$/)[1];
		       $(hidden_id).value = model_id;
					 var link = input.up('DIV').previousElement();
					 link.innerHTML = input.value;
					 input.clear();
					 input.parentNode.hide();
		     }
			}
		);
	  
		element.addClassName('rautocompleted');
	}
});

/*
  Build a select box via ajax, scoped to another select box
  destination: destination url to send ajax request to, with'scope_to' replaced 
  active_select: The select box that will be added
  key, value: the keys of the returned json to use for the options
*/
var ScopedSelect = Behavior.create({
  initialize: function(destination, active_select, key, value) {
    this.destination = destination;
    this.active_select = active_select;
    this.attrs = {'active_select': active_select, 'key': key, 'value': value};
  },
  
  onchange: function() {
    if (this.element.value) {
      var href = this.destination.gsub("scope_to", this.element.value);
      Progress.addAfter(this.active_select);
      var request = new Ajax.Request(href, {method:'get', onSuccess: this.buildSelect.bindAsEventListener(this), onFailure: generalFailure});
    };
  },

  buildSelect: function(request, json) {
		var active_select = $(this.active_select);
    active_select.descendants().each(function(item) {
      if (item.value != "") { item.remove(); }
    });
		var key = this.attrs['key'];
		var val = this.attrs['value'];
    eval(request.responseText).each(function(item) {
      active_select.appendChild($option({'value': item.attributes[key]},  item.attributes[val]));
    });
    Progress.removeAll();
	}

});
  

var TableAction = Behavior.create({
	initialize: function(destination) {
		this.destination = destination;
	},
	
	onchange: function() {
		if (this.element.value) {
			var confirmation = this.element.options[this.element.selectedIndex].getAttribute('confirm');
			if ((confirmation == null) || confirm(confirmation)) {			
				if (this.destination.match(/\?/)) {
					var href = this.destination.gsub(/\?/, ';'+this.element.value+'?');
				} else {
					var href = this.destination + ';' + this.element.value;
				}
				Progress.addAfter(this.element);
				var request = new Ajax.Request(href, {method: 'post', 
					asynchronous: true, 
					evalScripts: true, 
					parameters: Form.serializeElements($$('.raction'))
				});
			} else {
				TableActions.resetSelect();
			}
		}
	}
});

var TableActions = {
	resetSelect: function(model) {
		$('actions-'+model).value = '';		
	},
	
	reset: function(model) {
		this.resetSelect(model);
		$$('.raction').each(function(check) {
			check.removeAttribute('checked');
			check.checked = false;
		});
	},
	
	checkAll: function() {
		$$('.raction').each(function(check) {
			check.setAttribute('checked', 'checked');
			check.checked = true;
		});
	},
	
	toggleAll: function(link) {
		var model = RoarMatch.model(link.id);
		if (link.hasClassName('toggled')) {
			link.innerHTML = "Select All";
			link.removeClassName('toggled');
			TableActions.reset(model);
		} else {
			link.addClassName('toggled');
			link.innerHTML = "Deselect All";
			TableActions.checkAll();
		}
	},
	
	onClick: function() {
		if (this.checked) {
			this.setAttribute('checked', 'checked'); 
		} else {
			this.removeAttribute('checked');
		}
	}
};

var RoarSelectBox = {
	build: function(destination, active_select, key, value) {
    this.destination = destination;
    this.active_select = active_select;
		this.key = key;
		this.val = value;
    Progress.addAfter(this.active_select);
    new Ajax.Request(this.destination, {method:'get', 
			onSuccess: this.buildSelect.bindAsEventListener(this), onFailure: generalFailure});
	},

  buildSelect: function(request, json) {
		var active_select = $(this.active_select);
    active_select.descendants().each(function(item) {
      if (item.value != "") { item.remove(); }
    });
		var key = this.key;
		var val = this.val;
    eval(request.responseText).each(function(item) {
      active_select.appendChild($option({'value': item.attributes[key]},  item.attributes[val]));
    });
    Progress.removeAll();
	}
};

  
/* Main Roar Actions */
var RoarActions = {
	redit: function() {
		Roar.doAction(this, 'edit', false);
		return false;		
	},

	rshow: function() {
		Roar.doAction(this, 'show', true);
		return false;
	},
		

	rcancel: function() {
		Progress.removeAll();
		var container = this.up('.rcontainer');
		if (container) {
			container.remove();
			var model = RoarMatch.model(this.id);
	    var model_id = RoarMatch.id(this.id);
	    var nonedit = $('row-'+model+'-'+model_id);
			if (nonedit) { nonedit.show(); };
			var page = $('rpage-'+model);
			if (page) { page.visualEffect('blindDown', {duration: 0.3}); };			
		} else if (this.up('#MB_content')) {
			Modalbox.hide();
		}
    return false;
	},
	
	rnew: function() {
    var model = RoarMatch.model(this.id);
		Roar.buildSingle(model, 'edit-'+model, 'redit', false);
    new Ajax.Request(this.href, {asynchronous:true, evalScripts:true, method:'get',
			onSuccess: function(response) { $('edit-'+model).update(response.responseText); Progress.removeAll();	}});
    Progress.addChild(this);
    return false; 
		
	},
	
	rhas_many: function() {
		Progress.addAfter(this);
    var collection = this.id.match(/^([\w]*)-/)[1];
    var model_id = RoarMatch.id(this.id);
    var row = this.up('.rrow');
		var nextRow = row.next();
		var embedded_id = 'embedded-'+collection+'_'+model_id;
		if (nextRow && nextRow.hasClassName('inserted')) {
			nextRow.show();
		} else {
	    row.addAfter($tr({"class": "inserted", "id": "inline-row-"+collection+'-'+model_id}, $td({'colSpan': row.cells.length}, $div({'id': embedded_id}, "Loading..."), $a({'href': '#', 'class': 'rdone_inline'}, 'Done'))));
		}
		
    new Ajax.Request(this.href, {asynchronous:true, evalScripts:true, method:'get'});
    return false;
    
	},
	
	rdone_inline: function() {
    this.up('.inserted').remove();
    return false;
  },
  
  rdelete: function() {
    new Ajax.Request(this.href, {asynchronous:true, evalScripts:true, method:'get'});
    Progress.addAfter(this);
    var model = RoarMatch.model(this.id);
    var model_id = RoarMatch.id(this.id);
    var row = this.up('.rrow');
    row.addAfter($tr({"class": "rcontainer", "id": "inline_row-"+model+'-'+model_id}, $td({'colSpan': row.cells.length}, $div({'id': 'edit-'+model+'-'+model_id}, 'Loading...'))));
    return false;
  },
  
  rdestroy: function() {
		var confirmation = this.getAttribute('confirmation');
		if (confirm(confirmation)) {
			var form = $form({'style': 'display: none', 'method': 'POST', 'action': this.href}, $input({'type': 'hidden', 'name': '_method', 'value': 'delete'}));
			this.addAfter(form);
	    Progress.addAfter(this);
	    new Ajax.Request(form.action, {asynchronous:true, evalScripts:true, parameters:Form.serialize(form)}); 
		}
		return false;
  },

  /* Send page request as ajax */
  rpage: function() {
		rpage = this.up(".rpage");
    new Ajax.Request(this.href, {asynchronous:true, evalScripts:true, method:'get'});
    Progress.addChild(this);
    return false;
  },

	/* Intercept form submission, and submit via ajax */
	rsubmit: function() {
    return Roar.submittedForm(this.up('FORM'), this);
	},
	
	/* When return is pressed in internet explorer, no click events are given to the buttons, so intercept
	   it here, and submit the form using the first action */
  formsubmit: function() {
    var submitted = this.descendants().find(function(element) { return element.hasClassName('rsubmit'); });
    return Roar.submittedForm(this, submitted); 
  },
  	
	modalbox: function() {
		var closemodalbox = this.readAttribute('onclosebox');
		Modalbox.show(this.title, this.href, {width:600, afterHide: function() { eval(closemodalbox); }});
		return false;
	}
};

var Roar = {
	updated: function(model_and_id) {
		Roar.removeEdit(model_and_id);
		
		// Show table if it is hidden
		var page = $('rpage-'+RoarMatch.model(model_and_id));
		if (page) { page.show(); };
		
		// Show edit row, and highlight
		var row = $('row-'+model_and_id);
		if (row.next() && !row.next().hasClassName('odd')) {
			row.addClassName('odd');
		};
		row.show();
		row.visualEffect('highlight', {duration: 2.0});
    Progress.removeAll();
	},
	
	reset_new_form: function(model) {
		var container = $('rnew-'+model).down('.rcontainer');
		if (container) { container.remove(); }
		else { Roar.reset('new_form-'+model); };
	},
	
	reset: function(form_id) {
		$(form_id).reset();
		Roar.resetSubmits(form_id);
	},
	
	resetSubmits: function(form_id) {
		$(form_id).descendants().each(function(element) {
      if (element.hasClassName('rsubmit')) {
        $(element).enable();
      };			
    });
	},
	
	resetAllSubmits: function() {
		$$('.rsubmit').each(function(element) { element.enable(); });
	},
	
	removeEdit: function(model_and_id) {
    var edit_container = $('edit-'+model_and_id);
		if (edit_container) {
			edit_container.up('.rcontainer').remove(); 
		}	else if ($('MB_content')) {
			Modalbox.hide();
		};
	},
	
	buildSingle: function(model, container_id, container_class, show_done) {
		var donevisible = 'none;';
		if (show_done) { 
			donevisible = 'block;';
		};
		$('rnew-'+model).appendChild($div({'class':'rcontainer'},
			$div({'id': container_id, 'class': container_class}, "Loading..."), 
			$p({'style': 'display: '+donevisible}, $a({'class': 'rcancel', 'id': 'done-'+container_id, 'href': '#'}, 'Done'))
			));
    $('rnew-'+model).show();
	},
	
	/* Build a row that holds our .rcontainer -- either li,tr, or divs */
	buildInlineRow: function(row, container_id, container_class, show_done) {
		var donevisible = 'none;';
		if (show_done) { 
			donevisible = 'block;';
		};
		var container = $div({'id': container_id, 'class': container_class}, 'Loading....');
		var done = $p({'style': 'display: '+donevisible}, $a({'class': 'rcancel', 'id': 'done-'+container_id, 'href': '#'}, 'Done'));
		
		if (row.tagName == "LI") {
	    row.addAfter($li({"class": "rcontainer"}, container, done));
		} else if(row.tagName == "TR") {
	    row.addAfter($tr({"class": "rcontainer"}, $td({'colSpan': row.cells.length}, container, done)));
		} else {
			row.addAfter($div({"class": "rcontainer"}, container, done));
		}
	},
	
	doAction: function(link, prefix, show_done) {
		var model = RoarMatch.model(link.id);
    var model_id = RoarMatch.id(link.id);
		var collection_id = prefix+'-'+model+'-'+model_id;
		var row = link.up(".rrow");

		if (link.hasClassName("single")) {
			Roar.buildSingle(model, collection_id, 'r'+prefix, show_done);
			$('rpage-'+model).visualEffect('blindUp', {duration: 0.3});			
		} else {
		 	Roar.buildInlineRow(row, collection_id, 'r'+prefix, show_done);
		}
		
    new Ajax.Request(link.href, {asynchronous:true, evalScripts:true, method:'get',
			onSuccess: function(response) { 
				if (row) { row.hide(); }; 
				$(collection_id).update(response.responseText); 
				Progress.removeAll();	
			},
			onFailure: function(response) {
				//console.log("Failure received");
			}
		});
    Progress.addChild(link);
	},
  
  submittedForm: function(form, submitted) {
		var model = RoarMatch.model(form.id);
		if (form.id.match(/new_form/)) {
			if (!$('list-'+model)) { return true; }
		} else {
			if (!$('row-'+model+'-'+RoarMatch.id(form.id))) { return true; }
		}
		
		form.descendants().each(function(element) {
      if (element.hasClassName('rsubmit')) {
        $(element).disable();
      };			
    });
    
		/* Set name to 'submit' and value to the action symbol, so we get ex: 'submit' => 'save_and_add_another' */
		var value = submitted.getAttribute('value');
  	submitted.value = submitted.name;
  	submitted.name = 'submit';
    
    Progress.addAfter(submitted);
		
    new Ajax.Request(form.action, {asynchronous:true, evalScripts:true, parameters:Form.serialize(form, true),
			onFailure: function() {
				generalFailure("Form submission failed");
				Progress.removeAll();
				Roar.reset(form);
			}
		}); 
    
  	submitted.name = submitted.value;
		submitted.value = value;
		
		return false;
  }, 

	embedded_modalbox: function(link, source, callback) {
		Modalbox.show(link.title, link.href+'?content_only=1', {width:600, afterHide: callback});
		/* $('MB_content').appendChild($div({'id': 'embedded-'+source})); */
	}
	
};


var Toggles = {
  toggleIt: function() {
    element = this.nextElement();
    element.toggle();
    if (Element.visible(element)) {
      element.visualEffect('slideDown', {duration: 0.3});
    } else {
      element.visualEffect('slideUp', {duration: 0.3});
    }
  }
};


Event.addBehavior({
	'a.redit:click': RoarActions.redit, 
	'a.rshow:click': RoarActions.rshow, 
	'a.rcancel:click': RoarActions.rcancel,
	'a.rnew:click': RoarActions.rnew,
	'a.rhas_many:click': RoarActions.rhas_many,
	'a.rdone_inline:click': RoarActions.rdone_inline,
	'a.rdelete:click': RoarActions.rdelete,
	'a.rdestroy:click': RoarActions.rdestroy,
	'.rautocomplete': RoarAutoComplete,
  '.pager a:click': RoarActions.rpage,
  '.rsubmit:click': RoarActions.rsubmit,
	'form.roar:submit': RoarActions.formsubmit,
	'.modalbox:click': RoarActions.modalbox,
  '.toggle:click': Toggles.toggleIt,
	'input.action:click': TableActions.onClick,
  'a.external:click': function() { window.open(this.href, "ext"); return false; }  
});


/*-------------------- Flash ------------------------------*/
// Flash is used to manage error messages and notices from 
// Ajax calls. (from mephisto)
//
var Flash = {
  // When given an flash message, wrap it in a list 
  // and show it on the screen.  This message will auto-hide 
  // after a specified amount of milliseconds
  show: function(flashType, message) {
    new Effect.ScrollTo('flash-' + flashType);
    $('flash-' + flashType).innerHTML = '';
    if(message.toString().match(/<li/)) message = "<ul>" + message + '</ul>';
    $('flash-' + flashType).innerHTML = message;
    new Effect.Appear('flash-' + flashType, {duration: 0.3});
		var tofade = "";
		if (flashType=="notice") {
			tofade = "fadeNotice";
		} else {
			tofade = "fadeError";
		};
		var test = Flash[tofade].bind(this);
		//var test = Flash['fade' + flashType[0].toUpperCase() + flashType.slice(1, flashType.length)].bind(this);
    setTimeout(test, 5000);
  },
  
  errors: function(message) {
    this.show('errors', message);
  },

  // Notice-level messages.  See Messenger.error for full details.
  notice: function(message) {
		//alert(message);
    this.show('notice', message);
  },
  
  // Responsible for fading notices level messages in the dom    
  fadeNotice: function() {
    new Effect.Fade('flash-notice', {duration: 0.3});
  },
  
  // Responsible for fading error messages in the DOM
  fadeError: function() {
    new Effect.Fade('flash-errors', {duration: 0.3});
  }
};



