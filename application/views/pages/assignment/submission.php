<!-- Content Header (Page header) -->
<section class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1><?php echo $this->session->userdata('asg_header'); ?></h1>
      </div>
      <div class="col-sm-6">
        <ol class="breadcrumb float-sm-right">
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment'); ?>">Assignment List</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/info/'.$asg_id); ?>">Info</a></li>
          <li class="breadcrumb-item"><a href="<?php echo site_url('assignment/group/'.$asg_id); ?>">Groups</a></li>
          <li class="breadcrumb-item active">Submission</li>
        </ol>
      </div>
    </div>
  </div><!-- /.container-fluid -->
</section>

<div class="row">
  <div class="col-12">
    <?php if (!$allow_submit) :?>
    <div class="card">
      <div class="card-header bg-danger">
        <h3 class="card-title text-bold"><i class="fas fa-exclamation-triangle"></i> No Assignment Group Found.</h3>
      </div>
      <!-- /.card-header -->
      <div class="card-body">
            You are required to select an assignment group before submit any assignment.
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
    <?php else: ?>
    <div class="card card-secondary">
        <div class="card-header">
            <h3 class="card-title"><span class="badge badge-success">Part A</span> Submission</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body" id="submission_card" data-href="<?php echo site_url('Assignment/asg_upload_form/'.$asg_id.'/'.encode_id($assignment_topic['topic_id'])); ?>">

        </div>
        <!-- /.card-body -->
        <div class="card-footer">
          <button type="button" class="btn btn-primary btn-sm d-none" id="btn_submission_submit">Upload Assignment</button>
        </div>
        <div class="overlay dark" id="loading-submission-overlay"> 
          <i class="fas fa-2x fa-sync-alt fa-spin"></i>
        </div>
    </div>
    <!-- /.card -->
    
    <div class="card card-secondary">
        <div class="card-header">
            <h3 class="card-title"><span class="badge badge-success">Part B</span> Self Evaluation Questions</h3>
        </div>
        <!-- /.card-header -->
        <div class="card-body" id="self_feedback_card" data-href="<?php echo site_url('Assignment/self_feedback_form/'.$asg_id.'/'.encode_id($assignment_topic['topic_id'])); ?>">

        </div>
        <!-- /.card-body -->
        <div class="card-footer">
          <button type="button" class="btn btn-primary btn-sm d-none" id="btn_self_submit">Save</button>
        </div>
        <div class="overlay dark" id="loading-self-feedback-overlay"> 
          <i class="fas fa-2x fa-sync-alt fa-spin"></i>
        </div>
    </div>
    <!-- /.card -->
    

    <div class="card card-secondary">
        <div class="card-header">
            <h3 class="card-title"><span class="badge badge-success">Part C</span> Peer Review</h3>
        </div>
        <!-- /.card-header -->
        
        <div class="card-body" id="peer_feedback_card" data-href="<?php echo site_url('Assignment/peer_feedback_form/'.$asg_id.'/'.encode_id($assignment_topic['topic_id'])); ?>">

        </div>
        <!-- /.card-body -->
        <div class="card-footer">
          <button type="button" class="btn btn-primary btn-sm d-none" id="btn_peer_submit">Save</button>
        </div>
        <div class="overlay dark" id="loading-peer-feedback-overlay"> 
          <i class="fas fa-2x fa-sync-alt fa-spin"></i>
        </div>
    </div>
    <!-- /.card -->
    <?php endif; ?>
  </div>
</div>
<!-- /.row -->