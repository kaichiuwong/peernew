if($('#asg-calendar').length){
    const cal = document.querySelector('#asg-calendar');
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    
    document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('asg-calendar');
        var calendar = new FullCalendar.Calendar(calendarEl, {
          nextDayThreshold: '01:00:00',
          plugins: [ 'interaction', 'dayGrid', 'timeGrid' ],
          header: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay'
          },
          height: 650,
          defaultDate: yyyy + '-' + mm + '-' + dd ,
          editable: true,
          navLinks: true,
          events: {
            url: cal.dataset.jsonurl,
            failure: function() {
                document.getElementById('loading-calendar-overlay').className = 'd-none' ;
                document.getElementById('calendar-alert').className = 'alert alert-danger' ;
            }
          },
          loading: function(bool) {
            document.getElementById('loading-calendar-overlay').className = bool ? 'overlay dark' : 'd-none';
          }
        });
    
        calendar.render();
      });
}

$(function () {
    $('[data-toggle="tooltip"]').tooltip();
    enable_datatable();
    enable_editor();
    enable_datepicker();
});

$('#date_value').on('click',function(){
    $('#picker_button').click();
});    

$('.group_info_open').on('click',function(){
    var dataURL = $(this).attr('data-href');
    var grpName = $(this).attr('data-grp-name');
    $('#group_member_body').html('');
    $('#group_member_header').html('Group Members of ' + grpName);
    $('#loading-overlay').addClass('overlay d-flex justify-content-center align-items-center');
    $('#group_member_modal').modal({show:true});
    $('.modal-body').load(dataURL,function(){
        $('#loading-overlay').removeClass('overlay d-flex justify-content-center align-items-center');
        $('#loading-overlay').addClass('d-none');
    });
});


$('.peer_mark_open').on('click',function(){
    var dataURL = $(this).attr('data-href');
    var username = $(this).attr('data-username');
    $('#large-modal-body').html('');
    $('#large-modal-header').html('Peer Marking Detail of ' + username);
    $('#large-modal-loading-overlay').addClass('overlay d-flex justify-content-center align-items-center');
    $('#large-modal').modal({show:true});
    $('.modal-body').load(dataURL,function(){
        $('#large-modal-loading-overlay').removeClass('overlay d-flex justify-content-center align-items-center');
        $('#large-modal-loading-overlay').addClass('d-none');
        document.querySelector("#large-modal-body");
        enable_editor();
    });
});

$(document).on('change', '.custom-file-input', function (event) {
    $(this).next('.custom-file-label').html('<i class="fas fa-file"></i> ' + event.target.files[0].name);
});

$(document).on('change', '.score', function (event) {
    var peername = $(this).attr('user-name');
    calc_feedback_sum(peername);
});


$(document).on('submit','#asg_submit_form',function(event){
    event.preventDefault();
    $('#loading-submission-overlay').removeClass('d-none');
    $('#loading-submission-overlay').addClass('overlay dark');
    var form = $('#asg_submit_form')[0];
    var data = new FormData(form);
    var url = $('#asg_submit_form').attr('action');

    $.ajax({
           type: "POST",
           enctype: 'multipart/form-data',
           url: url,
           data: data,
           processData: false,
           contentType: false,
           cache: false,
           success: function(data)
           {
                load_asg_submission_form();
           }
         });
    return false;
 });

