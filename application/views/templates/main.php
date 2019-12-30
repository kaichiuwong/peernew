<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">

<!-- Main content -->
<section class="content">
    <!-- Begin Page Content -->
    <div class="container-fluid">
<?php	if(isset($_view) && $_view)
    $this->load->view($_view);
?>
    </div>
</section>
<!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- Modal -->
<div class="modal fade" id="group_member_modal" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="overlay d-flex justify-content-center align-items-center" id="loading-overlay">
                <i class="fas fa-2x fa-sync fa-spin"></i>
            </div>
            <div class="modal-header bg-secondary">
              <h6 class="modal-title" id="group_member_header">Group Members</h6>
              <button type="button" class="close btn-sm" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body" id="group_member_body">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>


<!-- Modal -->
<div class="modal fade" id="large-modal" role="dialog">
    <div class="modal-dialog modal-lg">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="overlay d-flex justify-content-center align-items-center" id="large-modal-loading-overlay">
                <i class="fas fa-2x fa-sync fa-spin"></i>
            </div>
            <div class="modal-header bg-secondary">
              <h6 class="modal-title" id="large-modal-header"></h6>
              <button type="button" class="close btn-sm" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body" id="large-modal-body">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>