$(document).ready(function() {
  /*
  setup_text_input_behavior('#review_school_name', DEFAULT_ENTRY_SCHOOL);
  setup_text_input_behavior('#review_field_name', DEFAULT_ENTRY_FIELD);

  //SCHOOL AUTOCOMPLETE
  $( "#review_school_name" ).autocomplete({
    source: '/reviews/school_lookup.json',
    minLength: 2,
    select: function( event, ui ) {
      //set school name if selected
      $("#review_school").val(ui.item.school.name);

      //select state as well
      $("#review_state_id").val(ui.item.school.state_id);
      return false;
    },
    focus: function( event, ui){
      $(this).val(ui.item.school.name);
      return false;
    }
  })
  .data( "autocomplete" )._renderItem = function( ul, item ) {
        return $( "<li></li>" )
          .data( "item.autocomplete", item )
          .append( "<a>" + item.school.name + "</a>" )
          .appendTo( ul );
  };*/
  /*
  $("#add_favorite").click(function (){
    //alert('word: ' + document.location.hostname);
    alert('word: ' + getURLParameter('id'));
    //don't want the browser to go anywhere
    //$.post("http://localhost:3000/favorites/create.js?id=" + getURLParameter('id'))
    //$.post("http://localhost:3000/favorites/create.js?id=11)
    return false;

  });*/
  //alert("loaded show js");
});