$(document).on('submit','#peer_feedback_form',function(event){
    event.preventDefault();
    $('#loading-peer-feedback-overlay').removeClass('d-none');
    $('#loading-peer-feedback-overlay').addClass('overlay dark');
    var form = $('#peer_feedback_form');
    var url = form.attr('action');

    $.ajax({
           type: "POST",
           url: url,
           data: form.serialize(),
           success: function(data)
           {
               load_peer_review_form();
           }
         });
    return false;
 });

 $(document).on('submit','#self_feedback_form',function(event){
    event.preventDefault();
    $('#loading-self-feedback-overlay').removeClass('d-none');
    $('#loading-self-feedback-overlay').addClass('overlay dark');
    var form = $('#self_feedback_form');
    var url = form.attr('action');

    $.ajax({
           type: "POST",
           url: url,
           data: form.serialize(),
           success: function(data)
           {
                load_self_review_form();
           }
         });
    return false;
 });

 $(document).on('click','#btn_submission_submit',function(){

    if($('#assignment_file').val() != '') {            
        $.each($('#assignment_file').prop("files"), function(k,v){
            var filename = v['name'];    
            var ext = filename.split('.').pop().toLowerCase();
            if($.inArray(ext, ['txt','rtf','pdf','docx','doc','ppt','pptx','xls','xlsx']) == -1) {
                alert("Please upload only 'pdf','docx','doc','ppt','pptx','xls','xlsx' format files.");
            }
            else {
                $('#asg_submit_button').trigger('click');
            }
        });        
    }
    else {
        alert("Please select a file to upload.");
    }
 });

 $(document).on('click','.remark_submit_btn',function(){
    event.preventDefault();
    var data_id="";
    var form = $('#remark_form'+data_id);
    var url = form.attr('action');
    $("#remark_submit_btn"+data_id).attr("disabled", true);
    $("#status_remark"+data_id).html("Saving");
    $("#status_remark"+data_id).removeClass("d-none badge-primary badge-danger");
    $("#status_remark"+data_id).addClass("badge-secondary");    
    $.ajax({
        type: "POST",
        url: url,
        data: form.serialize(),
        success: function(data)
        {
                $("#remark_score_id"+data_id).val(data.score_id);
                $("#remark_submit_btn"+data_id).attr("disabled", false);
                $("#status_remark"+data_id).html("Saved");
                $("#status_remark"+data_id).removeClass("badge-secondary");
                $("#status_remark"+data_id).addClass("badge-primary");
                
                setTimeout(function() { 
                    $("#status_remark"+data_id).removeClass("badge-primary");
                    $("#status_remark"+data_id).addClass("d-none");
                }, 5000);
        },
        error: function (data) {
                $("#remark_submit_btn"+data_id).attr("disabled", false);
                $("#status_remark"+data_id).html("Error");
                $("#status_remark"+data_id).removeClass("badge-secondary");
                $("#status_remark"+data_id).addClass("badge-danger");   
                
                setTimeout(function() { 
                    $("#status_remark"+data_id).removeClass("badge-secondary");
                    $("#status_remark"+data_id).addClass("d-none");
                }, 5000);
        }
        });
 });


 $(document).on('submit','.grp_submission_mark',function(event){
    event.preventDefault();
    var grpid = $(this).attr('data-grp-id');
    if ($("#score_"+grpid).val()) {
        $("#submit_btn_"+grpid).attr("disabled", true);
        $("#status_"+grpid).html("Saving");
        $("#status_"+grpid).removeClass("d-none badge-primary badge-danger");
        $("#status_"+grpid).addClass("badge-secondary");    

        var form = $('#grp_submission_mark_'+grpid);
        var url = form.attr('action');

        $.ajax({
            type: "POST",
            url: url,
            data: form.serialize(),
            success: function(data)
            {
                    $("#score_id_"+grpid).val(data.score_id);
                    $("#submit_btn_"+grpid).attr("disabled", false);
                    $("#status_"+grpid).html("Saved");
                    $("#status_"+grpid).removeClass("badge-secondary");
                    $("#status_"+grpid).addClass("badge-primary");
                    
                    setTimeout(function() { 
                        $("#status_"+grpid).removeClass("badge-primary");
                        $("#status_"+grpid).addClass("d-none");
                    }, 5000);
            },
            error: function (data) {
                    $("#submit_btn_"+grpid).attr("disabled", false);
                    $("#status_"+grpid).html("Error");
                    $("#status_"+grpid).removeClass("badge-secondary");
                    $("#status_"+grpid).addClass("badge-danger");   
                    
                    setTimeout(function() { 
                        $("#status_"+grpid).removeClass("badge-secondary");
                        $("#status_"+grpid).addClass("d-none");
                    }, 5000);
            }
            });
    }
    return false;
 });

 $(document).on('submit','.peer_submission_mark',function(event){
    event.preventDefault();
    var grpid = $(this).attr('data-username');
    if ($("#score_"+grpid).val()) {
        $("#submit_btn_"+grpid).attr("disabled", true);
        $("#status_"+grpid).html("Saving");
        $("#status_"+grpid).removeClass("d-none badge-primary badge-danger");
        $("#status_"+grpid).addClass("badge-secondary");    

        var form = $('#peer_submission_mark_'+grpid);
        var url = form.attr('action');

        $.ajax({
            type: "POST",
            url: url,
            data: form.serialize(),
            success: function(data)
            {
                    $("#score_id_"+grpid).val(data.score_id);
                    $("#submit_btn_"+grpid).attr("disabled", false);
                    $("#status_"+grpid).html("Saved");
                    $("#status_"+grpid).removeClass("badge-secondary");
                    $("#status_"+grpid).addClass("badge-primary");
                    
                    setTimeout(function() { 
                        $("#status_"+grpid).removeClass("badge-primary");
                        $("#status_"+grpid).addClass("d-none");
                    }, 5000);
            },
            error: function (data) {
                    $("#submit_btn_"+grpid).attr("disabled", false);
                    $("#status_"+grpid).html("Error");
                    $("#status_"+grpid).removeClass("badge-secondary");
                    $("#status_"+grpid).addClass("badge-danger");   
                    
                    setTimeout(function() { 
                        $("#status_"+grpid).removeClass("badge-secondary");
                        $("#status_"+grpid).addClass("d-none");
                    }, 5000);
            }
            });
    }
    return false;
 });

