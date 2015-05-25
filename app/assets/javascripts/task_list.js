var chooseSort = "DESC";

$(document).ready(function() {

  sortList();

  $('#add_task').click(function(){
    $('#addTaskDialog').show();
  });

  $('.closeTaskDialog').click(function(){
    $('#addTaskDialog').hide();
  });

  $('#createTask').click(function(){
    description = $('input[name="descriptionText"]').val();
    performer = $('#performer_id').val();
    $.ajax({
      type: "POST",
      url: "/",
      data: { new_task_data: [description, performer]},
      success: function (data) {
        addNewTask(data);
      }
    });
    $('#addTaskDialog').hide();
  });


});

function sortList(){
$(".order").click(function() {
  var classList = $(this).attr('class').split(/\s+/);
  console.log(classList[1], chooseSort)
  $.ajax({
    type: "POST",
    url: "/sort",
    data: { sort_data: [classList[1], chooseSort]},
    success: function (data) {
      if (chooseSort == "DESC"){
        chooseSort = "ASC";
      } else if (chooseSort == "ASC"){
        chooseSort = "DESC";
      }
    }
  });
});
};
