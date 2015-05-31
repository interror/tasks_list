// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-select
//= require turbolinks

source = new EventSource('/task_list/events')
source.addEventListener('event-create', function(e){
  $.ajax({
    type: "POST",
    url: "/create_live",
    data: { add_data: e.data }
  });
})
source.addEventListener('event-update', function(e){
  $.ajax({
    type: "POST",
    url: "/update_live",
    data: { upd_data: e.data }
  });
})
source.addEventListener('event-delete', function(e){
  $("#"+e.data).remove();
})