$(document).on('click','#btn_self_submit',function(){
    $('#self_feedback_form').submit();
 });

 $(document).on('click','#btn_peer_submit',function(){
    $('#peer_feedback_form').submit();
 });

 $(document).on('click','.grp_submit_button',function(){
    var grpid = $(this).attr('data-grp-id');
    $('#grp_submission_mark_'+grpid).submit();
 });

 
 $(document).on('click','.peer_submit_button',function(){
    var username = $(this).attr('data-username');
    $('#peer_submission_mark_'+username).submit();
 });
 

$(document).ready(function () {
    var counter = 1;

    $("#addrow").on("click", function () {
        var newRow = $("<tr>");
        var cols = "";
        
        cols += '<td><input type="number" min="1" step="1" value="'+(counter+1)+'" name="question_order'+(counter+1)+'" class="form-control" /></td>';
        cols += '<td><input type="text" name="question'+counter+'" class="form-control" /></td>';
        cols += '<td><select class="form-control" name="question_section'+counter+'" >';
        cols += '<option value="SELF">Self Evaluation Only (Private)</option>';
        cols += '<option value="PEER">Peer Evaluation (Viewable by Peers)</option>';
        cols += '</select></td>';
        cols += '<td><select class="form-control" name="answer_type'+counter+'" >';
        cols += '<option value="TEXT">Text</option>';
        cols += '<option value="SCALE">Scale (1-5)</option>';
        cols += '<option value="SCORE">Score (0%-100%)</option>';
        cols += '<option value="GRADE">Grade (NN/PP/CR/DN/HD)</option>';
        cols += '</select></td>';

        cols += '<td><input type="button" class="ibtnDel btn btn-sm btn-danger " value="Delete"></td>';
        newRow.append(cols);
        $("table.order-list").append(newRow);
        $('#counter').val(counter);
        counter++;
    });

    $("table.order-list").on("click", ".ibtnDel", function (event) {
        $(this).closest("tr").remove();
    });

    load_asg_submission_form();
    load_self_review_form();
    load_peer_review_form();

});

function enable_datatable() 
{
    if ($(".enable-datatable").length) {
        $(".enable-datatable").DataTable({
            "paging": true,
            "lengthChange": true,
            "searching": true,
            "ordering": true,
            "info": true,
            "autoWidth": false,
            "pageLength": 100
        });
    }
}

