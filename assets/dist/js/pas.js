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

 $(document).on('submit','.grp_assign_form',function(event){
    event.preventDefault();
    var grpid = $(this).attr('data-username');
    if ($("#user_id_"+grpid).val()) {
        $(".submit_btn").attr("disabled", true);
        $(".group_select_list").attr("readonly", true);  
        var new_grp_id = $("#group_id_"+grpid).val();
        var old_grp_id = $("#old_grp_id_"+grpid).val();
        $("#status_"+grpid).html("Saving");
        $("#status_"+grpid).removeClass("d-none badge-primary badge-danger");
        $("#status_"+grpid).addClass("badge-secondary");    

        var form = $('#grp_assign_'+grpid);
        var url = form.attr('action');

        $.ajax({
            type: "POST",
            url: url,
            data: form.serialize(),
            success: function(data)
            {
                    $("#old_grp_id_"+grpid).val(data.unit_group_id);
                    $("#current_group_"+grpid).html(data.group_desc);
                    refresh_group_list(grpid);
                    $(".submit_btn").attr("disabled", false);
                    $(".group_select_list").attr("readonly", false);
                    $("#status_"+grpid).html("Saved");
                    $("#status_"+grpid).removeClass("badge-secondary");
                    $("#status_"+grpid).addClass("badge-primary");
                    
                    setTimeout(function() { 
                        $("#status_"+grpid).removeClass("badge-primary");
                        $("#status_"+grpid).addClass("d-none");
                    }, 5000);
            },
            error: function (data) {
                    refresh_group_list(grpid);
                    $(".submit_btn").attr("disabled", false);
                    $(".group_select_list").attr("readonly", false);
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
    if ($(".select2bs4").length) {
        $('.select2bs4').select2({theme: 'bootstrap4'});
    }

    $("#addrow").on("click", function () {
        var newRow = $("<tr>");
        var cols = "";
        
        cols += '<td><input type="number" min="1" step="1" value="'+(counter+1)+'" name="question_order'+(counter)+'" class="form-control" required /></td>';
        cols += '<td><input type="text" name="question'+counter+'" class="form-control" /></td>';
        cols += '<td><select class="form-control" name="question_section'+counter+'" required>';
        cols += '<option value="SELF">Self Evaluation Only (Private)</option>';
        cols += '<option value="PEER">Peer Evaluation (Viewable by Peers)</option>';
        cols += '</select></td>';
        cols += '<td><select class="form-control" name="answer_type'+counter+'" required>';
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
    bind_info_windows();
    bind_large_info_windows();
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
            "pageLength": 1000
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
            bind_info_windows();
            bind_large_info_windows();
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

function verifyDateFormat(d) {
    var re = /^\d{4}-(0[1-9]|1[0-2])-([0-2]\d|3[01]) (0\d|1[0-9]|2[0-3]):[0-5]\d:[0-5]\d$/;
    return re.test(d);
}

function validateDateValue() {
    var rtnResult = false ;
    var msg = "Input Date is invalid. Please double check.";

    do 
    {
        if ( $("#pair_key").val() == $("#key").val() ) { rtnResult = true; break; }
        if ( $("#pair_date").val() == '' ) { rtnResult = true; break; }
        if ( $("#date_value").val() == '' ) { rtnResult = true; break; }
        if ( !(verifyDateFormat($("#date_value").val())) ) break;
        if ( $("#pair_key").val().includes('_OPEN') && $("#key").val().includes('_CLOSE')) {
            if ( $("#pair_date").val() >= $("#date_value").val() ) {
                msg = "Input Date should larger than the open date. Please double check.";
                break;
            }
        }
        if ( $("#pair_key").val().includes('_CLOSE') && $("#key").val().includes('_OPEN')) {
            if ( $("#pair_date").val() <= $("#date_value").val() ) {
                msg = "Input Date should smaller than the close date. Please double check.";
                break;
            }
        }
        rtnResult = true;
    } while (false);

    if (!rtnResult) {
        $("#errormsg").removeClass("d-none");
        $("#errorContent").html(msg);
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

function refresh_group_list(grpid) 
{
    $.ajax({ cache: false,
        url: $("#grp_list_url_"+grpid).val()
    }).done(function (data) {
        $(".group_select_list").html(data);
    });
}


function bind_info_windows() {
    $('.group_info_open').on('click',function(){
        var dataURL = $(this).attr('data-href');
        var grpName = $(this).attr('data-grp-name');
        var title = 'Group Members of ';
        var title_attr = $(this).attr('data-title')
        if (typeof title_attr !== typeof undefined && title_attr !== false) {
            title = $(this).attr('data-title');
        }
        $('#group_member_body').html('');
        $('#group_member_header').html(title + grpName);
        $('#loading-overlay').addClass('overlay d-flex justify-content-center align-items-center');
        $('#group_member_modal').modal({show:true});
        $('.modal-body').load(dataURL,function(){
            $('#loading-overlay').removeClass('overlay d-flex justify-content-center align-items-center');
            $('#loading-overlay').addClass('d-none');
        });
    });
}

function bind_large_info_windows() {
    $('.peer_mark_open').on('click',function(){
        var dataURL = $(this).attr('data-href');
        var username = $(this).attr('data-username');
        var title = 'Peer Marking Detail of ';
        var title_attr = $(this).attr('data-title')
        if (typeof title_attr !== typeof undefined && title_attr !== false) {
            title = $(this).attr('data-title');
        }
        $('#large-modal-body').html('');
        $('#large-modal-header').html(title + username);
        $('#large-modal-loading-overlay').addClass('overlay d-flex justify-content-center align-items-center');
        $('#large-modal').modal({show:true});
        $('.modal-body').load(dataURL,function(){
            $('#large-modal-loading-overlay').removeClass('overlay d-flex justify-content-center align-items-center');
            $('#large-modal-loading-overlay').addClass('d-none');
            document.querySelector("#large-modal-body");
            enable_editor();
        });
    });
}