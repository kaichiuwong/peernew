$(function () {
    $(".enable-datatable").DataTable({
        "paging": true,
        "lengthChange": true,
        "searching": true,
        "ordering": true,
        "info": true,
        "autoWidth": false,
    });
    $(".enable-editor").summernote({
        height: 300,
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

$(document).on('change', '.custom-file-input', function (event) {
    $(this).next('.custom-file-label').html('<i class="fas fa-file"></i> ' + event.target.files[0].name);
})

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


});

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