function enable_datepicker()
{
    if($('#datetimepicker1').length) {
        $('#datetimepicker1').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ss",
            widgetPositioning: {
                horizontal: 'left',
                vertical: 'auto'
            }
        });
    }
}

function enable_editor() {
    if($(".enable-editor").length) {
        $(".enable-editor").summernote({
            height: 200,
            toolbar: [
                [ 'style', [ 'style' ] ],
                [ 'font', [ 'bold', 'italic', 'underline', 'strikethrough', 'superscript', 'subscript', 'clear'] ],
                [ 'fontname', [ 'fontname' ] ],
                [ 'fontsize', [ 'fontsize' ] ],
                [ 'color', [ 'color' ] ],
                [ 'para', [ 'ol', 'ul', 'paragraph', 'height' ] ],
                [ 'table', [ 'table' ] ],
                [ 'insert', [ 'link'] ],
                [ 'view', [ 'undo', 'redo', 'fullscreen' ] ]
            ]
        });
    }
}

function calc_feedback_sum(peername) {
    var score_class = '.score-' + peername;
    val = 0;
    $(score_class).each(function(index) {
        if ($(this).val()) {
            val = parseInt( $(this).val() )+ val;
        }
    });
   $("#sum_"+peername).html(val);
}

function load_self_review_form() {
    if($('#self_feedback_card').length){
        var dataURL = $('#self_feedback_card').attr('data-href');
        $('#self_feedback_card').load(dataURL,function(){
            $('#loading-self-feedback-overlay').removeClass('overlay dark');
            $('#loading-self-feedback-overlay').addClass('d-none');
            if($('#self_feedback_form').length) {
                $('#btn_self_submit').removeClass('d-none');
            }
            else {
                $('#btn_self_submit').addClass('d-none');
            }
        });
    }
}

function load_peer_review_form() {
    if($('#peer_feedback_card').length){
        var dataURL = $('#peer_feedback_card').attr('data-href');
        $('#peer_feedback_card').load(dataURL,function(){
            $('#loading-peer-feedback-overlay').removeClass('overlay dark');
            $('#loading-peer-feedback-overlay').addClass('d-none');
            if($('#peer_feedback_form').length) {
                $('#btn_peer_submit').removeClass('d-none');
            }
            else {
                $('#btn_peer_submit').addClass('d-none');
            }
        });
    }
}

function load_asg_submission_form() {
    if($('#submission_card').length){
        var dataURL = $('#submission_card').attr('data-href');
        $('#submission_card').load(dataURL,function(){
            $('#loading-submission-overlay').removeClass('overlay dark');
            $('#loading-submission-overlay').addClass('d-none');
            if($('#asg_submit_form').length) {
                $('#btn_submission_submit').removeClass('d-none');
            }
            else {
                $('#btn_submission_submit').addClass('d-none');
            }
        });
    }
}

function hideSidebar() {
    $("body").toggleClass("sidebar-toggled");
    $(".sidebar").toggleClass("toggled");
    if ($(".sidebar").hasClass("toggled")) {
        document.cookie = "sidebar=hide";
        $('.sidebar .collapse').collapse('hide');
    }
    else {
        document.cookie = "sidebar=show";
    };
}

function validatePassword() {
    var rtnResult = false ;
    if ($("#password").val() === $("#repeatpassword").val()) {
        $("#errormsg").addClass("d-none");
        $("#errorContent").html("");
        rtnResult = true;
    }
    if (!rtnResult) {
        $("#errormsg").removeClass("d-none");
        $("#errorContent").html("Password and repeat password is different. Please double check.");
    }
    return rtnResult;
}

function updateTotal() {
    var input = 0;
    var total = parseInt($("#org_weight").html());
    try {
        input = parseInt($("#weight").val());
    }
    catch(err) { input = 0;}
    total = input + total;
    $("#sum_weight").html(total);
}

