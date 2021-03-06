//This is a manifest file that'll be compiled into application.js, which will include all the files
//listed below.

//Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
//or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.

//It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
//compiled file.

//Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
//about supported directives.

//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap-wysihtml5
//= require bootstrap-wysihtml5/locales
//= require jquery-ui
//= require d3.min
//= require whitelab
//= require pageguide
//= require cookies_eu
//= require_tree .

var ready;
var start_tour = false;

ready = function() {
	Whitelab.init();
	tl.pg.init({
		auto_refresh: true,
		custom_open_button: '#start-tour',
		refresh_interval: 500
	});
	if (start_tour) {
		start_site_tour();
	}
};

function start_site_tour() {
	if ($('#start-tour').length)
		setTimeout(function(){ $('#start-tour').click(); }, 1000);
	else
		setTimeout(function(){ start_site_tour(); }, 1000);
}

$(document).on('click', 'a.metadata-remove-rule', function(e) {
	e.preventDefault();
	e.stopPropagation();
	if ($('div.rule').length > 1) {
		$(this).parent().parent().remove();
		Whitelab.metadata.updateCoverage();
	} else {
        $("#key option[value='']").attr('selected', true);
        $("#key").change();
	}
});
$(document).on('click', 'a.metadata-add-rule', function(e) {
	e.preventDefault();
	e.stopPropagation();
	Whitelab.metadata.addMetadataRule();
});

$(document).ready(ready);
$(document).on('page:load', ready);




